Spree::Core::Engine.routes.draw do
  post '/payu/notify', to: 'payu#notify'
  get '/payu/positive', to: 'payu#positive'
  get '/payu/negative', to: 'payu#negative'
end
