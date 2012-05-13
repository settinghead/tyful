class Template < ActiveRecord::Base
  validates :name, :presence => true
  validates :uuid, :presence => true
end
