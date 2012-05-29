class AuthenticationsController < ApplicationController
  def index
    @authentications = current_user.authentications if current_user
  end

  def create
    omniauth = request.env["omniauth.auth"]
    session[:omniauth] = omniauth.except('extra')
    
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      flash[:notice] = "You have successfully signed in to Groffle."
      post_authentication_work(authentication.user,omniauth)
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:notice] = "You are now connected to Facebook."
      post_authentication_work(current_user,omniauth)
      redirect_to authentications_url
    else
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save
        flash[:notice] = "You have successfully signed in to Groffle."
        sign_in_and_redirect(:user, user)
        post_authentication_work(user,omniauth)
      else
        redirect_to new_user_registration_url
      end
    end
  end

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    redirect_to authentications_url, :notice => "Successfully disconnected from Facebook."
  end
  
  protected

  # This is necessary since Rails 3.0.4
  # See https://github.com/intridea/omniauth/issues/185
  # and http://www.arailsdemo.com/posts/44
  def handle_unverified_request
    true
  end
  
  private
  def post_authentication_work(user, omniauth)
    # generate user token if it's not present
    unless user.token?
      user.token = rand(36**128).to_s(36)
      user.save
    end
    
    REDIS.set("token_#{user.id}", user.token)
    #REDIS.set("fbtoken_#{user.id}", omniauth['credentials']['token'])

    WordListController.push_wordlist_task(omniauth, user)
    
  end
  
end
