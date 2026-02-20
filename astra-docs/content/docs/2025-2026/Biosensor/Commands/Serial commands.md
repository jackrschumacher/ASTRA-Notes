---
title: Serial commands
weight: 1
---

# Serial commands

## General 

| **Command** | **Output**                                   | **Notes** |
| ----------- | -------------------------------------------- | --------- |
| `ping`      | `pong`                                       |           |
| `time`      | Time in milliseconds from MCU                |           |
| `led`       | Turn on the boards inbuilt LED- if it exists |           |

## CAN 

| **Command**          | **Output** | **Notes**                                            |
| -------------------- | ---------- | ---------------------------------------------------- |
| `can_relay_tovic`    | N/A        | Relays commands from serial (for debugging purposes) |
| `can_relay_mode,on`  | `on`       | Turns on CAN relay mode                              |
| `can_relay_mode,off` | `off`      | Turns off CAN relay mode                             |

## Servo

- Servos are IDed from `1-9` in the embedded code

| **Servo IDs** | **Associated with**                         |
| ------------- | :------------------------------------------ |
| `1-3`         | Valve servos                                |
| `4-6`         | Distributor servos                          |
| `7-9`         | Chemical servos (limited to max 55 degrees) |



| **Command**                | **Output**                         | **Notes**                                                    |
| -------------------------- | ---------------------------------- | ------------------------------------------------------------ |
| `servo,[ID (0-9)],[angle]` | Specific Servo movement            | Chemical servos limited to 55 degrees to avoid hardware damage |
| `val,[angle]`              | Move valve servos                  |                                                              |
| `chem,[angle]`             | Move chemical servos               | Chemical servos limited to 55 degrees                        |
| `dist,[angle]`             | Move distributor servos            |                                                              |
| `all,[angle]`              | Move all servos to specified angle | Chemical servos limited to 55 degrees                        |
