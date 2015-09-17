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

      bool nodesUp = false;
      List nodes = [
        '/joint_state_publisher',
        '/robot_state_publisher',
        '/rosapi',
        '/rosbridge_websocket',
        '/rosout',
        '/tf2_web_republisher'
      ];

      while (!nodesUp) {
        ProcessResult result = Process.runSync('bash', ['-c', '. ${_uproot.path}/catkin_ws/devel/setup.bash && rosnode list'], runInShell: true);
        String stdout = result.stdout;
        for (String node in nodes) {
          if (!stdout.contains(node)) {
            nodesUp = false;
            break;
          }

          nodesUp = true;
        }
      }

      mailbox.send(new Msg('NODES_UP'));
      c.complete();
    });

    return c.future;
  }

  void cleanup() {
    if (_shell != null) _shell.kill();
  }
}