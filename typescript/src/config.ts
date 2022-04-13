import * as fs from "fs";
import * as path from "path";

type MapOfStrings = Map<string, string>;
type Links = Map<string, string[]>;

type ConfigFromFile = {
    links: Links,
    projector: Map<string, MapOfStrings>,
}

export default class Config {
    private constructor(
        private links: Links,
        private projector: Map<String, MapOfStrings>,
    ) { }

    public getValue(pwd: string, key: string): string | undefined {
        let curr = pwd;
        do {
            const value = this._getValue(curr, key);
            if (value !== undefined) {
                return value;
            }

            const nextPwd = path.dirname(curr);
            if (nextPwd === curr) {
                break;
            }
            curr = nextPwd;
        } while (true);

        const links = this.links.get(pwd);
        if (!links) {
            return undefined;
        }

        for (const link of links) {
            const value = this._getValue(link, key);
            if (value !== undefined) {
                return value;
            }
        }
    }

    public addValue(pwd: string, key: string, value: string): void {
        if (!this.projector.has(pwd)) {
            this.projector.set(pwd, new Map());
        }
        this.projector.get(pwd).set(key, value);
    }

    private _getValue(pwd: string, key: string): string | undefined {
        const values = this.projector.get(pwd);
        if (!values) {
            return undefined
        }

        return values.get(key)
    }

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
