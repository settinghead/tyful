class FacebookController < ApplicationController
  before_filter :connect_fb
  
  def invite
    respond_to do |format|
      format.js 
    end
  end

  def photos
    @photos = @graph.get_connections(params[:fb_uid], "photos")
    respond_to do |format|
      format.html 
      format.json {render json: @photos}
    end
  end
    
  private 
  def connect_fb
      if not current_user
        redirect_to '/auth/facebook/' 
      elsif not session["fb_access_token"]
       fb_auths = current_user.authentications.where(:provider=>'facebook')
       redirect_to '/auth/facebook/' if(fb_auths.size==0)
       session["fb_access_token"] = fb_auths.first.access_token
     end
      @graph = Koala::Facebook::API.new(session["fb_access_token"])
  end
end
