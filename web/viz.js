var ros;

function rosConnect() {
    // Connect to ROS.
    ros = new ROSLIB.Ros({
        url : 'ws://localhost:9090'
    });
}

function setUpViewer(canvasWidth, canvasHeight) {
    // Create the main viewer.
    var viewer = new ROS3D.Viewer({
        divID : 'upcom-viz-1-urdf-div',
        width : canvasWidth,
        height : canvasHeight,
        antialias : true
    });

    // Add a grid.
    viewer.addObject(new ROS3D.Grid());

    // Setup a client to listen to TFs.
    var tfClient = new ROSLIB.TFClient({
        ros : ros,
        angularThres : 0.01,
        transThres : 0.01,
        rate : 10.0
    });

    // Setup the URDF client.
    var urdfClient = new ROS3D.UrdfClient({
        ros : ros,
        tfClient : tfClient,
        path : 'http://localhost:12060/tabs/upcom-viz/',
        rootObject : viewer.scene,
        loader : ROS3D.COLLADA_LOADER_2
    });
}