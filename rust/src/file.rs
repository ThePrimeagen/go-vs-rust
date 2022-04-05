use std::{fs::File, path::PathBuf};

use crate::error::ProjectorError;

pub fn open_or_create(path: &PathBuf) -> Result<File, ProjectorError> {
    return Ok(File::options().read(true).write(true).create(true).open(path)?);
}


