class ScrollTracker
  constructor: (api, state) ->
    if not Func.existy(api) or typeof api isnt 'object' then Dom.error('Expected api to be an object.')
    if not Func.existy(state) or typeof state isnt 'object' then Dom.error('Expected state to be an object.')

    @_api = api
    @state = state

  listen: (commandArray) -> switch commandArray[0]
    when '_gapTrackBounceViaScroll'
      if commandArray.length is 2 and typeof commandArray[1] is 'number' and
      not Func.truthy(@_api.state.cookied) and not Func.truthy(@_api.state.bounced)

        @state.bounceViaScrollPercent = commandArray[1]
        @state.bounceViaScrollFunction = ->
          gap = root._gap
          gapState = root._gap.state
          percent = Dom.scrolledPercent()
          trackerState = root._gap.trackers.scroll.state

          if not Func.truthy(gapState.bounced) and percent >= trackerState.bounceViaScrollPercent
            gapState.bounced = true
            gap.push([
              '_trackEvent'
              'gapBounceViaScroll'
              trackerState.bounceViaScrollPercent.toString()
            ])

        Dom.append(root, 'onscroll', (event) ->
          trackerState = root._gap.trackers.scroll.state

          if Func.existy(trackerState.bounceViaScrollTimeout) then clearTimeout(trackerState.bounceViaScrollTimeout)
          trackerState.bounceViaScrollTimeout = setTimeout(trackerState.bounceViaScrollFunction, 100)
        )
    when '_gapTrackMaxScroll'
      if commandArray.length is 2 and typeof commandArray[1] is 'number'
        @state.maxScrollPercent = commandArray[1]
        @state.maxScrollFunction = ->
          percent = Dom.scrolledPercent()
          trackerState = root._gap.trackers.scroll.state

          if percent >= trackerState.maxScrollPercent and
          (not Func.existy(trackerState.maxScrolledPercent) or percent > trackerState.maxScrolledPercent)

            trackerState.maxScrolledPercent = percent

        Dom.append(root, 'onscroll', (event) ->
          trackerState = root._gap.trackers.scroll.state

          if Func.existy(trackerState.maxScrollTimeout) then clearTimeout(trackerState.maxScrollTimeout)
          trackerState.maxScrollTimeout = setTimeout(trackerState.maxScrollFunction, 100)
        )
        Dom.append(root, 'onunload', (event) ->
          gap = root._gap
          trackerState = root._gap.trackers.scroll.state

          if Func.existy(trackerState.maxScrolledPercent)
            gap.push([
              '_trackEvent'
              'gapMaxScroll'
              trackerState.maxScrolledPercent.toString()
            ])
        )
