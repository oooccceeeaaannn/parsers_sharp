table.insert(objlistdata.alltags, "orbits")

table.insert(editor_objlist_order, "text_orbit")

editor_objlist["text_orbit"] = 
{
	name = "text_orbit",
	sprite_in_root = false,
	unittype = "text",
	tags = {""},
	tiling = -1,
	type = 0,
	layer = 20,
	colour = {0, 1},
	colour_active = {0, 2},
}

add_glyph_using_text("orbit")

table.insert(editor_objlist_order, "text_chart")

editor_objlist["text_chart"] = 
{
	name = "text_chart",
	sprite_in_root = false,
	unittype = "text",
	tags = {""},
	tiling = -1,
	type = 1,
	layer = 20,
	colour = {0, 1},
	colour_active = {0, 3},
	argtype = {0, 2},
}

table.insert(editor_objlist_order, "text_center")

editor_objlist["text_center"] = 
{
	name = "text_center",
	sprite_in_root = false,
	unittype = "text",
	tags = {""},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {3, 0},
	colour_active = {3, 1},
}

--[[
table.insert(editor_objlist_order, "text_refers")

editor_objlist["text_refers"] = 
{
	name = "text_refers",
	sprite_in_root = false,
	unittype = "text",
	tags = {""},
	tiling = -1,
	type = 7,
	layer = 20,
	colour = {0, 1},
	colour_active = {0, 3},
	argtype = {0, 2},
}
--]]


table.insert(nlist.full, "orbit")
table.insert(nlist.short, "orbit")
table.insert(nlist.objects, "orbit")

orbit_types = {}
orbit_argtypes = {}

function addorbit(name,type,col,acol,argtype,tiling)
	local orbitname = "orbit_"..name

   	orbit_types[orbitname] = type
   	orbit_argtypes[orbitname] = argtype

	table.insert(editor_objlist_order, orbitname)

	editor_objlist[orbitname] = 
	{
		name = orbitname,
		sprite_in_root = false,
		unittype = "orbit",
		tags = {"orbits"},
		tiling = tiling,
		type = 0,
		layer = 20,
		colour = col,
		colour_active = acol,
	}
end

addorbit("orbit",0,{0,1},{0,2},{},-1)
addorbit("text",0,{4,0},{4,1},{},-1)

addorbit("baba",0,{4,0},{4,1},{},-1)
addorbit("flag",0,{6,1},{2,4},{},-1)
addorbit("wall",0,{1,1},{0,1},{},-1)
addorbit("rock",0,{6,0},{6,1},{},-1)
addorbit("grass",0,{5,1},{5,3},{},-1)
addorbit("tile",0,{1,1},{0,1},{},-1)
addorbit("skull",0,{2,0},{2,1},{},-1)
addorbit("water",0,{1,2},{1,3},{},-1)
addorbit("lava",0,{2,2},{2,3},{},-1)
addorbit("belt",0,{1,2},{1,3},{},-1)
addorbit("rubble",0,{6,0},{6,1},{},-1)
addorbit("dust",0,{6,2},{2,4},{},-1)
addorbit("brick",0,{6,0},{6,1},{},-1)
addorbit("keke",0,{2,1},{2,2},{},-1)

addorbit("is",1,{0,1},{0,3},{0,2},-1)
addorbit("has",1,{0,1},{0,3},{0},-1)
addorbit("chart",1,{0,1},{0,3},{0,2},-1)

addorbit("you",2,{4,0},{4,1},{},-1)
addorbit("win",2,{6,1},{2,4},{},-1)
addorbit("stop",2,{5,0},{5,1},{},-1)
addorbit("push",2,{6,0},{6,1},{},-1)
addorbit("sink",2,{1,2},{1,3},{},-1)
addorbit("open",2,{6,1},{2,4},{},-1)
addorbit("shut",2,{2,1},{2,2},{},-1)
addorbit("hot",2,{2,2},{2,3},{},-1)
addorbit("melt",2,{1,2},{1,3},{},-1)
addorbit("defeat",2,{2,0},{2,1},{},-1)
addorbit("shift",2,{1,2},{1,3},{},-1)
addorbit("tele",2,{1,2},{1,4},{},-1)
addorbit("float",2,{1,2},{1,4},{},-1)
addorbit("still",2,{2,1},{2,2},{},-1)
addorbit("red",2,{2,1},{2,2},{},-1)
addorbit("blue",2,{3,2},{3,3},{},-1)
addorbit("center",2,{3,0},{3,1},{},-1)

addorbit("cond",-1,{0,1},{0,2},{},-1)
--addorbit("filler",-1,{0,1},{0,2},{},-1)

addorbit("lonely",3,{2,1},{2,2},{-1},-1)

addorbit("on",3,{0,1},{0,3},{0},-1)
addorbit("near",3,{0,1},{0,3},{0},-1)
addorbit("refers",3,{0,1},{0,3},{0,2},-1)

formatobjlist()
