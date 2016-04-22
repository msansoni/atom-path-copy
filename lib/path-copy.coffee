{CompositeDisposable} = require 'atom'
path = require 'path'

module.exports =
  config:
    quotationCharacter:
      type: 'string'
      default: ''
      title: 'Quotation Character'
      description: 'Define a character to surround the copied path'
      order: 1
    copyFullPath:
      type: 'boolean'
      default: true
      title: 'Copy Full Path'
      description: 'Copies the full file path to the clipboard'
      order: 2
    copyFullName:
      type: 'boolean'
      default: true
      title: 'Copy Full Name'
      description: 'Copies the full file name to the clipboard (with the extension)'
      order: 3
    copyShortName:
      type: 'boolean'
      default: true
      title: 'Copy Short Name'
      description: 'Copies the short file name to the clipboard (without the extension)'
      order: 4
    copyExtension:
      type: 'boolean'
      default: true
      title: 'Copy Extension'
      description: 'Copies the extension of the file to the clipboard'
      order: 5
    copyFolderPath:
      type: 'boolean'
      default: true
      title: 'Copy Folder Path'
      description: 'Copies the folder path to the clipboard'
      order: 6
    copyProjectPath:
      type: 'boolean'
      default: true
      title: 'Copy Project Path'
      description: 'Copies the project path to the clipboard'
      order: 7
    copyRelativePath:
      type: 'boolean'
      default: true
      title: 'Copy Relative Path'
      description: 'Copies the relative path of the file in the project to the clipboard'
      order: 8

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

    @subscriptions.add atom.config.onDidChange 'path-copy',
      => @updateSettings()

    @updateSettings()

  deactivate: ->
    @subscriptions.dispose()

  updateSettings: ->
    # Add menuitems, depending on configuration choices
    isCopyFullPath = atom.config.get('path-copy.copyFullPath')
    isCopyShortName = atom.config.get('path-copy.copyShortName')
    isCopyFullName = atom.config.get('path-copy.copyFullName')
    isCopyFolderPath = atom.config.get('path-copy.copyFolderPath')
    isCopyProjectPath = atom.config.get('path-copy.copyProjectPath')
    isCopyRelativePath = atom.config.get('path-copy.copyRelativePath')
    isCopyExtension = atom.config.get('path-copy.copyExtension')

    atom.contextMenu.add
      '.tab': [{
        label: 'Path Copy'
        submenu: [
          {label: 'Copy Full Path', command: 'path-copy:fullpath', visible: isCopyFullPath}
          {label: 'Copy Full Name', command: 'path-copy:fullname', visible: isCopyFullName}
          {label: 'Copy Short Name', command: 'path-copy:shortname', visible: isCopyShortName}
          {label: 'Copy Extension', command: 'path-copy:extension', visible: isCopyExtension}
          {type: 'separator'}
          {label: 'Copy Folder Path', command: 'path-copy:folderpath', visible: isCopyFolderPath}
          {label: 'Copy Project Path', command: 'path-copy:projectpath', visible: isCopyProjectPath}
          {label: 'Copy Relative Path', command: 'path-copy:relativepath', visible: isCopyRelativePath}
          {type: 'separator'}
          {label: 'Add Options in Settings', command: '', visible: false, enabled: false}
        ]
      }]

  raiseNotificationSuccess: (textpath) ->
    atom.notifications.addSuccess("path-copy: #{textpath}")

  raiseNotificationError: ->
    atom.notifications.addError("path-copy: Editor file does not exist on the system directory as a valid path.")

  writeToClipboard: (textpath) ->
    character = atom.config.get('path-copy.quotationCharacter')

    if character?.length
      textpath = character + textpath + character

    atom.clipboard.write(textpath)

    @raiseNotificationSuccess(textpath)

  getTabContextClicked: ->
    return document.querySelector('.right-clicked')

  getTabPath: ->
    tab = @getTabContextClicked()
    return tab.path

  getRelativePath: ->
    [projectPath, relativePath] = atom.project.relativizePath(@getTabPath())
    return {
      projectPath : projectPath
      relativePath: relativePath
    }

  parseTabPath: ->
    tabPath = @getTabPath()

    if tabPath?
      return path.parse(tabPath)
    else
      @raiseNotificationError()
      return path.parse('')

  # Methods to write to clipboard the specific options
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
    tabPath = @getTabPath()

    if tabPath?
      @writeToClipboard(tabPath)
    else
      @raiseNotificationError()
