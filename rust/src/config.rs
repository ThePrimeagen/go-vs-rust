use std::{path::{PathBuf, Path}, fs::File, collections::HashMap};

use serde::{Serialize, Deserialize};

use crate::error::ProjectorError;

#[derive(Deserialize, Debug, Serialize)]
pub struct Config {
    pub links: HashMap<PathBuf, Vec<PathBuf>>,
    pub projector: HashMap<PathBuf, HashMap<String, String>>,
}

impl Config {

    pub fn from_file(file: File) -> Result<Config, ProjectorError> {
        return Ok(serde_json::from_reader(file)?);
    }

    pub fn get_value(self, path: PathBuf, key: String) -> Option<String> {
        let mut p: Option<&Path> = Some(&path);
        let mut value = None;

        loop {
            // TODO: Think about windows path separator
            // ^--- this is a joke..
            if p.is_none() {
                break;
            }

            let path_map = self.projector.get(p.unwrap());
            if path_map.is_some() {
                if let Some(v) = path_map.unwrap().get(&key) {
                    value = Some(v.to_string());
                    break;
                }
            }

            p = p.unwrap().parent();
        }

        if value.is_some() {
            return value;
        }

        for link in self.links.get(&path).iter().flat_map(|x| x.iter()) {
            let path_map = self.projector.get(link);
            if path_map.is_some() {
                if let Some(v) = path_map.unwrap().get(&key) {
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

    #[test]
    fn test_get_value() -> Result<(), Box<dyn std::error::Error>> {
        assert_eq!(false, true);
        return Ok(());
    }
}

