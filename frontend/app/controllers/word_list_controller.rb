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
  
  def facebook
    str = nil
    @l = {}
    if(params[:id]=='me')
      targetId = session[:omniauth].uid;
    else
      targetId = params[:id]
    end
  
    if session.has_key?('omniauth')
      str = REDIS.get("wl_#{session[:omniauth].provider}_#{session[:omniauth].uid}_#{targetId}")
      if(str)
        @l = ActiveSupport::JSON.decode(str)
      else
        WordListController.push_wordlist_task(session[:omniauth],current_user,targetId)
        @l = {:status => 'requested'}
      end
    else
      @l = {:error => 'You need to log in to Facebook in order to create an artwork for Facebook profile. Tyful will use a sample word list for now.'}
    end
    
    respond_to do |format|
      format.html { render json: @l }
      format.json { render json: @l }
    end
      
  end
    
  def url
    
  end
  
  def show
    @l = {}
    str = REDIS.get('wl_'+params[:id])
    if(str)
      @l = ActiveSupport::JSON.decode(str)
    else
      @l = {:error => "No such word list with given id #{params[:id]}"}
    end
    respond_to do |format|
      format.html { render json: @l }
      format.json { render json: @l }
    end
  end
  
  def self.push_wordlist_task(omniauth, user, targetId=nil)
    targetId = omniauth['uid'] if !targetId
    #enqueue wordlist generation task
    task = {:provider => omniauth['provider'], 
      :token => omniauth['credentials']['token'],
      :uid => omniauth['uid'],
      :user_id => user.id,
      :targetId => targetId
    }
    REDIS.lpush("wordlisttask_q", ActiveSupport::JSON.encode(task))
  end
end
