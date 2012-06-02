class TemplatesController < ApplicationController
  
  impressionist :actions=>[:show,:edit], :unique => [:impressionable_type, :impressionable_id, :session_hash]
  
  def retrieve_token
    @token = current_user.token if current_user && @template && @template.user && @template.user.id==current_user.id
    @fbToken =  session[:omniauth]['credentials']['token'] if session[:omniauth] && session[:omniauth]['credentials']
    @fbUid = session[:omniauth]['uid'] if session[:omniauth]
  end

  
  # GET /templates
  # GET /templates.json
  def index
    @templates = Template.find(:all, :conditions => ['private=?', false], :joins => 'LEFT OUTER JOIN "votes" ON "votes"."votable_id" = "templates"."id" AND "votes"."votable_type" = \'Template\'',
     :order => 'count(votes.id) DESC', :group => 'templates.id')
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @templates }
    end
  end
  
  def my
    @templates = Template.find_all_by_user_id(current_user.id)
    respond_to do |format|
      format.html do 
        render 'index'
      end
      format.json { render json: @templates }
    end
  end

  def newest
    @templates =  Template.find(:all, :conditions => ['private=?', false],
     :order => 'created_at DESC')
    respond_to do |format|
      format.html do 
        render 'index'
      end
      format.json { render json: @templates }
    end
  end

  

  # GET /templates/1
  # GET /templates/1.json
  def show
    if !current_user
      session["user_return_to"]=request.url
      redirect_to '/auth/facebook/'
    else
      @mode = "renderTu"
      @template = Template.find(params[:id])
      retrieve_token
      ShopController.push_shop_predict_task(current_user,@template)
      REDIS.set("token_#{@template.uuid}", @template.user.token) if @template && @template.user;
      respond_to do |format|
        format.html # show.html.erb
        # format.json { render json: @template }
      end
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
    if !current_user
      session["user_return_to"]=request.url
      redirect_to '/auth/facebook/'
    else
      @template = Template.new
      retrieve_token
      @mode = 'newTemplate'
      ShopController.push_shop_predict_task(current_user,@template)
    
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @template }
      end
    end
  end

  # GET /templates/1/edit
  def edit
    
    @template = Template.find(params[:id])
    authorize! :manage, @template
    retrieve_token
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
    authorize! :manage, @template

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
    authorize! :manage, @template
    
    @template.destroy

    respond_to do |format|
      format.html { redirect_to templates_url }
      format.json { head :ok }
      format.js
    end
  end
end
