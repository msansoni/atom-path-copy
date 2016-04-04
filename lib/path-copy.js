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

  getTargetEditorPath(e) {
    // tab's context menu
    var elTarget;
    if (e.target.classList.contains("title")) {
      elTarget = e.target;
    } else {
      // find .tab
      for (let i = 0; i < 100; i++) {
        const el = e.target.parentElement;
        if (el && el.classList.contains("tab")) {
          elTarget = el.querySelector(".title");
        }
      }
    }
    if (elTarget) {
      return elTarget.dataset.path;
    }
    // command palette etc.
    return atom.workspace.getActivePaneItem().getPath();
  }

  parseTargetEditorPath(e) {
    return path.parse(this.getTargetEditorPath(e));
  }

  getProjectRelativePath(p) {
    [projectPath, relativePath] = atom.project.relativizePath(p);
    return relativePath;
  }

  copyFullPath(e) {
   atom.clipboard.write(this.getTargetEditorPath(e));
  }
};
