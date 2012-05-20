ENV['RAILS_ENV'] = 'development' if !ENV['RAILS_ENV']
puts ENV['RAILS_ENV']

if ENV['RAILS_ENV']=='production'
  basedir = '/var/lib/jenkins/jobs/groffle-build/workspace'
else
  basedir = '/Users/settinghead/groffle'
end

God.watch do |w|
  w.name = "groffle-rails"
  w.dir = basedir+"/frontend"
  w.start = "rails server thin -p 3000 -e "+ENV['RAILS_ENV']
  w.keepalive
end

God.watch do |w|
  w.name = "groffle-file"
  w.dir = basedir+"/fileserver"
  w.start = "NODE_ENV=" + ENV['RAILS_ENV'] +" node web.js >> web.log"
  w.keepalive
end

God.watch do |w|
  w.name = "groffle-wordlist"
  w.dir = basedir+"/backend"
  w.start = "RAILS_ENV="+ENV['RAILS_ENV']+" java -Xms200M -Xmx2G -cp target/*:targeclasses/:target/dependency/* com.settinghead.wenwentu.service.WordListService"
  w.keepalive
end

God.watch do |w|
  w.name = "groffle-shop"
  w.dir = basedir+"/backend"
  w.start = "RAILS_ENV="+ENV['RAILS_ENV']+" java -Xms200M -Xmx2G -cp target/*:targeclasses/:target/dependency/* com.settinghead.wenwentu.service.ShopService"
  w.keepalive
end

