module Translator
  class Chain < I18n::Backend::Chain
    def initialized?
      true
    end

    def translations
      result = {}
      backends.reverse_each do |backend|
        backend_translations = backend.instance_eval do
          init_translations unless initialized?
          translations
        end
        result.deep_merge!(backend_translations)
      end
      result
    end
  end
end