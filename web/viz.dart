library web.viz;

import 'dart:async';
import 'dart:html';
import 'dart:js' as js;

// UpCom import for a Tab front-end (lib).
import 'package:upcom-api/tab_frontend.dart';

class UpDroidViz extends TabController {
  static final List<String> names = ['upcom-viz', 'UpDroid Visualizer', 'Visualizer'];

  static List getMenuConfig() {
    List menu = [
      {'title': 'File', 'items': [
        {'type': 'toggle', 'title': 'Close Tab'}]}
    ];
    return menu;
  }

  // Private instance variables.
  List<ScriptElement> _scripts;
  DivElement _urdfDiv;

  UpDroidViz(List<ScriptElement> scripts) :
  super(UpDroidViz.names, getMenuConfig(), 'tabs/upcom-viz/viz.css') {
    _scripts = scripts;

  }

  /// This method is called between registerMailbox() and registerEventHandlers().
  void setUpController() {
    _urdfDiv = new DivElement()
      ..id = '$refName-$id-urdf-div'
      ..classes.add('$refName-urdf-div');
    view.content.children.add(_urdfDiv);
  }

  //\/\/ Mailbox Handlers /\/\//

  void _startViz(Msg m) {
    WebSocket ws;
    new Timer(new Duration(seconds: 1), () {
      ws = new WebSocket('ws://localhost:9090');
      new Timer.periodic(new Duration(seconds: 3), (Timer t) {
        print('ws state: ${ws.readyState.toString()}, expecting: ${WebSocket.OPEN.toString()}');

        if (ws != null && (ws.readyState == WebSocket.OPEN)) {
          t.cancel();
          new js.JsObject(js.context['rosConnect'], []);
          _setUpViewer();
        }
      });
    });
  }

  /// Register handlers for [Mailbox].
  void registerMailbox() {
    //  mailbox.registerWebSocketEvent(EventType.ON_OPEN, 'TAB_READY', _signalReady);
      mailbox.registerWebSocketEvent(EventType.ON_MESSAGE, 'NODES_UP', _startViz);
  }

  //\/\/ Event Handlers /\/\//

  void _setUpViewer() {
    new js.JsObject(js.context['setUpViewer'], [_urdfDiv.contentEdge.width, _urdfDiv.contentEdge.height]);

    // Give the canvas some time to load before we apply the fade-in CSS.
    new Timer(new Duration(seconds: 1), () {
      CanvasElement canvas = _urdfDiv.children.first;
      canvas.classes.add('$refName-urdf-canvas-loaded');
    });
  }

  /// Create any event handlers for buttons, regular DOM events, etc.
  void registerEventHandlers() {
    window.onResize.listen((e) {
      CanvasElement canvas = _urdfDiv.children.first;
      canvas.remove();
      _setUpViewer();
    });
  }

  Element get elementToFocus => view.content.children[0];

  Future<bool> preClose() {
    Completer c = new Completer();
    c.complete(true);
    return c.future;
  }

  void cleanUp() {
    _scripts.forEach((e) => e.remove());
  }
}