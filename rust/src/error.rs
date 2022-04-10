use thiserror::Error;

#[derive(Error, Debug)]
pub enum ProjectorError {
    #[error("attempting to get xdg_config_directory and failed.")]
    XDGError(#[from] xdg::BaseDirectoriesError),

    #[error("an io error?")]
    IOError(#[from] std::io::Error),

    #[error("serde json decoding error")]
    SerdeJsonError(#[from] serde_json::Error),

    #[error("invalid argument count (expected {expected:?}, found {found:?})")]
    InvalidArguments{
        expected: usize,
        found: usize,
    },
}


