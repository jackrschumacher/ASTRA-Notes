---
title: 2025 Biosensor Code
weight: 1

---

Use this code for reference as needed.

```c
/**
 * @file DigitMainMCU.h
 * @author David Sharpe (ds0196@uah.edu)
 * @brief Digit PCB; controls end effector, wrist, and now FAERIE; attaches to end of arm
 *
 */
#pragma once


#if defined(ESP32) && !defined(ARDUINO_ADAFRUIT_FEATHER_ESP32_V2)

//------------------------------------------------------------------------------------------------//
//   DOIT ESP32 Devkit V1 (URC 2025, Digit+FAERIE V2)
//------------------------------------------------------------------------------------------------//

// Comms

#   define CAN_RX 27
#   define CAN_TX 14

// Linear actuator

#   define LINAC_RIN 19
#   define LINAC_FIN 18

// End Effector

#   define MOTOR_IN1 33
#   define MOTOR_IN2 25
#   define MOTOR_FAULT 4

#   define LASER_NMOS 23  // same for faerie

// ADC

#   define PIN_VDIV_5V 35
#   define PIN_VDIV_12V 36
#   define PIN_VDIV_BATT 39

// FAERIE

#   define SPARK_PWM 26

// Misc

#   define PIN_NEOPIXEL 13

// LSS

#   define LSS_SERIAL Serial2


#elif defined(ARDUINO_ADAFRUIT_FEATHER_ESP32_V2)

//------------------------------------------------------------------------------------------------//
//   Feather ESP32 (URC 2025, Digit V1)
//------------------------------------------------------------------------------------------------//

// Comms

#   define CAN_RX 14
#   define CAN_TX 32

// Linear actuator

#   define LINAC_RIN 12
#   define LINAC_FIN 13

// End Effector

#   define MOTOR_FAULT 5
#   define MOTOR_IN2 19
#   define MOTOR_IN1 21

#   define LASER_NMOS 25

// ADC

#   define PIN_VDIV_5V 34
#   define PIN_VDIV_12V 39
#   define PIN_VDIV_BATT 36

// Misc

#   define MCU_DEBUG 4

// Lynxmotion Smart Servo

#   define LSS_SERIAL Serial1


#elif defined(CORE_TEENSY)

//------------------------------------------------------------------------------------------------//
//   Teensy 4.x (URC 2024)
//------------------------------------------------------------------------------------------------//

//------//
// Pins //
//------//

// DC on/off control for laser on end effector
#    define PIN_LASER 8
// PWM control for REV motor that opens/closes end effector
#    define PIN_EF_MOTOR 19

//-----------//
// Constants //
//-----------//

#    define COMMS_UART Serial1


#endif

[   104][E][ESP32PWM.cpp:135] allocatenext(): [ESP32PWM] ERROR All PWM timers allocated! Can't accomodate 50.000 Hz

/**
 * @file main.cpp
 * @author Jack Schumacher (js0342@uah.edu)
 * @author David Sharpe (ds0196@uah.edu)
 * @brief ASTRA Biosensor Citadel embedded code
 *
 */
#include <Arduino.h>
#include <cmath>
#include <ESP32Servo.h>
#include "AstraMisc.h"
#include "AstraVicCAN.h"
#include "AstraREVCAN.h"
#include "AstraMotors.h"

// Remove to disable the boards inbuilt LED blinking
#define BLINK
#define CAN_TX 34
#define CAN_RX 35

#define FAN_MOTOR_ID 1   // TODO: Needs to be confirmed that this is the correct CAN ID
#define REV_PWM_MIN 1000 // us  -1.0 duty
#define REV_PWM_MAX 2000 // us  1.0 duty

#define SPARK_PWM 26

#define COMMS_UART Serial // To/from USB for debugging

bool ledState = false;

// Defined servos (3 for valves, 3 for distributors, 3 for chemicals)
Servo valve1, valve2, valve3, distributor1, distributor2, distributor3, chemical1, chemical2, chemical3;
Servo *servoReference[9] = {&valve1, &valve2, &valve3, &distributor1, &distributor2, &distributor3, &chemical1, &chemical2, &chemical3};

int currentServoPos[9] = {0, 0, 0, 0, 0, 0, 0, 0, 0};
int targetServoPos[9] = {0, 0, 0, 0, 0, 0, 0, 0, 0};
unsigned long lastServoMoveTime = 0;
int servoSpeed = 10; // Uses servo steps to determine speed

long lastWiggle = 0; // For PWM servos

unsigned long lastAccel = 0;

unsigned long lastHB = 0;
int heartBeatNum = 1;

unsigned long lastCtrlCmd = 0;
unsigned long lastMotorStatus = 0;

// Control the NEO550 functioning as the fan motor
Servo fanMotor;

void loop2(void *pvParameters)
{
  while (true)
  {
    CAN_sendHeartbeat(heartBeatNum);
    heartBeatNum++;
    if (heartBeatNum > 4)
    {
      heartBeatNum = 1;
    }
    delay(5);
  }
}

// Declarations
void Stop();

void setup()
{
  // Servo Pins: 13,14,18,19,22,23,25,26,27
  // Actual pins From bottom facing the USB C port- 25,13,27,18,22
  // Top Left: 14,26,19,23 (last 2 on the top are not used)
  Serial.begin(SERIAL_BAUD);
  // Valves are on top of the unit
  valve1.attach(10);
  valve2.attach(11);
  valve3.attach(12);

  // Distributors are on each of the pieces that hang down
  distributor1.attach(7);
  distributor2.attach(8);
  distributor3.attach(9);

  // Chemical servos are in the back of the unit (the larger servos)
  chemical1.attach(4);
  chemical2.attach(5);
  chemical3.attach(6);

  fanMotor.attach(SPARK_PWM, REV_PWM_MIN, REV_PWM_MAX);

  if (ESP32Can.begin(TWAI_SPEED_1000KBPS, CAN_TX, CAN_RX))
    Serial.println("CAN bus started!");
  else
    Serial.println("CAN bus failed!");

  // // TODO: Confirm that this is working- is CAN receiving a heartbeat?
  // // Pin the CAN heartbeat task to core
  // xTaskCreatePinnedToCore(
  //     loop2,   // Function to implement the task
  //     "loop2", // Name of the task
  //     1000,    // Stack size in bytes
  //     NULL,    // Task input parameter
  //     0,       // Priority of the task
  //     NULL,    // Task handle.
  //     0        // Core where the task should run
  // );
}

void loop()
{

  if (millis() - lastServoMoveTime >= servoSpeed)
  {
    lastServoMoveTime = millis();

    for (int i = 0; i < 9; i++)
    {
      if (currentServoPos[i] < targetServoPos[i])
      {
        currentServoPos[i]++;
        servoReference[i]->write(currentServoPos[i]);
      }
      else if (currentServoPos[i] > targetServoPos[i])
      {
        currentServoPos[i]--;
        servoReference[i]->write(currentServoPos[i]);
      }
    }
  }

  if (millis() - lastWiggle > 500)
  {
    // Move Servos ID 2-5 (The Distributor Servos) back and fourth to distribute the dirt into the tubes
    lastWiggle = millis();
    for (int i = 3; i < 6; i++)
    {
      if (currentServoPos[i])
      {
        targetServoPos[i] = (targetServoPos[i] == 0 ? 180 : 0);
      }
    }
  }
  // Serial commands
  if (Serial.available())
  {
    String input = Serial.readStringUntil('\n');
    Serial.println(input);

    input.trim();                  // Remove preceding and trailing whitespace
    std::vector<String> args = {}; // Initialize empty vector to hold separated arguments
    parseInput(input, args);       // Separate `input` by commas and place into args vector
    args[0].toLowerCase();         // Make command case-insensitive
    String command = args[0];      // To make processing code more readable

    if (command == "ping")
    {
      Serial.println("pong");
    }

    else if (command == "time")
    {
      Serial.println(millis());
    }

    else if (command == "led") // This command will not work when using boards that do not have a inbuilt LED (i.e. the ESP32 Dev Module 1)
    {
      digitalWrite(LED_BUILTIN, !ledState);
      ledState = !ledState;
    }

    else if (args[0] == "can_relay_tovic")
    {
      vicCAN.relayFromSerial(args);
    }

    else if (args[0] == "can_relay_mode")
    {
      if (args[1] == "on")
      {
        vicCAN.relayOn();
      }
      else if (args[1] == "off")
      {
        vicCAN.relayOff();
      }
    }
    // Servos are numbered 1-9
    // To use: servo,[servo number],[degrees]
    else if (args[0] == "servo")
    {
      int servo_id = args[1].toInt() - 1; // Get servo id
      int servo_angle = args[2].toInt();

      if (servo_id >= 0 && servo_id < 9)
      {
        // Validate the servo values - Servo IDs 6-9 (the chemical servos) should only move 60 degrees to prevent overextension and other issues

        if (servo_id >= 1 && servo_id <= 3)
        {
          targetServoPos[servo_id] = (servo_angle <= 60) ? servo_angle : 60;
        }
        // Other servos can move the full 180 degrees
        else
        {
          targetServoPos[servo_id] = servo_angle;
        }
      }
    }
    // Commands that move all servos in a group
    //  val = valve servos
    //  dist = distributor servos
    //  chem = chemical servos
    //  all = all servos (might cause power issues)

    else if (args[0] == "val")
    {
      valve1.write(args[1].toInt());
      valve2.write(args[1].toInt());
      valve3.write(args[1].toInt());
    }
    else if (args[0] == "dist")
    {
      distributor1.write(args[1].toInt());
      distributor2.write(args[1].toInt());
      distributor3.write(args[1].toInt());
    }
    else if (args[0] == "chem")
    {

      if (args[1].toInt() >= 55)
      {
        chemical1.write(55);
        chemical2.write(55);
        chemical3.write(55);
      }
      else
      {
        chemical1.write(args[1].toInt());
        chemical2.write(args[1].toInt());
        chemical3.write(args[1].toInt());
      }
    }
    else if (args[0] == "all")
    {
      valve1.write(args[1].toInt());
      valve2.write(args[1].toInt());
      valve3.write(args[1].toInt());
      distributor1.write(args[1].toInt());
      distributor2.write(args[1].toInt());
      distributor3.write(args[1].toInt());

      if (args[1].toInt() >= 55)
      {
        chemical1.write(55);
        chemical2.write(55);
        chemical3.write(55);
      }
      else
      {
        chemical1.write(args[1].toInt());
        chemical2.write(args[1].toInt());
        chemical3.write(args[1].toInt());
      }
    }
  }

  // CAN
  if (vicCAN.readCan())
  {
    const uint8_t commandID = vicCAN.getCmdId();
    static std::vector<double> canData;
    vicCAN.parseData(canData);

    Serial.print("VicCAN: ");
    Serial.print(commandID);
    Serial.print("; ");
    if (canData.size() > 0)
    {
      for (const double &data : canData)
      {
        Serial.print(data);
        Serial.print(", ");
      }
    }
    Serial.println();

    // Misc CAN commands

    if (commandID == CMD_PING)
    {
      vicCAN.respond(1); // "pong"
      Serial.println("Received ping over CAN");
    }
    // Takes a servo ID between 1 and 9 as well as the angle that the commanded servo should move to
    else if (commandID == CMD_PWMSERVO_SET_DEG)
    {
      if (canData.size() == 2 && canData[0] > 0 && canData[0] < 9)
      {
        unsigned servoId = static_cast<unsigned>(canData[0]);
        targetServoPos[servoId - 1] = static_cast<int>(canData[1]);
      }
    }
    // TODO: Add parser for REV command

    // Motor control safety timeout- if no command is received in 2 seconds, shut off the NEO
    if (millis() - lastCtrlCmd > 2000)
    {
      lastCtrlCmd = millis();
      fanMotor.write(0);
    }
    else if (commandID == CMD_REV_STOP)
    {
      lastCtrlCmd = millis();
      fanMotor.write((REV_PWM_MIN + REV_PWM_MAX) / 2);
    }
    // Converts duty cycle input into writeMicroseconds range of the NEO
    else if (commandID == CMD_REV_SET_DUTY)
    {
      if (canData.size() == 1)
      {
        lastCtrlCmd = millis();
        int value = map_d(canData[0] / 100.0, -1.0, 1.0, REV_PWM_MIN, REV_PWM_MAX);
        fanMotor.writeMicroseconds(value);
        Serial.print("Setting REV duty to ");
        Serial.println(value);
      }
    }
  }
}
```

