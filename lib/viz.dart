library lib.viz;

import 'dart:io';
import 'dart:async';
import 'dart:isolate';

// UpCom import for a Tab back-end (lib).
import 'package:upcom-api/tab_backend.dart';

part 'src/viz_helper.dart';

class CmdrViz extends Tab {
  static final List<String> names = ['upcom-viz', 'UpDroid Visualizer', 'Visualizer'];

  // Private instance variables.
  Process _shell;
  Directory _uproot;

  CmdrViz(SendPort sp, args) :
  super(CmdrViz.names, sp, args) {
    _uproot = new Directory(args[2]);
    _startRosNodes();
  }

  void registerMailbox() {
    //  mailbox.registerMessageHandler('MESSAGE_TO_LISTEN_FOR', _messageHandler);
    //  mailbox.registerEndPointHandler('/$refName/$id/websocket_endpoint', _endpointHandler);
  }

  Future _startRosNodes() {
    Completer c = new Completer();
    Process.start('bash', ['-c', '. ${_uproot.path}/catkin_ws/devel/setup.bash && roslaunch upcom_viz upcom_viz.launch'], runInShell: true).then((process) {
      _shell = process;
      stdout.addStream(process.stdout);
      stderr.addStream(process.stderr);

      // TODO: replace this timer with a method that checks rosnode list for
      // the expected nodes.
      // This timer may need to be fine-tuned depending on the system.
      sleep(new Duration(seconds: 5));
      mailbox.send(new Msg('NODES_UP'));
    });
    return c.future;
  }

  void cleanup() {
    if (_shell != null) _shell.kill();
  }
}