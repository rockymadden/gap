class Api
  constructor: (commands, gaq, state) ->
    if not Func.existy(commands) or typeof commands isnt 'object' then Dom.error('Expected commands to be an object.')
    if not Func.existy(gaq) or typeof gaq isnt 'object' then Dom.error('Expected gaq to be an object.')
    if not Func.existy(state) or typeof state isnt 'object' then Dom.error('Expected state to be an object.')

    @_gaq = gaq
    @state = state
    @trackers = {}

    @subscribe('mousedown', new MousedownTracker(@, {}))
    @subscribe('scroll', new ScrollTracker(@, {}))
    @subscribe('time', new TimeTracker(@, {}))
    if Func.lengthy(commands) then @push(commands)

  isCommand: (command) -> Func.lengthy(command) and {}.toString.call(command) is '[object Array]'

  publish: (command) ->
    if not @isCommand(command) then Dom.error('Expected valid command.')

    t.listen(command) for k, t of @trackers

  push: (command) ->
    if not @isCommand(command) then Dom.error('Expected valid command.')

    if @isCommand(command[0]) then @push(i) for i in command
    else
      @publish(command)

      if command[0].indexOf('_gap') isnt 0
        @_gaq.push(command)
        if Func.truthy(@state.debugging) then Dom.debug(['[', command.toString(), ']'].join(' '))

  subscribe: (key, tracker) ->
    if not Func.existy(key) or typeof key isnt 'string' then Dom.error('Expected key to be a string.')
    if not Func.existy(tracker) or typeof tracker isnt 'object' then Dom.error('Expected tracker to be an object.')

    @trackers[key] = tracker
