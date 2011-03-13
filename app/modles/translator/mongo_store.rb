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
      collection.update({:_id => key}, {'$set' => {:value => ActiveSupport::JSON.encode(value)}}, :upsert => true, :safe => true)
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

    private

    def collection; @collection; end
  end
end

