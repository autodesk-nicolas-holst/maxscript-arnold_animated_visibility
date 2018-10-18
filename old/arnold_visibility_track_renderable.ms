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

  -- set thin walled
  i.material.thin_walled=true
  i.material.internal_reflections = off
	 
	 
  -- check if there is an arnold properties modifier already
  j=-1
  for k in i.modifiers do
  (
   if (classof k) == ArnoldGeometryPropertiesModifier then
   (
     j=k
     k.enable_general_options=true
     k.opaque=false
     break
   )
  )
  if j==-1 then
  (
   --format "adding arnold properties modifier\n"
   -- if not add one
   u=ArnoldGeometryPropertiesModifier()
   addmodifier i u
   -- and uncheck opaque (that gets rid of shadows)
   u.enable_general_options=true
   u.opaque=false
  )
  
  -- use the same controller as the visibility track but ...
  u=copy t
  
  -- as visibility and transmission are opposites, invert the value of all the keys
  j=numkeys u
  -- loop through all keys
  for k = 1 to j do 
  (
   --s=getkey u k
   --format "mat - before %\n" s.value
   -- get the key so that we can use its .time and .value properties
   s=getkey t k
   --format "vis - before %\n" s.value

   -- need to have animate on to set the keys as expected	
   animate on
   (
    -- at the given time	   
    at time s.time 
    (
     -- set the key to 1 minus its value
     --setControllerValue u (1-s.value) true #absolute
     i.material.opacity=color (255*(s.value)) (255*(s.value)) (255*(s.value))
    )
    --s=getkey u k
    --format "after %\n" s.value
   )
  )
  -- commit all the changes we've made to the controller in one go
  --CommitControllerValue u
  
  -- assign the modified controller as the controller for the transmission property of the material we assigned to the object earlier
  --i.material.transmission.controller=u
  
  --i.material.opacity_color.controller=u
  
 )
)

-- print info
format "% of % objects in this scene have a visibilty controller\n" msg1.count objects.count

for i in msg1 do
(
 format "found visibility controller on %\n" i
)
