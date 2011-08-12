module Translator
  class TranslationsController < ApplicationController
    before_filter :auth

    def index
      @keys = paginate(Translator.keys_for_strings(params))
      render :layout => Translator.layout_name
    end

    def create
      Translator.current_store[params[:key]] = params[:value]
      redirect_to :back unless request.xhr?
    end

    def refresh
      SimplesIdeias::I18n.export!
      render :json => { :status => "OK" }
    end
    
    private

    def auth
      Translator.auth_handler.bind(self).call if Translator.auth_handler.is_a? Proc
    end

    def paginate(collection)
      @page = params[:page].to_i
      @page = 1 if @page == 0
      @total_pages = (collection.count / 50.0).ceil
      collection[(@page-1)*50..@page*50]
    end
  end
end

