{CompositeDisposable} = require 'atom'

module.exports =
  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-workspace',
      'path-copy:fullpath': => @copyFullPath()

  deactivate: ->
    @subscriptions.dispose()

  writeToClipboard: (path) ->
    atom.clipboard.write(path)

  getTabContextClicked: ->
    return document.querySelector('.right-clicked')

  copyFullPath: ->
    tab = @getTabContextClicked()

    if tab.path?
      @writeToClipboard(tab.path)
