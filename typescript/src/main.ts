import * as cla from "command-line-args";
import createConfig from "./opts";

const optionDefinitions = [
    { name: 'config', alias: 'c', type: String },
    { name: 'pwd', alias: 'p', type: String },
    { name: 'command', type: String, defaultOption: true, multiple: true },
]

const config = createConfig(cla(optionDefinitions));
