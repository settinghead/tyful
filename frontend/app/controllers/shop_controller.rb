class ShopController < ApplicationController
  def show
    if(params[:id]=='generic')
      str = REDIS.get('shop_generic')
    elsif(params[:id]=='predict')
      userId = current_user ? current_user.id : nil
      key = 'shop_'+ShopController.c_null(userId).to_s+'_'+ShopController.c_null(params[:templateId]);

      str = REDIS.get(key)
      @l = {}
      
      if(str)
        @l = ActiveSupport::JSON.decode(str)
      else
        ShopController.push_shop_predict_task(current_user,Template.find(params[:templateId]))
        @l = {:status => 'requested'}
      end
    end    
    respond_to do |format|
      format.html {render json: @l }
      format.json { render json: @l }
    end
  end
  
  def self.push_shop_predict_task(user, template)
    #enqueue shop prediction task
    userId = user ? user.id : nil
    templateId = template ? template.id : nil
    task = {:userId => c_null(userId), 
      :templateId => c_null(templateId)}
    REDIS.lpush("shoptask_q", ActiveSupport::JSON.encode(task))
  end
  
  def self.c_null(value)
    if(!value)
      return 'null'
    else
      return value
    end
  end
  
end
