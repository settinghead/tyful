#Set the current environment to true in the env object
currentEnv = process.env.NODE_ENV or 'development'
exports.appName = "Groffle Fileserver"
exports.env =
  production: false
  staging: false
  test: false
  development: false
exports.env[currentEnv] = true
exports.log =
  path: __dirname + "/var/log/app_#{currentEnv}.log"
exports.server =
  port: 5000
  #In staging and production, listen loopback. nginx listens on the network.
  ip: '127.0.0.1'
if currentEnv not in ['production', 'staging']
  exports.enableTests = true
  #Listen on all IPs in dev/test (for testing from other machines)
  exports.server.ip = '0.0.0.0'
if currentEnv in ['production']
  exports.redis_db = "redis://localhost:6379/2"
else if currentEnv in ['test']
  exports.redis_db = "redis://localhost:6379/1"
else
  exports.redis_db = "redis://localhost:6379/0"
  