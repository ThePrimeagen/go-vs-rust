import { Operation, ProjectorConfig } from "../opts";
import add from "./add";

type OperationFn = (config: ProjectorConfig) => unknown;
const operations = new Map<Operation, OperationFn>([
    [Operation.Add, add],
]);

export default function projectorerate(config: ProjectorConfig) {
    switch (config.operation) {
    case Operation.Add:
    }
}
