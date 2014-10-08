class TimeTracker
  constructor: (api, state) ->
    if not Func.existy(api) or typeof api isnt 'object' then Dom.error('Expected api to be an object.')
    if not Func.existy(state) or typeof state isnt 'object' then Dom.error('Expected state to be an object.')

    @_api = api
    @state = state

  listen: (commandArray) -> switch commandArray[0]
    when '_gapTrackBounceViaTime'
      if commandArray.length is 2 and typeof commandArray[1] is 'number' and
      not Func.truthy(@_api.state.cookied) and not Func.truthy(@_api.state.bounced)

        @state.bounceViaTimeTimeout = root.setTimeout(
          (->
            gap = root._gap
            gapState = root._gap.state

            if not Func.truthy(gapState.bounced)
              gapState.bounced = true
              gap.push([
                '_trackEvent'
                'gapBounceViaTime'
                commandArray[1].toString()
              ])
          ),
          commandArray[1] * 1000
        )
    when '_gapTrackReads'
      if commandArray.length is 3 and typeof commandArray[1] is 'number' and typeof commandArray[2] is 'number'
        @state.readsSeconds = 0
        @state.readsSecondsMax = commandArray[1] * commandArray[2]
        @state.readsInterval = root.setInterval(
          fn = (->
            gap = root._gap
            trackerState = root._gap.trackers.time.state

            if trackerState.readsSeconds < trackerState.readsSecondsMax
              gap.push([
                '_trackEvent'
                'gapRead'
                (trackerState.readsSeconds += commandArray[1]).toString()
              ])
              fn
            else clearInterval(trackerState.readsInterval)
          ),
          commandArray[1] * 1000
        )
