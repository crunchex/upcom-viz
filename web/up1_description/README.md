# UP1 Description #

A package containing the UpDroid UP1-Series description and helper tools for IK solvers and MoveIt! plugins.

## Generating IKFast solvers ##

These are the general steps for generating the IKFast solvers for UP1's arms:
```bash
# Use OpenRave to generate the C++ code for the left arm plugin.
rosrun collada_urdf urdf_to_collada left_arm_group.urdf left_arm_group.dae
rosrun moveit_ikfast round_collada_numbers.py left_arm_group.dae left_arm_group_rounded.dae 5
openrave-robot.py left_arm_group_rounded.dae --info links
python `openrave-config --python-dir`/openravepy/_openravepy_0_9/ikfast.py --robot=`rospack find up1_description`/urdf/left_arm_group_rounded.dae --iktype=translationdirection5d --baselink=0 --eelink=5 --savefile=ikfast_up1_left_arm.cpp

# Create a MoveIt! package for the left arm kinematics.
catkin_create_pkg up1_left_arm_kinematics
cd up1_left_arm_kinematics
mkdir src
cp ../up1_description/urdf/ikfast_up1_left_arm.cpp src/
rosrun moveit_ikfast create_ikfast_moveit_plugin.py up1 left_arm up1_left_arm_kinematics src/ikfast_up1_left_arm.cpp
catkin_make
```

However, there are some issues that you may run into.

1. The installation instructions for OpenRave via the PPA are completely broken for Ubuntu 14.04.
Best to install via source using this guide: [Andre's tutorial]. Even some of these steps are weird, though. All I had to do was install some of the packages he mentioned and then run `make` and `sudo make install` from the repo root.

2. `urdf_to_collada` in the current indigo-released **collada_urdf** package is broken. Build from source using the fix implemented at [Fix for Issue 89]. For more background, see [Issue 89].

3. `create_ikfast_moveit_plugin.py` in the current indigo-released **moveit_ikfast** package is broken. Build from source using the current indigo-devel HEAD. For more background, see [Issue 49].

[Andre's tutorial]: http://www.aizac.info/installing-openrave0-9-on-ubuntu-trusty-14-04-64bit/
[Fix for Issue 89]: https://github.com/ros/robot_model/commit/4ea3517910dbcfad59a517921dea186a0cb0f5c7
[Issue 89]: https://github.com/ros/robot_model/issues/89
[Issue 49]: https://github.com/ros-planning/moveit_ikfast/issues/49
