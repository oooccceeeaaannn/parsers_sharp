table.insert(nlist.full, "event")
table.insert(nlist.short, "event")
table.insert(nlist.objects, "event")


table.insert(editor_objlist_order, "glyph_event")
table.insert(editor_objlist_order, "glyph_metaevent")
table.insert(editor_objlist_order, "text_metaevent")
table.insert(editor_objlist_order, "node_event")
table.insert(editor_objlist_order, "glyph_node")
table.insert(editor_objlist_order, "glyph_metanode")
table.insert(editor_objlist_order, "text_metanode")
table.insert(editor_objlist_order, "glyph_metalogic")
table.insert(editor_objlist_order, "text_metalogic")
table.insert(editor_objlist_order, "glyph_metaorbit")
table.insert(editor_objlist_order, "text_metaorbit")
table.insert(editor_objlist_order, "event_node")
table.insert(editor_objlist_order, "node_glyph")
table.insert(editor_objlist_order, "node_logic")
table.insert(editor_objlist_order, "node_orbit")
table.insert(editor_objlist_order, "event_logic")
table.insert(editor_objlist_order, "event_orbit")
table.insert(editor_objlist_order, "text_metanot")
table.insert(editor_objlist_order, "glyph_metanot")
table.insert(editor_objlist_order, "text_refers")
table.insert(editor_objlist_order, "glyph_refers")
table.insert(editor_objlist_order, "event_refers")
table.insert(editor_objlist_order, "node_refers")
table.insert(editor_objlist_order, "text__NONE_")
table.insert(objlistdata.alltags, "glyphs")
table.insert(objlistdata.alltags, "events")
table.insert(objlistdata.alltags, "node")



editor_objlist["glyph_event"] =
{
	name = "glyph_event",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {5, 2},
  colour_active = {5, 3},
}

editor_objlist["glyph_metaevent"] =
{
	name = "glyph_metaevent",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {5, 3},
	colour_active = {5, 4},
}
editor_objlist["glyph_metanot"] = 
{
	name = "glyph_metanot",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyphs"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {2, 1},
	colour_active = {2, 2},
}

editor_objlist["text_metanot"] = 
{
	name = "text_metanot",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "abstract"},
	tiling = -1,
	type = -1,
	layer = 20,
	colour = {2, 0},
	colour_active = {2, 1},
}

editor_objlist["text_metanode"] =
{
	name = "text_metanode",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "abstract"},
	tiling = -1,
	type = -1,
	layer = 20,
	colour = {6, 1},
	colour_active = {2, 4},
}

editor_objlist["glyph_metanode"] =
{
	name = "glyph_metanode",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyphs"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {2, 4},
	colour_active = {0, 3},
}

editor_objlist["text_metalogic"] =
{
	name = "text_metalogic",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "abstract"},
	tiling = -1,
	type = -1,
	layer = 20,
	colour = {3, 0},
	colour_active = {3, 1},
}

editor_objlist["glyph_metalogic"] =
{
	name = "glyph_metalogic",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyphs"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {3, 0},
	colour_active = {3, 1},
}

editor_objlist["text_metaorbit"] =
{
	name = "text_metaorbit",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "abstract"},
	tiling = -1,
	type = -1,
	layer = 20,
	colour = {0,1},
	colour_active = {0,2},
}

editor_objlist["glyph_metaorbit"] =
{
	name = "glyph_metaorbit",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyphs"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {0,1},
	colour_active = {0,2},
}

editor_objlist["text_metaevent"] =
{
	name = "text_metaevent",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "abstract"},
	tiling = -1,
	type = -1,
	layer = 20,
	colour = {5, 2},
	colour_active = {5, 3},
}

editor_objlist["event_node"] =
{
	name = "event_node",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text","abstract", "events"},
	tiling = -1,
	type = 0,
	layer = 20,
	colour = {6, 1},
	colour_active = {2, 4},
}

editor_objlist["glyph_node"] = 
{
	name = "glyph_node",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyphs"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {6, 1},
	colour_active = {2, 4},
}


editor_objlist["event_logic"] =
{
	name = "event_logic",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text","abstract", "events"},
	tiling = -1,
	type = 0,
	layer = 20,
	colour = {3, 0},
	colour_active = {3, 1},
}

editor_objlist["event_orbit"] =
{
	name = "event_orbit",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text","abstract", "events"},
	tiling = -1,
	type = 0,
	layer = 20,
	colour = {0,1},
	colour_active = {0,2},
}

editor_objlist["text_refers"] = 
{
	name = "text_refers",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text","abstract"},
	tiling = -1,
	type = 7,
	layer = 1,
	colour = {0, 1},
	colour_active = {0, 3},
	argtype = {0,2,-1}
}

editor_objlist["glyph_refers"] = 
{
	name = "glyph_refers",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyphs"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {0, 1},
	colour_active = {0, 3},
}

editor_objlist["event_refers"] =
{
	name = "event_refers",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text","abstract", "events"},
	tiling = -1,
	type = 0,
	layer = 20,
	colour = {0, 1},
	colour_active = {0, 3},
}

editor_objlist["text__NONE_"] = 
{
	name = "text__NONE_",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "abstract"},
	tiling = -1,
	type = 0,
	layer = 20,
	colour = {3, 2},
	colour_active = {3, 3},
}

add_node(false, "glyph", 0, {3, 2}, {3, 3})
add_node(false, "event", 0, {5, 2}, {5, 3})
add_node(false, "logic", 0, {3, 0}, {3, 1})
add_node(false, "orbit", 0, {0,1}, {0,2})
add_node(false, "refers", 7, {0, 1}, {0, 3}, {0, 2})

addorbit("glyph",0,{3, 2}, {3, 3},{},-1)
addorbit("event",0,{5, 2}, {5, 3},{},-1)
addorbit("node",0,{6, 1}, {2, 4},{},-1)
addorbit("logic",0,{3, 0}, {3, 1},{},-1)

formatobjlist()