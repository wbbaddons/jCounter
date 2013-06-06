###
# jCounter - a simple character counter
#
# @author	Maximilian Mader
# @copyright	2011 - 2013 Maximilian Mader
# @license	Creative Commons Attribution-NonCommercial-ShareAlike <http://creativecommons.org/licenses/by-nc-sa/3.0/legalcode>
# @package	be.bastelstu.max.wcf.jCounter
###
(($) ->
	jCounterID = 0
	
	$.fn.jCounter = (container, options) ->
		# properly handle multiple elements passed
		if @length > 1
			return @.each (k, v) ->
				$(v).jCounter container, options
		
		# break if element already has got an inline jCounter assigned
		return @ if @parent().hasClass 'jCounterContainer'
		
		options = $.extend
			max: 0
			countUp: false
		, options
		
		max = @attr('maxlength') ? options.max
		
		jCounter = 	(if not container?
					# create inline jCounter
					id = @attr('id') ? @attr('id', "jCounterID#{jCounterID++}").attr('id')
					
					@addClass('jCounterInput').wrap("""<div class="jCounterContainer"></div>""").parent().append """<label for="#{id}" class="jCounter color-1">#{max}</label>"""
					
					$(@).parent().children(".jCounter").css
						borderTopRightRadius: @css 'border-top-right-radius'
						borderBottomRightRadius: @css 'border-bottom-right-radius'
				else
					if typeof container is 'object'
						container
					else
						$ container)
		
		# handle keyX events
		@on 'keypress keyup keydown change', =>
			length = if options.countUp then @.val().length else max - @.val().length
			
			# determine new color
			color = (if options.countUp
					if max > 0
						if length < max / 2
							1
						else if max / 2 < length <= max / 1.2
							2
						else
							3
					else
						1
				else
					if max / 2 < length
						1
					else if max / 6 <= length <= max / 2
						2
					else
						3)
			jCounter.text(length).removeClass('color-1 color-2 color-3').addClass "color-#{color}"
			
			# update position of inline jCounter in case the element changed size
			if not container?
				jCounter.css 'margin-left', -(jCounter.outerWidth() + parseFloat(@css('border-right-width')))
				@css 'padding-right', 5 + jCounter.outerWidth()
		@trigger 'keypress'
)(jQuery)
