# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_oracle_build_session',
  :secret      => '0283157811837dbe45f5ae7eaff873f14af2679f74c59e97a0f36a540d2cfdbb6cd29c95b212c7ef6f93e6a9d9f029a294034599f66b4c76894e0d233ed506c4'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
