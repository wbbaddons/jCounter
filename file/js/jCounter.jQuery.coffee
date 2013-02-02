###
# jCounter - a simple character counter
#
# @author	Maximilian Mader
# @copyright	2011 - 2013 Maximilian Mader
# @license	Creative Commons Attribution-NonCommercial-ShareAlike <http://creativecommons.org/licenses/by-nc-sa/3.0/legalcode>
# @package	be.bastelstu.max.wcf.jCounter
###
(($) ->
	$.fn.jCounter = (container, options) ->
		options = $.extend
			max: 0
			counterClass: 'jCounter'
			countUp: false
			width: '100%'
		, options
		
		max = if @.attr('maxlength')? then @.attr 'maxlength' else options.max

		if not container?
			@.addClass 'jCounterInput'
			
			@.wrap("""<div class="jCounterContainer" style="width: #{options.width}"><div></div></div>""").parent().append """<div class="#{options.counterClass} color-1">#{max}</div>"""
			jCounterContainer = $(@).parent().children ".#{options.counterClass}"
		else
			jCounterContainer = if typeof container is 'object' then container else $ container

		@.on 'keypress keyup', $.proxy () ->
			length = if options.countUp then @.val().length else max - @.val().length
			
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
			
			jCounterContainer.text(length).removeClass().addClass "#{options.counterClass} color-#{color}"
		, @
)(jQuery)