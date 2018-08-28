-- animated visibility track applied to Arnold renders
-- 
-- for all objects that have an animated visibility track (controller present on .visibility)
-- create a copy of the material so that the material is unique for the object
-- make sure thin walled is ticked
-- make object not opaque
--  use the same controller for the visibility track on the materials transmission 

fn do_visibility_for_physical_material i t =
(
	-- copy material in case multiple objects use the same material but fade in and out at different times 
	local m=copy i.material
	i.material=m  

	-- need to have a map in the cutout slot, using color map
	local o=ColorMap()
	o.solidcolor=color 255 255 255 255
	i.material.cutout_map=o
	 
	-- as visibility and transmission are opposites, invert the value of all the keys
	local j=numkeys t
	-- loop through all keys
	for k = 1 to j do 
	(
		local s=getkey t k
		-- need to have animate on to set the keys as expected	
		animate on
		(
			-- at the given time	   
			at time s.time 
			(
				if s.value==0 then
				(
					i.material.cutout_map.solidcolor=color 0 0 0 255
				)
				else
				(
					i.material.cutout_map.solidcolor=color 255 255 255 255
				)
			)
		)
	)
)

fn do_visibility_for_physical_sub_material i j t =
(
	-- copy material in case multiple objects use the same material but fade in and out at different times 
	local m=copy i.material.material[j]
	i.material.material[j]=m  

	-- need to have a map in the cutout slot, using color map
	local o=ColorMap()
	o.solidcolor=color 255 255 255 255
	i.material.materiallist[j].cutout_map=o
	 
	-- as visibility and transmission are opposites, invert the value of all the keys
	local j=numkeys t
	-- loop through all keys
	for k = 1 to j do 
	(
		local s=getkey t k
		-- need to have animate on to set the keys as expected	
		animate on
		(
			-- at the given time	   
			at time s.time 
			(
				if s.value==0 then
				(
					--					i.material.materiallist[j].cutout_map.solidcolor=color 0 0 0 255
					o.solidcolor=color 0 0 0 255
				)
				else
				(
					--i.material.materiallist[j].cutout_map.solidcolor=color 255 255 255 255
					o.solidcolor=color 255 255 255 255
				)
			)
		)
	)
)

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

		if classof i.material==PhysicalMaterial then
		(
			do_visibility_for_physical_material i t
		)
		if classof i.material==MultiMaterial then
		(
			-- first create a copy of the multimaterial
			local m=copy i.material
			i.material=m  
			
			-- now loop through the sub materials and apply the 
			for j = 1 to m.numsubs do
			(
				if classof i.material.material[j]==PhysicalMaterial then
				(
					do_visibility_for_physical_sub_material i j t
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