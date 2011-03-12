module Translator
  class TranslationsController < ApplicationController
    before_filter :auth

    def index
      @keys = Translator.keys_for_strings
    end

    def edit
      @translations = hash_class[
        *Translator.current_store.keys_without_prefix.collect do |key| 
          [key, Translator.current_store.default_translation("dev.#{key}")]
        end.flatten
      ]
      @locales = Translator.locales
      render :layout => Translator.layout_name
    end

    def update
      if params[:translations] && !params[:translations].empty?
        params[:translations].each do |key, value|
          Translator.current_store[key] = value
        end
      end
      redirect_to site_translations_path
    end

    private

    def auth
      Translator.auth_handler.bind(self).call if Translator.auth_handler.is_a? Proc
    end

    def hash_class
      RUBY_VERSION < '1.9' ? ActiveSupport::OrderedHash : Hash
    end
  end
end

