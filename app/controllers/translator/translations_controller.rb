module Translator
  class TranslationsController < ApplicationController
    before_filter :auth

    def index
      @keys = Translator.keys_for_strings(:show => params[:show])
      render :layout => Translator.layout_name
    end

    def create
      Translator.current_store[params[:key]] = params[:value]
      redirect_to :back unless request.xhr?
    end

    private

    def auth
      Translator.auth_handler.bind(self).call if Translator.auth_handler.is_a? Proc
    end
  end
end

