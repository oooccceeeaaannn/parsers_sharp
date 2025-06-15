
function is_str_metalike_prop(str)
    if (str == "meta" or str == "unmeta" or str == "mega" or str == "unmega" or str == "mena" or str == "unmena" or str == "meea" or str == "unmeea" or str == "mela" or str == "unmela" or str == "unmexa")  then
      return true
    end
    return false
end

function is_str_writelike_verb(str)
    if (str == "write" or str == "inscribe" or str == "code" or str == "log") or (operator == "chart") then 
      return true
    end
    return false
end

-- Implementation.
function conversion(dolevels_)
	local alreadydone = {}
	local dolevels = dolevels_ or false
	
	for i,v in pairs(features) do
		local words = v[1]
		
		local operator = words[2]
		
		if (operator == "is") or (operator == "write") or (operator == "code") or (operator == "become") or (operator == "inscribe") or (operator == "draw") or (operator == "log") then
			local output = {}
			local name = words[1]
			local thing = words[3]

			if (not dolevels) and (operator == "is" or operator == "become") and not is_str_special_prefix(name .. "_") and (string.sub(name,1,4)) ~= "meta" and ((thing ~= "not " .. name) and (thing ~= "all") and (thing ~= "text") and (thing ~= "revert") and not is_str_metalike_prop(thing)) and unitreference[thing] == nil and (is_str_special_prefixed(thing)) and ((unitlists[name] ~= nil and #unitlists[name] > 0) or name == "empty" or name == "level") then
				tryautogenerate(thing)
			elseif (not dolevels) and (operator == "write" or (operator == "draw")) and not is_str_special_prefix(name .. "_") and (string.sub(name,1,4)) ~= "meta" and (thing ~= "not " .. name) and unitreference["text_" .. thing] == nil and ((unitlists[name] ~= nil and #unitlists[name] > 0) or name == "empty" or name == "level") then
				tryautogenerate("text_" .. thing)
			elseif (not dolevels) and (operator == "inscribe") and not is_str_special_prefix(name .. "_") and (thing ~= "not " .. name) and unitreference["glyph_" .. thing] == nil then
				tryautogenerate("glyph_" .. thing)
			elseif (not dolevels) and (operator == "log") and not is_str_special_prefix(name .. "_") and (string.sub(name,1,4)) ~= "meta" and (thing ~= "not " .. name) and unitreference["logic_" .. thing] == nil and ((unitlists[name] ~= nil and #unitlists[name] > 0) or name == "empty" or name == "level") then
				tryautogenerate("logic_" .. thing)
			elseif (not dolevels) and (operator == "code") and not is_str_special_prefix(name .. "_") and (string.sub(name,1,4)) ~= "meta" and (thing ~= "not " .. name) and unitreference["code_" .. thing] == nil and ((unitlists[name] ~= nil and #unitlists[name] > 0) or name == "empty" or name == "level") then
				tryautogenerate("event_" .. thing)
			elseif (not dolevels) and (operator == "chart") and not is_str_special_prefix(name .. "_") and (string.sub(name,1,4)) ~= "meta" and (thing ~= "not " .. name) and unitreference["code_" .. thing] == nil and ((unitlists[name] ~= nil and #unitlists[name] > 0) or name == "empty" or name == "level") then
				tryautogenerate("orbit_" .. thing)
			end

			if (not is_str_broad_noun(name)) --@Merge: omg beeeeg if block
			  and (string.sub(name,1,4) ~= "meta")
			  and ((getmat(thing) ~= nil)
			  	or (thing == "not " .. name)
				or (thing == "all")
				or (unitreference[thing] ~= nil)
				or (is_str_broad_noun(thing))
				or (thing == "revert")
				or (is_str_metalike_prop(thing))
				or ((string.sub(thing,1,4) == "meta") and (unitreference["text_" .. thing] ~= nil))
				or ((operator == "write" or (operator == "draw")) and getmat_text("text_" .. name) or getmat_text(name)))
			  or ((operator == "inscribe")
			    and (getmat("glyph_" .. name) or getmat(name)))
					or ((operator == "code") and getmat("event_" .. name))
					or ((operator == "log") and (getmat("logic_" .. name) ~= nil))
					or ((operator == "chart") and (getmat("orbit_" .. name) ~= nil))
			  then -- @Merge: Original glyph mod has "((string.sub(name, 1, 5) == "text_") and getmat_text(name))". I think this is its own version of metatext??? in which case maybe not include it?
				
				if (featureindex[name] ~= nil) and (alreadydone[name] == nil) then
					alreadydone[name] = 1

					for a,b in ipairs(featureindex[name]) do
						local rule = b[1]
						local conds = b[2]
						local target,verb,object = rule[1],rule[2],rule[3]

						if (verb == "is") or (verb == "become") then
							-- EDIT: add check for ECHO
							if (target == name) and (object ~= "word") and (object ~= "echo") and (object ~= "symbol") and ((object ~= name) or (verb == "become")) then
								if not is_str_broad_noun(object) and (object ~= "revert") and (object ~= "createall") and (not is_str_metalike_prop(object)) and (string.sub(object,1,4) ~= "meta") then
									if (object == "not " .. name) then
										table.insert(output, {"error", conds, "is"})

									elseif is_str_special_prefixed(object) then
										table.insert(output, {object, conds, "is"})
									else
										for d,mat in pairs(objectlist) do
											if (string.sub(d, 1, 5) ~= "group") and ((d == object)) then
												table.insert(output, {object, conds, "is"})
											end
										end
									end
								elseif (name ~= object) or (verb == "become") then
									if (object ~= "revert") and (not is_str_metalike_prop(object)) then --Note: I don't actually think meta/unmeta needs to be placed at the front.
										table.insert(output, {object, conds, "is"})
									else
										table.insert(output, 1, {object, conds, "is"})
									end
								end
							end
						elseif (verb == "write") then
							if (string.sub(object, 1, 4) ~= "not ") and (target == name) then
								if toometafunc("text_" .. object) then
									table.insert(output, {"toometa", conds, "is"})
                                    if objectlist["toometa"] == nil then
                                        objectlist["toometa"] = 1
                                        updatecode = 1
                                    end
                                else
									table.insert(output, {object, conds, "write"})
								end
							end
						elseif (verb == "log") then
							if (string.sub(object, 1, 4) ~= "not ") and (target == name) then
								if toometafunc("logic_" .. object) then
									table.insert(output, {"toometa", conds, "is"})
                                    if objectlist["toometa"] == nil then
                                        objectlist["toometa"] = 1
                                        updatecode = 1
                                    end
                                else
									table.insert(output, {object, conds, "log"})
								end
							end
						elseif (verb == "chart") then
							if (string.sub(object, 1, 4) ~= "not ") and (target == name) then
								if toometafunc("orbit_" .. object) then
									table.insert(output, {"toometa", conds, "is"})
                                    if objectlist["toometa"] == nil then
                                        objectlist["toometa"] = 1
                                        updatecode = 1
                                    end
                                else
									table.insert(output, {object, conds, "chart"})
								end
							end
						elseif (verb == "inscribe") then
							if (string.sub(object, 1, 4) ~= "not ") and (target == name) then
								if toometafunc("glyph_" .. object) then
									table.insert(output, {"toometa", conds, "is"})
                                    if objectlist["toometa"] == nil then
                                        objectlist["toometa"] = 1
                                        updatecode = 1
                                    end
                                else
									table.insert(output, {object, conds, "inscribe"})
								end
							end
						elseif (verb == "code") then
							if (string.sub(object, 1, 4) ~= "not ") and (target == name) then
								if toometafunc("event_" .. object) then
									table.insert(output, {"toometa", conds, "is"})
                                    if objectlist["toometa"] == nil then
                                        objectlist["toometa"] = 1
                                        updatecode = 1
                                    end
                                else
									table.insert(output, {object, conds, "code"})
								end
							end
						end
					end
				end
				
				if (#output > 0) then
					local conversions = {}
					
					for k,v3 in pairs(output) do
						local object = v3[1]
						local conds = v3[2]
						local op = v3[3]

						if (op == "is") then
							-- EDIT: add check for ECHO
							if (findnoun(object,nlist.brief) == false) and (object ~= "word") and (object ~= "echo") and (object ~= "symbol") and (not is_str_broad_noun(object)) and (not is_str_metalike_prop(object)) then
								table.insert(conversions, v3)
							elseif (object == "all") then
								--[[
								addaction(0,{"createall",{name,conds},dolevels})
								createall({name,conds})
								]]--
								table.insert(conversions, {"createall",conds})
							elseif (object == "text") or (object == "meta") then
								local valid = true -- don't attempt conversion if the object does not exist
								if unitreference["text_" .. name] == nil and ((unitreference[name] ~= nil and unitlists[name] ~= nil and #unitlists[name] > 0) or name == "empty" or name == "level") then
									valid = tryautogenerate("text_" .. name,name)
								end
								if valid then
									table.insert(conversions, {"text_" .. name,conds})
								end
							elseif (object == "unmeta") and string.sub(name,1,5) == "text_" then
								local valid = (getmat(string.sub(name,6)) ~= nil or unitreference[string.sub(name,6)] ~= nil) and not is_str_broad_noun(string.sub(name,6)) and (string.sub(name,6) ~= "all") -- don't attempt conversion if the object does not exist
								if unitreference[string.sub(name,6)] == nil and unitreference[name] ~= nil and unitlists[name] ~= nil and #unitlists[name] > 0 and is_str_special_prefixed(string.sub(name,6)) then
									valid = tryautogenerate(string.sub(name,6))
								end
								if valid then
									table.insert(conversions, {string.sub(name,6),conds})
								end
							elseif (object == "unmega") and string.sub(name,1,6) == "glyph_" then
								local valid = (getmat(string.sub(name,7)) ~= nil or unitreference[string.sub(name,7)] ~= nil) and not is_str_broad_noun(string.sub(name,7)) and (string.sub(name,7) ~= "all") -- don't attempt conversion if the object does not exist
								if unitreference[string.sub(name,7)] == nil and unitreference[name] ~= nil and unitlists[name] ~= nil and #unitlists[name] > 0 and is_str_special_prefixed(string.sub(name,7)) then
									valid = tryautogenerate(string.sub(name,7))
								end
								if valid then
									table.insert(conversions, {string.sub(name,7),conds})
								end
							elseif (object == "unmeea") and string.sub(name,1,6) == "event_" then
								local valid = (getmat(string.sub(name,7)) ~= nil or unitreference[string.sub(name,7)] ~= nil) and not is_str_broad_noun(string.sub(name,7)) and (string.sub(name,7) ~= "all") -- don't attempt conversion if the object does not exist
								if unitreference[string.sub(name,7)] == nil and unitreference[name] ~= nil and unitlists[name] ~= nil and #unitlists[name] > 0 and is_str_special_prefixed(string.sub(name,7)) then
									valid = tryautogenerate(string.sub(name,7))
								end
								if valid then
									table.insert(conversions, {string.sub(name,7),conds})
								end
							elseif (object == "unmena") and string.sub(name,1,5) == "node_" then
								local valid = (getmat(string.sub(name,6)) ~= nil or unitreference[string.sub(name,6)] ~= nil) and not is_str_broad_noun(string.sub(name,6)) and (string.sub(name,6) ~= "all") -- don't attempt conversion if the object does not exist
								if unitreference[string.sub(name,6)] == nil and unitreference[name] ~= nil and unitlists[name] ~= nil and #unitlists[name] > 0 and is_str_special_prefixed(string.sub(name,6)) then
									valid = tryautogenerate(string.sub(name,6))
								end
								if valid then
									table.insert(conversions, {string.sub(name,6),conds})
								end
							elseif (object == "unmela") and string.sub(name,1,6) == "logic_" then
								local valid = (getmat(string.sub(name,7)) ~= nil or unitreference[string.sub(name,7)] ~= nil) and not is_str_broad_noun(string.sub(name,7)) and (string.sub(name,7) ~= "all") -- don't attempt conversion if the object does not exist
								if unitreference[string.sub(name,7)] == nil and unitreference[name] ~= nil and unitlists[name] ~= nil and #unitlists[name] > 0 and is_str_special_prefixed(string.sub(name,7)) then
									valid = tryautogenerate(string.sub(name,7))
								end
								if valid then
									table.insert(conversions, {string.sub(name,7),conds})
								end
							elseif (object == "unmexa") and is_str_special_prefixed(name) then
								local unmetad = get_ref(name)
								local valid = (getmat(unmetad) ~= nil or unitreference[unmetad] ~= nil) and not is_str_broad_noun(unmetad) and (unmetad ~= "all") -- don't attempt conversion if the object does not exist
								if unitreference[unmetad] == nil and unitreference[name] ~= nil and unitlists[name] ~= nil and #unitlists[name] > 0 and is_str_special_prefixed(unmetad) then
									valid = tryautogenerate(unmetad)
								end
								if valid then
									table.insert(conversions, {unmetad,conds})
								end
							elseif (string.sub(object,1,4) == "meta") then
								local level = string.sub(object,5)
								if tonumber(level) ~= nil and tonumber(level) >= -1 then
									local newname = edit_str_meta_layer(name, level)
									local valid = true -- don't attempt conversion the if object does not exist
									if tonumber(level) >= 0 and unitreference[newname] == nil and ((unitreference[name] ~= nil and unitlists[name] ~= nil and #unitlists[name] > 0) or name == "empty" or name == "level") then
										if is_str_special_prefixed(newname) then
											valid = tryautogenerate(newname)
										else
											valid = false
										end
									end
									if valid then
										table.insert(conversions, {newname,conds})
									end
								end
							elseif (object == "glyph") or (object == "mega") then
								local valid = true -- don't attempt conversion if the object does not exist
								if unitreference["glyph_" .. name] == nil and ((unitreference[name] ~= nil and unitlists[name] ~= nil and #unitlists[name] > 0) or name == "empty" or name == "level") then
									valid = tryautogenerate("glyph_" .. name,name)
								end
								if valid then
									table.insert(conversions, {"glyph_" .. name,conds})
								end
							elseif (object == "event") or (object == "meea") then
								local valid = true -- don't attempt conversion if the object does not exist
								if unitreference["event_" .. name] == nil and ((unitreference[name] ~= nil and unitlists[name] ~= nil and #unitlists[name] > 0) or name == "empty" or name == "level") then
									valid = tryautogenerate("event_" .. name,name)
								end
								if valid then
									table.insert(conversions, {"event_" .. name,conds})
								end
							elseif (object == "node") or (object == "mena") then
								local valid = true -- don't attempt conversion if the object does not exist
								if unitreference["node_" .. name] == nil and ((unitreference[name] ~= nil and unitlists[name] ~= nil and #unitlists[name] > 0) or name == "empty" or name == "level") then
									valid = tryautogenerate("node_" .. name,name)
								end
								if valid then
									table.insert(conversions, {"node_" .. name,conds})
								end
							elseif (object == "logic") or (object == "mela") then
								local valid = true -- don't attempt conversion if the object does not exist
								if unitreference["logic_" .. name] == nil and ((unitreference[name] ~= nil and unitlists[name] ~= nil and #unitlists[name] > 0) or name == "empty" or name == "level") then
									valid = tryautogenerate("logic_" .. name,name)
								end
								if valid then
									table.insert(conversions, {"logic_" .. name,conds})
								end
							elseif (object == "orbit") then
								local valid = true -- don't attempt conversion if the object does not exist
								if unitreference["orbit_" .. name] == nil and ((unitreference[name] ~= nil and unitlists[name] ~= nil and #unitlists[name] > 0) or name == "empty" or name == "level") then
									valid = tryautogenerate("orbit_" .. name,name)
								end
								if valid then
									table.insert(conversions, {"orbit_" .. name,conds})
								end
							end
						elseif (op == "write") or (op == "inscribe") or (op == "draw") or (op == "log") or (op == "code") or (op == "chart") then
							table.insert(conversions, v3)
						end
					end
					
					if (#conversions > 0) then
						convert(name,conversions,dolevels)
					end
				end
			end
		end
	end
end

function convert(stuff,mats,dolevels_)
	local layer = map[0]
	local delthese = {}
	local mat1 = stuff
	local dolevels = dolevels_ or false
	local donewid = false

	if (dolevels == false) then
		if (mat1 ~= "empty") then
			local targets = {}

			if (unitlists[mat1] ~= nil) then
				targets = unitlists[mat1]
			end

			if (editor2.values[CURSORSEXIST] == 1) then
				if (featureindex[mat1] ~= nil) then
					for i,v in ipairs(featureindex[mat1]) do
						local rule = v[1]

						if (rule[2] == "is") and (rule[3] == "select") then
							editor.values[NAMEFLAG] = 0
							break
						end
					end
				end
			end

			if (#targets > 0) then
				for i,mat in pairs(mats) do
					if (mat[1] == "createall") then
						donewid = true
						break
					end
				end

				for i,unitid in pairs(targets) do
					local unit = mmf.newObject(unitid)
					local x,y,dir,id = unit.values[XPOS],unit.values[YPOS],unit.values[DIR],unit.values[ID]
					local name = getname(unit)

					local reverting = false
					local mats2 = {}

					if (unit.flags[CONVERTED] == false) then
						for a,matdata in pairs(mats) do
							local mat2 = matdata[1]
							local conds = matdata[2]
							local op = matdata[3]

							if (op == "write") then
								mat2 = "text_" .. matdata[1]
							elseif (op == "inscribe") then
								mat2 = "glyph_" .. matdata[1]
							elseif (op == "log") then
								mat2 = "logic_" .. matdata[1]
							elseif (op == "chart") then
								mat2 = "orbit_" .. matdata[1]
							end

							if (reverting == false) then
								local objectfound = false

								if (unitreference[mat2] ~= nil) and (mat2 ~= "level") then
									local object = unitreference[mat2]

									if (tileslist[object]["name"] == mat2) and ((changes[object] == nil) or (changes[object]["name"] == nil)) then
										objectfound = true
									elseif (changes[object] ~= nil) then
										if (changes[object]["name"] ~= nil) and (changes[object]["name"] == mat2) then
											objectfound = true
										end
									end
								else
									objectfound = true
								end

								if testcond(conds,unit.fixed) and objectfound then
									local ingameid = 0
									if (a == 1) and (donewid == false) then
										ingameid = id
									elseif (a > 1) or donewid then
										ingameid = newid()
									end

									if (mat2 == "revert") then
										if (unit.strings[UNITNAME] ~= unit.originalname) then
											reverting = true
										end
									end

									if (mat2 ~= "revert") or ((mat2 == "revert") and reverting) then
										table.insert(mats2, {mat2,ingameid,id})
										unit.flags[CONVERTED] = true
									end
								end
							else
								break
							end
						end
					end

					if (#mats2 > 0) then
						addaction(unit.fixed,{"convert",mats2})
					end
				end
			end
		elseif (mat1 == "empty") then
			local convunitmap = {}

			for a,unit in pairs(units) do
				local tileid = unit.values[XPOS] + unit.values[YPOS] * roomsizex
				convunitmap[tileid] = 1
			end

			for i=0,roomsizex-1 do
				for j=0,roomsizey-1 do
					local empty = true
					local mats2 = {}

					local tileid = i + j * roomsizex
					if (convunitmap[tileid] ~= nil) then
						empty = false
					end

					if (emptydata[tileid] ~= nil) then
						if (emptydata[tileid]["conv"] ~= nil) and emptydata[tileid]["conv"] then
							empty = false
						end
					end

					if (layer:get_x(i,j) ~= 255) then
						empty = false
					end

					if empty then
						for a,matdata in pairs(mats) do
							local mat2 = matdata[1]
							local conds = matdata[2]
							local op = matdata[3]

							if (op == "write") then
								mat2 = "text_" .. matdata[1]
							elseif (op == "log") then
								mat2 = "logic_" .. matdata[1]
							elseif (op == "inscribe") then
								mat2 = "glyph_" .. matdata[1]
							elseif (op == "chart") then
								mat2 = "orbit_" .. matdata[1]
							end

							local objectfound = false

							if (unitreference[mat2] ~= nil) and (mat2 ~= "level") then
								local object = unitreference[mat2]

								if (tileslist[object]["name"] == mat2) and ((changes[object] == nil) or (changes[object]["name"] == nil)) then
									objectfound = true
								elseif (changes[object] ~= nil) then
									if (changes[object]["name"] ~= nil) and (changes[object]["name"] == mat2) then
										objectfound = true
									end
								end
							elseif (mat2 ~= "revert") then
								objectfound = true
							end

							if (mat2 ~= "empty") and objectfound then
								if testcond(conds,2,i,j) then
									table.insert(mats2, {mat2,i,j})
								end
							end
						end
					end

					if (#mats2 > 0) then
						addaction(2,{"emptyconvert",mats2})
					end
				end
			end
		end
	end

	if (mat1 == "level") and dolevels then
		for i,v in ipairs(mats) do
			table.insert(levelconversions, v)
		end
	end
end

function dolevelconversions()
	if (#features > 0) and (generaldata.values[WINTIMER] == 0) and (destroylevel_check == false) then
		local mats = levelconversions
		local mat1 = "level"
		local levelmats = {}

		local revert = false

		for i,matdata in pairs(mats) do
			local conds = matdata[2]
			local mat2 = matdata[1]
			local op = matdata[3]

			if (op == "write") then
				mat2 = "text_" .. matdata[1]
			end

			if (op == "inscribe") then
				mat2 = "glyph_" .. matdata[1]
			end

			local objectfound = false

			if (unitreference[mat2] ~= nil) then
				local object = unitreference[mat2]

				if (tileslist[object]["name"] == mat2) and ((changes[object] == nil) or (changes[object]["name"] == nil)) then
					objectfound = true
				elseif (changes[object] ~= nil) then
					if (changes[object]["name"] ~= nil) and (changes[object]["name"] == mat2) then
						objectfound = true
					end
				end
			elseif (mat2 == "error") and testcond(conds,1) then
				destroylevel()
			elseif (mat2 == "revert") then
				objectfound = true
			end

			if testcond(conds,1) and objectfound then
				if (mat2 ~= "revert") then
					table.insert(levelmats, mat2)
					MF_alert("Converting level into " .. mat2)
				else
					revert = true
					levelmats = {"revert"}
					break
				end
			end
		end

		if (#levelmats > 0) and (#levelmats < 50) then
			if (editor.values[INEDITOR] == 0) then
				if (revert == false) then
					level_to_convert = {generaldata.strings[CURRLEVEL], levelmats}

					local savestring = ""
					for a,b in pairs(levelmats) do
						savestring = savestring .. b .. ","
					end

					local upperlevel = leveltree[#leveltree - 1] or generaldata.strings[CURRLEVEL]
					local convertdata = MF_read("save",generaldata.strings[WORLD] .. "_" .. upperlevel .. "_convert","converts")
					local levelconverts = tonumber(convertdata) or 0
					local idtostore = levelconverts

					if (levelconverts == 0) then
						local totalconverts = tonumber(MF_read("save",generaldata.strings[WORLD] .. "_converts","total")) or 0
						MF_store("save",generaldata.strings[WORLD] .. "_converts",tostring(totalconverts),generaldata.strings[WORLD] .. "_" .. upperlevel .. "_convert")
						totalconverts = totalconverts + 1
						MF_store("save",generaldata.strings[WORLD] .. "_converts","total",tostring(totalconverts))
					end

					if (levelconverts > 0) then
						for a=1,levelconverts do
							local result = string.find("___" .. MF_read("save",generaldata.strings[WORLD] .. "_" .. upperlevel .. "_convert",tostring(a-1)), "___" .. generaldata.strings[CURRLEVEL])

							if (result ~= nil) then
								idtostore = a - 1
							end
						end
					end

					MF_store("save",generaldata.strings[WORLD] .. "_" .. upperlevel .. "_convert",tostring(idtostore),generaldata.strings[CURRLEVEL] .. "," .. savestring)

					if (idtostore == levelconverts) then
						levelconverts = levelconverts + 1

						MF_store("save",generaldata.strings[WORLD] .. "_" .. upperlevel .. "_convert","converts",tostring(levelconverts))
					end
				else
					level_to_convert = {generaldata.strings[CURRLEVEL], levelmats}

					local upperlevel = leveltree[#leveltree - 1] or generaldata.strings[CURRLEVEL]
					local convertdata = MF_read("save",generaldata.strings[WORLD] .. "_" .. upperlevel .. "_convert","converts")
					local levelconverts = tonumber(convertdata) or 0

					local found = -1

					if (levelconverts > 0) then
						for a=1,levelconverts do
							local result = string.find("___" .. MF_read("save",generaldata.strings[WORLD] .. "_" .. upperlevel .. "_convert",tostring(a-1)), "___" .. generaldata.strings[CURRLEVEL])

							if (result ~= nil) then
								found = a
							end

							if (found > 0) and (a > found) then
								local newa = a - 1
								local datatostore = MF_read("save",generaldata.strings[WORLD] .. "_" .. upperlevel .. "_convert",tostring(a-1))
								MF_store("save",generaldata.strings[WORLD] .. "_" .. upperlevel .. "_convert",tostring(newa-1),datatostore)
							end
						end
					end

					if (found > 0) then
						levelconverts = levelconverts - 1

						if (levelconverts > 0) then
							MF_store("save",generaldata.strings[WORLD] .. "_" .. upperlevel .. "_convert","converts",tostring(levelconverts))
						else
							MF_deletesave_group(generaldata.strings[WORLD] .. "_" .. upperlevel .. "_convert","converts")

							local totalconverts = tonumber(MF_read("save",generaldata.strings[WORLD] .. "_converts","total"))
							local found2 = -1

							if (totalconverts ~= nil) then
								for a=1,totalconverts do
									local result = string.find("___" .. MF_read("save",generaldata.strings[WORLD] .. "_converts",tostring(a-1)), "___" .. generaldata.strings[WORLD] .. "_" .. upperlevel .. "_convert")

									if (result ~= nil) then
										found2 = a
									end

									if (found2 > 0) and (a > found2) then
										local newa = a - 1
										local datatostore = MF_read("save",generaldata.strings[WORLD] .. "_converts",tostring(a-1))
										MF_store("save",generaldata.strings[WORLD] .. "_converts",tostring(newa-1),datatostore)
									end
								end
							end

							if (found2 > 0) then
								totalconverts = totalconverts - 1

								if (totalconverts > 0) then
									MF_store("save",generaldata.strings[WORLD] .. "_converts","total",tostring(totalconverts))
								else
									MF_deletesave_group(generaldata.strings[WORLD] .. "_converts")
								end
							end
						end
					end
				end

				uplevel()
			else
				level_to_convert = {}
			end

			MF_levelconversion()
		elseif (#levelmats >= 50) then
			HACK_INFINITY = 200
			destroylevel("toocomplex")
		end

		levelconversions = {}
	end
end

function doconvert(data,extrarule_)
	local style = data[2]
	local mats2 = data[3]
	
	local unitid = data[1]
	local unit = {}
	local x,y,dir,name,id,completed,float,ogname = 0,0,0,"",0,0,0,""
	local delthis = false
	local delthis_createall = false
	local delthis_createall_ = false
	
	if (unitid ~= 2) then
		unit = mmf.newObject(unitid)
		x,y,dir,name,id,completed,ogname = unit.values[XPOS],unit.values[YPOS],unit.values[DIR],unit.strings[UNITNAME],unit.values[ID],unit.values[COMPLETED],unit.originalname
	end
	
	local cdata = {}
	cdata[1] = name
	
	if (style == "convert") then
		for a,mats2data in ipairs(mats2) do
			local mat2 = mats2data[1]
			local ingameid = mats2data[2]
			local baseingameid = mats2data[3]
			
			local unitname = ""
			
			if (mat2 == "revert") and (unitid ~= 2) and (ogname ~= nil) then
				local originalname = ogname
				
				if (string.len(originalname) > 0) then
					unitname = unitreference[originalname]
					mat2 = originalname
				else
					unitname = nil
				end
				
				if (source == "emptyconvert") then
					unitname = ""
					mat2 = "empty"
				end
				
				if (unitname == unit.className) then
					MF_alert("Trying to revert object to the same thing: " .. tostring(originalname))
					return
				end
			elseif (mat2 == "revert") and (unitid == 2) then
				MF_alert("Trying to revert empty")
				return
			end
			
			if (mat2 ~= "empty") and (mat2 ~= "error") and (mat2 ~= "revert") and (mat2 ~= "createall") then
				if (mats2data[1] ~= "revert") then
					unitname = unitreference[mat2]
				end
				
				if (mat2 == "level") then
					unitname = "level"
				end
				
				if (unitname == nil) then
					MF_alert("no className found for " .. mat2 .. "!")
					return
				end
				
				local newunitid = MF_emptycreate(unitname,x,y)
				local newunit = mmf.newObject(newunitid)
				
				newunit.values[ONLINE] = 1
				newunit.values[XPOS] = x
				newunit.values[YPOS] = y
				newunit.values[DIR] = dir
				newunit.values[POSITIONING] = 20
				
				newunit.values[VISUALLEVEL] = unit.values[VISUALLEVEL]
				newunit.values[VISUALSTYLE] = unit.values[VISUALSTYLE]
				newunit.values[COMPLETED] = completed
				
				newunit.strings[COLOUR] = unit.strings[COLOUR]
				newunit.strings[CLEARCOLOUR] = unit.strings[CLEARCOLOUR]
				
				if (unitname == "level") then
					newunit.values[COMPLETED] = math.max(completed, 1)
					newunit.flags[LEVEL_JUSTCONVERTED] = true
					
					if (string.len(unit.strings[LEVELFILE]) > 0) then
						newunit.values[COMPLETED] = math.max(completed, 2)
					end
					
					if (string.len(unit.strings[COLOUR]) == 0) or (string.len(unit.strings[CLEARCOLOUR]) == 0) then
						newunit.strings[COLOUR] = "1,2"
						newunit.strings[CLEARCOLOUR] = "1,3"
						MF_setcolour(newunitid,1,2)
					else
						local c = MF_parsestring(unit.strings[COLOUR])
						MF_setcolour(newunitid,c[1],c[2])
					end
					
					newunit.visible = true
				end
				
				newunit.values[ID] = ingameid
				
				newunit.strings[U_LEVELFILE] = unit.strings[U_LEVELFILE]
				newunit.strings[U_LEVELNAME] = unit.strings[U_LEVELNAME]
				newunit.flags[MAPLEVEL] = unit.flags[MAPLEVEL]
				
				newunit.values[EFFECT] = 1
				newunit.flags[9] = true
				newunit.flags[CONVERTED] = true
				
				cdata[2] = mat2
				
				addundo({"convert",cdata[1],cdata[2],ingameid,baseingameid,x,y,dir})
				addundo({"create",mat2,ingameid,baseingameid,"convert",x,y,dir})
				
				addunit(newunitid)
				addunitmap(newunitid,x,y,newunit.strings[UNITNAME])
				poscorrect(newunitid,generaldata2.values[ROOMROTATION],generaldata2.values[ZOOM],0)
				
				if (spritedata.values[VISION] == 0) or ((newunit.values[TILING] == 1) and (newunit.values[ZLAYER] <= 10) and (newunit.values[ZLAYER] >= 0)) then
					dynamic(newunitid)
				end
				
				newunit.new = false
				newunit.originalname = unit.originalname
				
				if (newunit.strings[UNITTYPE] == "text" or newunit.strings[UNITTYPE] == "node" or newunit.strings[UNITTYPE] == "logic") or (newunit.strings[UNITTYPE] == "orbit") then
					updatecode = 1
				else
					local newname = newunit.strings[UNITNAME]
					local notnewname = "not " .. newunit.strings[UNITNAME]
					
					if (featureindex["word"] ~= nil) then
						for i,v in ipairs(featureindex["word"]) do
							local rule = v[1]
							local conds = v[2]
							
							if (rule[2] == "is") and (rule[3] == "word") then
								if (rule[1] == newname) then
									updatecode = 1
									break
								elseif (unitid ~= 2) then
									if (rule[1] == unitname) then
										updatecode = 1
										break
									end
								end
								
								if (#conds > 0) then
									for a,b in ipairs(conds) do
										if (b[2] ~= nil) and (#b[2] > 0) then
											for c,d in ipairs(b[2]) do
												if (d == newname) or ((string.sub(d, 1, 4) == "not ") and (string.sub(d, 5) ~= newname)) then
													updatecode = 1
													break
												elseif (unitid ~= 2) then
													if (d == unitname) or ((string.sub(d, 1, 4) == "not ") and (string.sub(d, 5) ~= unitname)) then
														updatecode = 1
														break
													end
												end
											end
										end
									end
								end
							end
						end
					end
                    if (featureindex["break"] ~= nil) then
						for i,v in ipairs(featureindex["break"]) do
							local rule = v[1]
							local conds = v[2]
							
							if (rule[2] == "is") and (rule[3] == "break") then
								if (rule[1] == newname) then
									updatecode = 1
									break
								elseif (unitid ~= 2) then
									if (rule[1] == unitname) then
										updatecode = 1
										break
									end
								end
								
								if (#conds > 0) then
									for a,b in ipairs(conds) do
										if (b[2] ~= nil) and (#b[2] > 0) then
											for c,d in ipairs(b[2]) do
												if (d == newname) or ((string.sub(d, 1, 4) == "not ") and (string.sub(d, 5) ~= newname)) then
													updatecode = 1
													break
												elseif (unitid ~= 2) then
													if (d == unitname) or ((string.sub(d, 1, 4) == "not ") and (string.sub(d, 5) ~= unitname)) then
														updatecode = 1
														break
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end
				
				delthis = true
			elseif (mat2 == "error") then
				if (unitid ~= 2) then
					local unit = mmf.newObject(unitid)
					local x,y = unit.values[XPOS],unit.values[YPOS]
					local pmult,sound = checkeffecthistory("paradox")
					local c1,c2 = getcolour(unitid)
					MF_particles("unlock",x,y,20 * pmult,c1,c2,1,1)
					--paradox[id] = 1
				end
				
				delthis = true
			elseif (mat2 == "empty") then
				addundo({"convert",cdata[1],"empty",ingameid,baseingameid,x,y,dir})
				updateunitmap(unitid,x,y,x,y,unit.strings[UNITNAME])
				delthis = true
				
				local tileid = x + y * roomsizex
				if (emptydata[tileid] == nil) then
					emptydata[tileid] = {}
				end
				
				emptydata[tileid]["conv"] = true
			elseif (mat2 == "createall") then
				delthis_createall = createall_single(unitid)
				delthis = delthis_createall
				delthis_createall_ = true
			end
		end
		
		if delthis_createall_ and (delthis_createall == false) and delthis then
			delthis = false
		end
		
		if delthis and (unit.flags[DEAD] == false) then
			addundo({"remove",unit.strings[UNITNAME],unit.values[XPOS],unit.values[YPOS],unit.values[DIR],unit.values[ID],unit.values[ID],unit.strings[U_LEVELFILE],unit.strings[U_LEVELNAME],unit.values[VISUALLEVEL],unit.values[COMPLETED],unit.values[VISUALSTYLE],unit.flags[MAPLEVEL],unit.strings[COLOUR],unit.strings[CLEARCOLOUR],unit.followed,unit.back_init,unit.originalname,unit.strings[UNITSIGNTEXT]})

			if (unit.strings[UNITTYPE] == "text" or unit.strings[UNITTYPE] == "node" or unit.strings[UNITTYPE] == "logic" or (newunit.strings[UNITTYPE] == "orbit")) then
				updatecode = 1
			end
			
			delunit(unitid)
			dynamic(unitid)
			MF_specialremove(unitid,2)
		end
	elseif (style == "emptyconvert") then
		for a,mats2data in ipairs(mats2) do
			local mat2 = mats2data[1]
			local i = mats2data[2]
			local j = mats2data[3]
			
			if (mat2 ~= "createall") and (mat2 ~= "error") then
				local unitname = unitreference[mat2]
				local newunitid = MF_emptycreate(unitname,i,j)
				local newunit = mmf.newObject(newunitid)
				
				cdata[1] = "empty"
				
				local id = newid()
				local dir = emptydir(i,j)
				
				if (dir == 4) then
					dir = fixedrandom(0,3)
				end
				
				newunit.values[ONLINE] = 1
				newunit.values[XPOS] = i
				newunit.values[YPOS] = j
				newunit.values[DIR] = dir
				newunit.values[ID] = id
				newunit.values[EFFECT] = 1
				newunit.flags[9] = true
				newunit.flags[CONVERTED] = true
				
				cdata[2] = mat2
				addundo({"convert",cdata[1],cdata[2],id,id,i,j,dir})
				addundo({"create",mat2,id,-1,"emptyconvert",i,j,dir})
				
				addunit(newunitid)
				addunitmap(newunitid,i,j,newunit.strings[UNITNAME])
				dynamic(newunitid)
				
				newunit.originalname = "empty"
				
				local tileid = i + j * roomsizex
				if (emptydata[tileid] == nil) then
					emptydata[tileid] = {}
				end
				
				emptydata[tileid]["conv"] = true
				
				if (newunit.strings[UNITTYPE] == "text" or newunit.strings[UNITTYPE] == "node") then
					updatecode = 1
				else
					if (featureindex["word"] ~= nil) then
						for i,v in ipairs(featureindex["word"]) do
							local rule = v[1]
							if (rule[1] == newunit.strings[UNITNAME]) then
								updatecode = 1
							elseif (unitid ~= 2) then
								if (rule[1] == unit.strings[UNITNAME]) then
									updatecode = 1
								end
							end
						end
					end
                    if (featureindex["break"] ~= nil) then
						for i,v in ipairs(featureindex["break"]) do
							local rule = v[1]
							if (rule[1] == newunit.strings[UNITNAME]) then
								updatecode = 1
							elseif (unitid ~= 2) then
								if (rule[1] == unit.strings[UNITNAME]) then
									updatecode = 1
								end
							end
						end
					end
				end
			elseif (mat2 == "createall") then
				createall_single(2,nil,i,j)
			end
		end
	end
end
