class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :populate_word_lists

  private
  def populate_word_lists
  	
  end
  
end
