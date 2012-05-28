require("coffee-script");

var express = require('express'),
    fs = require('fs'), node_uuid = require('node-uuid'),  formidable = require('formidable'),
	URL = require('url'), redis = require("redis"),    util = require('util'),
	knox = require('knox'), sys=require('sys');
	var exec = require('child_process').exec;
	
	
	var s3client = knox.createClient({
	    key: 'AKIAICJYKXXF7EZ5A5IQ'
	  , secret: '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'
	  , bucket: 'wwt_templates'
	});
	
    app = express.createServer();
	app.use(express.static(__dirname + '/../static'));
		
console.log(require('./config').redis_db);
var redisUrl = URL.parse(require('./config').redis_db);
var redisClient = redis.createClient(redisUrl.port, redisUrl.hostname);
if(redisUrl.auth){
	redisClient.auth(redisUrl.auth.substr(redisUrl.auth.indexOf(":")+1), startServices());
}
else{
	startServices();
}

function startServices(){
	//select correct redis db
	if(redisUrl.path)
		redisClient.select(redisUrl.path[0]=='/'?redisUrl.path.substr(1):redisUrl.path);
		
	app.get('/t', function(req, res){
				res.header("Content-Type", "text/html");
			  res.send('<h1>t</h1><form method="post" action="/t" enctype="multipart/form-data">'
			           + '<p>Image: <input type="file" name="test" /></p>'
			           + '<p><input type="submit" value="Upload" /></p>'
			           + '</orm>');
			});
	
	app.post('/t', function(req, res){
		var form = new formidable.IncomingForm();
		form.parse(req, function(err, fields, files) {
		    if(err) {
		      next(err);
		    } else {
				var uuid;
				if(fields.templateUuid){
					//TODO: check token
					uuid = fields.templateUuid;
				}
				else{
					uuid =  node_uuid.v4();
				}
				console.log(uuid);
				fs.mkdir('/tmp/' + uuid,0777, function(e){
					ins = fs.createReadStream(files.template.path);
					ous = fs.createWriteStream('/tmp/' +uuid +'/' + uuid +".zip");
					util.pump(ins, ous, function(err) {
						if(err) {
				    		next(err);
						} else {
							exec('unzip -o /tmp/'+uuid+'/'+uuid+'.zip /preview.png -d /tmp/'+uuid+'/', function(){
						          fs.readFile('/tmp/'+uuid+'/preview.png', function (err, data) {
								      if (err) throw err;
				   				      var req4 = s3client.put(uuid+'.png', {
    			   					  'Content-Length': data.length,
								      'Content-Type': 'application/octet-stream',
									  'x-amz-acl': 'private'
				   					  });
				   					  req4.on('response', function(res4){
				   					    if (200 == res4.statusCode) {
				   					      console.log('saved to %s', req4.url);
				   					    }
				   					  });
				   					  req4.end(data);
		    	 				   });
							 });
						
						//client.set(id, body);
						fs.readFile('/tmp/' +uuid +'/' + uuid +".zip", function(err, buf){
					  	    var req3 = s3client.put(uuid+'.zip', {
						  			'Content-Length': buf.length,
						  			 'Content-Type': 'application/octet-stream',
						  		      'x-amz-acl': 'private'
						  		  });
						  req3.on('response', function(res3){
						    if (200 == res.statusCode) {
						      console.log('saved to %s', req3.url);
  					  	      res.send(JSON.stringify({"uuid":uuid}));
						    }
							else{
								res.send(JSON.stringify({"error":res.statusCode}));
							}
						  });
						  req3.end(buf);
					   });
				   }
				});
		    });
		}
		});
	});

	//template repository
	app.get('/t/:id', function(req, res){
		var count = 0;
		console.log('Retrieving s3 file '+req.params.id+'.zip');
		s3client.get(req.params.id+'.zip').on('response', function(res3){
		  console.log(res3.statusCode);
		  console.log(res3.headers);
		  res3.setEncoding('binary');
		  res3.on('data', function(chunk){
			      res.write(chunk, "binary");
				  count+=chunk.length;
		  });
		  res3.on('end', function(){
			  console.log('File size: ' + count);
		  	  res.end();
		  });
		}).end();
	});
	
	//template preview
	app.get('/tp/:id', function(req, res){
		var count = 0;
		s3client.get(req.params.id).on('response', function(res3){
		  console.log(res3.statusCode);
		  console.log(res3.headers);
		  res3.setEncoding('binary');
		  res3.on('data', function(chunk){
			      res.write(chunk, "binary");
				  count+=chunk.length;
		  });
		  res3.on('end', function(){
			  console.log('File size: ' + count);
		  	  res.end();
		  });
		}).end();
	});
	
	
	app.post('/r', function(req, res){
		var form = new formidable.IncomingForm();
		form.parse(req, function(err, fields, files) {
		    if(err) {
		      next(err);
		    } else {
				var uuid =  node_uuid.v4();
				console.log(uuid);
				ins = fs.createReadStream(files.image.path);
				ous = fs.createWriteStream('/tmp/' + uuid +".png");
				util.pump(ins, ous, function(err) {
					if(err) {
			    		 res.send(JSON.stringify({"error":err}));
					} else {
						console.log("saved to "+'/tmp/' + uuid +".png");
						 res.send(JSON.stringify({"id":uuid}));
					}
				});
			}
		});
	});  


	app.get('/r/:id', function(req, res){
	
	fs.readFile('/tmp/'+req.params.id+'.png', "binary", function(err, file) {
	      if(err) {        
	        res.writeHead(500, {"Content-Type": "text/plain"});
	        res.write(err + "\n");
	        res.end();
	        return;
	      }
		res.writeHead(200);
		      res.write(file, "binary");
		      res.end();
		});
	});
	
	app.get('/crossdomain.xml', function(req,res){
		fs.readFile('crossdomain.xml', "binary", function(err, file) {
		      if(err) {        
		        res.writeHead(500, {"Content-Type": "text/plain"});
		        res.write(err + "\n");
		        res.end();
		        return;
		      }
			res.writeHead(200);
			      res.write(file, "binary");
			      res.end();
			});
		});
		
	console.log("Port: "+process.env.PORT);
	var port = process.env.PORT || 5000;
	app.listen(port);

}

function validate_token(user_id, token, callback){
	var realToken = redisClient.get("token_"+user_id, function (err, reply) {
		var validated = reply.toString()==token;
		callback(validated);
    });
}