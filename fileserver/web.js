var express = require('express'),
    fs = require('fs'), node_uuid = require('node-uuid'), 
	URL = require('url'), redis = require("redis"),
	knox = require('knox'), sys=require('sys');
	var exec = require('child_process').exec;
	
	
	var s3client = knox.createClient({
	    key: 'AKIAICJYKXXF7EZ5A5IQ'
	  , secret: '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'
	  , bucket: 'wwt_templates'
	});
	
    app = express.createServer();
	app.enable('view cache');

//url = URL.parse("redis://redistogo:15ccf727b1849df6b901821393510e82@drum.redistogo.com:9724/");
//var client = redis.createClient(url.port, url.hostname);
//client.auth(url.auth.substr(url.auth.indexOf(":")+1), function(){
	
	app.get('/t', function(req, res){
		res.header("Content-Type", "text/html");
	  res.send('<h1>t</h1><form method="post" action="/t" enctype="multipart/form-data">'
	           + '<p>Image: <input type="file" name="test" /></p>'
	           + '<p><input type="submit" value="Upload" /></p>'
	           + '</orm>');
	});
	
	app.post('/t', function(req, res){
	  var body = [];
	  var header = '';
	  var content_type = req.headers['content-type'];
	  var boundary = (content_type.split('; ').length<2)?"":content_type.split('; ')[1].split('=')[1];
	  var content_length = parseInt(req.headers['content-length']);
	  var headerFlag = true;
	  var filename = 'dummy.bin';
	  var filenameRegexp = /filename="(.*)"/m;
	  console.log('content-type: ' + content_type);
	  console.log('boundary: ' + boundary);
	  console.log('content-length: ' + content_length);

	  req.on('data', function(raw) {
	    console.log('received data length: ' + raw.length);
	    var i = 0;
	    while (i < raw.length)
	      if (headerFlag) {
	        var chars = raw.slice(i, i+4).toString();
	        if (chars === '\r\n\r\n') {
	          headerFlag = false;
	          header = raw.slice(0, i+4).toString();
	          console.log('header length: ' + header.length);
	          i = i + 4;
	          // get the filename
	          var result = filenameRegexp.exec(header);
	          if (result[1]) {
	            filename = result[1];
	          }
	          console.log('filename: ' + filename);
	          console.log('header done');
	        }
	        else {
	          i += 1;
	        }
	      }
	      else { 
	        // parsing body including footer
	        body += raw.toString('binary', i, raw.length);
	        i = raw.length;
	        console.log('actual file size: ' + body.length);
	      }
	  });

	  req.on('end', function() {		  
	    // removing footer '\r\n'--boundary--\r\n' = (boundary.length + 8)
	    body = body.slice(0, body.length - (boundary.length + 8))
	    console.log('final file size: ' + body.length);
		var id = node_uuid.v4();
		
		/******Extract preview file******/
		//create directory
		fs.mkdir('/tmp/' + id,0777, function(e){
	  	    fs.writeFile('/tmp/' +id +'/' + id +".zip", body, 'binary', function(){
	  	    	//unzip
				exec('unzip /tmp/'+id+'/'+id+'.zip /preview.png -d /tmp/'+id+'/', function(){
					fs.readFile('/tmp/'+id+'/preview.png', function (err, data) {
					  if (err) throw err;
  				      var req4 = s3client.put(id+'.png', {
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
	  	    });	
		});
  	    
		
		//client.set(id, body);
	    var req3 = s3client.put(id+'.zip', {
			'Content-Length': body.length,
			 'Content-Type': 'application/octet-stream',
		      'x-amz-acl': 'private'
		  });
		  req3.on('response', function(res){
		    if (200 == res.statusCode) {
		      console.log('saved to %s', req3.url);
		    }
		  });
		  req3.end(new Buffer(body, 'binary'));
	    res.send(JSON.stringify({"id":id}));
	  })
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
	  var body = [];
	  var header = '';
	  var content_type = req.headers['content-type'];
	  var boundary = (content_type.split('; ').length<2)?"":content_type.split('; ')[1].split('=')[1];
	  var content_length = parseInt(req.headers['content-length']);
	  var headerFlag = true;
	  var filename = 'dummy.bin';
	  var filenameRegexp = /filename="(.*)"/m;
	  console.log('content-type: ' + content_type);
	  console.log('boundary: ' + boundary);
	  console.log('content-length: ' + content_length);

	  req.on('data', function(raw) {
	    console.log('received data length: ' + raw.length);
	    var i = 0;
	    while (i < raw.length)
	      if (headerFlag) {
	        var chars = raw.slice(i, i+4).toString();
	        if (chars === '\r\n\r\n') {
	          headerFlag = false;
	          header = raw.slice(0, i+4).toString();
	          console.log('header length: ' + header.length);
	          console.log('header: ');
	          console.log(header);
	          i = i + 4;
	          // get the filename
	          var result = filenameRegexp.exec(header);
	          if (result[1]) {
	            filename = result[1];
	          }
	          console.log('filename: ' + filename);
	          console.log('header done');
	        }
	        else {
	          i += 1;
	        }
	      }
	      else { 
	        // parsing body including footer
	        body += raw.toString('binary', i, raw.length);
	        i = raw.length;
	        console.log('actual file size: ' + body.length);
	      }
	  });

	  req.on('end', function() {
	    // removing footer '\r\n'--boundary--\r\n' = (boundary.length + 8)
	    body = body.slice(0, body.length - (boundary.length + 8))
	    console.log('final file size: ' + body.length);
		var id = node_uuid.v4();
		//client.set(id, body);
	    fs.writeFile('/tmp/' + id +".png", body, 'binary', function(){
		    res.send(JSON.stringify({"id":id}));
	    });
	    console.log('done');
	  })
	});  

	// app.get('/r', function(req, res){
	// 	res.header("Content-Type", "text/html");
	//   res.send('<form method="post" action="/r" enctype="multipart/form-data">'
	//            + '<p>Image: <input type="file" name="test" /></p>'
	//            + '<p><input type="submit" value="Upload" /></p>'
	//            + '</orm>');
	// });

	app.get('/r/:id', function(req, res){
	//	client.get(req.params.id, function(err, reply){
			// res.header("Content-Type", "image/png");
			// 	res.send(
			// 		new Buffer(
			// 			reply.toString(), "binary")
			// 			);		
	//	});
	
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
	
		app.get('/f/(*)', function(req,res){
			console.log('Getting file '+req.params[0]);
			fs.readFile('../static/'+req.params[0], "binary", function(err, file) {
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
//});

