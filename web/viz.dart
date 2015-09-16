library web.viz;

// Typical dart built-in imports.
import 'dart:async';
import 'dart:html';
import 'dart:js' as js;

// UpCom import for a Tab front-end (lib).
import 'package:upcom-api/tab_frontend.dart';

class UpDroidViz extends TabController {
  static final List<String> names = ['upcom-viz', 'UpDroid Visualizer', 'Visualizer'];

  /// This [List] will populate the Tab menu.
  /// You should probably keep at least File > Close Tab.
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

  /// Initial [TabController] setup.
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
          new js.JsObject(js.context['vizInit'], []);
        }
      });
    });
  }

  /// Register handlers for [Mailbox].
  void registerMailbox() {
    //  mailbox.registerWebSocketEvent(EventType.ON_OPEN, 'TAB_READY', _signalReady);
      mailbox.registerWebSocketEvent(EventType.ON_MESSAGE, 'NODES_UP', _startViz);
  }

  //\/\/ Mailbox Handlers /\/\//

  void _resizeContents() {
    CanvasElement canvas = _urdfDiv.children.first;
    canvas.classes.add('${refName}-urdf-canvas');
    canvas.width = _urdfDiv.contentEdge.width;
    canvas.height = _urdfDiv.contentEdge.height;
  }


  /// Create any event handlers for buttons, regular DOM events, etc.
  void registerEventHandlers() {
    window.onResize.listen((e) => _resizeContents());
  }

  /// Set the [Element] to focus on when the user clicks within the [TabView] area,
  /// (below the menu).
  Element get elementToFocus => view.content.children[0];

  /// This method can be used to prevent a user from closing this [TabController].
  /// DO NOT abuse this. It should only interrupt the process if is still stuff
  /// that needs to be cleaned up. You can also use the [Future] to delay closing.
  Future<bool> preClose() {
    Completer c = new Completer();
    c.complete(true);
    return c.future;
  }

  /// Final clean up method, called right before the [TabController] is destroyed.
  void cleanUp() {
    _scripts.forEach((e) => e.remove());
  }
}