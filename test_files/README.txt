This folder contains the files used to valide the script works as expected
3ds Max files:
- arnold_visibility_before.max
- arnold_visibility_after.max  (same as before but after running the v4 script)
Two boxes, the one on the left with an Arnold Standard Surface (Box001) and one with a Physical Material (Box002)

Screenshots of the trackview showing the visibily curve for the two boxes:
- visibility_box001.png
- visibility_box002.png

Rendered images of different frames on the adter scene file:
- after-frame-11.png (the one of the left fully visible, the one on the right is partially transparent)
- after-frame-21.png (both partially visible, the one on the left is more transparent)
- after-frame-31.png (both visible)

Output of the script:
debug_format()
do_a_standard_material()
do_an_arnold_material()
do_a_physical_material()
do_a_material()
handle_a_material_type()
do_apply_arnold_visibility()
found visibility controller on $Box:Box001 @ [0.903705,-7.356001,0.000000]
Adding Arnold specific material properties to 01 - Default
Adding Arnold properties modifiier to Box001
Arnold standard surface 01 - Default
Creating keys
At time -2f visibility value is 0.0 , colour value set to 0 0 0
At time 12f visibility value is 1.0 , colour value set to 255 255 255
At time 23f visibility value is 0.0 , colour value set to 0 0 0
At time 29f visibility value is 1.0 , colour value set to 255 255 255

Deleted key at time zero
found visibility controller on $Box:Box002 @ [73.917725,-62.443520,0.000000]
Physical 02 - Default
Creating keys
At time 2f visibility value is 1.0 , colour value set to 255 255 255
At time 16f visibility value is 0.0 , colour value set to 0 0 0
At time 29f visibility value is 1.0 , colour value set to 255 255 255

Deleted key at time zero
2 of 2 objects in this scene have a visibilty controller
""
