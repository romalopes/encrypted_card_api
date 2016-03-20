Rails.application.routes.draw do
  resources :credit_cards do 
  end

  resources :users do 
  	# collection do 
  	# 	post 'create_user_master'
  	# end
  end

	match 'authenticate' => 'users#authenticate', via: [:post] 
  match 'create_user_master' => 'users#create_user_master', via: [:post] 
  match 'retrieve_credit_card_number' => 'credit_cards#retrieve_credit_card_number', via: [:post] 
end
