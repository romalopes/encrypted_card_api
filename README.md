### Encrypted card API
API to save encrypted credit card linked to users.<br>
		GitHub<br>
		  https://github.com/romalopes/encrypted_card_api<br>


		To run locally:
		  $ git clone   https://github.com/romalopes/encrypted_card_api.git
			$ cd encrypted_card_api
			$ bundle install
			$ rake db:migrate

		 # To test
		  	$ rake db:migrate RAILS_ENV=test
		  	$ bundle exec rspec spec  (63 tests)


		 # To run the api web server
		  	$ rails s -p 3030 (this port only to be able to be accessed by encrypted_card_client)


  	First action to do
		http://localhost:3030/create_user_master?password=PASSWORD (post)
      Create a users called user_master.
      Some actions should be done only by this user

    Other actions:
      http://localhost:3030/authenticate_user?login=user_master&password=romalopes (post)
        Authenticate user and return a 50 character TOKEN.

      http://localhost:3030/users?token=TOKEN (post)
        Return all users.   Only user_master

      http://localhost:3030/create_user?token=TOKEN&login=romalopes&password=romalopes (post)
        Create a new user.  Only user_master


      http://localhost:3030/create_card?token=<TOKEN>&key=<KEY>&credit_card_number=<CREDI_CARD_NUMBER>&password=<PASSWORD> (post)
        Create a new card, encrypting the credit_card_number.  Password is a value passed by client to encrypt credit card number.

      http://localhost:3030/retrieve_credit_card_number?token=<TOKEN>&key=<KEY>&password=<PASSWORD> (post)
        Retrieve the credit card number.  Password is an information passed by client to encrypt credit card number.