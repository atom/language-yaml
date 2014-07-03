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

  it "parses nested keys", ->
    lines = grammar.tokenizeLines """
      first:
        second:
          third: 3
          fourth: "4th"
    """

    expect(lines[0][0]).toEqual value: "first", scopes: ["source.yaml", "string.unquoted.yaml", "entity.name.tag.yaml"]
    expect(lines[0][1]).toEqual value: ":", scopes: ["source.yaml", "string.unquoted.yaml", "entity.name.tag.yaml", "punctuation.separator.key-value.yaml"]

    expect(lines[1][0]).toEqual value: "  ", scopes: ["source.yaml"]
    expect(lines[1][1]).toEqual value: "second", scopes: ["source.yaml", "string.unquoted.yaml", "entity.name.tag.yaml"]
    expect(lines[1][2]).toEqual value: ":", scopes: ["source.yaml", "string.unquoted.yaml", "entity.name.tag.yaml", "punctuation.separator.key-value.yaml"]

    expect(lines[2][0]).toEqual value: "    ", scopes: ["source.yaml"]
    expect(lines[2][1]).toEqual value: "third", scopes: ["source.yaml", "constant.numeric.yaml", "entity.name.tag.yaml"]
    expect(lines[2][2]).toEqual value: ":", scopes: ["source.yaml", "constant.numeric.yaml", "entity.name.tag.yaml", "punctuation.separator.key-value.yaml"]
    expect(lines[2][3]).toEqual value: " 3", scopes: ["source.yaml", "constant.numeric.yaml"]

    expect(lines[3][0]).toEqual value: "    ", scopes: ["source.yaml"]
    expect(lines[3][1]).toEqual value: "fourth", scopes: ["source.yaml", "string.unquoted.yaml", "entity.name.tag.yaml"]
    expect(lines[3][2]).toEqual value: ":", scopes: ["source.yaml", "string.unquoted.yaml", "entity.name.tag.yaml", "punctuation.separator.key-value.yaml"]
    expect(lines[3][3]).toEqual value: " ", scopes: ["source.yaml", "string.unquoted.yaml"]
    expect(lines[3][4]).toEqual value: "\"", scopes: ["source.yaml", "string.unquoted.yaml", "string.quoted.double.yaml", "punctuation.definition.string.begin.yaml"]
    expect(lines[3][5]).toEqual value: "4th", scopes: ["source.yaml", "string.unquoted.yaml", "string.quoted.double.yaml"]
    expect(lines[3][6]).toEqual value: "\"", scopes: ["source.yaml", "string.unquoted.yaml", "string.quoted.double.yaml", "punctuation.definition.string.end.yaml"]

  it "parses keys and values", ->
    lines = grammar.tokenizeLines """
      first: 1st
      second: 2nd
    """

    expect(lines[0][0]).toEqual value: "first", scopes: ["source.yaml", "string.unquoted.yaml", "entity.name.tag.yaml"]
    expect(lines[0][1]).toEqual value: ":", scopes: ["source.yaml", "string.unquoted.yaml", "entity.name.tag.yaml", "punctuation.separator.key-value.yaml"]
    expect(lines[0][2]).toEqual value: " ", scopes: ["source.yaml", "string.unquoted.yaml"]
    expect(lines[0][3]).toEqual value: "1st", scopes: ["source.yaml", "string.unquoted.yaml", "string.unquoted.yaml"]

    expect(lines[1][0]).toEqual value: "second", scopes: ["source.yaml", "string.unquoted.yaml", "entity.name.tag.yaml"]
    expect(lines[1][1]).toEqual value: ":", scopes: ["source.yaml", "string.unquoted.yaml", "entity.name.tag.yaml", "punctuation.separator.key-value.yaml"]
    expect(lines[1][2]).toEqual value: " ", scopes: ["source.yaml", "string.unquoted.yaml"]
    expect(lines[1][3]).toEqual value: "2nd", scopes: ["source.yaml", "string.unquoted.yaml", "string.unquoted.yaml"]
