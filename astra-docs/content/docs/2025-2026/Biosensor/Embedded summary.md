---
title: Embedded summary
weight: 2
---

# Summary
- 9 servos
- One NEO 550 functioning as the fan motor

## Resources

Equipment Links

{{< button href="https://www.amazon.com/dp/B0F8NDRQQK?ref=ppx_yo2ov_dt_b_fed_asin_title" >}}ESP-32-S3 (3 pack){{< /button >}}

{{< button href="https://www.amazon.com/AITRIP-ESP-WROOM-32-Development-Microcontroller-Compatible/dp/B0DF2YJSHN/ref=sr_1_2?crid=2QQX1NIA0UNNW&dib=eyJ2IjoiMSJ9.kdZ5Zt_HmSZ7Mkirf5g0bLPlB4Xkex-_FIzfpr2h7AjdW3ZQnSEYFhYFGiOFdNzNz2Q9fdKZHdP-J_uhvKIvrYkTzThMgD08OA8U0HiTIIB--eKqtlqrWGeR-rrLeKFl3wvLaw32rAstsYGXDc1v3P7HFdZcpHDU8ljxwJMIjs1gXJ_hzWVTd6ihydBviNhD8Hd-0Id6E5nyJnMS6Acml3b9a9hzHCXfS4AHiTfnpJJNTtFfy3WcM3YmGKR7BIcB5FJ60vgfXcMvu4avpTsuBlE0uo2Q7JUpMqGevxisVQQ.k0ZazkDqLGm9ticndLtfSU5ZKW4cHAdYqyIAtI7JXic&dib_tag=se&keywords=esp-32%2Bdevelopment%2Bboard%2Busb-c&qid=1768773850&s=electronics&sprefix=%2Celectronics%2C125&sr=1-2&th=1" >}}ESP-32 Devkit V1{{< /button >}}

<br></br>



{{< tabs >}}
{{% tab "ESP-32 S3" %}} 

### ESP-32 S3 pins

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



{{% /tab %}}



{{% tab "ESP-32 Devkit V1" %}} 

### ESP-32 Devkit V1 GPIO/PWM pins

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





{{% /tab %}}
{{< /tabs >}}



