chai = require "chai"
config = require "./../src/config"
strings = require "./../src/resources/values/strings.coffee"

chai.should();

describe "Config file", ->
  it "Exists", ->
    config.should.to.be.ok
    (typeof  config).should.be.equal "object"

  it "Has different languages", ->
    config.languages.should.be.ok
    config.default_language.should.be.ok;
    config.languages[config.default_language].should.be.ok

  it "Has all connection configurations", ->
    config.socketio.should.be.ok;
    (typeof config.socketio.ip).should.be.equal "string"
    (typeof config.socketio.port).should.be.equal "number"

describe "Languages", ->
  it "Has default values", ->
    strings.test.should.be.equal("the test")
    strings.setLanguage(config.languages.es)
    strings.test.should.be.equal("el testo");
    strings.setLanguage(config.languages.en)
    strings.test.should.be.equal("the test")

