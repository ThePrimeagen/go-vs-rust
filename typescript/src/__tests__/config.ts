import Config from "../config";

const path = "/foo/bar";
test("test config get by pwd", function() {
    const config = Config.new();
    expect(config.getValue(path, "baz")).toEqual(undefined);

    config.addValue(path, "baz", "fortran");
    expect(config.getValue(path, "baz")).toEqual("fortran");
});



