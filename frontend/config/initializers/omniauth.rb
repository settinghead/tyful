Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  #provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  fb_permissions = "offline_access, user_about_me, read_stream, publish_stream, user_notes, user_status, user_activities, user_likes, user_interests, user_hometown, user_location, email, user_checkins"
  if RbConfig::CONFIG["host_os"] =~ /linux/
    provider :facebook, GRAPH_APP_ID, GRAPH_SECRET, {:scope => fb_permissions, :authorize_params => { :display => 'popup' }, :client_options => {:ssl => {:ca_path => "/etc/ssl/certs"}}}
  else
    provider :facebook, GRAPH_APP_ID, GRAPH_SECRET, {:scope => fb_permissions, :authorize_params => { :display => 'popup' }}
  end
  
end