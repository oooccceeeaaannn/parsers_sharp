-- This file adds the TEXT_ prefix and handles parsing.

-- Adds object to editor.
table.insert(editor_objlist_order,"text_text_")
table.insert(editor_objlist_order, "text_glyph_")
table.insert(editor_objlist_order, "text_node_")
editor_objlist["text_text_"] = {
  name = "text_text_",
  sprite_in_root = false,
  sprite = "text_textpre",
  unittype = "text",
  tags = {"text_special","abstract"},
  tiling = -1,
  type = 4,
  layer = 20,
  colour = {4, 0},
  colour_active = {4, 1},
}
editor_objlist["text_glyph_"] =
{
	name = "text_glyph_",
	sprite = "text_glyphpre",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text","abstract", "glyph"},
	tiling = -1,
	type = 4,
	layer = 20,
	colour = {3, 2},
	colour_active = {3, 3},
}
editor_objlist["text_node_"] =
{
    name = "text_node_",
    sprite = "text_nodepre",
    sprite_in_root = false,
    unittype = "text",
    tags = {"text"},
    tiling = -1,
    type = 4,
    layer = 20,
    colour = {6, 1},
    colour_active = {2, 4}
}
table.insert(editor_objlist_order, "text_event_")

editor_objlist["text_event_"] =
{
    name = "text_event_",
    sprite = "text_eventpre",
    sprite_in_root = false,
    unittype = "text",
    tags = {"text","abstract"},
    tiling = -1,
    type = 4,
    layer = 20,
    colour = {5, 2},
    colour_active = {5, 3},
}

table.insert(editor_objlist_order, "text_logic_")

editor_objlist["text_logic_"] =
{
	name = "text_logic_",
	sprite = "text_logicpre",
	sprite_in_root = false,
	unittype = "text",
	tags = {"logics","text", "abstract"},
	tiling = -1,
	type = 4,
	layer = 20,
	colour = {3, 0},
	colour_active = {3, 1},
}

table.insert(editor_objlist_order, "text_orbit_")

editor_objlist["text_orbit_"] =
{
	name = "text_orbit_",
	sprite = "text_orbitpre",
	sprite_in_root = false,
	unittype = "text",
	tags = {"orbits","text", "abstract"},
	tiling = -1,
	type = 4,
	layer = 20,
	colour = {0,1},
	colour_active = {0,2},
}

for _,name in ipairs(special_prefixes) do
  add_glyph_using_text(name)
  glyphtypes[name] = 10
  editor_objlist["glyph_" .. name].colour = editor_objlist["glyph_" .. name].colour_active
end

formatobjlist()


