import { ProjectorConfig } from "../opts";

export default function remove(config: ProjectorConfig): any {
    if (config.terms.length !== 1) {
        const len = config.terms.length;
        throw new Error(
            `Please provide the correct amount of arguments. Provided ${len} expected 1`);
    }

    config.config.removeValue(config.pwd, config.terms[0]);
}


