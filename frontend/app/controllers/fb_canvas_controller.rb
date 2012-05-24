class FbCanvasController < ApplicationController
  def index
    redirect_to "/auth/facebook?signed_request=#{params['signed_request']}&state=canvas"
  end
  def create
    redirect_to "/auth/facebook?signed_request=#{params['signed_request']}&state=canvas"
  end
  
end
