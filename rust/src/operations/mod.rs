use crate::{error::ProjectorError, opts::ProjectorConfig};

use self::add::add;

pub mod operation;
pub mod add;

pub fn process(opts: ProjectorConfig) -> Result<(), ProjectorError> {
    match opts.operation {
        operation::Operation::Add => add(opts)?,
        operation::Operation::Remove => unreachable!(),
        operation::Operation::Link => unreachable!(),
        operation::Operation::Unlink => unreachable!(),
        _ => unreachable!(),
    };

    return Ok(());
}

