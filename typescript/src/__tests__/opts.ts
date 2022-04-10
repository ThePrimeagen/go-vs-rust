import { getOperation, getTerms, Operation } from "../opts";


test("getTerms happy path", function() {
    const terms = ["foo", "bar"];
    const parsedTerms = getTerms(terms);
    expect(parsedTerms).toEqual(["foo", "bar"]);
});

test("with print operation", function() {
    const terms = ["print", "foo", "bar"];
    const parsedTerms = getTerms(terms);
    expect(parsedTerms).toEqual(["foo", "bar"]);
});

test("with other operation", function() {
    const terms = ["add", "foo", "bar"];
    const parsedTerms = getTerms(terms);
    expect(parsedTerms).toEqual(["foo", "bar"]);
});

test("getOperation add", function() {
    const terms = ["add", "foo", "bar"];
    const operation = getOperation(terms);
    expect(operation).toEqual(Operation.Add);
});

test("getOperation default", function() {
    const terms = ["blah", "foo", "bar"];
    const operation = getOperation(terms);
    expect(operation).toEqual(Operation.Print);
});
