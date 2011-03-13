require 'spec_helper'

describe Translator do
  it "should list non-framework keys by default" do
    Translator.keys_for_strings.should include("hello.world")
    Translator.keys_for_strings.should_not include("helpers.submit.update")
  end

  it "should list only keys that their values are Strings in Yaml files" do
    Translator.keys_for_strings.should_not include("date.month_names")
  end

  it "should be possible to list framework keys with option" do
    Translator.keys_for_strings(:show => :framework).should_not include("hello.world")
    Translator.keys_for_strings(:show => :framework).should include("helpers.submit.update")
  end

  it "should be possible to list all keys with option" do
    Translator.keys_for_strings(:show => :all).should include("hello.world")
    Translator.keys_for_strings(:show => :all).should include("helpers.submit.update")
  end
end
