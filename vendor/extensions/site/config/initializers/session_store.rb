# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_testing_copy_session',
  :secret      => '700bd65032d42849334e3c6d7568f781f60e7a78a259304490a153feaafe72a52f555bc35ba9c311bcf03495c56bbb938f0a3726d127aeaba8bb84308f250677'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store