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
		if @length > 1
			@.each (k, v) ->
				$(v).jCounter container, options
			return
			
		return @ if @parent().hasClass 'jCounterContainer'
		
		options = $.extend
			max: 0
			counterClass: ''
			countUp: false
		, options
		
		max = if @.attr('maxlength')? then @.attr 'maxlength' else options.max

		if not container?
			@addClass 'jCounterInput'
			
			id = @attr('id') ? @attr('id', "jCounterID#{jCounterID++}").attr('id')
			
			@wrap("""<div class="jCounterContainer"></div>""").parent().append """<label for="#{id}" class="jCounter #{options.counterClass} color-1">#{max}</label>"""
			jCounter = $(@).parent().children ".jCounter" + (if options.counterClass != "" then " ." + options.counterClass else "")
		else
			jCounter = if typeof container is 'object' then container else $ container
		@css 'padding-right', 5 + jCounter.outerWidth()
		jCounter.css 'border-top-right-radius', @css 'border-top-right-radius'
		jCounter.css 'border-bottom-right-radius', @css 'border-bottom-right-radius'
		
		@on 'keypress keyup', =>
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
			jCounter.text(length).removeClass().addClass "jCounter #{options.counterClass} color-#{color}"
			jCounter.css 'margin-left', -(jCounter.outerWidth() + parseFloat(@css('border-right-width')))
			@css 'padding-right', 5 + jCounter.outerWidth()
)(jQuery)