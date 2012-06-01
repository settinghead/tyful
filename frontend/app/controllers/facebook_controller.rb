class FacebookController < ApplicationController
  
  def invite
    respond_to do |format|
      format.js 
    end
  end


end
