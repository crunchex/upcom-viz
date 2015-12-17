import 'dart:html';
import 'package:quiver/async.dart';
import 'viz.dart';

void main() {
  ScriptElement depsJs = new ScriptElement()
    ..type = 'text/javascript'
    ..src = 'plugins/upcom-viz/viz-deps.js';
  document.body.children.add(depsJs);

  ScriptElement vizJs = new ScriptElement()
    ..type = 'text/javascript'
    ..src = 'plugins/upcom-viz/viz.js';
  document.body.children.add(vizJs);

  FutureGroup jsGroup = new FutureGroup();
  jsGroup.add(depsJs.onLoad.first);
  jsGroup.add(vizJs.onLoad.first);

  jsGroup.future.then((_) {
    new UpDroidViz([depsJs, vizJs]);
  });
}