require 'translator/engine' if defined?(Rails) && Rails::VERSION::MAJOR == 3

module Translator
  class << self
    attr_accessor :auth_handler, :current_store
    attr_reader :simple_backend
    attr_writer :layout_name
  end

  def self.setup_backend(simple_backend)
    @simple_backend = simple_backend

    I18n::Backend::Chain.new(I18n::Backend::KeyValue.new(@current_store), @simple_backend)
  end

  def self.locales
    @simple_backend.available_locales
  end

  def self.keys_for_strings
    @simple_backend.available_locales

    flat_translations = {}
    flatten_keys nil, @simple_backend.instance_variable_get("@translations"), flat_translations
    flat_translations = flat_translations.select {|k,v| v.is_a?(String)}
    (flat_translations.keys + Translator.current_store.keys).map {|k| k.sub(/^\w*\./, '') }.uniq
  end

  def self.layout_name
    @layout_name || "translator"
  end

  private

  def self.flatten_keys(current_key, hash, dest_hash)
    hash.each do |key, value|
      full_key = [current_key, key].compact.join('.')
      if value.kind_of?(Hash)
        flatten_keys full_key, value, dest_hash
      else
        dest_hash[full_key] = value
      end
    end
  end
end

