Rails.application.routes.draw do
  resources :messages
	resources :rs_as
	  
	post '/rsa', to: 'rs_as#create'
	get '/rsa/:id', to: 'rs_as#show'

	post '/rsa/:id/encrypt_messages', to: 'messages#create'
	get '/rsa/:id/encrypt_messages/:mid', to: 'messages#show'

	post '/rsa/:id/decrypt_messages', to: 'messages#decrypt'
end
