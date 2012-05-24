class Template < ActiveRecord::Base
  belongs_to :user
  acts_as_votable
  has_friendly_id :name,
                   :use_slug => true,
                   :approximate_ascii => true
                     
  validates :name, :presence => true
  validates :uuid, :presence => true
end
