class TemplatesController < ApplicationController
  
  impressionist :actions=>[:show,:edit], :unique => [:impressionable_type, :impressionable_id, :session_hash]
  
  # GET /templates
  # GET /templates.json
  def index
    
    @templates = Template.find(:all, :joins => 'LEFT OUTER JOIN "votes" ON "votes"."votable_id" = "templates"."id" AND "votes"."votable_type" = \'Template\'', :order => 'count(votes.id) DESC', :group => 'templates.id')
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @templates }
    end
  end

  # GET /templates/1
  # GET /templates/1.json
  def show
    
    @mode = "showTemplate"
    @template = Template.find(params[:id])
    @token = "1" if current_user && @template.user && current_user.id == @template.user.id

    
    ShopController.push_shop_predict_task(current_user,@template)
    respond_to do |format|
      format.html # show.html.erb
      # format.json { render json: @template }
    end
  end
  
  def like
    @template = Template.find(params[:id])
    @template.liked_by current_user
    respond_to do |format|
      format.js do
        render 'emote.js'
      end
    end
  end
  
  def unlike
    @template = Template.find(params[:id])
    current_user.unvote_for @template
    respond_to do |format|
      format.js do
        render 'emote.js'
      end
    end
  end
  

  # GET /templates/new
  # GET /templates/new.json
  def new
    @template = Template.new
    @mode = 'newTemplate'
    ShopController.push_shop_predict_task(current_user,@template)
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @template }
    end
  end

  # GET /templates/1/edit
  def edit
    @template = Template.find(params[:id])
    @token = "1" if current_user && @template.user && current_user.id == @template.user.id
    
    ShopController.push_shop_predict_task(current_user,@template)
    
    @mode = 'editTemplate'
    respond_to do |format|
      format.html # show.html.erb
    end
    
  end

  # POST /templates
  # POST /templates.json
  def create
    @template = Template.new(params[:template])
    if(params[:nickname]) 
      current_user.nickname = params[:nickname]
      current_user.save
    end
    respond_to do |format|
      @template.user = current_user
      if @template.save
        format.html { redirect_to @template, notice: 'Template was successfully created.' }
        format.json { render json: @template, status: :created, location: @template }
        format.js
      else
        format.html { render action: "new" }
        format.json { render json: @template.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PUT /templates/1
  # PUT /templates/1.json
  def update
    @template = Template.find(params[:id])

    respond_to do |format|
      if @template.update_attributes(params[:template])
        format.html { redirect_to @template, notice: 'Template was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @template.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /templates/1
  # DELETE /templates/1.json
  def destroy
    @template = Template.find(params[:id])
    @template.destroy

    respond_to do |format|
      format.html { redirect_to templates_url }
      format.json { head :ok }
      format.js
    end
  end
end
