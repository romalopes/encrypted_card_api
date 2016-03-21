Rails.application.routes.draw do
  resources :credit_cards
  resources :users

	match 'authenticate' => 'users#authenticate', via: [:post] 
  match 'create_user_master' => 'users#create_user_master', via: [:post] 
  match 'reset_authentication_tries' => 'users#reset_authentication_tries', via: [:post] 
  match 'logs' => 'users#logs', via: [:post] 
  match 'retrieve_credit_card_number' => 'credit_cards#retrieve_credit_card_number', via: [:post] 
end
