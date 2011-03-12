require 'translator/engine' if defined?(Rails) && Rails::VERSION::MAJOR == 3

module Translator
  class << self
    attr_accessor :layout_name, :locales, :auth_handler, :current_store
  end
end

