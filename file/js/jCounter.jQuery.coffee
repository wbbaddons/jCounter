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
			return @each (k, v) ->
				$(v).jCounter container, options
		
		# break if element already has got an inline jCounter assigned
		return @ if @parent().hasClass 'jCounterContainer'
		
		options = $.extend
			max: 0
			countUp: false
		, options
		
		options.colors = ['blue', 'orange', 'red'] if not options.colors? or options.colors.length < 3
		max = @attr('maxlength') ? options.max
		
		jCounter = (
			if container?
				if typeof container is 'object'
					container
				else
					$ container
			else
				# create inline jCounter
				id = @attr('id') ? @attr('id', "jCounterID#{jCounterID++}").attr('id')
				
				@addClass('jCounterInput').wrap("""<div class="jCounterContainer"></div>""").parent().append """<label for="#{id}" class="jCounter badge #{options.colors[0]}">#{max}</label>"""
				
				$(@).parent().children(".jCounter").css
					borderTopRightRadius: @.css 'border-top-right-radius'
					borderBottomRightRadius: @.css 'border-bottom-right-radius'
					borderBottomLeftRadius: @.css 'border-bottom-left-radius'
					borderTopLeftRadius: 	@.css 'border-top-left-radius'
		)
		
		# handle keyX events
		@on 'keypress keyup keydown change', =>
			length = if options.countUp then @val().length else max - @val().length
			
			# determine new color
			color = (if options.countUp
					if max > 0
						if length < max / 2
							options.colors[0]
						else if max / 2 < length <= max / 1.2
							options.colors[1]
						else
							options.colors[2]
					else
						options.colors[0]
				else
					if max / 2 < length
						options.colors[0]
					else if max / 6 <= length <= max / 2
						options.colors[1]
					else
						options.colors[2])
			jCounter.text(length).removeClass(options.colors.join ' ').addClass color
			
			# update position of inline jCounter in case the element changed size
			unless container?
				@css 'padding-right', 4 + jCounter.outerWidth()
		@trigger 'keypress'
)(jQuery)
