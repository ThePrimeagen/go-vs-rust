use crate::{opts::ProjectorConfig, error::ProjectorError};


pub fn remove(cfg: &mut ProjectorConfig) -> Result<(), ProjectorError> {

    if cfg.terms.len() != 1 {
        return Err(ProjectorError::InvalidArguments{
            expected: 1,
            found: cfg.terms.len(),
        });
    }

    cfg.config.remove(&cfg.pwd, &cfg.terms[0]);

    return Ok(());
}

#[cfg(test)]
mod test {
    use std::path::PathBuf;

    use crate::{error::ProjectorError, opts::ProjectorConfig, config::Config, operations::operation::Operation};

    use super::remove;

    // TODO: I should probably make sure that I actually do something other than copy pasta.
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
    fn test_remove() -> Result<(), ProjectorError> {
        let (mut config, pwd) = get_config(vec!["foo".to_string()]);

        config.config.add(&pwd, "foo", "bar");
        config.config.add(&pwd, "baz", "piq");
        remove(&mut config)?;

        assert_eq!(config.config.get_value(&pwd, "foo"), None);
        assert_eq!(config.config.get_value(&pwd, "baz"), Some(String::from("piq")));

        return Ok(());
    }
}
