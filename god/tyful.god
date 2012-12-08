ENV['RAILS_ENV'] = 'development' if !ENV['RAILS_ENV']
puts ENV['RAILS_ENV']

if ENV['RAILS_ENV']=='production'
  basedir = '/var/lib/jenkins/jobs/tyful-build/workspace'
else
  basedir = '/Users/settinghead/tyful'
end

God.watch do |w|
  w.name = "redis"
  w.dir = basedir
  w.start = "redis-server"
  w.log = basedir+'/log/'+w.name+'-'+ENV['RAILS_ENV']+'.log'
  w.keepalive
end

God.watch do |w|
  w.name = "rails"
  w.dir = basedir+"/frontend"
  w.env = {'RAILS_ENV' => ENV['RAILS_ENV'], 'RACK_ENV' => ENV['RAILS_ENV'], 'PORT' => 3000 }
  w.start = (ENV['RAILS_ENV']=='production') ? "bundle exec unicorn -p 3000 -E "+ENV['RAILS_ENV'] + " -c " + basedir + "/frontend/config/unicorn.rb" : "thin start -p 3002 -e " + ENV['RAILS_ENV']
  w.log = basedir+'/log/'+w.name+'-'+ENV['RAILS_ENV']+'.log'
  w.keepalive
end

God.watch do |w|
  w.name = "file"
  w.dir = basedir+"/fileserver"
  w.env = {'NODE_ENV' => ENV['RAILS_ENV'] }
  w.start = "node web.js"
  w.stop  = "killall -9 node"
  w.log = basedir+'/log/'+w.name+'-'+ENV['RAILS_ENV']+'.log'
  w.keepalive
end

God.watch do |w|
  w.name = "words"
  w.dir = basedir+"/backend"
  w.env = {'RAILS_ENV' => ENV['RAILS_ENV'] }
  w.start = "java -Xms64M -Xmx2G -cp target/*:targeclasses/:target/dependency/* com.settinghead.tyful.service.WordListService"
  w.log = basedir+'/log/'+w.name+'-'+ENV['RAILS_ENV']+'.log'
  w.keepalive
end

God.watch do |w|
  w.name = "shop"
  w.dir = basedir+"/backend"
  w.env = {'RAILS_ENV' => ENV['RAILS_ENV'] }
  w.start = "java -Xms64M -Xmx2G -cp target/*:targeclasses/:target/dependency/* com.settinghead.tyful.service.ShopService"
  w.log = basedir+'/log/'+w.name+'-'+ENV['RAILS_ENV']+'.log'
  w.keepalive
end

God.watch do |w|
  w.name = "photos"
  w.dir = basedir+"/backend"
  w.env = {'RAILS_ENV' => ENV['RAILS_ENV'] }
  w.start = "java -Xms64M -Xmx2G -cp target/*:targeclasses/:target/dependency/* com.settinghead.tyful.service.FbUploadService"
  w.log = basedir+'/log/'+w.name+'-'+ENV['RAILS_ENV']+'.log'
  w.keepalive
end

if ENV['RAILS_ENV']=='development'
God.watch do |w|
  w.name = "forward"
  w.dir = basedir
  w.start = "forward 3002"
  w.log = basedir+'/log/'+w.name+'-'+ENV['RAILS_ENV']+'.log'
  w.keepalive
end
end

