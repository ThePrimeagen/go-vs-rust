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
