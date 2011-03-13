# encoding: UTF-8
require 'spec_helper'

describe Translator::RedisStore do
  before :each do
    @store = Translator::RedisStore.new(Redis.new)
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
end
