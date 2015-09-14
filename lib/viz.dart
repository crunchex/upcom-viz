library lib.viz;

// Typical dart built-in imports.
import 'dart:io';
import 'dart:async';
import 'dart:isolate';

// UpCom import for a Tab back-end (lib).
import 'package:upcom-api/tab_backend.dart';

// Other parts of your back-end.
part 'src/viz_helper.dart';

/// This is the main class that should encapsulate most of your code.
/// If it does grow sufficiently large, then it will at least be your entry point.
/// [YourTab] will be instantiated in bin/main.dart.
class CmdrViz extends Tab {
  /// These names should match what you have in lib/tabinfo.json.
  /// names[0] will be used almost everywhere (filesystem, DOM, identification within UpCom core code, etc.).
  /// names[1] will be used when a full, pretty name is needed - such as within the Shop.
  /// names[2] will be used where space is limited, such as the tab handle title. Single words are best.
  static final List<String> names = ['upcom-viz', 'UpDroid Visualizer', 'Visualizer'];

  // Private instance variables.
  //  int _x;
  //  String _y;

  CmdrViz(SendPort sp, args) :
  super(CmdrViz.names, sp, args) {
    // Don't put expensive, time-consuming code here.
    // Set up a call to an async function, or save more
  }

  /// Register message handlers as part of the setup routine.
  void registerMailbox() {
    // Register message handlers for incoming String messages.
    //  mailbox.registerMessageHandler('MESSAGE_TO_LISTEN_FOR', _messageHandler);

    // Register endpoint handlers for direct websocket connections. These are more useful for
    // cases where there is a lot of data (like a video stream), or when a pre-existing application
    // requires a direct endpoint.
    //  mailbox.registerEndPointHandler('/$refName/$id/websocket_endpoint', _endpointHandler);
  }

  /// Called last, right before the [Tab] is destroyed.
  void cleanup() {
  //  if (_shell != null) _shell.kill();
  }
}