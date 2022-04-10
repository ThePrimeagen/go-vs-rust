use crate::{error::ProjectorError, opts::ProjectorConfig};

pub fn add(cfg: ProjectorConfig) -> Result<(), ProjectorError> {
    if cfg.terms.len() != 2 {
        return Err(ProjectorError::InvalidArguments{
            expected: 2,
            found: cfg.terms.len(),
        });
    }

    let key = cfg.terms.get(0).unwrap();
    let value = cfg.terms.get(0).unwrap();

    cfg.config.add(key, value)

    return Ok(());
}
