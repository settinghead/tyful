class WordListController < ApplicationController
  
  def index
    @list = []
    if(current_user)
      current_user.authentications.each do |authentication|
        if(str = REDIS.get('wl_'+authentication.provider+'_'+authentication.uid))
          @list << ActiveSupport::JSON.decode(str)
        end
      end
    end
    respond_to do |format|
      format.html {render json: @list}
      format.json { render json: @list }
    end
  end
  
  def show
    str = nil
    @l = {}
    if(params[:id]=='recent')
      if session.has_key?('omniauth')
        str = REDIS.get('wl_'+session[:omniauth].provider+'_'+session[:omniauth].uid)
        if(str=='pending')
          @l = {:status => 'pending'}
        else
          WordListController.push_wordlist_task(session[:omniauth],current_user)
          @l = {:status => 'requested'}
        end
      else
        @l = {:error => 'not logged in'}
      end
    else
      str = REDIS.get('wl_'+params[:id])
    end
    @l = ActiveSupport::JSON.decode(str) if str
    respond_to do |format|
      format.html { render json: @l }
      format.json { render json: @l }
    end
  end
  
  def self.push_wordlist_task(omniauth, user)
    #enqueue wordlist generation task
    task = {:provider => omniauth['provider'], 
      :token => omniauth['credentials']['token'],
      :uid => omniauth['uid'],
      :user_id => user.id}
    REDIS.lpush("q", ActiveSupport::JSON.encode(task))
  end
end