{CompositeDisposable} = require 'atom'
path = require 'path'

module.exports =
  config:
    quotationCharacter:
      type: 'string'
      default: ''
      title: 'Quotation Character'
      description: 'Define a character to surround the copied path. Default is none.'
      order: 1
    displayNotifications:
      type: 'boolean'
      default: true
      title: 'Display notifications'
      description: 'Show notifications when path-copy has been called on whether the command was successful or not. On successful commands the notifications also displays the path text that has been copied to the clipboard.'
      order: 2
    copyFullPath:
      type: 'boolean'
      default: true
      title: 'Copy Full Path'
      description: 'Copies the full file path to the clipboard.'
      order: 3
    copyFullName:
      type: 'boolean'
      default: true
      title: 'Copy Full Name'
      description: 'Copies the full file name to the clipboard (with the extension).'
      order: 4
    copyShortName:
      type: 'boolean'
      default: true
      title: 'Copy Short Name'
      description: 'Copies the short file name to the clipboard (without the extension).'
      order: 5
    copyExtension:
      type: 'boolean'
      default: true
      title: 'Copy Extension'
      description: 'Copies the extension of the file to the clipboard.'
      order: 6
    copyFolderPath:
      type: 'boolean'
      default: true
      title: 'Copy Folder Path'
      description: 'Copies the folder path to the clipboard.'
      order: 7
    copyProjectPath:
      type: 'boolean'
      default: true
      title: 'Copy Project Path'
      description: 'Copies the project path to the clipboard.'
      order: 8
    copyRelativePath:
      type: 'boolean'
      default: true
      title: 'Copy Relative Path'
      description: 'Copies the relative path of the file in the project to the clipboard.'
      order: 9

  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-workspace',
      'path-copy:fullpath': => @copyFullPath()
      'path-copy:shortname': => @copyShortName()
      'path-copy:fullname': => @copyFullName()
      'path-copy:folderpath': => @copyFolderPath()
      'path-copy:projectpath': => @copyProjectPath()
      'path-copy:relativepath': => @copyRelativePath()
      'path-copy:extension': => @copyExtension()
      'path-copy:copy-current-editor-path': => @copyCurrentEditorPath()

    @subscriptions.add atom.config.onDidChange 'path-copy',
      => @updateSettings()

    @updateSettings()

  deactivate: ->
    @subscriptions.dispose()

  updateSettings: ->
    # Add menuitems, depending on configuration choices
    contextMenuOptions = {
      isCopyFullPath : atom.config.get('path-copy.copyFullPath'),
      isCopyShortName : atom.config.get('path-copy.copyShortName'),
      isCopyFullName : atom.config.get('path-copy.copyFullName'),
      isCopyFolderPath : atom.config.get('path-copy.copyFolderPath'),
      isCopyProjectPath : atom.config.get('path-copy.copyProjectPath'),
      isCopyRelativePath : atom.config.get('path-copy.copyRelativePath'),
      isCopyExtension : atom.config.get('path-copy.copyExtension')
    }

    # Check if any of the config options are visible
    # Will accept any PR to clean this up into one line :)
    anyVisible = false
    for k, v of contextMenuOptions
      if v is true
        anyVisible = true

    atom.contextMenu.add
      '.tab': [{
        label: 'Path Copy'
        submenu: [
          {label: 'Copy Full Path', command: 'path-copy:fullpath', visible: contextMenuOptions.isCopyFullPath}
          {label: 'Copy Full Name', command: 'path-copy:fullname', visible: contextMenuOptions.isCopyFullName}
          {label: 'Copy Short Name', command: 'path-copy:shortname', visible: contextMenuOptions.isCopyShortName}
          {label: 'Copy Extension', command: 'path-copy:extension', visible: contextMenuOptions.isCopyExtension}
          {type: 'separator'}
          {label: 'Copy Folder Path', command: 'path-copy:folderpath', visible: contextMenuOptions.isCopyFolderPath}
          {label: 'Copy Project Path', command: 'path-copy:projectpath', visible: contextMenuOptions.isCopyProjectPath}
          {label: 'Copy Relative Path', command: 'path-copy:relativepath', visible: contextMenuOptions.isCopyRelativePath}
          {type: 'separator'}
          {label: 'Add Options in Settings', command: '', visible: !anyVisible, enabled: false}
        ]
      }]

  raiseNotificationSuccess: (textpath) ->
    atom.notifications.addSuccess("path-copy: #{textpath} added to clipboard.", {dismissable: true})

  raiseNotificationError: ->
    atom.notifications.addError("path-copy: Editor file does not exist on the system directory as a valid path.", {dismissable: true})

  writeToClipboard: (textpath) ->
    character = atom.config.get('path-copy.quotationCharacter')

    if character?.length
      textpath = character + textpath + character

    atom.clipboard.write(textpath)

    if atom.config.get('path-copy.displayNotifications')
      if textpath != ''
        @raiseNotificationSuccess(textpath)
      else
        @raiseNotificationError()

  getCurrentTabPath: ->
    path = atom.workspace.getActivePaneItem().getURI()
    return path

  getTabContextClicked: ->
    return document.querySelector('.right-clicked')

  getTabPath: ->
    tab = @getTabContextClicked()
    return tab.pane.getActiveItem().getURI()

  getRelativePath: ->
    [projectPath, relativePath] = atom.project.relativizePath(@getTabPath())
    return {
      projectPath : projectPath
      relativePath: relativePath
    }

  parseTabPath: ->
    tabPath = @getTabPath()
    return path.parse(tabPath)

  # Methods to write to clipboard the specific options
  copyCurrentEditorPath: ->
    @writeToClipboard(@getCurrentTabPath())

  copyShortName: ->
    @writeToClipboard(@parseTabPath().name)

  copyFullName: ->
    @writeToClipboard(@parseTabPath().base)

  copyFolderPath: ->
    @writeToClipboard(@parseTabPath().dir)

  copyExtension: ->
    @writeToClipboard(@parseTabPath().ext)

  copyProjectPath: ->
    @writeToClipboard(@getRelativePath().projectPath)

  copyRelativePath: ->
    @writeToClipboard(@getRelativePath().relativePath)

  copyFullPath: ->
    @writeToClipboard(@getTabPath())
