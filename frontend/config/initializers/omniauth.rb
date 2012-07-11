Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  #provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  fb_permissions = "offline_access, user_about_me, friends_about_me, publish_stream, publish_actions, friends_notes, user_notes, user_status, friends_status, user_activities, friends_activities, user_likes, friends_likes, user_interests, friends_interests, user_hometown, friends_hometown, user_location, friends_location, user_photos, friends_photos, email, user_checkins, friends_checkins"
  if RbConfig::CONFIG["host_os"] =~ /linux/
    provider :facebook, GRAPH_APP_ID, GRAPH_SECRET, {:scope => fb_permissions, :authorize_params => { :display => 'page' }, :client_options => {:ssl => {:ca_path => "/etc/ssl/certs"}}}
  else
    provider :facebook, GRAPH_APP_ID, GRAPH_SECRET, {:scope => fb_permissions, :authorize_params => { :display => 'page' }}
  end
  
end