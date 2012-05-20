class Template < ActiveRecord::Base
  belongs_to :user
  acts_as_votable
  
  validates :name, :presence => true
  validates :uuid, :presence => true
end
