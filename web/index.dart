import 'dart:html';
import 'viz.dart';

void main() {
  ScriptElement depsJs = new ScriptElement()
    ..type = 'text/javascript'
    ..src = 'tabs/upcom-viz/viz-deps.js';
  document.body.children.add(depsJs);

  depsJs.onLoad.first.then((_) {
    new UpDroidViz([depsJs]);
  });
}