conn = Mongo::Connection.new.db("go_translate_yourself_test").collection("translations")
Translator.current_store = Translator::MongoStore.new(conn)
Translator.locales = [:pl, :de]

I18n.backend = I18n::Backend::KeyValue.new Translator.current_store

#Translator.auth_handler = proc {
#  authenticate_or_request_with_http_basic do |user_name, password|
#    user_name == 'some' && password == 'user'
#  end
#}

Translator.layout_name = "dummy_admin"
