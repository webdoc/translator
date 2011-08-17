require 'translator/engine' if defined?(Rails) && Rails::VERSION::MAJOR == 3

module Translator
  class << self
    attr_accessor :auth_handler, :current_store
    attr_reader :simple_backend
    attr_writer :layout_name
  end

  def self.setup_backend(simple_backend)
    @simple_backend = simple_backend

    Translator::Chain.new(Translator::KeyValue.new(@current_store), @simple_backend)
  end

  def self.locales
    @simple_backend.available_locales
  end

  def self.is_missing?(key, locale)
    @current_store["#{locale.to_s}.#{key.to_s}"].nil?
  end

  def self.need_review?(key, locale)
    @current_store.need_review?("#{locale.to_s}.#{key.to_s}")
  end

  def self.keys_for_strings(options = {})
    @simple_backend.available_locales
    flat_translations = {}
    flatten_keys nil, @simple_backend.instance_variable_get("@translations"), flat_translations
    flat_translations = flat_translations.delete_if {|k,v| !v.is_a?(String)}
    keys = (flat_translations.keys + 
            Translator.current_store.keys).map {|k| k.sub(/^\w*\./, '') }.uniq

    if options[:show].to_s == 'missing'
      keys.select! do |k|
        is_missing = false
        Translator.locales.each do |locale|
            if (locale != :en && Translator.is_missing?(k, locale))
              is_missing = true
            end
        end
        is_missing
      end
    elsif options[:show].to_s == 'need_review'
      keys.select! do |k|
        need_review = false
        Translator.locales.each do |locale|
            if (locale != :en && Translator.need_review?(k, locale))
              need_review = true
            end
        end
        need_review
      end
    else
      keys
    end
    if options[:filter].present?
      keys.select! do |key|
        !key.to_s.match(options[:filter]).nil?
      end
    else
      keys
    end
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
    hash
  end
end

