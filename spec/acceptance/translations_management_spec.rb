# encoding: UTF-8
require File.dirname(__FILE__) + '/acceptance_helper'

feature "Translations management", %q{
  In order to show user app in different translate
  As a app admin
  I want to 
} do

  [:mongodb, :redis].each do |db|
    context "with #{db}" do
      background do
        if db == :redis
          Translator.current_store = Translator::RedisStore.new(Redis.new)
        else
          conn = Mongo::Connection.new.db("translator_test").collection("translations")
          Translator.current_store = Translator::MongoStore.new(conn)
        end

        I18n.backend = Translator.setup_backend(I18n::Backend::Simple.new)
        Translator.current_store.clear_database
        visit translations_path
      end

      scenario "see translations keys specified in main language yaml file" do
        page.should have_content "hello.world"
      end

      scenario "see translations provided in language files" do
        visit root_path
        page.should have_content "Hello world!"
        visit root_path(:locale => "pl")
        page.should have_content "Witaj, Świecie"
      end

      scenario "editing translations" do
        within :css, "#pl-hello-world" do
          fill_in "value", with: "Elo ziomy"
          click_button "Save"
        end

        within :css, "#en-hello-world" do
          fill_in "value", with: "Yo hommies"
          click_button "Save"
        end

        visit root_path
        page.should have_content("Yo hommies")
        visit root_path(:locale => "pl")
        page.should have_content("Elo ziomy")
      end

      scenario "see only app translations by default, Rails ones after changing tab" do
        page.should_not have_content("date.formats")
        click_link "Framework Translations"
        page.should have_content("date.formats")
      end
    end
  end
end

