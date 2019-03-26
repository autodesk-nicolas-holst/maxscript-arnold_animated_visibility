-- animated visibility track applied to Arnold renders
-- 
-- for all objects that have an animated visibility track (controller present on .visibility)
-- first check that the material doesn't already use a cutout
-- but still apply it if there is a colormap in the cutout (so we can run the script multiple times)
-- create a copy of the material so that the material is unique for the object
-- make sure thin walled is ticked
-- make object not opaque
--  use the same controller for the visibility track on the materials transmission 

-- refactored the whole thing
-- amd added support for arnold standard surface

-- NEW: fixed a corner case where the first key was set before frame 0 which added another key at frame 0, if this is the case the additional key at frame 0 is removed

-- NEW: additional debug information
-- higher values for debug_print_level mean it will print more info, 0 means it won't print any
-- support for groups and hierarchies


fn debug_format l s=
(
	debug_print_level=5

	if debug_print_level>=l then
	(
		if s.count==1 then
		(
			format s[1]
		)
		if s.count==2 then
		(
			format s[1] s[2]
		)
		if s.count==3 then
		(
			format s[1] s[2] s[3]
		)
	)
)

fn do_a_standard_material i_material visibility_track =
(
	local mat=i_material
	
	debug_format 1 #("standard material is currently not supported\n")
	
	return mat
)

fn do_an_arnold_material i_material i_object visibility_track =
(
	local mat=i_material
	
	-- Arnold surface shader -> use a colormap in the cutout slot
	-- only do this if there isn't already a cutout map
	-- but do it if there is a colormap in the cutout slot so we can run the script multiple times
	-- pretty similar to the physicial material, but we need to add a modifier totell Arnold that the material isn't opaque and instead of cutout it goes to the opacity shader slot
	if (mat.opacity_shader==undefined) or ((classof mat.opacity_shader)==Colormap) then
	(
		debug_format 3 #("Adding Arnold specific material properties to %\n",mat.name)
		-- extra stuff needed for Arnold
		--set thin walled
		mat.thin_walled=true
		mat.internal_reflections = off
	 
		-- check if there is an arnold properties modifier already
		j=-1
		for k in i_object.modifiers do
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
			debug_format 3 #("Adding Arnold properties modifiier to %\n",i_object.name)
			--format "adding arnold properties modifier\n"
			-- if not add one
			u=ArnoldGeometryPropertiesModifier()
			addmodifier i_object u
			-- and uncheck opaque (that gets rid of shadows)
			u.enable_general_options=true
			u.opaque=false
		)
  

  		debug_format 1 #("Arnold standard surface %\n",mat.name)
		-- need to have a map in the cutout slot, using color map
		o=ColorMap()
		o.solidcolor=color 255 255 255 255
		mat.opacity_shader=o
	 
		
		-- for some reason we always end up with a key of frame 0, even if we don't have one on the visibility controller
		-- so we're going to check if it is there
		debug_format 4 #("Creating keys\n")
		local j=numkeys visibility_track
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
					if s.value<=0 then
					(
						mat.opacity_shader.solidcolor=color 0 0 0 255
						debug_format 4 #("At time % visibility value is % , colour value set to 0 0 0\n",s.time,s.value)
					)
					if s.value>=1 then
					(
						mat.opacity_shader.solidcolor=color 255 255 255 255
						debug_format 4 #("At time % visibility value is % , colour value set to 255 255 255\n",s.time,s.value)
					)
				)
			)
		)
		debug_format 4 #("\n")
		-- for some reason we always end up with a key of frame 0, even if we don't have one on the visibility controller
		-- so we're going to check if it is there
		
		-- loop through all keys
		key_at_time_zero=-1
		for k = 1 to j do 
		(
			s=getkey visibility_track k
			if s.time==0 then
			(
				key_at_time_zero=1
			)
		)
		if key_at_time_zero==-1 then
		(
			selectkeys mat.opacity_shader.solidcolor.controller 0
			deletekeys mat.opacity_shader.solidcolor.controller #selection
			debug_format 4 #("Deleted key at time zero\n")
		)
	)
	else
	(
		debug_format 1 #("Skipped replacing material because it already has a cut out map.\n",mat.name)
	)
	return mat
)



