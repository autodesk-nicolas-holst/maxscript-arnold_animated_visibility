-- animated visibility track applied to Arnold renders
-- 
-- for all objects that have an animated visibility track (controller present on .visibility)
-- NEW: first check that the material doesn't already use a cutout
-- NEW: but still apply it if there is a colormap in the cutout (so we can run the script multiple times)
-- create a copy of the material so that the material is unique for the object
-- make sure thin walled is ticked
-- make object not opaque
--  use the same controller for the visibility track on the materials transmission 


cnt=0

fn do_a_material i_material visibility_track =
(
	-- only do this if there isn't already a cutout map
	-- but do it if there is a colormap in the cutout slot so we can run the script multiple times
	if (i_material.cutout_map==undefined) or ((classof i_material.cutout_map)==Colormap) then
	(
		mat=copy i_material

		format "Physical %\n" mat.name
		-- need to have a map in the cutout slot, using color map
		o=ColorMap()
		o.solidcolor=color 255 255 255 255
		mat.cutout_map=o
	 
		j=numkeys visibility_track
		-- loop through all keys
		for k = 1 to j do 
		(
			s=getkey visibility_track k
			-- need to have animate on to set the keys as expected	
			animate on
			(
				-- at the given time	   
				at time s.time 
				(
					if s.value==0 then
					(
						mat.cutout_map.solidcolor=color 0 0 0 255
					)
					else
					(
						mat.cutout_map.solidcolor=color 255 255 255 255
					)
				)
			)
		)
		return mat
	)
	else
	(
		format "Skipped replacing material % because it already has a cut out map.\n" i_material.name
		return i_material
	)
)


-- loop through all geometry objects
for i in geometry do
(
	-- check for the presence of a visibity controller
	visibility_track=getviscontroller i
	if visibility_track != undefined then
	(
		format "found visibility controller on %\n" i
		cnt=cnt+1

		if classof i.material==PhysicalMaterial then
		(
			i.material=do_a_material i.material visibility_track
		)
		
		if classof i.material==Blend then
		(
			m=copy i.material
			i.material=m

			format "Blend %\n" i.material.name
			-- do the two sub materials called map1 and map2
			if classof i.material.map1==PhysicalMaterial then
			(
				i.material.map1 = do_a_material i.material.map1 visibility_track
			)

			if classof i.material.map2==PhysicalMaterial then
			(
				i.material.map2 = do_a_material i.material.map2 visibility_track
			)
			format "\n"
		)

		if classof i.material==DoubleSided then
		(
			m=copy i.material
			i.material=m

			format "DoubleSided %\n" i.name
			-- do the two sub materials called material1 and material2

			if classof i.material.material1==PhysicalMaterial then
			(
				i.material.material1 = do_a_material i.material.material1 visibility_track
			)
			if classof i.material.material2==PhysicalMaterial then
			(
				i.material.material2 = do_a_material i.material.material2 visibility_track
			)
			format "\n"
		)

		-- now the whole thing again in case there appear inside a multimaterial
		if classof i.material==MultiMaterial then
		(
			m=copy i.material
			i.material=m

			format "MultiMaterial %\n" i.name
			for h = 1 to i.material.numsubs do
			(
				format "SubMaterial % %\n" h i.material[h]

				if classof i.material.material[h]==PhysicalMaterial then
				(
					i.material.material[h]=do_a_material i.material.material[h] visibility_track
				)
				
				if classof i.material.material[h]==Blend then
				(
					m=copy i.material.material[h]
					i.material.material[h]=m

					format "Blend %\n" i.name
					-- do the two sub materials called map1 and map2
					if classof i.material.material[h].map1==PhysicalMaterial then
					(
						i.material.material[h].map1 = do_a_material i.material.material[h].map1 visibility_track
					)

					if classof i.material.material[h].map2==PhysicalMaterial then
					(
						i.material.material[h].map2 = do_a_material i.material.material[h].map2 visibility_track
					)
					format "\n"
				)
				
				if classof i.material.material[h]==DoubleSided then
				(
					m=copy i.material.material[h]
					i.material.material[h]=m

					format "DoubleSided %\n" i.name
					-- do the two sub materials called material1 and material2

					if classof i.material.material[h].material1==PhysicalMaterial then
					(
						i.material.material[h].material1 = do_a_material i.material.material[h].material1 visibility_track
					)
					if classof i.material.material[h].material2==PhysicalMaterial then
					(
						i.material.material[h].material2 = do_a_material i.material.material[h].material2 visibility_track
					)
					format "\n"
				)
			)
			format "\n"
		)
	)
)

-- print info
format "% of % objects in this scene have a visibilty controller\n" cnt geometry.count
