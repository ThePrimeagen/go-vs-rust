use std::str::FromStr;

use crate::error::ProjectorError;

#[derive(Debug, Clone)]
pub enum Operation {
    Add,
    Remove,
    Link,
    Unlink,
    Search(String),
}

impl FromStr for Operation {
    type Err = ProjectorError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        return Ok(match s {
            "add" => Operation::Add,
            "rm" => Operation::Remove,
            "link" => Operation::Link,
            "unlink" => Operation::Unlink,
            _ => Operation::Search(s.to_string())
        });
    }
}


