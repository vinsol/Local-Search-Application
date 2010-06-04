# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_askme_session',
  :secret      => 'dc1b466c4c900cd5d5226617090a91de53197e19e264615151333fbaa33adc209dc319cd935d7b16d845a52ef6bcc2dcf621369c83852100a6dae84dba96cedb'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store
