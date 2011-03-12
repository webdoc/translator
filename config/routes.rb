Rails.application.routes.draw do
  resources :translations, :to => "Translator::Translations"
end
