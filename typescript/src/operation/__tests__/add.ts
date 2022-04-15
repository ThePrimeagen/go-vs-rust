import projector from "../";
import Config from "../../config";
import { Operation, ProjectorConfig } from "../../opts";

const pwd = "/foo/bar";
test("add via projector", function() {
    const config = Config.new();
    const projectorConfig: ProjectorConfig = {
        pwd,
        config,
        terms: ["foo", "kekw"],
        operation: Operation.Add,
    }

    config.addValue(pwd, "foo", "bar");
    config.addValue(pwd, "baz", "piq");

    projector(projectorConfig);

    expect(config.getValue(pwd, "foo")).toEqual("kekw");
});
