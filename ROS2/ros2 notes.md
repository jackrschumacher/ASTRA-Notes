# ROS2 Notes

## How to Build 
* Go to the ROS2 workstation folder and run the following:
	* colcon build
	* source /opt/ros/humble/setup.bash
	* ros2 run [package_name] [node_name]
		
### When modifying the package and other Notes
* source install/setup.bash - this will have to be done whenever a new terminal is opened
	- This is likley (should be) located at /opt/ros/humble/setup.bash
* colcon build if anything is modified
* Can do this everytime ROS2 is opened

	
### Common issues

#### Issues with ROS2 building on Certain devices


* Can have issues with building (colcon build) on certain devices
* **DO NOT DELETE SRC**
* rm ./build ./install ./log -rf
* colcon build
* colcon install/setup.bash

#### Issues relating to "no ROS2 command or something similar"
* Probably want to modify the bash file on the system to avoid having to do this
* Can run this to try to fix it- but recommended to add to .bashrc
	* source /opt/ros/humble/setup.bash