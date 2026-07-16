---
title: Embedded summary
weight: 2
---

# Summary
- 9 servos



{{< tabs >}}



{{< tab name="ESP-32 S3 pins" >}}


> [!WARNING]
>
> This board requires an additional PWM servo driver in order to work with more than 8 PWM devices. See [Adafruit PCA9685 PWM](/docs/2025-2026/biosensor/adafruit-pca9685-pwm/) for more details on usage. The servo assignments below 

```
Valve1: 1
Valve2: 2
Valve3: 42

Distributor1: 41
Distributor2: 40
Distributor3: 39  - Commented out because of S3 timing issue

Chemical1: 38	
Chemical2: 37
Chemical3: 36
```

{{< /tab >}}



{{< tab name="ESP-32 Devkit V1 GPIO/PWM pins" >}}

### Avaliable Pins with PWM, IO and no board functions

* 14
* 27
* 26
* 25
* 33
* 32
* 23
* 22
* 21
* 19
* 18
* 5
* 17
* 16
* 4


{{< /tab >}}



{{< /tabs >}}



