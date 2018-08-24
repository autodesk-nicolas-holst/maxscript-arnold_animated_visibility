-- animated visibility track applied to Arnold renders
-- 
-- for all objects that have an animated visibility track (controller present on .visibility)
-- create a copy of the material so that the material is unique for the object
-- make sure thin walled is ticked
-- make object not opaque
--  use the same controller for the visibility track on the materials transmission 


msg1=array()

-- loop through objects
for i in objects do
(
 -- check for the presence of a visibity controller
 t=getviscontroller i
 if t!=undefined then
 (
  format "%\n" i.name
  append msg1 i.name

  -- copy material in case multiple objects use the same material but fade in and out at different times 
  m=copy i.material
  i.material=m  

  -- need to have a map in the cutout slot, using colour selection OSL map
  o=OSLMap()
  o.OSLPath ="c:/program files/autodesk/3ds max 2019/osl/Color1of5.osl"
  o.I0=color 0 0 0 255
  o.I1=color 255 255 255 255
  i.material.cutout_map=o
	 
  -- as visibility and transmission are opposites, invert the value of all the keys
  j=numkeys t
  -- loop through all keys
  for k = 1 to j do 
  (
   s=getkey t k
   -- need to have animate on to set the keys as expected	
   animate on
   (
    -- at the given time	   
    at time s.time 
    (
     i.material.cutout_map.index=s.value
    )
   )
  )
 )
)

-- print info
format "% of % objects in this scene have a visibilty controller\n" msg1.count objects.count

for i in msg1 do
(
 format "found visibility controller on %\n" i
)