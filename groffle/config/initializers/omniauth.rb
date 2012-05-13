Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  #provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  fb_permissions = "offline_access, read_stream, publish_stream, user_notes, user_status, user_activities, user_likes, user_interests, user_hometown, user_location, email, user_checkins"
  
  if RbConfig::CONFIG["host_os"] =~ /mingw|mswin/
    ca_file = File.expand_path Rails.root.join("config", "cacert.pem")
    ssl_options = {}
    ssl_options[:ca_path] = '/etc/ssl/certs' if Rails.env.staging?
    ssl_options[:ca_file] = ca_file
    provider :facebook, GRAPH_APP_ID, GRAPH_SECRET, {:scope => fb_permissions, :client_options => {:ssl => ssl_options}}
  else
    provider :facebook, GRAPH_APP_ID, GRAPH_SECRET, {:scope => fb_permissions}
  end
end