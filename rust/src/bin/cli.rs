use projector::{error::ProjectorError, opts::{ProjectorOpts, ProjectorConfig}, operations::process};
use structopt::StructOpt;

fn main() -> Result<(), ProjectorError> {
    let args: ProjectorConfig = ProjectorOpts::from_args().try_into()?;

    process(args)?;

    return Ok(());
}
