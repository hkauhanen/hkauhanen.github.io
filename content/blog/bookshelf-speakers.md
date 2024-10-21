---
title: "Small bass reflex speakers"
date: 2023-04-17
draft: true
tags: ["audio", "diy"]
---

For my piano playing hobby, I use a Kawai VPC-1 MIDI controller combined with a PC running the excellent [Pianoteq](https://www.modartt.com/) software. I normally practice using headphones so as not to annoy others, but on occasion, it is nice to play through loudspeakers. Given the way the keyboard is placed in our living room, however, the main speakers of our hifi system are to one side of the keyboard and hence do not project well when you're sat at the keyboard. For this reason, I had been using a pair of JBL Control One monitors, installed on stands on either side of the keyboard. I was never a fan of the sound of these little speakers, however---they sounded muddy: the bass is boomy rather than crisp, and the treble lacks clarity.

I wanted to try and construct something better, as a recent turntable repair project had got me seriously interested in audio. One day when visiting our local scrapyard/recycling centre I found a pair of old but cosmetically nice Sony SS-CEH10 speakers, paying 6 € for the pair. They seemed to be roughly the size of the JBL Control Ones, so I figured they'd be a potential replacement if I just installed some nice drivers in the cabinets.

At home, I took the Sonys (Sonies?) apart and discovered that they are nothing but a single 2.5" full-range woofer in a ported (bass reflex) cabinet. Apparently they were originally incorporated in the Sony CMT-EH10, an inexpensive mini "hifi" unit. I decided to convert the speakers into a two-way design, with a proper bass-mid woofer and a tweeter for the high frequencies.

At this point, I knew absolutely nothing about loudspeaker design and construction, and had never attempted it before. I figured some study was in order. I was lucky to get David B. Weems's *Designing, building, and testing your own speaker system* (4th edition, McGraw-Hill, 1997) off of eBay for a reasonable price. Although this book is not exactly beginner-friendly, I was able to supplement it with information gathered from other places (chiefly on the web), to arrive at a basic understanding of the operation of loudspeaker drivers, Thiele/Small parameters, crossover networks and cabinet construction.


## Choosing the drivers

The Sonies have an internal cabinet volume of roughly 2.8 liters each. The first task was to find a woofer that would work well in a box this size. Initially, I thought of going for a sealed cabinet design, as every resource I read considered this to be easier for a beginner compared to a ported box design. However, I was worried the resulting speakers would not deliver enough bass extension in such a configuration, and in the end decided to go with a ported (bass reflex) design. In a ported box, an opening (the port) is used to tune the speaker enclosure to the speaker driver's free air resonance, thereby boosting the bass response.

After much consideration of various candidate drivers, I landed on the DaytonAudio TCP115-8 for the woofer. This is a 4"-diameter driver with a treated paper cone designed with ported enclosures in mind. It handles 40/80 W of power (RMS/max) and has a nominal impedance of 8 Ω. (The latter was an important consideration; since I thought I might on occasion want to play through the monitors and my main speakers simultaneously, both speaker pairs would have to have an impedance of at least 8 Ω so as not to cause distress to the amplifier.) The driver has the following Thiele/Small parameters:

- free air resonance (Fs): 59.2 Hz
- total Q (Qts): 0.43
- compliance equivalent volume (Vas): 2.52 l

Plugging these values into the formulae suggested in Weems's book for a basic Thiele ported-box design resulted in an ideal enclosure volume of 3.5 liters, somewhat more than I had at my disposal. However, Weems's book has a section on a boombox design, with somewhat different specifications. Those specifications indicated an ideal volume of about 2.3 l for the DaytonAudio woofer, so I was satisfied the driver would indeed likely work well enough in the enclosure volume provided by the Sony cabinets.

For the tweeter, I needed something with a relatively small frontal footprint, given the space constraints. I landed on the HiVi T20-8, which is a 3/4" domed tweeter with a power handling of 15 W RMS into 8 Ω and a resonant frequency of 2000 Hz.


## The crossover

In a loudspeaker with more than one driver, a crossover circuit filters the signal frequencies so that the various drivers receive frequency ranges they are compatible with; in a basic two-way design, the woofer receives the low frequencies (through a low-pass filter) and the tweeter receives the high frequencies (through a high-pass filter). I decided to go for a second-order crossover network, meaning that the power reduction after the crossover point is 12 dB per octave. I was hoping to cross over at around 4000 Hz, as the woofer's frequency response becomes less flat from there on, on the one hand, and because of the general recommendation not to cross tweeters over at frequencies less than twice their resonant frequency, on the other. Again consulting the relevant tables in Weems's book, I found that using 3.3 μF capacitors would give a Butterworth-type second-order crossover at about 4200 Hz. Since components of this capacitance are easy to find (and since affordable components come with relatively high tolerances anyway), I decided to go for a nominally 4200 Hz crossover.

To finish the crossover circuit, the capacitors must be paired with inductors (choke coils) of a suitable inductance. The tables in Weems's book specified an inductance of 0.42 mH for my crossover. The book also gives instructions for winding one's own air-core coils using magnet wire and a coil frame, so I decided to give this a try. The tables indicated a wire length of 11.9 meters for each coil, assuming a wire diameter of 0.65 mm and a coil frame with the following dimensions: 19 mm (spool diameter), 9.5 mm (coil thickness). I put together a makeshift coil frame and used a variable-speed electric drill to slowly wind the magnet wire onto the frame. When wound, the coil was then removed from the frame and taped over. This proved to be a very finicky job---the magnet wire very easily gets tangled, and as I was not very careful with the first couple of coils, I ended up spending a long time unknotting 12 meters of wire... not fun.

In addition to the crossover, the circuit that connects the drivers to the amplified source needed to include an attenuator for the tweeter in my case---this is because the HiVi tweeter has a stated sensitivity of 89 dB @ 2.83V/1m, whereas the sensitivity of the DaytonAudio woofer is much lower at 81.9 dB. I thus wanted to turn the tweeter down by about 7 dB. This is normally done with an L-pad, a combination of a series and a parallel resistor. Using an online calculator, I determined that a roughly 7 dB decrease would be achieved in this case by using a 3.9 Ω series resistor combined with a 5.5 Ω parallel resistor. Since I could not find a component with the latter resistance, I had to use two resistors wired in series for the parallel part of the L-pad, one 3.3 Ω, the other 2.2 Ω. These resistors cannot be any old resistors---they need to be able to withstand potentially relatively high power loads. To stay on the safe side, I went with wirewound resistors rated for 9 W. These were still relatively inexpensive at around 0.5€ per resistor, as well as small enough not to cause problems when arranging the components physically inside the speaker cabinet. The crossover and L-pad network was physically implemented on a stripboard and placed inside the speaker cabinet.

I had also considered wiring an impedance equalizer circuit (a "Zobel network") in parallel with the woofer, as the datasheet from DaytonAudio shows a prominent increase in impedance for this woofer beginning at around 500 Hz. I constructed the equalizer circuit, which consists of resistors and capacitors, on a solderless breadboard and connected it to the rest of the circuit. However, in subjective listening tests, the sound quality in fact went down with the addition of the impedance equalizer. For this reason, and also to save space inside the small enclosures, I decided to leave it out.


## The cabinet

I could have mounted the drivers on the original baffle of the Sony speaker, and reused the cloth grille. However, I wanted the drivers to be visually more prominent and decided to redesign the baffle. I bought a scrap piece of birch plywood and cut it to size using a small jigsaw; this jigsaw was also used to cut the holes for the drivers. As for driver placement in the baffle, I had seen varying opinions: some people said they should be centrally aligned, some (such as Weems) said they should be offset to one side but in line with each other, and yet others recommended offsetting the drivers also in relation to each other. At this point of the project, I still had not decided whether the port should go on the front or at the back, and hence wanted to leave enough space on the baffle in case the port should end up there. The woofer was set off from the middle line so that its distance to each of the four relevant faces of the enclosure would be different, and the tweeter was displaced even a bit further to the side (to allow space for that potential frontal port).

This part of the construction can be a lot of fun if one is into woodworking; it is not my forté, however. A jigsaw of some kind is necessary, and a small rotary tool with various sanding bits helps tremendously.

To finish the baffle, I used a wood finish which in this part of the world is called "Innenlasur"; I am unsure how this ought to be translated, and indeed unsure of what it is exactly, apart from knowing that it is relatively non-toxic. I applied two layers after sanding.

In the end, I decided to place the port in the back. This was due to two considerations: first, I was worried that the small port diameter (I was going to use PVC pipe of 2.5 cm diameter) might give rise to unwanted aerodynamic effects, which would be more audible if the port was front-facing; and secondly, it would be easier to secure the pipe to the cabinet if it was installed in the back.

To implement the port, I needed an estimate of how long the pipe ought to be in order to tune the box to the desired frequency (about 60 Hz). I had calculated the enclosure internal volume to be about 2.8 liters, and estimated that the woofer would take up about 0.25 liters, while the crossover and L-pad circuit would take up about 0.08 liters and the port another 0.08 liters. This left an effective internal volume of 2.4 liters. Using an online calculator, this suggested that a 2.5 cm diameter cylindrical port would need a length of roughly 16 cm to tune the enclosure to 60 Hz.

There was no way to fit a straight port this long in the box (unless it was placed in the vertical direction, opening either at the top or at the bottom, but I did not want this). Hence, I decided to use a bent piece of PVC pipe in the shape of a rounded L. Very fortunately, this piece had exactly the right length (through the middle), so no cutting or extending was necessary. I attached the pipe to the side wall with a screw, and to the port opening with hot glue. The gap between the opening and the pipe was then filled with wood putty and sanded.

Finally, I added simple screw-type binding posts for the speaker wire, loosely filled the cabinet with polyester damping material, and put the speakers together.


## Evaluation

How do the completed speakers sound? Very nice, and much better than the JBL Control Ones they replaced (though I realize I am hardly an impartial observer here). The bass is crisp and punchy, the treble very clear. They have easily enough output to fill our living room when connected to a suitable amplifier (even if the original use case was as a near-field monitor). All in all, I am very happy with the end result, and somewhat surprised that everything worked as well as it did.

This was a fun project that I would wholeheartedly recommend to anyone interested in audio and electronics. See below for a listing of the parts and tools used.


## Specifications of the finished loudspeakers

- nominal power handling: 40 W RMS
- nominal impedance: 8 Ω
- dimensions: 24 cm x 15 cm x 13 cm
- weight: 1.9 kg (per box)


## Parts and costs

| Item            | Unit price    | Total    |
|:----------------|--------------:|---------:|
| Old speakers (2)| 3 €           | 6 €      |
| Scrap plywood   | 4 €           | 4 €      |
| PVC pipe (2)    | 3 €           | 6 €      |
| Resistors (6)   | ~0.5€         | 3 €      |
| Capacitors (4)  | ~1 €          | 4 €      |
| Magnet wire (~50 m) | 10 €         | 10 €    |
| Stripboard (2)  | 2 €           | 4 €      |
| Woofer (2)      | 17 €          | 34 €     |
| Tweeter (2)     | 10 €          | 20 €     |
| Binding post (2)| 3 €           | 6 €      |
| Damping material| 5 €           | 5 €      |
| ---             |               |          |
| Grand total     |               | 102 €    |

Not included in above table: screws, wood finish, wood putty, sanding paper, electrical wire, solder and flux, cable ties, glue, electrical tape, Weems's book (or equivalent information!)


## Tools needed

- screwdrivers
- drill
- small jigsaw, e.g. Proxxon Micromot
- small hacksaw
- sanding block
- files
- hobby knife
- small rotary tool with sanding and drill bits, e.g. Proxxon Micromot
- vise
- hot glue gun and glue sticks
- soldering iron
- paintbrush
- PPE (safety goggles, FFP2 masks)


## Gallery

![Alternate Text](DSCF5148.jpg "The starting point: cheap speakers from an old 'hifi' combo.")

![Alternate Text](DSCF5139.jpg "The original full-range driver.")

![Alternate Text](DSCF5156.jpg "Cabinet with driver removed.")

![Alternate Text](DSCF5160.jpg "Invasive surgery of cabinet.")

![Alternate Text](DSCF5192.jpg "The port, a bent 16-cm long piece of PVC tubing, installed.")

![Alternate Text](DSCF5198.jpg "Designing the baffle.")

![Alternate Text](DSCF5204.jpg "More of the same.")

![Alternate Text](DSCF5208.jpg "It's starting to take shape.")

![Alternate Text](DSCF5216.jpg "The baffles were treated with 'Innenlasur'.")
