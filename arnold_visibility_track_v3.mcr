macroScript maxVisObj category:"maxVisObj" (

-- animated visibility track applied to Arnold renders
-- 
-- for all objects that have an animated visibility track (controller present on .visibility)
-- NEW: first check that the material doesn't already use a cutout
-- NEW: but still apply it if there is a colormap in the cutout (so we can run the script multiple times)
-- create a copy of the material so that the material is unique for the object
-- make sure thin walled is ticked
-- make object not opaque
--  use the same controller for the visibility track on the materials transmission 

-- refactored the whole thing
-- and added support for arnold standard surface
-- NEW: use Arnold string so this also works as a macroscript which runs before MaxtoA is initialised


global quiet_mode=1

fn do_a_standard_material i_material visibility_track =
(
	local mat=i_material
	
	if quiet_mode!=1 then format "standard material is currently not supported\n"
	return mat
)


fn do_an_arnold_material i_material i_object visibility_track =
(
	local j,k
	local mat=i_material
	
	-- Arnold surface shader -> use a colormap in the cutout slot
	-- only do this if there isn't already a cutout map
	-- but do it if there is a colormap in the cutout slot so we can run the script multiple times
	-- pretty similar to the physicial material, but we need to add a modifier totell Arnold that the material isn't opaque and instead of cutout it goes to the opacity shader slot
	if (mat.opacity_shader==undefined) or ((classof mat.opacity_shader)==Colormap) then
	(
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
			--format "adding arnold properties modifier\n"
			-- if not add one
			local u=ArnoldGeometryPropertiesModifier()
			addmodifier i_object u
			-- and uncheck opaque (that gets rid of shadows)
			u.enable_general_options=true
			u.opaque=false
		)
  

  		if quiet_mode!=1 then format "Arnold standard surface %\n" mat.name
		-- need to have a map in the cutout slot, using color map
		local o=ColorMap()
		o.solidcolor=color 255 255 255 255
		mat.opacity_shader=o
	 
		j=numkeys visibility_track
		-- loop through all keys
		for k = 1 to j do 
		(
			local s=getkey visibility_track k
			-- need to have animate on to set the keys as expected	
			animate on
			(
				-- at the given time	   
				at time s.time 
				(
					if s.value<=0 then
					(
						mat.opacity_shader.solidcolor=color 0 0 0 255
					)
					if s.value>=1 then
					(
						mat.opacity_shader.solidcolor=color 255 255 255 255
					)
				)
			)
		)
	)
	else
	(
		if quiet_mode!=1 then format "Skipped replacing material % because it already has a cut out map.\n" mat.name
	)
	return mat
)



fn do_a_physical_material i_material visibility_track =
(
	local j,k
	local mat=i_material
	-- physical material -> use a colormap in the cutout slot
	-- only do this if there isn't already a cutout map
	-- but do it if there is a colormap in the cutout slot so we can run the script multiple times
	if (mat.cutout_map==undefined) or ((classof mat.cutout_map)==Colormap) then
	(
		mat=copy i_material

		if quiet_mode!=1 then format "Physical %\n" mat.name
		-- need to have a map in the cutout slot, using color map
		local o=ColorMap()
		o.solidcolor=color 255 255 255 255
		mat.cutout_map=o
	 
		j=numkeys visibility_track
		-- loop through all keys
		for k = 1 to j do 
		(
			local s=getkey visibility_track k
			-- need to have animate on to set the keys as expected	
			animate on
			(
				-- at the given time	   
				at time s.time 
				(
					if s.value<=0 then
					(
						mat.cutout_map.solidcolor=color 0 0 0 255
					)
					if s.value>=1 then
					(
						mat.cutout_map.solidcolor=color 255 255 255 255
					)
				)
			)
		)
	)
	else
	(
		if quiet_mode!=1 then format "Skipped replacing material % because it already has a cut out map.\n" mat.name
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
	-- this works if we run the code as a normal script
	--if classof mat==ai_standard_surface then 
	--(
	--	format "doing Arnold standard surface\n"
	--	mat=do_an_arnold_material mat i_object visibility_track
	--)
    -- this works both from a normal script and from within a macroscript (it looks like MactoA hasn't been loaded when the macroscripts get evaluated)
	if ((classof mat) as string)=="ai_standard_surface" then 
	(
		if quiet_mode!=1 then format "doing Arnold standard surface\n"
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
		
		if quiet_mode!=1 then format "Blend %\n" mat.name
		-- do the two sub materials called map1 and map2
		mat.map1 = handle_a_material_type mat.map1 i_object visibility_track
		mat.map2 = handle_a_material_type mat.map2 i_object visibility_track

		if quiet_mode!=1 then format "\n"
	)

	if mat==undefined and classof i_material==DoubleSided then
	(
		mat=copy i_material
		
		if quiet_mode!=1 then format "DoubleSided %\n" mat.name
		-- do the two sub materials called material1 and material2
		mat.material1 = handle_a_material_type mat.material1 i_object visibility_track
		mat.material2 = handle_a_material_type mat.material2 i_object visibility_track

		format "\n"
	)

	-- now the whole thing again in case there appear inside a multimaterial
	if mat==undefined and classof i_material==MultiMaterial then
	(
		mat=copy i_material
		
		if quiet_mode!=1 then format "MultiMaterial %\n" mat.name
		for h = 1 to mat.numsubs do
		(
			if quiet_mode!=1 then format "SubMaterial % %\n" h mat[h]

			mat.material[h]=handle_a_material_type mat.material[h] i_object visibility_track
		)
		if quiet_mode!=1 then format "\n"
	)

	-- main material, if this doesn't match the supported material types it just gives us the same material back
	if mat==undefined then
	(
		mat=do_a_material i_material i_object visibility_track
	)
	
	return mat
)


fn do_apply_arnold_visibility =
(
	local i
	
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
		local visibility_track=getviscontroller i
		if visibility_track != undefined then
		(
			if quiet_mode!=1 then format "found visibility controller on %\n" i
			cnt=cnt+1

			i.material=handle_a_material_type i.material i visibility_track
		)
	)



	-- print info
	format "% of % objects in this scene have a visibilty controller\n" cnt geometry.count
)

do_apply_arnold_visibility()
)