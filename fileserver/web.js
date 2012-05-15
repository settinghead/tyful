var express = require('express'),
    fs = require('fs'), node_uuid = require('node-uuid'), 
	URL = require('url'), redis = require("redis"),
	knox = require('knox');
	
	var s3client = knox.createClient({
	    key: 'AKIAICJYKXXF7EZ5A5IQ'
	  , secret: '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'
	  , bucket: 'wwt_templates'
	});
	
    app = express.createServer();

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
		//client.set(id, body);
	    var req = s3client.put(id+'.zip', {
			'Content-Length': body.length,
			 'Content-Type': 'application/octet-stream',
		      'x-amz-acl': 'private'
		  });
		  req.on('response', function(res){
		    if (200 == res.statusCode) {
		      console.log('saved to %s', req.url);
		    }
		  });
		  req.end(new Buffer(body, 'binary'));
	    res.send(JSON.stringify({"id":id}));
	  })
	});
	
	app.get('/t/:id', function(req, res){
		var count = 0;
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
	    fs.writeFileSync('/tmp/' + id +".png", body, 'binary');
	    console.log('done');
	    res.send(JSON.stringify({"id":id}));
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
			fs.readFile('f/'+req.params[0], "binary", function(err, file) {
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

