class Template < ActiveRecord::Base
  belongs_to :user
  acts_as_votable
  extend FriendlyId
  friendly_id :name, use: :slugged
                     
  validates :name, :presence => true
  validates :uuid, :presence => true
end
