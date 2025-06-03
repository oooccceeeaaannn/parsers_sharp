function delunit(unitid)
	local unit = mmf.newObject(unitid)

	-- MF_alert("DELUNIT " .. unit.strings[UNITNAME])

	if (unit ~= nil) then
		local name = get_broaded_str(unit.strings[UNITNAME])
		local x,y = unit.values[XPOS],unit.values[YPOS]
		local unitlist = unitlists[name]
		local unitlist_ = unitlists[unit.strings[UNITNAME]] or {}
		local unittype = unit.strings[UNITTYPE]

		if (unittype == "text" or unittype == "node") or (name == "glyph") then
			updatecode = 1
		end

		x = math.floor(x)
		y = math.floor(y)

		if (unitlist ~= nil) then
			for i,v in pairs(unitlist) do
				if (v == unitid) then
					v = {}
					table.remove(unitlist, i)
					break
				end
			end
		end

		if (unitlist_ ~= nil) then
			for i,v in pairs(unitlist_) do
				if (v == unitid) then
					v = {}
					table.remove(unitlist_, i)
					break
				end
			end
		end

		-- This is the added part
		local level = getmetalevel(unit.strings[UNITNAME])
		if level >= -1 then
			local munitlist = unitlists["meta" .. level]
			if (munitlist ~= nil) then
				for i,v in pairs(munitlist) do
					if (v == unitid) then
						v = {}
						table.remove(munitlist, i)
					end
				end
			end
		end

		-- TÄMÄ EI EHKÄ TOIMI
		local tileid = x + y * roomsizex

		if (unitmap[tileid] ~= nil) then
			for i,v in pairs(unitmap[tileid]) do
				if (v == unitid) then
					v = {}
					table.remove(unitmap[tileid], i)
				end
			end

			if (#unitmap[tileid] == 0) then
				unitmap[tileid] = nil
			end
		end

		if (unittypeshere[tileid] ~= nil) then
			local uth = unittypeshere[tileid]

			local n = unit.strings[UNITNAME]

			if (uth[n] ~= nil) then
				uth[n] = uth[n] - 1

				if (uth[n] == 0) then
					uth[n] = nil
				end
			end
		end

		if ((unit.strings[UNITTYPE] == "text") or (unit.strings[UNITTYPE] == "logic")) and (codeunits ~= nil) then
			for i,v in pairs(codeunits) do
				if (v == unitid) then
					v = {}
					table.remove(codeunits, i)
				end
			end
			
			if (unit.values[TYPE] == 5) then
				for i,v in pairs(letterunits) do
					if (v == unitid) then
						v = {}
						table.remove(letterunits, i)
					end
				end
			end
		end

        if (string.sub(unit.strings[UNITNAME], 1, 6) == "glyph_") and (glyphunits ~= nil) then
			for i,v in pairs(glyphunits) do
				if (v == unitid) then
					v = {}
					table.remove(glyphunits, i)
				end
			end
        end

		if (unit.values[TILING] > 1) and (animunits ~= nil) then
			for i,v in pairs(animunits) do
				if (v == unitid) then
					v = {}
					table.remove(animunits, i)
				end
			end
		end

		if (unit.values[TILING] == 1) and (tiledunits ~= nil) then
			for i,v in pairs(tiledunits) do
				if (v == unitid) then
					v = {}
					table.remove(tiledunits, i)
				end
			end
		end

		if (#wordunits > 0) and (unit.values[TYPE] == 0) and (unit.strings[UNITTYPE] ~= "text") then
			for i,v in pairs(wordunits) do
				if (v[1] == unitid) then
					local currentundo = undobuffer[1]
					table.insert(currentundo.wordunits, unit.values[ID])
					updatecode = 1
					v = {}
					table.remove(wordunits, i)
				end
			end
		end

		if (#symbolunits > 0) and (unit.values[TYPE] == 0) and not isglyph(unit) then
			for i,v in pairs(symbolunits) do
				if (v[1] == unitid) then
					local currentundo = undobuffer[1]
					table.insert(currentundo.symbolunits, unit.values[ID])
					updatecode = 1
					v = {}
					table.remove(symbolunits, i)
				end
			end
		end

		if (#wordrelatedunits > 0) then
			for i,v in pairs(wordrelatedunits) do
				if (v[1] == unitid) then
					local currentundo = undobuffer[1]
					table.insert(currentundo.wordrelatedunits, unit.values[ID])
					updatecode = 1
					v = {}
					table.remove(wordrelatedunits, i)
				end
			end
		end

		if (#symbolrelatedunits > 0) then
			for i,v in pairs(symbolrelatedunits) do
				if (v[1] == unitid) then
					local currentundo = undobuffer[1]
					table.insert(currentundo.symbolrelatedunits, unit.values[ID])
					updatecode = 1
					v = {}
					table.remove(symbolrelatedunits, i)
				end
			end
		end

		if (#visiontargets > 0) then
			for i,v in pairs(visiontargets) do
				if (v == unitid) then
					local currentundo = undobuffer[1]
					--table.insert(currentundo.visiontargets, unit.values[ID])
					v = {}
					table.remove(visiontargets, i)
				end
			end
		end
	else
		MF_alert("delunit(): no object found with id " .. tostring(unitid) .. " (delunit)")
	end

	for i,v in ipairs(units) do
		if (v.fixed == unitid) then
			v = {}
			table.remove(units, i)
		end
	end

	for i,data in pairs(updatelist) do
		if (data[1] == unitid) and (data[2] ~= "convert") then
			data[2] = "DELETED"
		end
	end
end

-- Prevent text from being called "text", and also handles parameters
function getname(unit,pname_,pnot_)
	if unit == nil then return nil end
	local result = unit.strings[UNITNAME]
	local pname = pname_ or ""
	local pnot = pnot_ or false
	if type(pname) ~= "string" then
		--Guys I fixed the bug that keeps getting reported
		pname = ""
	elseif pnot then
		if (get_pref(result) ~= get_pref(pname)) and (string.sub(pname,1,4) ~= "meta") then
			result = pname
		end
	end

	if (string.sub(result, 1, 5) == "text_") and ((pname == "text") or (pnot == true)) and (string.sub(pname,1,4) ~= "meta") and (string.sub(pname,1,5) ~= "text_") then
		result = "text"
	elseif (string.sub(result, 1, 6) == "glyph_") and ((pname == "glyph") or (pnot == true)) and (string.sub(pname,1,4) ~= "meta")  and (string.sub(pname,1,6) ~= "glyph_") then
		result = "glyph"
	elseif (string.sub(result, 1, 6) == "event_") and ((pname == "event") or (pnot == true)) and (string.sub(pname,1,4) ~= "meta")  and (string.sub(pname,1,6) ~= "event_") then
		result = "event"
	elseif (string.sub(result, 1, 5) == "node_") and ((pname == "node") or (pnot == true)) and (string.sub(pname,1,4) ~= "meta") and (string.sub(pname,1,5) ~= "node_") then
		result = "node"
	elseif (string.sub(result, 1, 6) == "logic_") and ((pname == "logic") or (pnot == true)) and (string.sub(pname,1,4) ~= "meta") and (string.sub(pname,1,6) ~= "logic_") then
		result = "logic"
	elseif string.sub(pname,1,4) == "meta" then
		if metatext_includenoun or pnot == false or is_str_special_prefixed(result) then
			local include = false
			local level = string.sub(pname,5)
			if tonumber(level) ~= nil and tonumber(level) >= -1 then
				local metalevel = getmetalevel(result)
				if metalevel == tonumber(level) then
					include = true
				end
			end
			if include == pnot then
				result = pname
			elseif not pnot then
				result = pname
			end
		end
	end

	return result
end


-- Remove lines that change name to "text"
function findtype(typedata,x,y,unitid_,just_testing_)
	local result = {}
	local unitid = 0
	local tileid = x + y * roomsizex
	local name = typedata[1]
	local conds = typedata[2]

	local just_testing = just_testing_ or false

	if (unitid_ ~= nil) then
		unitid = unitid_
	end

	if (unitmap[tileid] ~= nil) then
		for i,v in ipairs(unitmap[tileid]) do
			if (v ~= unitid) then
				local unit = mmf.newObject(v)

				if (unit.strings[UNITNAME] == name) then -- or ((unit.strings[UNITTYPE] == "text") and (name == "text")) or ((unit.strings[UNITTYPE] == "node") and (name == "node")) or (isglyph(unit) and (name == "glyph")) or (string.sub(unit.strings[UNITNAME], 1, 6) == "event_" and (name == "event")) then
					if testcond(conds,v) then
						table.insert(result, v)

						if just_testing then
							return result
						end
					end
				end
			end
		end
	end

	return result
end

function update(unitid,x,y,dir_)
	if (unitid ~= nil) then
		local unit = mmf.newObject(unitid)

		local unitname = unit.strings[UNITNAME]
		local dir,olddir = unit.values[DIR],unit.values[DIR]
		local tiling = unit.values[TILING]
		local unittype = unit.strings[UNITTYPE]
		local oldx,oldy = unit.values[XPOS],unit.values[YPOS]

		if (dir_ ~= nil) then
			dir = dir_
		end

		if (x ~= oldx) or (y ~= oldy) or (dir ~= olddir) then
			updateundo = true

			addundo({"update",unitname,oldx,oldy,olddir,x,y,dir,unit.values[ID]},unitid)

			local ox,oy = x-oldx,y-oldy

			if (math.abs(ox) + math.abs(oy) == 1) and (unit.values[MOVED] == 0) then
				unit.x = unit.x + ox * tilesize * spritedata.values[TILEMULT] * generaldata2.values[ZOOM] * 0.25
				unit.y = unit.y + oy * tilesize * spritedata.values[TILEMULT] * generaldata2.values[ZOOM] * 0.25
			end

			unit.values[XPOS] = x
			unit.values[YPOS] = y
			unit.values[DIR] = dir
			unit.values[MOVED] = 1
			unit.values[POSITIONING] = 0

			updateunitmap(unitid,oldx,oldy,x,y,unit.strings[UNITNAME])

			if (tiling == 1) then
				dynamic(unitid)
				dynamicat(oldx,oldy)
			end

			if (unittype == "text") or isglyph(unit) or (unittype == "node") or (unittype == "logic") then
				updatecode = 1
			end

			if (featureindex["word"] ~= nil or featureindex["break"] ~= nil) then
				checkwordchanges(unitid,unitname)
			end
			if (featureindex["symbol"] ~= nil) then
				checksymbolchanges(unitid,unitname)
			end
		end

	else
		MF_alert("Tried to update a nil unit")
	end
end

function updatedir(unitid,dir,noundo_)
	if (unitid ~= nil) then
		local unit = mmf.newObject(unitid)
		local x,y = unit.values[XPOS],unit.values[YPOS]
		local unitname = unit.strings[UNITNAME]
		local unittype = unit.strings[UNITTYPE]
		local olddir = unit.values[DIR]

		local noundo = noundo_ or false

		if (dir ~= olddir) then
			if (noundo == false) then
				updateundo = true
				addundo({"update",unitname,x,y,olddir,x,y,dir,unit.values[ID]},unitid)
			end
			unit.values[DIR] = dir

			if (unittype == "text") or isglyph(unit) or (unittype == "node") or (unittype == "logic") then
				updatecode = 1
			end
		end
	else
		MF_alert("Tried to updatedir a nil unit")
	end
end

function findall(name_,ignorebroken_,just_testing_)
	local result = {}
	local name = name_[1]
	local meta
	
	local checklist = unitlists[name]

	local ignorebroken = ignorebroken_ or false
	local just_testing = just_testing_ or false
	
	if (checklist ~= nil) then
		for i,unitid in ipairs(checklist) do
			local unit = mmf.newObject(unitid)
			local unitname = getname(unit,meta)
			
			local oldbroken = unit.broken
			if ignorebroken then
				unit.broken = 0
			end
			
			if (unitname == name)  then
				if testcond(name_[2],unitid) then
					table.insert(result, unitid)
					
					if just_testing then
						return result
					end
				end
			end
			
			unit.broken = oldbroken
		end
	end
	
	return result
end

--Fixes TEXT HAS TEXT and NOT METATEXT HAS TEXT, and implements HAS META#.
function inside(name,x,y,dir_,unitid,leveldata_)
	local ins = {}
	local tileid = x + y * roomsizex
	local maptile = unitmap[tileid] or {}
	local dir = dir_

	local leveldata = leveldata_ or {}

	if (dir == 4) then
		dir = fixedrandom(0,3)
	end

	if (featureindex[name] ~= nil) then
		for i,rule in ipairs(featureindex[name]) do
			local baserule = rule[1]
			local conds = rule[2]

			local target = baserule[1]
			local verb = baserule[2]
			local object = baserule[3]

			if (target == name) and (verb == "has") then
				table.insert(ins, {object,conds})
			end
		end
	end

	if (#ins > 0) then
		for i,v in ipairs(ins) do
			local object = v[1]
			local conds = v[2]
			if testcond(conds,unitid,x,y) then
				if is_str_broad_noun(object) then
					object = object .. "_" .. name
				elseif string.sub(object,1,4) == "meta" then
					local level = string.sub(object,5)
					if tonumber(level) ~= nil and tonumber(level) >= -1 then
						object = edit_str_meta_layer(name, level)
						if findnoun(object,nlist.short,true) ~= false then
							object = "_NONE_"
						end
					else
						object = "_NONE_"
					end
				end
				local did = false -- changes start here
				for a,mat in pairs(fullunitlist) do -- main change
					if (a == object) and (object ~= "empty") then
						if (object ~= "all") and (string.sub(object, 1, 5) ~= "group") then
							if unitreference[object] ~= nil then
								create(object,x,y,dir,nil,nil,nil,nil,leveldata)
								did = true
							end
						elseif (object == "all") then
							createall(v,x,y,unitid,nil,leveldata)
							did = true
						end
					end
				end
				if not did and is_str_special_prefixed(object) then
					did = tryautogenerate(object)
					if did then
						create(object,x,y,dir,nil,nil,nil,nil,leveldata)
					end
				end
			end
		end
	end
end


function cantmove(name,unitid,dir,x,y)
	local still = hasfeature(name,"is","still",unitid,x,y)

	if (still ~= nil) then
		return true
	end

	if (dir ~= nil) then
		local opts = {"lockedright","lockedup","lockedleft","lockeddown"}
		local checkdir = dir
		if (featureindex["reverse"] ~= nil) then
			checkdir = reversecheck(unitid,dir,x,y)
		end
		local opt = opts[checkdir+1]

		if (opt ~= nil) then
			still = hasfeature(name,"is",opt,unitid,x,y)

			if (still ~= nil) then
				return true
			end

      if unitid ~= 1 and unitid ~= 2 then
        local unit = mmf.newObject(unitid)
        local customdirprop = ""
        if unit.values[DIR] == checkdir then
          customdirprop = "forward"
        end
        if unit.values[DIR] == (checkdir + 1) % 4 then
          customdirprop = "aroundleft"
        end
        if unit.values[DIR] == (checkdir + 2) % 4 then
          customdirprop = "backward"
        end
        if unit.values[DIR] == (checkdir + 3) % 4 then
          customdirprop = "aroundright"
        end
        still = hasfeature(name,"is","locked" .. customdirprop,unitid,x,y)
        if still ~= nil then
          return true
        end
      end
		end
	end

	if (unitid ~= 2) and (unitid ~= 1) and (featureindex["grab"] ~= nil) then
		local unit = mmf.newObject(unitid)

		if (unit.grabbed ~= nil) and (unit.grabbed ~= 0) then
			return true
		end
	end

	return false
end

-- Makes sure text units and meta# are considered special nouns
function findnoun(noun,list_,ignoretext)
	local list = list_ or nlist.full
	if noun == nil then
		print(debug.traceback())
		return false
	end

	for i,v in ipairs(list) do
		if (v == noun) or ((v == "group") and (string.sub(noun, 1, 5) == "group")) or (v == get_broaded_str(noun) and ignoretext ~= true) or (string.sub(noun,1,4) == "meta" and v == "all") then
			return true
		end
	end

	return false
end

function checkwordchanges(unitid,unitname)
	if (#wordunits > 0) then
		for i,v in ipairs(wordunits) do
			if (v[1] == unitid) then
				updatecode = 1
				return
			end
		end
	end
	
	if (#wordrelatedunits > 0) then
		for i,v in ipairs(wordrelatedunits) do
			if (v[1] == unitid) then
				updatecode = 1
				return
			end
		end
	end

	if (#breakunits > 0) then
		for i,v in ipairs(breakunits) do
			if (v[1] == unitid) then
				updatecode = 1
				return
			end
		end
	end
	
	if (#breakrelatedunits > 0) then
		for i,v in ipairs(breakrelatedunits) do
			if (v[1] == unitid) then
				updatecode = 1
				return
			end
		end
	end
end


-- Fix TEXT MIMIC X.
function getmat(m,checkallunit)
	local found = false
	if checkallunit then
		for i,v in pairs(fullunitlist) do
			if (i == m) then
				found = true
			end
		end
	else
		for i,v in pairs(objectlist) do
			if (i == m) then
				found = true
			end
		end
	end

	if found then
		return m
	else
		return nil
	end
end

-- Make WRITE work with text.
function getmat_text(name)
	if string.sub(name,1,10) == "text_text_" then
		name = string.sub(name,6)
	end
	local base = unitreference[name]
	local changed = objectpalette[name]

	if (generaldata.strings[WORLD] ~= generaldata.strings[BASEWORLD]) then
		return (changed ~= nil)
	else
		return (base ~= nil)
	end

	return false
end

-- Adds option to exclude group rules made by "TEXT" or "META#" noun. It's used in conditions.lua.
function findgroup(grouptype_,invert_,limit_,checkedconds_,notextnoun_)
	local result = {}
	local limit = limit_ or 0
	local invert = invert_ or false
	local grouptype = grouptype_ or "group"
	local notextnoun = notextnoun_ or false
	local found = {}
	local alreadyused = {}

	limit = limit + 1

	local idstring = ""
	local currmembers = {}
	local handlerecursion = false

	for i,v in ipairs(groupmembers) do
		local name = v[1]
		local conds = v[2]
		local gtype = v[3]
		local recursion = v[4]
		local tags = v[5]
		local foundtag = false
		if notextnoun then
			for num,tag in pairs(tags) do
				if is_str_broad_noun(tag) or string.sub(tag,1,4) == "meta" then
					foundtag = true
					break
				end
			end
		elseif is_str_broad_noun(name) or string.sub(name,1,4) == "meta" then
			foundtag = true
		end

		if (gtype == grouptype) and foundtag == false then
			if hasconds(v) and (unitlists[name] ~= nil) then
				if (recursion == false) then
					for a,b in ipairs(unitlists[name]) do
						local unit = mmf.newObject(b)
						local x,y = unit.values[XPOS],unit.values[YPOS]

						if testcond(conds,b,x,y,nil,limit,checkedconds_) then
							table.insert(result, name)
							table.insert(currmembers, name)
							found[name] = 1
							idstring = idstring .. name
							break
						end
					end
				else
					handlerecursion = true
				end
			elseif (hasconds(v) == false) then
				table.insert(result, name)
				table.insert(currmembers, name)
				found[name] = 1
				idstring = idstring .. name
			end
		end
	end

	local reclimit = 0
	local curridstring = idstring

	while handlerecursion and (reclimit < 10) do
		local newidstring = idstring
		local newmembers = {}
		for i,v in ipairs(result) do
			table.insert(newmembers, v)
		end

		for i,v in ipairs(groupmembers) do
			local name = v[1]
			local conds = v[2]
			local gtype = v[3]
			local recursion = v[4]

			if recursion and (gtype == grouptype) then
				if hasconds(v) and (unitlists[name] ~= nil) then
					for a,b in ipairs(unitlists[name]) do
						local unit = mmf.newObject(b)
						local x,y = unit.values[XPOS],unit.values[YPOS]

						if testcond(conds,b,x,y,nil,limit,checkedconds_,nil,currmembers) then
							table.insert(newmembers, name)
							newidstring = newidstring .. name
							break
						end
					end
				elseif (hasconds(v) == false) then
					table.insert(newmembers, name)
					newidstring = newidstring .. name
				end
			end
		end

		--MF_alert(curridstring .. ", " .. newidstring)

		if (newidstring ~= curridstring) then
			currmembers = {}
			for i,v in ipairs(newmembers) do
				table.insert(currmembers, v)
			end
			curridstring = newidstring
			reclimit = reclimit + 1
		else
			for i,v in ipairs(currmembers) do
				found[v] = 1
				idstring = idstring .. v
				table.insert(result, v)
			end

			handlerecursion = false
		end
	end

	if (reclimit >= 10) then
		HACK_INFINITY = 200
		destroylevel("infinity")
		return
	end

	if invert then
		local actualresult = {}

		for a,mat in pairs(objectlist) do
			if (found[a] == nil) and (alreadyused[a] == nil) and (findnoun(a,nlist.short) == false) then
				table.insert(actualresult, a)
				alreadyused[a] = 1
			end
		end

		return actualresult
	end

	return result
end
