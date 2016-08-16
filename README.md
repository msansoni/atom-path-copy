# [path-copy](https://github.com/msansoni/atom-path-copy)

[![Build Status](https://travis-ci.org/msansoni/atom-path-copy.svg?branch=master)](https://travis-ci.org/msansoni/atom-path-copy)

Add context menu options to the tab context menu to copy the open editor file path.

Atom Package: https://atom.io/packages/path-copy

```bash
apm install path-copy
```

Or Settings/Preferences ➔ Packages ➔ Search for `path-copy`

## Available Commands

- Full Path
- Full Name
- Short Name
- Extension
- Folder Path
- Project Path
- Relative Path

## Usage

Open the [Tab Context Menu](https://github.com/atom/atom/blob/master/src/context-menu-manager.coffee), and  select which file path you would like to copy from the [Path Copy](https://atom.io/packages/path-copy) sub-menu.

The benefit of `path-copy` is that the package uses the path of the tab where the context menu was called, rather than only being able to retrieve the path of the active tab.

## Preview

![Path Copy in Action](https://github.com/msansoni/atom-path-copy/raw/master/preview.gif)

## Configuration

Context menu items can easily be set to visible/hidden by clicking the checkboxes in the package settings. To add functionality/de-clutter the `path-copy` sub-menu.
- Atom Package Settings  
  `Atom` ➔ `Preferences` ➔ Search for `path-copy`

The configuration page also allows users to set quotation characters such as `""` or `''` to enclose path strings.

Notifications can also be toggled on/off to show successful path-copy commands and the paths that have been added to the clipboard.

## Keyboard Shortcut

All [path-copy](https://atom.io/packages/path-copy) functions are available directly via keyboard shortcuts, for example: <kbd>Cmd</kbd>-<kbd>Alt</kbd>-<kbd>W</kbd> as a shortcut to copy the current editor's full file path.

### Custom Keyboard Shortcuts

The default key-bindings can be modified in your keymap.cson file.
See [Keymaps In-Depth](https://atom.io/docs/latest/behind-atom-keymaps-in-depth) for more details.

For example:

```coffeescript
'atom-text-editor':
  'alt-cmd-w': 'path-copy:current-fullpath'
```

## License

[MIT](https://github.com/msansoni/atom-path-copy/blob/master/LICENSE.md) © [Michael Sansoni](http://www.michaelsansoni.com)
