import { Operation, ProjectorConfig } from "../opts";
import add from "./add";

type OperationFn = (config: ProjectorConfig) => unknown;
const operations = new Map<Operation, OperationFn>([
    [Operation.Add, add],
]);

export default function projector(config: ProjectorConfig) {
    operations.get(config.operation)(config);
}
