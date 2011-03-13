module Translator
  class TranslationsController < ApplicationController
    layout "translator"
    before_filter :auth

    def index
      @keys = Translator.keys_for_strings
    end

    def create
      Translator.current_store[params[:key]] = params[:value]
      redirect_to :back unless request.xhr?
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

