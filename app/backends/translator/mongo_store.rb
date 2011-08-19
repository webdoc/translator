module Translator
  class MongoStore
    def initialize(database)
      @database = database
      @collection = @database.collection("translations")
    end

    def database
      return @database
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
      document = collection.find({:_id => Regexp.new("^#{key}")})
      if document && document.count == 1
        document.first()["value"]
      elsif document && document.count > 1
        result = {}
        document.each do |d|
          result[d['_id'].gsub("#{key}.", "").to_sym] = d['value']
        end
        ActiveSupport::JSON.encode(result)
      end
    end

    def set_need_review(key, flag)
      value_to_set = flag ? true : false
      collection.update({:_id => key},
                        {'$set' => {:need_review => flag}},
                        {:safe => true})
    end

    def need_review?(key)
      if document = collection.find_one(:_id => key)
        document["need_review"]? true : false
      else
        false
      end
    end

    def clear_key(key)
      collection.remove(:_id => key)
    end

    def clear_database
      collection.drop
    end

    # return all translations in the form of a hash like
    # { :en => { :namespace => {:key => "blabla" } } }
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

