---
title: Citadel Environment setup
weight: 1
---

# Citadel Environment setup

## Tools

To setup citadel embedded code, you need a few tools, listed below. 

{{< button href="https://code.visualstudio.com/Download" >}}Visual Studio Code{{< /button >}}

{{< button href="https://git-scm.com/install/" >}}Git{{< /button >}}

Once you have installed Visual Studio Code, you need the following extensions:

{{< button href="https://marketplace.visualstudio.com/items?itemName=platformio.platformio-ide" >}}PlaformIO extension for Visual Studio Code{{< /button >}}

{{< button href="https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools" >}}Microsoft C/C++ for Visual Studio Code{{< /button >}}

## Opening the Platform IO project and Uploading to the MCU

> [!IMPORTANT]
>
> The current published repository branch `(citadel-2026)` uses the `ESP32-DevKitV1` not the `ESP32-S3-DevKit`

First clone the git repository using the following link:

```
git@github.com:SHC-ASTRA/biosensor-embedded.git (If you have an SSH key)
https://github.com/SHC-ASTRA/biosensor-embedded.git (If you have HTTPS)
```

You want to be on the `citadel-2026` branch

{{< button href="https://github.com/SHC-ASTRA/biosensor-embedded/tree/citadel-2026" >}}Biosensor-embedded GitHub repository{{< /button >}}

Then open the Platform IO extension in Visual Studio Code, and click 'Open' and select the folder which you have cloned the Git repository into. 

The main .cpp file will be located at: `citadel-embedded/src/main.cpp` 

To verify that you have set up the project correctly, look for the `platformio.ini` file in the root of the project and verify that it looks like this:

> [!IMPORTANT]
>
> Note that the board is defined as the `esp32doit-devkit-v1`

```ini
; PlatformIO Project Configuration File
;
;   Build options: build flags, source filter
;   Upload options: custom upload port, speed and extra flags
;   Library options: dependencies, extra library storages
;   Advanced options: extra scripting
;
; Please visit documentation for the other options and examples
; https://docs.platformio.org/page/projectconf.html

[env:esp32devkit-v1]
platform = espressif32
framework = arduino
monitor_speed = 115200
lib_deps = 
	https://github.com/SHC-ASTRA/rover-Embedded-Lib
	https://github.com/madhephaestus/ESP32Servo.git
	handmade0octopus/ESP32-TWAI-CAN@^1.0.1
monitor_filters = send_on_enter
build_flags =
	-D CITADEL
	-D DEBUG
board = esp32doit-devkit-v1

```

After you have verified this, you can click the checkmark icon on the bottom bar of VSCode to build the project. If this succeeds, you are ready to upload code to the MCU. For the `ESP32-DevKitV1`, use a USB-A to USB-C cable to ensure proper data and power transfer. 

Click the arrow icon to upload to the MCU and click the plug icon (by the upload icon) to show the serial monitor. You may have to change the serial port if it is not auto-recognized correctly. To do this, click the plug icon with the word 'auto' next to it. This should allow you to select a specific COM port. Look for one the says something like `Standard Serial over USB...`.