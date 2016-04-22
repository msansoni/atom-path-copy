{CompositeDisposable} = require 'atom'
path = require 'path'

module.exports =
  config:
    copyFullPath:
      type: 'boolean'
      default: true
      description: 'Copies the full file path to the clipboard'
    copyShortName:
      type: 'boolean'
      default: true
      description: 'Copies the short file name to the clipboard (without the extension)'
    copyFullName:
      type: 'boolean'
      default: true
      description: 'Copies the full file name to the clipboard (with the extension)'

  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-workspace',
      'path-copy:fullpath': => @copyFullPath()
      'path-copy:shortname': => @copyShortName()
      'path-copy:fullname': => @copyFullName()

    @setContextMenu()

    @subscriptions.add atom.config.onDidChange 'path-copy',
      => @setContextMenu()

  deactivate: ->
    @subscriptions.dispose()

  setContextMenu: ->
    # Add menuitems, depending on configuration choices
    isCopyFullPath = atom.config.get('path-copy.copyFullPath')
    isCopyShortName = atom.config.get('path-copy.copyShortName')
    isCopyFullName = atom.config.get('path-copy.copyFullName')

    atom.contextMenu.add
      '.tab': [{
        label: 'Path Copy'
        submenu: [
          {label: 'Copy Full Path', command: 'path-copy:fullpath', visible: isCopyFullPath}
          {label: 'Copy Short Name', command: 'path-copy:shortname', visible: isCopyShortName}
          {label: 'Copy Full Name', command: 'path-copy:fullname', visible: isCopyFullName}
          {label: 'Add Options in Settings', command: '', visible: false, enabled: false}
        ]
      }]

  writeToClipboard: (textpath) ->
    atom.clipboard.write(textpath)

  getTabContextClicked: ->
    return document.querySelector('.right-clicked')

  getTabPath: ->
    tab = @getTabContextClicked()
    return tab.path

  # Methods to write to clipboard the specific options
  copyShortName: ->
    tabPath = @getTabPath()

    if tabPath?
      @writeToClipboard(path.parse(tabPath).name)

  copyFullName: ->
    tabPath = @getTabPath()

    if tabPath?
      @writeToClipboard(path.parse(tabPath).base)

  copyFullPath: ->
    tabPath = @getTabPath()

    if tabPath?
      @writeToClipboard(tabPath)
