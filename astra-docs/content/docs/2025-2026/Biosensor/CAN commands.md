---
title: CAN commands
weight: 1
---

# Citadel CAN commands

## Starting CAN relay mode

```
can_relay_mode,on
```



## Ping command

```
can_relay_tovic,citadel,1
```

## Motor Movement
### Servo Movement

#### Structure:

```
can_relay_tovic,citadel,40,[group],[angle1],[angle2],[angle3]
```
- **can_relay_tovic** - call the can_relay_tovic command
- **citadel** - call the citadel mcu
- **40** - CAN command
- **Group**
  - valves (1,2,3)
  - distributor (1,2,3)
  - chemical (1,2,3)
- **Angles**
  - Angle to move valve servos
  - Angle to move distributor servos
  - Angle to move chemical servos

#### Example:

```
can_relay_tovic,citadel,40,1,30,30,30
```

### REV/NEO 550 motor movement

#### Structure

```
can_relay_tovic,citadel,19,[speed]
```

- **citadel** - call the citadel MCU
- **19** - CAN command
- **Speed** - speed that the motor should run at

#### Example

```
can_relay_tovic,19,20
```

### Other Commands

#### Ping

**Expected response:** pong

```
can_relay_tovic,citadel,CMD_PING
```

#### CMD_REV_STOP

**Expected response:** stop REV motor

```
can_relay_tovic,citadel,CMD_REV_STOP
```

