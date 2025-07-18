-- Use the in-game menu now.

table.insert(mod_hook_functions["level_start"], function()
	metatext_fixquirks = get_setting("fix_quirks") --[[Set this to FALSE to:
Make TEXT/META# IS TELE link text units of the same type together rather than all text units included.
(Removed as of v469) Make TEXT IS MORE allow text units to grow into other text units as long as they are not the same type.
Make TEXT/META# IS GROUP, NOUN HAS/MAKE/BECOME GROUP make NOUN HAS/MAKE/BECOME every text included.
Make TEXT/META# IS GROUP, NOUN NEAR GROUP force noun to be near every text included.]]

	metatext_overlaystyle = get_setting("overlay_style", true) --[[Has 3 options:
0 disables this feature.
1 enables overlay if the "meta level" (the amount of times "text_" appears in the name excluding
if the name ends with "text_") does not match the name of the object.
Anything else always enables the overlay.]]

	metatext_textisword = get_setting("text_word") --Makes TEXT IS WORD a default rule, and breaking it will make text not parse.

	metatext_istextnometa = get_setting("is_nometa") --[[Makes METATEXT IS TEXT not turn the text object into it's metatext
counterpart, instead making it not transform.
Not recommended to set to TRUE if you are not using the Meta/Unmeta addon.]]

	metatext_hasmaketextnometa = get_setting("hasmake_nometa") --[[Makes METATEXT HAS/MAKE TEXT not make the text object have/make
it's metatext counterpart. Since you can't make Has/Make Meta/Unmeta, this is really only useful for
consistency I guess.]]

	metatext_autogenerate = get_setting("auto_gen", true) --[[Tries to add more metatext to the object palette if it does not exist.
Can only add up to 35 additional objects. REQUIRES metaunmeta.lua.
Comes with the following options:
0 disables this feature.
1 tries to use the correct sprite, if it exists. Otherwise, it uses the default.
2 is like 1, but if the sprite doesn't exist, it won't generate.
Anything else always uses the default sprite. If you choose this, you're gonna want the overlay on.
Note that if the nonexistant text is available in the editor object list, that will be referenced instead.]]

	metatext_includenoun = get_setting("include_noun") --Includes nouns in NOT META#.
end
)

-- New function, checks if rule relies on certain noun. Based off of hasfeature()
function checkiftextrule(rule1, rule2, rule3, unitid, findtextrule_, findtag_)
	local findtag = "text"
	local findtextrule = false
	if findtextrule_ ~= nil then
		findtextrule = findtextrule_
	end
	if findtag_ ~= nil then
		findtag = findtag_
	end
	if (featureindex[rule3] ~= nil) and (rule2 ~= nil) and (rule1 ~= nil) then
		for i, rules in ipairs(featureindex[rule3]) do
			local rule = rules[1]
			local conds = rules[2]
			local tags = rules[4]
			local foundtag = false
			for num, tag in pairs(tags) do
				if tag == findtag then
					foundtag = true
					break
				end
			end

			if (conds[1] ~= "never") and (foundtag == findtextrule) then
				if (rule[1] == rule1) and (rule[2] == rule2) and (rule[3] == rule3) then
					if testcond(conds, unitid) then
						return findtextrule
					end
				end
			end
		end
	end
	return (not findtextrule)
end

-- New function that writes the meta level of an object in the top right corner, if enabled.
function writemetalevel()
	if metatext_overlaystyle ~= 0 and not (generaldata.values[MODE] == 5) then
		MF_letterclear("metaoverlay")
		for id, unit in pairs(units) do
			local unitname = unit.strings[UNITNAME]

			local metalevel = getmetalevel(unitname)

			if metalevel >= 0 and unit.values[TYPE] == 0 and unit.visible then
				local show = true
				if metatext_overlaystyle == 1 then
					local c = changes[unit.className] or {}
					if c.image == nil then
						show = false
					else
						local imetalevel = getmetalevel(c.image)
						if imetalevel == metalevel then
							show = false
						end
					end
				end
				if metalevel > 4 then
					local mouse_x, mouse_y = MF_mouse()
					local half_tilesize = f_tilesize * generaldata2.values[ZOOM] * spritedata.values[TILEMULT] / 2
					if not (mouse_x >= unit.x - half_tilesize and mouse_x < unit.x + half_tilesize and mouse_y >= unit.y - half_tilesize and mouse_y < unit.y + half_tilesize) then
						show = false
					end
				end
				if show then
					-- imagine flag: print pink T text
					local color = textoverlaycolor(unit, {4,1}, {4,2})
					if true then
						local sequenceText, sequenceGlyph, sN, sE, sL, sO = makemetastring(unitname)
						writetext(sequenceText:sub(2), unit.fixed, (8 * unit.scaleX),
								-(6 * unit.scaleY), "metaoverlay", true,
								1, true, color)

						--imagine flag: print blue lambda text. I had to flip it over which was crazy but looks amazing
						color = textoverlaycolor(unit, {3,3}, {1,4})
						local _, glyphflip = writetext(sequenceGlyph:sub(2), unit.fixed, (8 * unit.scaleX),
								-(6 * unit.scaleY), "metaoverlay", true,
								1, true, color)
						for _, table in ipairs(glyphflip) do
							mmf.newObject(table[1]).angle = 180
						end

						color = textoverlaycolor(unit, {2,4}, {3,4})
						writetext(sN:sub(2), unit.fixed, (8 * unit.scaleX),
								-(6 * unit.scaleY), "metaoverlay", true,
								1, true, color)
						color = textoverlaycolor(unit, {5,4}, {5,3})
						writetext(sE:sub(2), unit.fixed, (8 * unit.scaleX),
								-(6 * unit.scaleY), "metaoverlay", true,
								1, true, color)
						color = textoverlaycolor(unit, {3,1}, {3,0})
						writetext(sL:sub(2), unit.fixed, (8 * unit.scaleX),
								-(6 * unit.scaleY), "metaoverlay", true,
								1, true, color)
						color = textoverlaycolor(unit, {0,2}, {0,1})
						writetext(sO:sub(2), unit.fixed, (8 * unit.scaleX),
								-(6 * unit.scaleY), "metaoverlay", true,
								1, true, color)
					else
						writetext(getmetalevel(getname(unit)), unit.fixed, (8 * unit.scaleX),
								-(6 * unit.scaleY), "metaoverlay", true,
								1, true, color)
					end
				end
			end
		end
	end
end

function textoverlaycolor(unit, maincolor, backcolor)
	local textcolor = maincolor
	local unitcolor1, unitcolor2 = getcolour(unit.fixed)
	if unit.colours ~= nil and #unit.colours > 0 then
		for z, c in pairs(unit.colours) do
			unitcolor1, unitcolor2 = c[1], c[2]
			if textcolor[1] == tonumber(unitcolor1) and textcolor[2] == tonumber(unitcolor2) then
				textcolor = backcolor
			end
		end
	else
		if unit.active == true or generaldata.values[MODE] == 5 then
			unitcolor1, unitcolor2 = getcolour(unit.fixed, "active")
		end
		if textcolor[1] == tonumber(unitcolor1) and textcolor[2] == tonumber(unitcolor2) then
			textcolor = backcolor
		end
	end
	return textcolor
end

table.insert(mod_hook_functions["always"], writemetalevel)

-- Enables TEXT IS WORD behavior with letters if enabled
function formlettermap()
	letterunits_map = {}

	local lettermap = {}
	local letterunitlist = {}

	if (#letterunits > 0) then
		for i, unitid in ipairs(letterunits) do
			local unit = mmf.newObject(unitid)

			if (unit.values[TYPE] == 5) and (unit.flags[DEAD] == false) then
				local valid = true
				if metatext_textisword and (#wordunits > 0) then
					valid = false
					for c, d in ipairs(wordunits) do
						if (unitid == d[1]) and testcond(d[2], d[1]) then
							valid = true
							break
						end
					end
				end
				if valid then
					local x, y = unit.values[XPOS], unit.values[YPOS]
					local tileid = x + y * roomsizex

					local name = string.sub(unit.strings[UNITNAME], 6)

					if (lettermap[tileid] == nil) then
						lettermap[tileid] = {}
					end

					table.insert(lettermap[tileid], { name, unitid })
				end
			end
		end

		for tileid, v in pairs(lettermap) do
			local x = math.floor(tileid % roomsizex)
			local y = math.floor(tileid / roomsizex)

			local ux, uy = x, y - 1
			local lx, ly = x - 1, y
			local dx, dy = x, y + 1
			local rx, ry = x + 1, y

			local tidr = rx + ry * roomsizex
			local tidu = ux + uy * roomsizex
			local tidl = lx + ly * roomsizex
			local tidd = dx + dy * roomsizex

			local continuer = false
			local continued = false

			if (lettermap[tidr] ~= nil) then
				continuer = true
			end

			if (lettermap[tidd] ~= nil) then
				continued = true
			end

			if (#cobjects > 0) then
				for a, b in ipairs(v) do
					local n = b[1]
					if (cobjects[n] ~= nil) then
						continuer = true
						continued = true
						break
					end
				end
			end

			if (lettermap[tidl] == nil) and continuer then
				letterunitlist = formletterunits(x, y, lettermap, 1, letterunitlist)
			end

			if (lettermap[tidu] == nil) and continued then
				letterunitlist = formletterunits(x, y, lettermap, 2, letterunitlist)
			end
		end

		if (unitreference["text_play"] ~= nil) then
			letterunitlist = cullnotes(letterunitlist)
		end

		for i, v in ipairs(letterunitlist) do
			local x = v[3]
			local y = v[4]
			local w = v[6]
			local dir = v[5]

			local dr = dirs[dir]
			local ox, oy = dr[1], dr[2]

			--[[
      MF_debug(x,y,1)
      MF_alert("In database: " .. v[1] .. ", dir " .. tostring(v[5]))
      ]]
			--

			local tileid = x + y * roomsizex

			if (letterunits_map[tileid] == nil) then
				letterunits_map[tileid] = {}
			end

			table.insert(letterunits_map[tileid], { v[1], v[2], v[3], v[4], v[5], v[6], v[7] })

			if (w > 1) then
				local endtileid = (x + ox * (w - 1)) + (y + oy * (w - 1)) * roomsizex

				if (letterunits_map[endtileid] == nil) then
					letterunits_map[endtileid] = {}
				end

				table.insert(letterunits_map[endtileid], { v[1], v[2], v[3], v[4], v[5], v[6], v[7] })
			end
		end
	end
end

-- Try to add more metatext if it doesn't exist.
function tryautogenerate(want, have)

	if (objectpalette[want] ~= nil or unitreference[want] ~= nil) then return true end
	if is_str_special_prefix(want) then
		return false -- fix silly edgecase
	else
		if metatext_autogenerate ~= 0 then
		if editor_objlist_reference[want] ~= nil then
			local data = editor_objlist[editor_objlist_reference[want]]
			local root = data.sprite_in_root
			if root == nil then
				root = true
			end
			local colour = data.colour
			local active = data.colour_active
			local colourasstring = colour[1] .. "," .. colour[2]
			local activeasstring = "0,0"
			if active ~= nil then
				activeasstring = active[1] .. "," .. active[2]
			end
			local new =
			{
				want,
				data.sprite or data.name,
				colourasstring,
				data.tiling,
				data.type or 0,
				data.unittype,
				activeasstring,
				root,
				data.layer or 10,
				nil,
			}
			local target = "120"
			while target ~= "156" do
				local done = true
				for objname, data in pairs(objectpalette) do
					if data == "object" .. target then
						done = false
						target = tostring(tonumber(target) + 1)
						while string.len(target) < 3 do
							target = "0" .. target
						end
					end
				end
				if done then break end
			end
			if target == "156" then
				return false
			else
				savechange("object" .. target, new, nil, true)
				dochanges_full("object" .. target)
				objectpalette[want] = "object" .. target
				objectlist[want] = 1
				if root == true then
					fullunitlist[want] = "fixroot" .. (data.sprite or data.name)
				else
					fullunitlist[want] = "fix" .. (data.sprite or data.name)
				end
				return true
			end
		elseif have == nil then
			local test = want
			local count = 0
			if objectpalette["text_" .. test] == nil then
				while objectpalette[test] == nil do
					if is_str_special_prefixed(test) and not is_str_special_prefix(test) then
						test = get_ref(test)
						count = count + 1
					else
						local lowestlevel = "text_" .. test
						if lowestlevel == "text_" then
							lowestlevel = "text_text_"
						end
						local SAFETY = 0
						while (not getmat_text(lowestlevel)) and SAFETY <= 1000 do
							lowestlevel = "text_" .. lowestlevel
							SAFETY = SAFETY + 1
						end
						-- this shouldn't happen, but just in case
						if SAFETY >= 1000 then
							return false
						end
						have = lowestlevel
						break
					end
				end
				if have == nil then
					have = test
				end
			else
				have = "text_" .. test
			end
		end
		if not is_str_special_prefixed(have) then
			have = get_pref(want) .. have
		end
		print("Trying to generate " .. want .. " from " .. have .. ".")
		local realname = objectpalette[have]
		local root = getactualdata_objlist(realname, "sprite_in_root")
		local colour = getactualdata_objlist(realname, "colour")
		local active = getactualdata_objlist(realname, "active")
		if colour == nil then
			return false
		end
		local sprite = getactualdata_objlist(realname, "sprite", true) or getactualdata_objlist(realname, "name")
		local colourasstring = colour[1] .. "," .. colour[2]
		local activeasstring = "0,0"
		if active ~= nil then
			activeasstring = active[1] .. "," .. active[2]
		end
		local tiling = getactualdata_objlist(realname, "tiling")
		local type = getactualdata_objlist(realname, "unittype")
		if (string.sub(want,1,5) == "text_" or string.sub(want,1,6) == "event_") then
			type = "text"
		elseif (string.sub(want,1,6) == "glyph_") then
			type = "object"
		elseif (string.sub(want,1,6) == "logic_") then
			type = "logic"
		elseif string.sub(want,1,5) == "node_" then
			type = "node"
			tiling = 0
		elseif string.sub(want,1,6) == "orbit_" then
			type = "orbit"
		end
		local new =
		{
			want,
			sprite,
			colourasstring,
			tiling,
			0,
			type,
			activeasstring,
			root,
			getactualdata_objlist(realname, "layer"),
			nil,
		}
		if metatext_autogenerate == 1 or metatext_autogenerate == 2 then
			local spritewanted = get_pref(want)
			local base = want
			for _,k in ipairs(special_prefixes) do
				base = string.gsub(base,k,"")
			end
			spritewanted = spritewanted..base
			if MF_findsprite(spritewanted .. "_0_1.png", false) or MF_findsprite(spritewanted .. "_0_1.png", true) then
				sprite = spritewanted
				new[2] = sprite
				root = MF_findsprite(spritewanted .. "_0_1.png", true)
				new[8] = root
			elseif metatext_autogenerate == 2 then
				return false
			end
		end
		local target = "120"
		while target ~= "156" do
			local done = true
			for objname, data in pairs(objectpalette) do
				if data == "object" .. target then
					done = false
					target = tostring(tonumber(target) + 1)
					while string.len(target) < 3 do
						target = "0" .. target
					end
				end
			end
			if done then break end
		end
		if target == "156" then
			return false
		else
			savechange("object" .. target, new, nil, true)
			dochanges_full("object" .. target)
			objectpalette[want] = "object" .. target
			objectlist[want] = 1
			if root == true then
				fullunitlist[want] = "fixroot" .. sprite
			else
				fullunitlist[want] = "fix" .. sprite
			end
			return true
		end
	end
		return false
	end
end

-- Allows metatext to be named in editor.
if old_editor_trynamechange == nil then
	old_editor_trynamechange = editor_trynamechange
end
function editor_trynamechange(object,newname_,fixed,objlistid,oldname_)
	local valid = true

	local newname = newname_ or "error"
	local oldname = oldname_ or "error"
	local checking = true

	if (newname:sub(1,1) == "$") then -- support for raw rename mod
		return old_editor_trynamechange(object,newname_,fixed,objlistid,oldname_)
	end

	newname = string.gsub(newname, "_", "UNDERDASH")
	newname = string.gsub(newname, "%W", "")
	newname = string.gsub(newname, "UNDERDASH", "_")

	while checking do
		checking = false

		for a,obj in pairs(editor_currobjlist) do
			if (obj.name == newname) then
				checking = true

				if (tonumber(string.sub(obj.name, -1)) ~= nil) then
					local num = tonumber(string.sub(obj.name, -1)) + 1

					newname = string.sub(newname, 1, string.len(newname)-1) .. tostring(num)
				else
					newname = newname .. "2"
				end
			end
		end
	end

	if (#newname == 0) or (newname == "level") or (newname == "text_crash") or (newname == "text_error") or (newname == "crash") or (newname == "error") or (newname == "text_never") or (newname == "never") or (newname == "text_") then
		valid = false
	end

	if (string.find(newname, "#") ~= nil) then
		valid = false
	end

	MF_alert("Trying to change name: " .. object .. ", " .. newname .. ", " .. tostring(valid))

	if valid then
		savechange(object,{newname},fixed)
		MF_updateobjlistname_hack(objlistid,newname)

		-- we're gonna change every layer
		local textlessName, metalevel = string.gsub(oldname, "text_", "")
		if string.sub(oldname, -5) == "text_" then
			metalevel = metalevel - 1
			textlessName = "text_"..textlessName
		end
		newname = string.gsub(newname, "text_", "", metalevel)
		
		for i,v in ipairs(editor_currobjlist) do
			--[[if (v.object == object) then -- idk what this does, I'm just gonna disable this
				v.name = newname
			end]]

			local nTextlessName, nMetalevel = string.gsub(v.name, "text_", "")
			if string.sub(v.name, -5) == "text_" then
				nMetalevel = nMetalevel - 1
				nTextlessName = "text_"..nTextlessName
			end

			if (nTextlessName == textlessName) then
				local tOldname = v.name
				v.name = string.rep("text_",nMetalevel) .. newname
				local vid = MF_create(v.object)
				savechange(v.object,{v.name},vid)
				MF_cleanremove(vid)

				MF_alert("Found " .. tOldname .. ", changing to " .. v.name)

				MF_updateobjlistname_byname(tOldname,v.name)
			end
		end
	end

	return valid
end

-- Fix issue with FEAR.
function getunitverbtargets(rule2)
	local group = {}
	local result = {}

	if (featureindex[rule2] ~= nil) then
		for i, v in ipairs(featureindex[rule2]) do
			local rule = v[1]
			local conds = v[2]

			local name = rule[1]

			local isnot = string.sub(rule[3], 1, 4)

			if (rule[2] == rule2) and (conds[1] ~= "never") and (findnoun(rule[1], nlist.brief) == false) and (isnot ~= "not ") and (not is_str_broad_noun(rule[1])) then
				if (group[name] == nil) then
					group[name] = {}
				end

				table.insert(group[name], { rule[3], conds })
			end
		end

		for name, v in pairs(group) do
			if (string.sub(name, 1, 4) ~= "not ") then
				if (name ~= "empty") then
					local fgroupmembers = unitlists[name] or {}
					local finalgroup = {}

					for a, b in ipairs(fgroupmembers) do
						local myverbs = {}

						for c, d in ipairs(v) do
							if testcond(d[2], b) then
								local unit = mmf.newObject(b)

								if (unit.flags[DEAD] == false) then
									table.insert(myverbs, d[1])
								end
							end
						end

						table.insert(finalgroup, { b, myverbs })
					end

					table.insert(result, { name, finalgroup })
				else
					local empties = findempty()
					local finalgroup = {}

					if (#empties > 0) then
						for a, b in ipairs(empties) do
							local x = math.floor(b % roomsizex)
							local y = math.floor(b / roomsizex)
							local myverbs = {}

							for c, d in ipairs(v) do
								if testcond(d[2], 2, x, y) then
									table.insert(myverbs, d[1])
								end
							end

							table.insert(finalgroup, { b, myverbs })
						end

						table.insert(result, { name, finalgroup })
					end
				end
			end
		end
	end

	return result
end

-- This fixes this really weird bug where the game tries to convert particles and text.
olddoconvert = doconvert
function doconvert(data, extrarule_)
	local unitid = data[1]
	if unitid ~= 2 then
		local unit = mmf.newObject(unitid)
		if unit.strings[UNITNAME] == "" then
			return
		end
	end
	olddoconvert(data, extrarule_)
end

--[[ Gets the meta level of a string
(times "text_" appears, minus 1, minus 1 again if the string ends with "text_")
Examples:
"baba" = -1
"text_baba" = 0
"text_text_baba" = 1
"text_text_" = 0
"text_text_text_" = 1
]]
function getmetalevel(str)
	local metalevel = -1
	while is_str_special_prefixed(str) do
		for _,v in ipairs(special_prefixes) do
			if string.sub(str, 1, string.len(v)) == v then
				metalevel = metalevel + 1
				str = string.sub(str, string.len(v) + 1)
			end
		end
	end
	if str == "" then
		metalevel = metalevel - 1
	end
	return metalevel
end

-- Fix issue with TEXT MAKE TEXT
function getunitswithverb(rule2, ignorethese_, checkedconds)
	local group = {}
	local result = {}
	local ignorethese = ignorethese_ or {}

	if (featureindex[rule2] ~= nil) then
		for i, v in ipairs(featureindex[rule2]) do
			local rule = v[1]
			local conds = v[2]

			local name = rule[1]

			if (rule[2] == rule2) and (conds[1] ~= "never") and (findnoun(rule[1], nlist.brief) == false) and (string.sub(rule[3], 1, 4) ~= "not ") then
				if (group[name] == nil) then
					group[name] = {}
				end

				table.insert(group[name], { rule[3], conds })
			end
		end

		for i, v in pairs(group) do
			if (string.sub(i, 1, 4) ~= "not ") and (not is_str_broad_noun(i)) and string.sub(i, 1, 4) ~= "meta" then -- changed line
				if (i ~= "empty") then
					local name = i
					local fgroupmembers = unitlists[name]

					if (fgroupmembers ~= nil) and (#fgroupmembers > 0) then
						for c, d in ipairs(v) do
							table.insert(result, { d[1], {}, name })
							local thisthisresult = result[#result][2]

							for a, b in ipairs(fgroupmembers) do
								if testcond(d[2], b, nil, nil, nil, nil, checkedconds) then
									local unit = mmf.newObject(b)

									if (unit.flags[DEAD] == false) then
										local valid = true
										for e, f in ipairs(ignorethese) do
											if (f == b) then
												valid = false
												break
											end
										end

										if valid then
											table.insert(result[#result][2], unit)
										end
									end
								end
							end
						end
					end
				else
					local name = i
					local empties = findempty()

					if (#empties > 0) then
						for c, d in ipairs(v) do
							table.insert(result, { d[1], {}, name })

							for e, f in ipairs(empties) do
								local x = math.floor(f % roomsizex)
								local y = math.floor(f / roomsizex)

								if testcond(d[2], 2, x, y, nil, nil, checkedconds) then
									local valid = true
									for g, h in ipairs(ignorethese) do
										if (f == h) then
											valid = false
											break
										end
									end

									if valid then
										table.insert(result[#result][2], f)
									end
								end
							end
						end
					end
				end
			end
		end
	end

	return result
end

function getunitswitheffect(rule3,nolevels_,ignorethese_,checkedconds,ignorebroken_)
	local group = {}
	local result = {}
	local ignorethese = ignorethese_ or {}
	local ignorebroken = ignorebroken_ or false
	
	local nolevels = nolevels_ or false
	
	if (featureindex[rule3] ~= nil) then
		for i,v in ipairs(featureindex[rule3]) do
			local rule = v[1]
			local conds = v[2]
			
			if (rule[2] == "is") and (conds[1] ~= "never") and (findnoun(rule[1],nlist.brief) == false) then
				table.insert(group, {rule[1], conds})
			end
		end
		
		for i,v in ipairs(group) do
			if (v[1] ~= "empty") and (not is_str_broad_noun(v[1])) and (not is_string_metax(v[1],true)) then
				local name = v[1]
				local fgroupmembers = unitlists[name]
				
				local valid = true
				
				if (name == "level") and nolevels then
					valid = false
				end
				
				if (fgroupmembers ~= nil) and valid then
					for a,b in ipairs(fgroupmembers) do
						if testcond(v[2],b,nil,nil,nil,nil,checkedconds,ignorebroken) then
							local unit = mmf.newObject(b)
							
							if (unit.flags[DEAD] == false) then
								valid = true
								
								for c,d in ipairs(ignorethese) do
									if (d == b) then
										valid = false
										break
									end
								end
								
								if valid then
									table.insert(result, unit)
								end
							end
						end
					end
				end
			else
				--table.insert(result, {2, v[2]})
			end
		end
	end
	
	return result
end

function makemetastring(string)
	local namestring = string
	local sT, sG, sN, sE, sL, sO = "", "", "", "", "", ""
	while true do
		if namestring:sub(1,5) == "text_" and #namestring > 5 then
			sT = sT.."T"
			sG = sG.." "
			sN = sN.." "
			sE = sE.." "
			sL = sL.." "
			sO = sO.." "
			namestring = namestring.gsub(namestring, "text_", "", 1)
		elseif namestring:sub(1,6) == "glyph_" and #namestring > 6 then
			sT = sT.." "
			sG = sG.."V"
			sN = sN.." "
			sE = sE.." "
			sL = sL.." "
			sO = sO.." "
			namestring = namestring.gsub(namestring, "glyph_", "", 1)
		elseif namestring:sub(1, 5) == "node_" and #namestring > 5 then
			sT = sT .. " "
			sG = sG .. " "
			sN = sN .. "N"
			sE = sE .. " "
			sL = sL .. " "
			sO = sO .. " "
			namestring = namestring.gsub(namestring, "node_", "", 1)
		elseif namestring:sub(1, 6) == "event_" and #namestring > 6 then
			sT = sT .. " "
			sG = sG .. " "
			sN = sN .. " "
			sE = sE .. "E"
			sL = sL .. " "
			sO = sO .. " "
			namestring = namestring.gsub(namestring, "event_", "", 1)
		elseif namestring:sub(1, 6) == "logic_" and #namestring > 6 then
			sT = sT .. " "
			sG = sG .. " "
			sN = sN .. " "
			sE = sE .. " "
			sL = sL .. "L"
			sO = sO .. " "
			namestring = namestring.gsub(namestring, "logic_", "", 1)
		elseif namestring:sub(1, 5) == "orbit_" and #namestring > 5 then
			sT = sT .. " "
			sG = sG .. " "
			sN = sN .. " "
			sE = sE .. " "
			sL = sL .. " "
			sO = sO .. "O"
			namestring = namestring.gsub(namestring, "orbit_", "", 1)
		else
			return sT, sG, sN, sE, sL, sO
		end
	end
end

broad_nouns = {"text", "glyph", "node", "event", "logic", "orbit"}
special_prefixes = {}
for _, v in ipairs(broad_nouns) do
	table.insert(special_prefixes, v .. "_")
end

function is_str_broad_noun(str)
	for _, v in ipairs(broad_nouns) do
		if str == v then
			return true
		end
	end
	return false
end

function is_str_notted_broad_noun(str)
	for _, v in ipairs(broad_nouns) do
		if str == "not " .. v then
			return true
		end
	end
	return false
end

function get_broaded_str(str)
	for _,v in ipairs(broad_nouns) do
		if string.sub(str, 1, string.len(v) + 1) == v .. "_" then
			return v
		end
	end
	return str
end

function is_str_special_prefix(str)
	for _, v in ipairs(special_prefixes) do
		if str == v then
			return true
		end
	end
	return false
end

function is_str_special_prefixed(str)
	for _, v in ipairs(special_prefixes) do
		if string.sub(str, 1, string.len(v)) == v then
			return true
		end
	end
	return false
end

function get_pref(str)
	for _, v in ipairs(special_prefixes) do
		if string.sub(str, 1, string.len(v)) == v then
			return v
		end
	end
	return ""
end

function get_ref(str)
	for _, v in ipairs(special_prefixes) do
		if string.sub(str, 1, string.len(v)) == v then
			return string.sub(str, string.len(v) + 1)
		end
	end
	return str
end

function edit_str_meta_layer(str, layer)
	local metalevel = getmetalevel(str)
	local diff = metalevel - layer
	if diff > 0 then
		for i = 1, diff do
			str = get_ref(str)
		end
	elseif diff < 0 then
		local top_pref = get_pref(str)
		if top_pref == "" then top_pref = "text_" end
		str = string.rep(top_pref, -diff) .. str
	end
	return str
end

function equals_or_included(a,b)
	if a == b then return true end
	if ("meta"..getmetalevel(a) == b) then return true end
	if get_pref(a) == b .. "_" then return true end
	return false
end

function can_refer(noun,target)
	local isnot = false
	if string.sub(noun,1,4) == "not " then
		noun = string.sub(noun,5)
		isnot = true
	end
	if isnot then
		if (string.sub(noun,1,4) == "meta") then 
			if (string.sub(noun,5) ~= tostring(getmetalevel(target))) and (metatext_includenoun or is_str_special_prefixed(target)) then return true end
		elseif (noun == "all") then
			if is_str_special_prefixed(target) or target == "empty" then return true end
		elseif (get_pref(noun) == get_pref(target)) and (target ~= noun) and (is_str_special_prefixed(noun) or (findnoun(target) == false)) then return true end
	else
        if equals_or_included(target, noun) then return true end
		if (noun == "all") and (findnoun(target) == false) then return true end
    end

	return false

end

function diff_or_excluded(a,b)
	if a ~= b then
		if string.sub(b, 1, 4) == "meta" then
            if ("meta" .. tostring(getmetalevel(a)) ~= b) and (metatext_includenoun or getmetalevel(a) >= 0) then
                return true
            end
        else
            if get_pref(a) == get_pref(b) then return true end
        end
	end
	return false
end

function is_string_metax(str, include_n1)
	if string.sub(str,1,4) ~= "meta" then return false end
	local metalevel = tonumber(string.sub(str,5))
	if metalevel == nil then return false end
	if metalevel < -1 then return false end
	--check if metalevel is integer
	--if metalevel ~= math.floor(metalevel) then return false end
	if (not include_n1) or (include_n1 == nil) then
		if metalevel == -1 then return false end
	end
	return true
end