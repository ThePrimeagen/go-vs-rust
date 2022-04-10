import * as path from "path";
import Config from "./config";

export type CLIOptions = {
    command: string[],
    config?: string,
    pwd?: string,
}

export enum Operation {
    Add,
    Remove,
    Link,
    Unlink,
    Print,
}

export type ProjectorConfig = {
    pwd: string,
    config: Config,
    operation: Operation,
    terms: string[],
}

export function getProjectorConfigDir(config?: string): string {
    const xdgPath = process.env["XDG_CONFIG_HOME"];

    if (!xdgPath) {
        throw new Error("Start using an operating system with xdg you goof");
    }
    return config || path.join(xdgPath, "projector", "projector.json");
}

export function getOperation(operation: string[]): Operation {
    switch (operation[0]) {
    case "add": return Operation.Add;
    case "rm": return Operation.Remove;
    case "link": return Operation.Link;
    case "unlink": return Operation.Unlink;
    }

    return Operation.Print;
}

export function isOperationSpecified(operation: string[]): boolean {
    return getOperation(operation) !== Operation.Print ||
        operation[0] === "print";
}

export function getTerms(operation: string[]): string[] {
    return isOperationSpecified(operation) ? operation.slice(1) : operation;
}

export default function createConfig(options: CLIOptions): ProjectorConfig {
    return {
        pwd: options.pwd || process.cwd(),
        config: Config.fromFile(getProjectorConfigDir(options.config)),
        operation: getOperation(options.command),
        terms: getTerms(options.command),
    };
}
