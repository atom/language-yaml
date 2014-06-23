describe "YAML grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-yaml")

    runs ->
      grammar = atom.syntax.grammarForScopeName('source.yaml')

  it "parses the grammar", ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe "source.yaml"

  describe "strings", ->
    describe "double quoted", ->
      it "parses escaped quotes", ->
        {tokens} = grammar.tokenizeLine("\"I am \\\"escaped\\\"\"")
        expect(tokens[0]).toEqual value: "\"", scopes: ["source.yaml", "string.quoted.double.yaml", "punctuation.definition.string.begin.yaml"]
        expect(tokens[1]).toEqual value: "I am ", scopes: ["source.yaml", "string.quoted.double.yaml"]
        expect(tokens[2]).toEqual value: "\\\"", scopes: ["source.yaml", "string.quoted.double.yaml", "constant.character.escape.yaml"]
        expect(tokens[3]).toEqual value: "escaped", scopes: ["source.yaml", "string.quoted.double.yaml"]
        expect(tokens[4]).toEqual value: "\\\"", scopes: ["source.yaml", "string.quoted.double.yaml", "constant.character.escape.yaml"]
        expect(tokens[5]).toEqual value: "\"", scopes: ["source.yaml", "string.quoted.double.yaml", "punctuation.definition.string.end.yaml"]


        {tokens} = grammar.tokenizeLine("key:\"I am \\\"escaped\\\"\"")
        expect(tokens[0]).toEqual value: "key", scopes: ["source.yaml", "string.unquoted.yaml", "entity.name.tag.yaml"]
        expect(tokens[1]).toEqual value: ":", scopes: ["source.yaml", "string.unquoted.yaml", "entity.name.tag.yaml", "punctuation.separator.key-value.yaml"]
        expect(tokens[2]).toEqual value: "\"", scopes: ["source.yaml", "string.unquoted.yaml", "string.quoted.double.yaml", "punctuation.definition.string.begin.yaml"]
        expect(tokens[3]).toEqual value: "I am ", scopes: ["source.yaml", "string.unquoted.yaml", "string.quoted.double.yaml"]
        expect(tokens[4]).toEqual value: "\\\"", scopes: ["source.yaml", "string.unquoted.yaml", "string.quoted.double.yaml", "constant.character.escape.yaml"]
        expect(tokens[5]).toEqual value: "escaped", scopes: ["source.yaml", "string.unquoted.yaml", "string.quoted.double.yaml"]
        expect(tokens[6]).toEqual value: "\\\"", scopes: ["source.yaml", "string.unquoted.yaml", "string.quoted.double.yaml", "constant.character.escape.yaml"]
        expect(tokens[7]).toEqual value: "\"", scopes: ["source.yaml", "string.unquoted.yaml", "string.quoted.double.yaml", "punctuation.definition.string.end.yaml"]

    describe "single quoted", ->
      it "parses escaped quotes", ->
        {tokens} = grammar.tokenizeLine("'I am \\'escaped\\''")
        expect(tokens[0]).toEqual value: "'", scopes: ["source.yaml", "string.quoted.single.yaml", "punctuation.definition.string.begin.yaml"]
        expect(tokens[1]).toEqual value: "I am ", scopes: ["source.yaml", "string.quoted.single.yaml"]
        expect(tokens[2]).toEqual value: "\\'", scopes: ["source.yaml", "string.quoted.single.yaml", "constant.character.escape.yaml"]
        expect(tokens[3]).toEqual value: "escaped", scopes: ["source.yaml", "string.quoted.single.yaml"]
        expect(tokens[4]).toEqual value: "\\'", scopes: ["source.yaml", "string.quoted.single.yaml", "constant.character.escape.yaml"]
        expect(tokens[5]).toEqual value: "'", scopes: ["source.yaml", "string.quoted.single.yaml", "punctuation.definition.string.end.yaml"]

        {tokens} = grammar.tokenizeLine("key:'I am \\'escaped\\''")
        expect(tokens[0]).toEqual value: "key", scopes: ["source.yaml", "string.unquoted.yaml", "entity.name.tag.yaml"]
        expect(tokens[1]).toEqual value: ":", scopes: ["source.yaml", "string.unquoted.yaml", "entity.name.tag.yaml", "punctuation.separator.key-value.yaml"]
        expect(tokens[2]).toEqual value: "'", scopes: ["source.yaml", "string.unquoted.yaml", "string.quoted.single.yaml", "punctuation.definition.string.begin.yaml"]
        expect(tokens[3]).toEqual value: "I am ", scopes: ["source.yaml", "string.unquoted.yaml", "string.quoted.single.yaml"]
        expect(tokens[4]).toEqual value: "\\'", scopes: ["source.yaml", "string.unquoted.yaml", "string.quoted.single.yaml", "constant.character.escape.yaml"]
        expect(tokens[5]).toEqual value: "escaped", scopes: ["source.yaml", "string.unquoted.yaml", "string.quoted.single.yaml"]
        expect(tokens[6]).toEqual value: "\\'", scopes: ["source.yaml", "string.unquoted.yaml", "string.quoted.single.yaml", "constant.character.escape.yaml"]
        expect(tokens[7]).toEqual value: "'", scopes: ["source.yaml", "string.unquoted.yaml", "string.quoted.single.yaml", "punctuation.definition.string.end.yaml"]

  it "parses the leading ! before values", ->
    {tokens} = grammar.tokenizeLine("key:! 'hi'")
    expect(tokens[0]).toEqual value: "key", scopes: ["source.yaml", "string.unquoted.yaml", "entity.name.tag.yaml"]
    expect(tokens[1]).toEqual value: ":", scopes: ["source.yaml", "string.unquoted.yaml", "entity.name.tag.yaml", "punctuation.separator.key-value.yaml"]
    expect(tokens[2]).toEqual value: "! ", scopes: ["source.yaml", "string.unquoted.yaml", "string.unquoted.yaml"]
    expect(tokens[3]).toEqual value: "'", scopes: ["source.yaml", "string.unquoted.yaml", "string.quoted.single.yaml", "punctuation.definition.string.begin.yaml"]
    expect(tokens[4]).toEqual value: "hi", scopes: ["source.yaml", "string.unquoted.yaml", "string.quoted.single.yaml"]
    expect(tokens[5]).toEqual value: "'", scopes: ["source.yaml", "string.unquoted.yaml", "string.quoted.single.yaml",  "punctuation.definition.string.end.yaml"]