fn do_a_physical_material i_material visibility_track =
(
	local mat=i_material
	-- physical material -> use a colormap in the cutout slot
	-- only do this if there isn't already a cutout map
	-- but do it if there is a colormap in the cutout slot so we can run the script multiple times
	if (mat.cutout_map==undefined) or ((classof mat.cutout_map)==Colormap) then
	(
		mat=copy i_material

		debug_format 2 #("Physical %\n",mat.name)
		
		-- for some reason we always end up with a key of frame 0, even if we don't have one on the visibility controller
		-- so we're going to check if it is there
		debug_format 4 #("Creating keys\n")
		-- need to have a map in the cutout slot, using color map
		o=ColorMap()
		o.solidcolor=color 255 255 255 255
		mat.cutout_map=o
	 
		local j=numkeys visibility_track
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
					if s.value<=0 then
					(
						mat.cutout_map.solidcolor=color 0 0 0 255
						debug_format 4 #("At time % visibility value is % , colour value set to 0 0 0\n",s.time,s.value)
					)
					if s.value>=1 then
					(
						mat.cutout_map.solidcolor=color 255 255 255 255
						debug_format 4 #("At time % visibility value is % , colour value set to 255 255 255\n",s.time,s.value)
					)
				)
			)
		)
		
		debug_format 4 #("\n")
		-- for some reason we always end up with a key of frame 0, even if we don't have one on the visibility controller
		-- so we're going to check if it is there
		
		-- loop through all keys
		key_at_time_zero=-1
		for k = 1 to j do 
		(
			s=getkey visibility_track k
			if s.time==0 then
			(
				key_at_time_zero=-1
			)
		)
		if key_at_time_zero==1 then
		(
			selectkeys mat.cutout_map.solidcolor.controller 0
			deletekeys mat.cutout_map.solidcolor.controller #selection
			debug_format 4 #("Deleted key at time zero\n")
		)
		
	)
	else
	(
		debug_format 1 #("Skipped replacing material because it already has a cut out map.\n",mat.name)
	)
	return mat
)


fn do_a_material i_material i_object visibility_track =
(
	local mat=i_material -- this is set in case the material isn't one we handle,, otherwise we'd set it to undefined...
	
	if classof mat==StandardMaterial then
	(
		mat=do_a_standard_material mat visibility_track
	)
	if classof mat==ai_standard_surface then
	(
		mat=do_an_arnold_material mat i_object visibility_track
	)

	-- physical material -> use a colormap in the cutout slot
	if classof mat==PhysicalMaterial then
	(
		mat=do_a_physical_material mat visibility_track
	)
	
	return mat
)


fn handle_a_material_type i_material i_object visibility_track =
(
	local mat
	mat=undefined
	
	-- materials that have sub materials
	if mat==undefined and classof i_material==Blend then
	(
		mat=copy i_material
		
		debug_format 2 #("Blend %\n",mat.name)
		-- do the two sub materials called map1 and map2
		mat.map1 = handle_a_material_type mat.map1 i_object visibility_track
		mat.map2 = handle_a_material_type mat.map2 i_object visibility_track

		debug_format 2 #("\n")
	)

	if mat==undefined and classof i_material==DoubleSided then
	(
		mat=copy i_material
		
		debug_format 2 #("DoubleSided %\n",mat.name)
		-- do the two sub materials called material1 and material2
		mat.material1 = handle_a_material_type mat.material1 i_object visibility_track
		mat.material2 = handle_a_material_type mat.material2 i_object visibility_track

		debug_format 2 #("\n")
	)

	-- now the whole thing again in case there appear inside a multimaterial
	if mat==undefined and classof i_material==MultiMaterial then
	(
		mat=copy i_material
		
		debug_format 2 #("MultiMaterial %\n",mat.name) 
		for h = 1 to mat.numsubs do
		(
			debug_format 2 #("SubMaterial % %\n",h,mat[h])

			mat.material[h]=handle_a_material_type mat.material[h] i_object visibility_track
		)
		debug_format 2 #("\n")
	)

	-- main material, if this doesn't match the supported material types it just gives us the same material back
	if mat==undefined then
	(
		mat=do_a_material i_material i_object visibility_track
	)
	
	return mat
)


fn find_visibility_track_with_keys o =
(
	-- returns the visibility track that should be used

	-- start by checking if the object has a visibility track
	local v=getviscontroller o 

	-- ignore if there are no keys on the controller
	if (numkeys v)==0 then
	(
		v=undefined
	)
	
	-- same logic for groups and for hierarchies as groups are a special form of hierarchy
	if v== undefined then
	(
		-- also check if this object is part of a group which has a visibility track 
		if o.parent!=undefined then
		(
			debug_format 5 #("object is part of a group or hierarchy, getting the parent's visibility track %\n",o.parent.name)
			v=find_visibility_track_with_keys o.parent
		)
	)
	
	return v
)


fn do_apply_arnold_visibility =
(
	-- first ensure that the legacy map support is set
	if 	(renderers.current as string)=="Arnold:Arnold" then
	(
		 renderers.current.legacy_3ds_max_map_support=True
	)
	
	
	local cnt=0
	-- loop through all geometry objects
	for i in geometry do
	(
		-- check for the presence of a visibity controller
		local visibility_track=find_visibility_track_with_keys i
		
		-- only if there is a visibility track ....
		if visibility_track != undefined then
		(

			debug_format 2 #("found visibility controller on %\n",i)
			cnt=cnt+1

			i.material=handle_a_material_type i.material i visibility_track
		)
	)



	-- print info
	debug_format 1  #("% of % objects in this scene have a visibilty controller\n",cnt,geometry.count)
	
	return ""
)

do_apply_arnold_visibility()