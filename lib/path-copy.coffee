{CompositeDisposable} = require 'atom'
path = require 'path'
OutputViewManager = require './output-view-manager'

module.exports =
  config:
    quotationCharacter:
      type: 'string'
      default: ''
      title: 'Quotation Character'
      description: 'Define a character to surround the copied path. Default is none.'
      order: 1
    statusNotifications:
      type: 'boolean'
      default: true
      title: 'Status-bar stlye notifications'
      description: 'Show status-bar style notifications when path-copy has been called on whether the command was successful or not. On successful commands the notifications also displays the path text that has been copied to the clipboard.'
      order: 2
    popupNotifications:
      type: 'boolean'
      default: false
      title: 'Pop-up stlye notifications'
      description: 'Show pop-up style notifications when path-copy has been called on whether the command was successful or not. On successful commands the notifications also displays the path text that has been copied to the clipboard.'
      order: 3
    messageTimeout:
      type: 'integer'
      default: 5
      minimum: 1
      title: 'Notification timeout (s)'
      description: 'Length of time to display status-bar style notifications before removing'
      order: 4

  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable()

    @subscriptions.add atom.commands.add 'atom-workspace, .tree-view .selected, .tab.texteditor',
      'path-copy:fullpath': (e) =>
        @copyFullPath(e)
        e.stopPropagation()
      'path-copy:current-fullpath': (e) =>
        @copyFullPath(e, current=true)
        e.stopPropagation()
      'path-copy:shortname': (e) =>
        @copyShortName(e)
        e.stopPropagation()
      'path-copy:current-shortname': (e) =>
        @copyShortName(e, current=true)
        e.stopPropagation()
      'path-copy:fullname': (e) =>
        @copyFullName(e)
        e.stopPropagation()
      'path-copy:current-fullname': (e) =>
        @copyFullName(e, current=true)
        e.stopPropagation()
      'path-copy:folderpath': (e) =>
        @copyFolderPath(e)
        e.stopPropagation()
      'path-copy:current-folderpath': (e) =>
        @copyFolderPath(e, current=true)
        e.stopPropagation()
      'path-copy:projectpath': (e) =>
        @copyProjectPath(e)
        e.stopPropagation()
      'path-copy:current-projectpath': (e) =>
        @copyProjectPath(e, current=true)
        e.stopPropagation()
      'path-copy:relativepath': (e) =>
        @copyRelativePath(e)
        e.stopPropagation()
      'path-copy:current-relativepath': (e) =>
        @copyRelativePath(e, current=true)
        e.stopPropagation()
      'path-copy:extension': (e) =>
        @copyExtension(e)
        e.stopPropagation()
      'path-copy:current-extension': (e) =>
        @copyExtension(e, current=true)
        e.stopPropagation()

  deactivate: ->
    @subscriptions.dispose()

  raiseNotificationSuccess: (textpath) ->
    msg = 'path-copy: ' + textpath + ' added to clipboard.'

    if atom.config.get('path-copy.popupNotifications')
      atom.notifications.addSuccess(msg, {dismissable: true})
    if atom.config.get('path-copy.statusNotifications')
      OutputViewManager.create().addLine(msg).finish()

  raiseNotificationError: ->
    msg = 'path-copy: Editor file does not exist on the system directory as a valid path.'

    if atom.config.get('path-copy.popupNotifications')
      atom.notifications.addError(msg, {dismissable: true})
    if atom.config.get('path-copy.statusNotifications')
      OutputViewManager.create().addLine(msg).finish()

  writeToClipboard: (textpath) ->
    character = atom.config.get('path-copy.quotationCharacter')

    if character?.length
      textpath = character + textpath + character

    atom.clipboard.write(textpath)

    if textpath != ''
      @raiseNotificationSuccess(textpath)
    else
      @raiseNotificationError()

  getEventPath: (event) ->
    if event?.currentTarget.classList.contains('tab') || event?.currentTarget.classList.contains('file')
      elem = event.currentTarget.querySelector('[data-path]');
      panePath = elem.dataset.path;
    else
      panePath = @getCurrentPath()

    return panePath

  getCurrentPath: ->
    panePath = atom.workspace.getActivePaneItem().getURI();

    return panePath

  getRelativePath: (panePath) ->
    [projectPath, relativePath] = atom.project.relativizePath(panePath)
    return {
      projectPath : projectPath
      relativePath: relativePath
    }

  parsePanePath: (panePath) ->
    return path.parse(panePath)

  # Methods to write to clipboard the specific options
  copyShortName: (e, current=false) ->
    if current
      panePath = @getCurrentPath()
    else
      panePath = @getEventPath(e)

    @writeToClipboard(@parsePanePath(panePath).name)

  copyFullName: (e, current=false) ->
    if current
      panePath = @getCurrentPath()
    else
      panePath = @getEventPath(e)

    @writeToClipboard(@parsePanePath(panePath).base)

  copyFolderPath: (e, current=false) ->
    if current
      panePath = @getCurrentPath()
    else
      panePath = @getEventPath(e)

    @writeToClipboard(@parsePanePath(panePath).dir)

  copyExtension: (e, current=false) ->
    if current
      panePath = @getCurrentPath()
    else
      panePath = @getEventPath(e)

    @writeToClipboard(@parsePanePath(panePath).ext)

  copyProjectPath: (e, current=false) ->
    if current
      panePath = @getCurrentPath()
    else
      panePath = @getEventPath(e)

    @writeToClipboard(@getRelativePath(panePath).projectPath)

  copyRelativePath: (e, current=false) ->
    if current
      panePath = @getCurrentPath()
    else
      panePath = @getEventPath(e)

    @writeToClipboard(@getRelativePath(panePath).relativePath)

  copyFullPath: (e, current=false) ->
    if current
      panePath = @getCurrentPath()
    else
      panePath = @getEventPath(e)

    @writeToClipboard(panePath);
