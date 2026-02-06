---
title: Building and running a ROS package
---



> [!WARNING]
>
> Make sure to source your ROS2 setup script

### Building and Running a ROS2 Package

####  Run rosdep

> [!IMPORTANT]
>
> It is a good idea to run rosdep in the root of your workspace before building to ensure that no packages are missing

```bash
rosdep install -i --from-path src --rosdistro humble -y
```

#### Build your package

Run this from the root of your workspace (like ros2_ws)

```bash
colcon build --packages-select [packageName]
```

#### Source the Setup Files

```bash
source install/setup.bash
```

#### Start the talker node

```bash
ros2 run [package_name] talker
```

Like this:

```bash
ros2 run py_pubsub talker
```

The output may look like this:

```bash
[info] [minimal_publisher]: publishing: "hello world: 0"
[info] [minimal_publisher]: publishing: "hello world: 1"
[info] [minimal_publisher]: publishing: "hello world: 2"
[info] [minimal_publisher]: publishing: "hello world: 3"
[info] [minimal_publisher]: publishing: "hello world: 4"
```

#### Start the listener node

```bash
ros2 run [package_name] listener
```

Like:

```bash
ros2 run py_pubsub listener
```

The output may look like this:

```bash
[INFO] [minimal_subscriber]: I heard: "Hello World: 10"
[INFO] [minimal_subscriber]: I heard: "Hello World: 11"
[INFO] [minimal_subscriber]: I heard: "Hello World: 12"
[INFO] [minimal_subscriber]: I heard: "Hello World: 13"
[INFO] [minimal_subscriber]: I heard: "Hello World: 14"
```