# encoding: UTF-8
require File.dirname(__FILE__) + '/acceptance_helper'

feature "Translations management", %q{
  In order to show user app in different translate
  As a app admin
  I want to 
} do

  background do
    visit translations_path
  end

  scenario "see translations keys specified in main language yaml file" do
    page.should have_content "hello.world"
  end

  scenario "see translations provided in language files" do
    page.should have_content "Hello world!"
    page.should have_content "Witaj, Świecie"
  end

  scenario "editing translations" do
    click_link "Edit hello.world"
    fill_in "pl", with: "Elo ziomy"
    fill_in "en", with: "Yo hommies"
    click_button "Save"
    visit root_path
    page.should have_content("Elo ziomy")
    page.should have_content("Yo hommies")
  end

  scenario "see only app translations by default, Rails ones after changing tab" do
    page.should_not have_content("en.date.formats")
    click_link "Framework Translations"
    page.should have_content("en.date.formats")
  end
end

