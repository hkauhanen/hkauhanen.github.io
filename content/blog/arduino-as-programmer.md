---
title: "Using an Arduino Nano as an AVR programmer"
date: 2024-10-21
draft: true
tags: ["electronics", "microcontrollers", "diy"]
---

The [Arduino](https://arduino.cc) is a wonderful platform for all manner of electronics projects requiring a microcontroller. Embedding an Arduino device in every such project is, in the long run, costly and wasteful. After a point, it makes more sense to program an AVR microcontroller -- the brains inside many of Arduino's boards -- and use that instead.

The cool thing is that various Arduino boards can be used to program AVR microcontroller chips. This turns your Arduino into a device that can effectively "self-reproduce". In this short tutorial, I will discuss how to use the [Arduino Nano](https://store.arduino.cc/en-de/products/arduino-nano) to program the [Atmega328P](https://en.wikipedia.org/wiki/ATmega328) microcontroller for use with an external clock provided by a quartz crystal.

Here is a list of the required hardware:

- a computer with the Arduino IDE installed (I'm using version 2.3.3 on Linux)
- an Arduino Nano board (official or clone)
- an ATmega328P microcontroller
- a DIP-14 IC socket (preferably [zero insertion force](https://en.wikipedia.org/wiki/Zero_insertion_force))
- a 16 MHz crystal
- two 22 pF ceramic capacitors
- one 100 nF ceramic capacitor
- one 10 µF electrolytic capacitor
- perfboard, soldering iron, solder and wire (preferably) or a solderless breadbord with jumper wires
- optionally, three LEDs and three 220 Ω resistors


## Step 1: Uploading the ISP programmer

The first thing to is to upload the ArduinoISP sketch, provided by Arduino IDE, onto the Arduino Nano. For this, connect the Arduino Nano to your computer through USB, and launch Arduino IDE. Under the *Tools* menu, set the board and port to their correct values.

::: {.note}
On Linux, your user needs sufficient rights to operate the ports: typically this means being part of the `dialout` group. Run the following command as root to enable this:

```{bash}
usermod -a -G dialout <username>
```

and restart your system.
:::

Then, under *File > Examples > 11.ArduinoISP*, locate the *ArduinoISP* sketch and open it. Run *Sketch > Upload* (or Ctrl+U, or click the corresponding icon) to upload this sketch to the Arduino Nano.


## Step 2: Wiring up the programmer

The next step is to implement the circuit shown in the following figure, either permanently on a perfboard or stripboard, or less permanently on a solderless breadboard:

FIXME circuit diagram

The pins on the IC chip are numbered in the usual way, starting at top left and running counterclockwise.

Here is my perfboard implementation (not the cleanest job perhaps, but it does what it says -- or rather, what it doesn't say -- on the tin):

FIXME picture

The LEDs are optional; they simply provide information about the programmer's status. Green means the programmer is ready for input; yellow means the programmer is actively programming a chip; and red indicates an error.


## Step 3: Programming a microcontroller


## Step 4: Learning more

To learn more about AVR microcontrollers, I recommend Elliot Williams's excellent book *Make: AVR Programming* (MakerMedia, 2014).


![Alternate Text](DSCF5355.jpg "Close-up.")
