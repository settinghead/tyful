require 'sinatra'
class ResizeApp < Sinatra::Base
  get '/resize/:dimensions/*' do |operation, dimensions, url|
    image = MiniMagick::Image.open("http://#{ url }")

    image.combine_options do |command|
      #
      # The box filter majorly decreases processing time without much
      # decrease in quality
      #
      command.filter("box")
      command.resize(dimensions)
    end

    send_file(image.path, :disposition => "inline")
  end
    
  get '/crop/:dimensions/*' do |operation, dimensions, url|

      image = MiniMagick::Image.open("http://#{ url }")

      image.combine_options do |command|
        command.filter("box")
        command.resize(dimensions + "^^")
        command.gravity("Center")
        command.extent(dimensions)
      end

      send_file(image.path, :disposition => "inline")

    end
end