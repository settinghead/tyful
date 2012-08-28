class Template < ActiveRecord::Base
  extend FriendlyId
  belongs_to :user
  acts_as_votable
  attr_accessible :name, :description, :private, :uuid
  friendly_id :name, use: :slugged
                     
  validates :name, :presence => true
  validates :uuid, :presence => true
end
