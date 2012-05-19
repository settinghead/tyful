class Template < ActiveRecord::Base
  belongs_to :user
  validates :name, :presence => true
  validates :uuid, :presence => true
end
