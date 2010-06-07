# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_askme_session',
  :secret      => '6666b6cf32af1f1c60bc553567f7cf4ab1fa3773a16ec6bce54f5500fec2c67daa83a6198b469166304a07aa7c863ff7707c965f59188297f766854ce4b5610a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store
