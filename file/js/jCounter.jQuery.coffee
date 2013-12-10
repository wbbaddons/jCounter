###
# jCounter - a simple character counter
#
# @author	Maximilian Mader
# @copyright	2011 - 2013 Maximilian Mader
# @license	BSD 3-Clause License <http://opensource.org/licenses/BSD-3-Clause>
# @package	be.bastelstu.max.wcf.jCounter
###
(($) ->
	jCounterID = 0
	
	###
	# Throttle function <http://remysharp.com/2010/07/21/throttling-function-calls/>
	###
	throttle = (fn, threshold, scope) ->
		threshold || (threshold = 250)
		last = 0;
		deferTimer = null;
		
		return =>
			context = scope or @
			now = +new Date
			args = arguments
			
			if last and now < last + threshold
				clearTimeout deferTimer
				deferTimer = setTimeout ->
					last = now
					fn.apply context, args
				, threshold
			else
				last = now
				fn.apply context, args
	
	$.fn.jCounter = (container, options) ->
		# properly handle multiple elements passed
		if @length > 1
			return @each (k, v) ->
				$(v).jCounter container, options
		
		# check for supported elements
		unless @is 'textarea, input:not([type=radio], [type=checkbox], [type=hidden], [type=color], [type=number], [type=range], [type=datetime], [type=date], [type=datetime-local], [type=month], [type=time], [type=week])'
			console.log '[jCounter] Unsupported element ' + if @.prop('tagName') is 'INPUT' then """INPUT type='#{@.attr('type')}'""" else """type #{@.prop('tagName')}"""
			return @
		
		# break if element already has got an inline jCounter assigned
		return @ if @parent().hasClass 'jCounterContainer'
		
		options = $.extend
			max: 0
			countUp: false
		, options
		
		options.colors = ['blue', 'orange', 'red'] if not options.colors? or options.colors.length < 1
		options.max = @attr('maxlength') ? options.max
		options.countUp = true if options.max is 0
		
		jCounter = (
			if container?
				if typeof container is 'object'
					container
				else
					$ container
			else
				# create inline jCounter
				id = @attr('id') ? @attr('id', "jCounterID#{jCounterID++}").attr('id')
				
				@addClass('jCounterInput').wrap("""<div class="jCounterContainer"></div>""").parent().append """<label for="#{id}" class="jCounter badge #{options.colors[0]}">#{if options.countUp then 0 else options.max}</label>"""
				
				$(@).parent().children(".jCounter").css
					borderTopRightRadius: @.css 'border-top-right-radius'
					borderBottomRightRadius: @.css 'border-bottom-right-radius'
					borderBottomLeftRadius: @.css 'border-bottom-left-radius'
					borderTopLeftRadius: 	@.css 'border-top-left-radius'
		)
		
		firstStep = options.max * (1 / options.colors.length) * 1.5
		step = (options.max - firstStep) / (options.colors.length - 1)
		
		# handle events
		@on 'input change', throttle =>
			length = @val().length
			
			color = (
				if options.max > 0 and options.colors.length > 0
					if length < firstStep
						options.colors[0]
					else
						index = Math.floor((length - firstStep) / step) + 1
						if index < options.colors.length
							options.colors[index]
						else
							options.colors[options.colors.length - 1]
				else
					options.colors[0]
			)
			
			jCounter.text(if options.countUp then length else options.max - length).removeClass(options.colors.join ' ').addClass color
			
			# update position of inline jCounter in case the element changed size
			unless container?
				jCounter.css 'margin-left', -(jCounter.outerWidth() + parseFloat(@css('border-right-width')) +  parseFloat(@css('margin-right')) + 1)
				@css 'padding-right', 3 + jCounter.outerWidth()
		, 16
		
		@trigger 'change'
)(jQuery)
