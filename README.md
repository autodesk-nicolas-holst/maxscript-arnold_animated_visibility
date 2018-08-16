# maxscript-arnold_animated_visibility
An approach for driving animated visibility with the Arnold renderer in 3ds Max

Problem:
The Arnold renderer doesn't take the 3ds Max visibility track into account when rendering: objects are always fully visible

Solution:
A small script that creates a copy of the material (in case there are multiple objects with the same material that don't fade in and out at the same time) and uses a copy of the visibility controller to animate the transmission of the material in order to get the same result.
In order to get the same result (visibility and transmission are inverted) it loops over the keys and inverts their values. This assumes that keys are in the range of 0.0-1.0 .
