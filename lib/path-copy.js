"use babel";
import {$, CompositeDisposable} from "atom";
import path from "path";

module.exports = new class {

  constructor() {
    this.config = {};
  }

  activate() {
    this.subscriptions = new CompositeDisposable();
    this.subscriptions.add(atom.commands.add("atom-workspace", {
      "path-copy:copy-full-path": (e) => this.copyFullPath(e),
    }));
  }

  deactivate() {
    this.subscriptions.dispose();
  }

  getEditorPath(e) {
    return atom.workspace.getActivePaneItem().getPath();
  }

  copyFullPath(e) {
   atom.clipboard.write(this.getEditorPath(e));
  }
};
