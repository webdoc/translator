# encoding: UTF-8
require 'spec_helper'

describe Translator::MongoStore do
  before :each do
    conn = Mongo::Connection.new.db("translator_test").collection("translations")
    @store = Translator::MongoStore.new(conn)
    @store.clear_database
  end

  it "should be possible to set translation value" do
    @store["pl.hello.world"] = "Witaj, świecie!"
    @store["pl.hello.world"].should eql("\"Witaj, \\u015bwiecie!\"")
  end

  it "should list all keys" do
    @store["pl.hello.world"] = "Witaj, świecie!"
    @store["en.hello.world"] = "Hello, World!"
    @store.keys.should include("pl.hello.world")
    @store.keys.should include("en.hello.world")
  end

  it "should return correct translations" do
    @store["pl.hello.world"] = "Witaj, świecie!"
    @store["pl.hello.msg1"] = "A message in pl"
    @store["en.hello.world"] = "Hello, World!"
    @store["en.hello.msg1"] = "A message in english"
    @store.translations.should be_an_instance_of(Hash)
    @store.translations.keys.should have(2).items
    @store.translations.should have_key(:pl)
    @store.translations.should have_key(:en)
    @store.translations[:en].keys.should have(1).items
    @store.translations[:en].should have_key(:hello)
    @store.translations[:en][:hello].keys.should have(2).items
    @store.translations[:en][:hello].should have_key(:world)
    @store.translations[:en][:hello].should have_key(:msg1)
  end
end
