### Common issues
- Issues with ROS2 building on Certain devices
  
  *   Can have issues with building (colcon build) on certain devices
  *   **DO NOT DELETE SRC**
  
    ```bash
    rm ./build ./install ./log -rf
    colcon build
    colcon install/setup.bash
  ```
- #### Issues relating to "no ROS2 command or something similar"
  
  *   Probably want to modify the bash file on the system to avoid having to do this
  *   Can run this to try to fix it- but recommended to add to .bashrc
- ```bash
  source /opt/ros/humble/setup.bash
  ```