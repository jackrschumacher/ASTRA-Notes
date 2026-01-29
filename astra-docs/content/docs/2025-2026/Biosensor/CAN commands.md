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

```c++
can_relay_tovic,citadel,1
```

## Motor Testing
### Structure:

```c++
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

### Example:

```c++
can_relay_tovic,citadel,40,1,30,30,30
```