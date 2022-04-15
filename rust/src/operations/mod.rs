use crate::{error::ProjectorError, opts::ProjectorConfig};

use self::{add::add, remove::remove};

pub mod operation;
pub mod add;
pub mod remove;

pub fn process(mut opts: ProjectorConfig) -> Result<(), ProjectorError> {

    match opts.operation {
        operation::Operation::Add => add(&mut opts)?,
        operation::Operation::Remove => remove(&mut opts)?,
        operation::Operation::Link => unreachable!(),
        operation::Operation::Unlink => unreachable!(),
        _ => unreachable!(),
    };

    return Ok(());
}

