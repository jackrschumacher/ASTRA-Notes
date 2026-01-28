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
### Example:

```c++
can_relay_tovic,citadel,40,1,30,30,30
```