Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  #provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  fb_permissions = "offline_access, read_stream, publish_stream, user_notes, user_status, user_activities, user_likes, user_interests, user_hometown, user_location, email, user_checkins"
  if Rails.env.production?
    provider :facebook, GRAPH_APP_ID, GRAPH_SECRET, {:scope => fb_permissions, :client_options => {:ssl => {:ca_path => "/usr/lib/ssl"}}}
  else
    provider :facebook, GRAPH_APP_ID, GRAPH_SECRET, {:scope => fb_permissions}
  end
end