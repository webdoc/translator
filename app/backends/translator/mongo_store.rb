module Translator
  class MongoStore
    def initialize(collection)
      @collection = collection
    end

    def keys
      @collection.distinct :_id
    end

    def []=(key, value)
      value = nil if value.blank?
      collection.update({:_id => key},
                        {'$set' => {:value => ActiveSupport::JSON.encode(value)}},
                        {:upsert => true, :safe => true})
    end

    def [](key)
      if document = collection.find_one(:_id => key)
        document["value"]
      else
        nil
      end
    end

    def clear_database
      collection.drop
    end

    def translations
      result = {}
      collection.find.each do |an_entry|
        new_hash = {}
        previous_hash = new_hash
        previous_key = nil
        an_entry["_id"].split('.').each do |a_key|
          previous_hash = previous_hash[previous_key] = {} if (previous_key)
          previous_key = a_key.to_sym
        end
        previous_hash[previous_key] = ActiveSupport::JSON.decode(an_entry["value"])
        result.deep_merge!(new_hash)
      end
      result
    end

    private

    def collection; @collection; end
  end
end

