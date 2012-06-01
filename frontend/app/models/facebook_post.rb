class FacebookPost < ActiveRecord::Base
  attr_accessible :fbid, :message, :time_posted, :link, :type, :category
end
