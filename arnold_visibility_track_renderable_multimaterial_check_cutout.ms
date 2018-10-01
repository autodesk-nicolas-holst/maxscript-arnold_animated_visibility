-- animated visibility track applied to Arnold renders
-- 
-- for all objects that have an animated visibility track (controller present on .visibility)
-- NEW: first check that the material doesn't already use a cutout
-- create a copy of the material so that the material is unique for the object
-- make sure thin walled is ticked
-- make object not opaque
--  use the same controller for the visibility track on the materials transmission 


cnt=0

-- loop through objects
for i in geometry do
(
	-- check for the presence of a visibity controller
	visibility_track=getviscontroller i
	if visibility_track != undefined then
	(
		format "found visibility controller on %\n" i
		cnt=cnt+1

		--moved the following two lines to all the materials
		--m=copy i.material
		--i.material=m

		if classof i.material==PhysicalMaterial then
		(
			if i.material.cutout_map==undefined then
			(
				m=copy i.material
				i.material=m

				format "Physical %\n" i.material.name
				-- need to have a map in the cutout slot, using color map
				o=ColorMap()
				o.solidcolor=color 255 255 255 255
				i.material.cutout_map=o
	 
				-- as visibility and transmission are opposites, invert the value of all the keys
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
			else
			(
				format "Skippded replacing material % because it already has a cut out map.\n" i.material.name
			)
		)
		
		if classof i.material==Blend then
		(
			m=copy i.material
			i.material=m

			format "Blend %\n" i.material.name
			-- do the two sub materials called map1 and map2
			if classof i.material.map1==PhysicalMaterial then
			(
				m=copy i.material.map1
				i.material.map1=m

				if i.material.map1.cutout_map==undefined then
				(
					format "Physical %\n" i.material.map1.name
					-- need to have a map in the cutout slot, using color map
					o=ColorMap()
					o.solidcolor=color 255 255 255 255
					i.material.map1.cutout_map=o
	 
					-- as visibility and transmission are opposites, invert the value of all the keys
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
									i.material.map1.cutout_map.solidcolor=color 0 0 0 255
								)
								else
								(
									i.material.map1.cutout_map.solidcolor=color 255 255 255 255
								)
							)
						)
					)
				)
				else
				(
					format "Skippded replacing material % because it already has a cut out map.\n" i.material.map1.name
				)
			)

			if classof i.material.map2==PhysicalMaterial then
			(
				if i.material.map2.cutout_map==undefined then
				(
					m=copy i.material.map2
					i.material.map2=m
				
					format "Physical %\n" i.material.map2.name
					-- need to have a map in the cutout slot, using color map
					o=ColorMap()
					o.solidcolor=color 255 255 255 255
					i.material.map2.cutout_map=o
	 
					-- as visibility and transmission are opposites, invert the value of all the keys
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
									i.material.map2.cutout_map.solidcolor=color 0 0 0 255
								)
								else
								(
									i.material.map2.cutout_map.solidcolor=color 255 255 255 255
								)
							)
						)
					)
				)
				else
				(
					format "Skippded replacing material % because it already has a cut out map.\n" i.material.map2.name
				)
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
				if i.material.material1.cutout_map==undefined then
				(
					m=copy i.material.material1
					i.material.material1=m
				
					format "Physical %\n" i.material.material1.name
					-- need to have a map in the cutout slot, using color map
					o=ColorMap()
					o.solidcolor=color 255 255 255 255
					i.material.material1.cutout_map=o
	 
					-- as visibility and transmission are opposites, invert the value of all the keys
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
									i.material.material1.cutout_map.solidcolor=color 0 0 0 255
								)
								else
								(
									i.material.material1.cutout_map.solidcolor=color 255 255 255 255
								)
							)
						)
					)
				)
				else
				(
					format "Skippded replacing material % because it already has a cut out map.\n" i.material.material1.name
				)
			)
			if classof i.material.material2==PhysicalMaterial then
			(
				if i.material.material2.cutout_map==undefined then
				(
					m=copy i.material.material2
					i.material.material2=m
				
					format "Physical %\n" i.material.material2.name
					-- need to have a map in the cutout slot, using color map
					o=ColorMap()
					o.solidcolor=color 255 255 255 255
					i.material.material2.cutout_map=o
	 
					-- as visibility and transmission are opposites, invert the value of all the keys
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
									i.material.material2.cutout_map.solidcolor=color 0 0 0 255
								)
								else
								(
									i.material.material2.cutout_map.solidcolor=color 255 255 255 255
								)
							)
						)
					)
				)
				else
				(
					format "Skippded replacing material % because it already has a cut out map.\n" i.material.material2.name
				)
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
					if i.material.material[h].cutout_map==undefined then
					(	
						m=copy i.material.material[h]
						i.material.material[h]=m

						format "Physical %\n" i.material.material[h].name
						-- need to have a map in the cutout slot, using color map
						o=ColorMap()
						o.solidcolor=color 255 255 255 255
						i.material.material[h].cutout_map=o
	 
						-- as visibility and transmission are opposites, invert the value of all the keys
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
										i.material.material[h].cutout_map.solidcolor=color 0 0 0 255
									)
									else
									(
										i.material.material[h].cutout_map.solidcolor=color 255 255 255 255
									)
								)
							)
						)
					)
					else
					(
						format "Skippded replacing material % because it already has a cut out map.\n" i.material.material[h].name
					)
				)

				
				if classof i.material.material[h]==Blend then
				(
					m=copy i.material.material[h]
					i.material.material[h]=m

					format "Blend %\n" i.name
					-- do the two sub materials called map1 and map2
					if classof i.material.material[h].map1==PhysicalMaterial then
					(
						if i.material.material[h].map1.cutout_map==undefined then
						(	
							m=copy i.material.material[h].map1
							i.material.material[h].map1=m

							format "Physical %\n" i.material.material[h].map1.name
							-- need to have a map in the cutout slot, using color map
							o=ColorMap()
							o.solidcolor=color 255 255 255 255
							i.material.material[h].map1.cutout_map=o
	 
							-- as visibility and transmission are opposites, invert the value of all the keys
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
											i.material.material[h].map1.cutout_map.solidcolor=color 0 0 0 255
										)
										else
										(
											i.material.material[h].map1.cutout_map.solidcolor=color 255 255 255 255
										)
									)
								)
							)
						)
						else
						(	
							format "Skippded replacing material % because it already has a cut out map.\n" i.material.material[h].map1.name
						)
					)

					if classof i.material.material[h].map2==PhysicalMaterial then
					(
						if i.material.material[h].map2.cutout_map==undefined then
						(	
							m=copy i.material.material[h].map2
							i.material.material[h].map2=m
					
							format "Physical %\n" i.material.material[h].map2.name
							-- need to have a map in the cutout slot, using color map
							o=ColorMap()
							o.solidcolor=color 255 255 255 255
							i.material.material[h].map2.cutout_map=o
	 
							-- as visibility and transmission are opposites, invert the value of all the keys
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
											i.material.material[h].map2.cutout_map.solidcolor=color 0 0 0 255
										)
										else
										(
											i.material.material[h].map2.cutout_map.solidcolor=color 255 255 255 255
										)
									)
								)
							)
						)
						else
						(	
							format "Skippded replacing material % because it already has a cut out map.\n" i.material.material[h].map2.name
						)
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
						if i.material.material[h].material1.cutout_map==undefined then
						(	
							m=copy i.material.material[h].material1
							i.material.material[h].material1=m
				
							format "Physical %\n" i.material.material[h].material1.name
							-- need to have a map in the cutout slot, using color map
							o=ColorMap()
							o.solidcolor=color 255 255 255 255
							i.material.material[h].material1.cutout_map=o
	 
							-- as visibility and transmission are opposites, invert the value of all the keys
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
											i.material.material[h].material1.cutout_map.solidcolor=color 0 0 0 255
										)
										else
										(
											i.material.material[h].material1.cutout_map.solidcolor=color 255 255 255 255
										)	
									)
								)
							)
						)
						else
						(	
							format "Skippded replacing material % because it already has a cut out map.\n" i.material.material[h].material1.name
						)
					)
					if classof i.material.material[h].material2==PhysicalMaterial then
					(
						if i.material.material[h].material2.cutout_map==undefined then
						(	
							m=copy i.material.material[h].material2
							i.material.material[h].material2=m
				
							format "Physical %\n" i.material.material[h].material2.name
							-- need to have a map in the cutout slot, using color map
							o=ColorMap()
							o.solidcolor=color 255 255 255 255
							i.material.material[h].material2.cutout_map=o
	 
							-- as visibility and transmission are opposites, invert the value of all the keys
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
											i.material.material[h].material2.cutout_map.solidcolor=color 0 0 0 255
										)
										else
										(
											i.material.material[h].material2.cutout_map.solidcolor=color 255 255 255 255
										)
									)
								)
							)
						)
						else
						(	
							format "Skippded replacing material % because it already has a cut out map.\n" i.material.material[h].material2.name
						)
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
