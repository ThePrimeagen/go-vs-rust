import { ProjectorConfig } from "../opts";

export default function add(config: ProjectorConfig): any {
    if (config.terms.length !== 2) {
        const len = config.terms.length;
        throw new Error(
            `Please provide the correct amount of arguments. Provided ${len} expected 2`);
    }

    config.config.addValue(config.pwd, config.terms[0], config.terms[1]);
}

