conn = Mongo::Connection.new.db("translator_test").collection("translations")
Translator.current_store = Translator::MongoStore.new(conn)

I18n.backend = Translator.setup_backend(I18n.backend)

#Translator.auth_handler = proc {
#  authenticate_or_request_with_http_basic do |user_name, password|
#    user_name == 'some' && password == 'user'
#  end
#}

Translator.layout_name = "dummy_admin"
