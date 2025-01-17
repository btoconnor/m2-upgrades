This documents describes an LED case light upgrade to the Makergear
M2.

In order to have better visibility of the printed part during
printing, I added LEDs to the top of the M2 frame.  The LEDs are
underneath the X axis aluminum plate and shine down towards the print
area.

I designed an [LED holder](m2-led-holder.stl).  It is printed in white
ABS with 0.200mm layer height.  (The white ABS helps diffuse the
light.)  The holder is screwed to the frame using the two existing M4
screws that secure the top aluminum plate to the steel frame.

For the LEDs, I purchased a "24V white LED strip without power supply"
($9 for 5 meters / 300 LEDs from Amazon).  I cut five 200mm sections
from the strip and then soldered wires to them.  I soldered those five
pairs of wires into one pair of wires and then connected that to the
"E1 mosfet" on the electronics.

2022 Update: The center of the case light holder was sagging when
printing large amounts of ABS with the printer enclosed.  A support
bump-out was added to attach to a M2.5 screw on the X-Axis linear rail
for extra support to prevent the sagging.
