module Translator

  class KeyValue < I18n::Backend::KeyValue
    def initialized?
      true
    end

    def translations
      @store.translations
    end
  end
end