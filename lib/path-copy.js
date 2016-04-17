"use babel";
import {
    $,
    CompositeDisposable
} from "atom";
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
    };

    deactivate() {
        this.subscriptions.dispose();
    };

    getActiveBuffer() {
        if (atom.workspace.getActivePaneItem() && atom.workspace.getActivePaneItem().buffer) {
          return atom.workspace.getActivePaneItem().buffer;
        };

        return null;
    };

    getActiveFile() {
        var buffer = this.getActiveBuffer();

        if (buffer && buffer.file) {
            return buffer.file;
        }

        return null;
    };

    getActiveEditorPath(e) {
      var file = this.getActiveFile();

      if (file && file.path) {
          return file.path;
      }

      return null;
    };

    copyFullPath(e) {
        atom.clipboard.write(this.getActiveEditorPath(e));
    };
};
