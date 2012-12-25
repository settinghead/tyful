$ ->
	$("#textize").click ->
		$("#textize-dialog").dialog
			modal: true,
			width: "auto"
			height: "auto"
			buttons:
				"Apply": ->
					$("#sketch").tsketch().directionContext.globalCompositeOperation = 'destination-in'
					$("#sketch").tsketch().directionContext.drawImage $("#textizer")[0], 0, 0
					$( this ).dialog "close"
				Cancel: ->
					$( this ).dialog "close"
               
	$("#apply_filter_threshold_value").change ->
		threshold = $(this).val()
		textizer = $("#textizer")[0]
		context = textizer.getContext('2d')
		pixels = window.photoCanvas.getContext('2d').getImageData 0,0,textizer.width,textizer.height
		d = pixels.data
		i = 0

		while i < d.length
			if (d[i] + d[i + 1] + d[i + 2]) > threshold
				v = 255
			else
				v = 0
			d[i] = v
			d[i + 1] = v
			d[i + 2] = v
			d[i + 3] = 255 - v
			i += 4
		context.putImageData pixels, 0, 0