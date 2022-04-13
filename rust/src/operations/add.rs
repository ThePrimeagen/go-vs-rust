use crate::{error::ProjectorError, opts::ProjectorConfig};

pub fn add(cfg: &mut ProjectorConfig) -> Result<(), ProjectorError> {
    if cfg.terms.len() != 2 {
        return Err(ProjectorError::InvalidArguments{
            expected: 2,
            found: cfg.terms.len(),
        });
    }

    let key = cfg.terms.get(0).expect("expect key to exist");
    let value = cfg.terms.get(1).expect("expect value to exist");

    // todo: i don't like this.
    cfg.config.add(cfg.pwd.clone(), key, value);

    return Ok(());
}

#[cfg(test)]
mod test {
    use std::path::PathBuf;

    use crate::{error::ProjectorError, opts::ProjectorConfig, config::Config, operations::{operation::Operation, add}};

    fn get_config(terms: Vec<String>) -> (ProjectorConfig, PathBuf) {
        let pwd = PathBuf::from("/foo/bar/baz");
        let config = ProjectorConfig {
            pwd: pwd.clone(),
            config: Config::new(),
            operation: Operation::Add,
            terms,
        };

        return (config, pwd);
    }

    #[test]
    fn test_add_with_not_enough_terms() -> Result<(), ProjectorError> {
        let (mut config, _) = get_config(vec![
            String::from("foo"),
        ]);

        // TODO: How to test?
        let out = add(&mut config);
        assert_eq!(out.is_ok(), false);

        return Ok(());
    }

    #[test]
    fn test_add_with_too_many_terms() -> Result<(), ProjectorError> {
        let (mut config, _) = get_config(vec![
            String::from("foo"),
            String::from("foo"),
            String::from("foo"),
        ]);

        // TODO: How to test?
        let out = add(&mut config);
        assert_eq!(out.is_ok(), false);

        return Ok(());
    }

    #[test]
    fn test_add() -> Result<(), ProjectorError> {
        let (mut config, path) = get_config(vec![
            String::from("foo"),
            String::from("bar"),
        ]);

        let out = add(&mut config);
        assert_eq!(out.is_ok(), true);
        assert_eq!(config.config.get_value(&path, "foo"), Some(String::from("bar")));

        return Ok(());
    }
}
