//=require jquery.hoverIntent.js
//=require jquery.purr.js

window.notify = function (msg, title){
	var notice = '<div class="notice">'
		  + '<div class="notice-body">' 
			  + '<img src="/assets/purr/info.png" alt="" />'
			  + '<h3>'+ title +'</h3>'
			  + '<p>' + msg + '</p>'
		  + '</div>'
		  + '<div class="notice-bottom">'
		  + '</div>'
	  + '</div>';
	  $(document).append(notice);
	$( notice ).purr(
		{
			usingTransparentPNG: true,
		    removeTimer: 5000
		}
	);	
	return false;
}

