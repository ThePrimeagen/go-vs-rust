import { Operation, ProjectorConfig } from "../opts";
import add from "./add";
import remove from "./remove";

type OperationFn = (config: ProjectorConfig) => unknown;
const operations = new Map<Operation, OperationFn>([
    [Operation.Add, add],
    [Operation.Remove, remove],
]);

export default function projector(config: ProjectorConfig) {
    operations.get(config.operation)(config);
}
