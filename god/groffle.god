ENV['RAILS_ENV'] = 'development' if !ENV['RAILS_ENV']
puts ENV['RAILS_ENV']

if ENV['RAILS_ENV']=='production'
  basedir = '/var/lib/jenkins/jobs/groffle-rails/workspace'
else
  basedir = '/Users/settinghead/wexpression'
end

God.watch do |w|
  w.name = "groffle-rails"
  w.dir = basedir+"/groffle"
  w.start = "rails server thin -p 3000 -e "+ENV['RAILS_ENV']
  w.keepalive
end

God.watch do |w|
  w.name = "groffle-file"
  w.dir = basedir+"/groffle-relay"
  w.start = "node web.js"
  w.keepalive
end

God.watch do |w|
  w.name = "groffle-wordlist"
  w.dir = basedir+"/groffle-backend"
  w.start = "RAILS_ENV="+ENV['RAILS_ENV']+" java -cp target/*:targeclasses/:target/dependency/* com.settinghead.wenwentu.service.WordListService"
  w.keepalive
end

God.watch do |w|
  w.name = "groffle-shop"
  w.dir = basedir+"/groffle-backend"
  w.start = "RAILS_ENV="+ENV['RAILS_ENV']+" java -cp target/*:targeclasses/:target/dependency/* com.settinghead.wenwentu.service.ShopService"
  w.keepalive
end

