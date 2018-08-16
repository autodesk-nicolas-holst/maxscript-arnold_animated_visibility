-- animated visibility track applied to Arnold renders
-- 
-- for all objects that have an animated visibility track (controller present on .visibility)
-- create a copy of the material so that the material is unique for the object
-- if required make it an Arnold Standard Surface material
-- make sure thin walled is ticked
-- make object not opaque
-- use the same controller for the visibility track on the materials transmission 
-- 
-- future options: support other materials

-- loop through objects
for i in objects do
(
 -- check for the presence of a visibity controller
 t=getviscontroller i
 if t!=undefined then
 (
  format "found visibility controller on %\n" i.name
  -- copy material
  m=copy i.material
  i.material=m  

  -- set thin walled
  i.material.thin_walled=true

  -- use the same controller as the visibility track but ...
  u=copy t
  -- invert all the keys
  j=numkeys u
  for k = 1 to j do 
  (
   --s=getkey u k
   --format "mat - before %\n" s.value
   s=getkey t k
   --format "vis - before %\n" s.value
	
   animate on
   (	   
   at time s.time 
   (
	setControllerValue u (1-s.value) true #absolute
	CommitControllerValue u
   )
   --s=getkey u k
   --format "after %\n" s.value
   )
 )

 -- assign it
  i.material.transmission.controller=u
 )
)