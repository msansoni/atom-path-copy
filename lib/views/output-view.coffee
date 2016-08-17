{$, ScrollView} = require 'atom-space-pen-views'

defaultMessage = 'Path-Copy'
module.exports =
  class OutputView extends ScrollView
    message: ''

    @content: ->
      @div class: 'path-copy info-view', =>
        @pre class: 'output', defaultMessage

    initialize: ->
      super

    addLine: (line) ->
      @message = '' if @message is defaultMessage
      @message += line
      this

    reset: -> @message = defaultMessage

    finish: ->
      @find(".output").text(@message)
      @show()
      @timeout = setTimeout =>
        @hide()
      , atom.config.get('path-copy.messageTimeout') * 1000

    toggle: ->
      clearTimeout @timeout if @timeout
      $.fn.toggle.call(this)
