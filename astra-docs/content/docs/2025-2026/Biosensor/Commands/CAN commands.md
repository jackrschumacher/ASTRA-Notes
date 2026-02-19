---
title: CAN commands
weight: 1
---

# CAN commands

{{< tabs >}}
{{% tab "Relay commands" %}} 

> [!IMPORTANT]
>
> This is not a command that is transmitted over the CAN loop, but is rather commanded over the serial loop to enable CAN command validation over serial

#### Starting CAN relay mode

```
can_relay_mode,on
```

#### Stopping CAN relay mode

```
can_relay_mode,off
```



{{% /tab %}}

{{% tab "Ping commands" %}} 

#### Ping citadel MCU over CAN

| **CommandID** | **Returns/Output** |
| ------------- | ------------------ |
| `1`           | `pong`             |



```
can_relay_tovic,citadel,1
```



{{% /tab %}}

{{% tab "Valve, Tube and Distributor movement" %}} 

| **CommandID** | **Data format**                                              | **Returns/Output**                                           |
| ------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| `40`          | **double:** valve_selection, **float**: tube_id (0-2), milliliters, **short**: distributor_id (3x) | Moves a selected valve, tube and distributor (one group essentially) |

#### Format

- `valveID`,`tubeID`, and `distributorID` are indexed `0,1,2`

```
can_relay_tovic,citadel,40,[valveID],[tubeID],[distributorID]
```

#### Range of movement

> [!NOTE]
>
> These values are in degrees

- Valves: `0 or 180` (Open/Close)
- Distributors: `0-180`
- Chemicals: `0-55` (Max value to the top of the box)

{{% /tab %}}

{{% tab "NEO movement" %}} 

| **CommandID** | Data Format                                                  | **Returns/Output**                                           |
| ------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| `16`          | N/A                                                          | Stops REV motor (NEO550)                                     |
| `17`          | **double:** motorID                                          | ID's REV motor                                               |
| `18`          | **double:** brakeAmount                                      | Brakes REV motor                                             |
| `19`          | <u>**double**: CITADEL fan speed</u>, **float**: core duty cycles, **short**: arm duty cycle | Moves the NEO550 motor a set amount by converting the input value to microseconds |

#### Format

```
can_relay_tovic,citadel,19,[movement amount]
```



{{% /tab %}}



{{< /tabs >}}
