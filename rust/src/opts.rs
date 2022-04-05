use std::{path::PathBuf, fs::File};

use structopt::StructOpt;

use crate::{operations::operation::Operation, error::ProjectorError, file::open_or_create, config::get_config_path};

#[derive(Debug, StructOpt, Clone)]
pub struct ProjectorOpts {

    /// The port to use for the events to be served on
    #[structopt(long = "pwd")]
    pub pwd: Option<PathBuf>,

    /// The port to use for the events to be served on
    #[structopt(long = "config")]
    pub config: Option<PathBuf>,

    /// The operation to perform.
    /// It is either a keyword, or its a search term
    #[structopt()]
    pub operation: Operation,

    /// Any other arguments for the operation
    ///
    /// add: 2 arguments, the key and the value.
    /// remove: 1 argument, the key
    /// link: 1 arguments, the directory to link
    /// unlink: 1 argumentes, the directory to unlink
    /// search terms: zero or more search terms to search in this projector path
    #[structopt()]
    pub args: Vec<String>,
}

pub struct ProjectorConfig {
    pub pwd: PathBuf,
    pub config: File,
    pub operation: Operation,
    pub terms: Vec<String>,
}

impl TryFrom<ProjectorOpts> for ProjectorConfig {
    type Error = ProjectorError;

    fn try_from(value: ProjectorOpts) -> Result<Self, Self::Error> {
        let pwd = value.pwd.unwrap_or(std::env::current_dir()?);

        let config = get_config_path(value.config)?;
        let config = open_or_create(&config)?;

        return Ok(ProjectorConfig {
            pwd,
            config,
            operation: value.operation,
            terms: value.args,
        });
    }
}
