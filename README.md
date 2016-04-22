# [path-copy](https://github.com/msansoni/atom-path-copy)

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

## License

[MIT](https://github.com/msansoni/atom-path-copy/blob/master/LICENSE.md) © [Michael Sansoni](http://www.michaelsansoni.com)
