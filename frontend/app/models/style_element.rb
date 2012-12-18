class StyleElement < ActiveRecord::Base
  attr_accessible :element_type, :name
  has_and_belongs_to_many :style_element_sets
end
