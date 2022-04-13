import * as fs from "fs";

type MapOfStrings = Map<string, string>

type ConfigFromFile = {
    links: MapOfStrings,
    projector: Map<String, MapOfStrings>,
}

export default class Config {
    private constructor(
        private links: MapOfStrings,
        private projector: Map<String, MapOfStrings>,
    ) { }

    static fromFile(file: string): Config {
        if (!fs.existsSync(file)) {
            fs.writeFileSync(file, "{\"links\": {}, \"projector\": {}}");
        }

        const contents = JSON.parse(fs.readFileSync(file).toString()) as ConfigFromFile;
        return new Config(contents.links, contents.projector);
    }

    static new(): Config {
        return new Config(new Map(), new Map());
    }
}
