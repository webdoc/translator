# encoding: UTF-8
require 'spec_helper'

describe Translator::Chain do
  before :each do
    conn = Mongo::Connection.new.db("translator_test").collection("translations")
    @store = Translator::MongoStore.new(conn)
    @store.clear_database
    Translator.current_store = @store
    I18n.backend = Translator.setup_backend(I18n::Backend::Simple.new)
  end

  it "should initialized? be always true" do
    I18n.backend.initialized?.should be true
  end

  it "should return translations of sub backend" do
    @store["pl.hello.world"] = "Witaj, świecie!"
    @store["en.hello.world"] = "Hello, World!"

    global_translations = I18n.backend.translations
    global_translations.should_not be_empty

    global_translations[:en].should have_key(:hello)
    global_translations[:en][:hello].should have_key(:world)
    global_translations[:en][:hello][:world].should == "Hello, World!"

  end

end
