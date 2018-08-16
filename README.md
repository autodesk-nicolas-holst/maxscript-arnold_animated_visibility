# maxscript-arnold_animated_visibility
An approach for driving animated visibility with the Arnold renderer in 3ds Max

Problem:
The Arnold renderer doesn't take the 3ds Max visibility track into account when rendering: objects are always fully visible

Solution:
A small script that creates a copy of the material and uses the visibility controller to animate the transmission of the material in order to get the same result.
One small drawback is that visibility and transmission are inverted so it loops over the keys and inverts them.
