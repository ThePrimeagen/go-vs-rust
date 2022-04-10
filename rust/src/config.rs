use std::{path::{PathBuf, Path}, fs::File, collections::HashMap};

use serde::{Serialize, Deserialize};

use crate::error::ProjectorError;

#[derive(Deserialize, Debug, Serialize)]
pub struct Config {
    pub links: HashMap<PathBuf, Vec<PathBuf>>,
    pub projector: HashMap<PathBuf, HashMap<String, String>>,
}

impl Config {

    pub fn new() -> Config {
        return Config {
            links: HashMap::new(),
            projector: HashMap::new(),
        }
    }

    pub fn from_file(file: File) -> Result<Config, ProjectorError> {
        return Ok(serde_json::from_reader(file)?);
    }

    pub fn add(&mut self, dir: PathBuf, key: &str, value: &str) {
        if !self.projector.contains_key(&dir) {
            self.projector.insert(dir.clone(), HashMap::new());
        }

        self.projector
            .get_mut(&dir)
            .expect("should always exist")
            .insert(key.to_string(), value.to_string());
    }

    pub fn get_value(&self, path: &PathBuf, key: &str) -> Option<String> {
        let mut p: Option<&Path> = Some(path);
        let mut value = None;

        loop {
            // TODO: Think about windows path separator
            // ^--- this is a joke..
            if p.is_none() {
                break;
            }

            let path_map = self.projector.get(p.unwrap());
            if path_map.is_some() {
                if let Some(v) = path_map.unwrap().get(key) {
                    value = Some(v.to_string());
                    break;
                }
            }

            p = p.unwrap().parent();
        }

        if value.is_some() {
            return value;
        }

        for link in self.links.get(path).iter().flat_map(|x| x.iter()) {
            let path_map = self.projector.get(link);
            if path_map.is_some() {
                if let Some(v) = path_map.unwrap().get(key) {
                    value = Some(v.to_string());
                    break;
                }
            }
        }

        return value;
    }
}

fn default_config_path() -> Result<PathBuf, ProjectorError> {
    let xdg_dirs = xdg::BaseDirectories::with_prefix("projector")?;
    return Ok(xdg_dirs.place_config_file("projector.json")?);
}

pub fn get_config_path(config: Option<PathBuf>) -> Result<PathBuf, ProjectorError> {
    return Ok(match config {
        Some(cfg) => cfg,
        None => default_config_path()?,
    });
}

#[cfg(test)]
mod test {
    use std::path::PathBuf;

    use super::*;

    #[test]
    fn test_get_config_with_parameter() -> Result<(), Box<dyn std::error::Error>> {
        let config = get_config_path(Some(PathBuf::from("/foo/bar/projector.json")))?;
        assert_eq!(config, PathBuf::from("/foo/bar/projector.json"));

        return Ok(());
    }

    #[test]
    fn test_get_config() -> Result<(), Box<dyn std::error::Error>> {
        let config = get_config_path(None)?;
        assert_eq!(config, default_config_path()?);

        return Ok(());
    }

    fn get_config() -> (Config, PathBuf, PathBuf) {
        let mut config = Config::new();

        let path = PathBuf::from("/home/test");
        let path2 = PathBuf::from("/home/test/foo");

        config.projector.insert(
            path.clone(),
            HashMap::from([
                ("foo".to_string(), "baz".to_string()),
            ])
        );

        config.projector.insert(
            path2.clone(),
            HashMap::from([
                ("foo".to_string(), "baz2".to_string()),
                ("buzz".to_string(), "baz".to_string()),
            ])
        );

        return (config, path, path2);
    }

    #[test]
    fn test_get_value() -> Result<(), Box<dyn std::error::Error>> {
        let (config, path, path2) = get_config();

        assert_eq!(config.get_value(&path, "foo"), Some("baz".to_string()));
        assert_eq!(config.get_value(&path2, "foo"), Some("baz2".to_string()));

        return Ok(());
    }

    #[test]
    fn add_value() -> Result<(), ProjectorError> {
        let (mut config, path, path2) = get_config();

        config.add(path.clone(), "foo", "bar");

        assert_eq!(config.get_value(&path, "foo"), Some("bar".to_string()));
        assert_eq!(config.get_value(&path2, "foo"), Some("baz2".to_string()));

        return Ok(());
    }

}

