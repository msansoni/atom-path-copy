{CompositeDisposable} = require 'atom'

module.exports =
  config:
    copyFullPath:
      type: 'boolean'
      default: false
      desciption: 'Copy Full Path'

  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-workspace',
      'path-copy:fullpath': => @copyFullPath()

    @setContextMenu()

    @subscriptions.add atom.config.onDidChange 'path-copy',
      => @setContextMenu()

  deactivate: ->
    @subscriptions.dispose()

  setContextMenu: ->
    # Add menuitems, depending on configuration choices
    isCopyFullPath = atom.config.get('path-copy.copyFullPath')

    atom.contextMenu.add
      '.tab': [{
        label: 'Path Copy'
        submenu: [
          {label: 'Copy Full Path', command: 'path-copy:fullpath', visible: isCopyFullPath}
          {label: 'Add Options in Settings', command: '', visible: false, enabled: false}
        ]
      }]

  writeToClipboard: (path) ->
    atom.clipboard.write(path)

  getTabContextClicked: ->
    return document.querySelector('.right-clicked')

  copyFullPath: ->
    tab = @getTabContextClicked()

    if tab.path?
      @writeToClipboard(tab.path)
