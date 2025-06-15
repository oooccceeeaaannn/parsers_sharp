function doorbit(centers)
	local orbitnouns = {}
	local orbitverbs = {}
	local orbitconds = {}

	for a,b in ipairs(centers) do
		if testcond(b[2],b[1]) then
			table.insert(orbitnouns, mmf.newObject(b[1]))
		end
	end

	for a,b in ipairs(units) do
		local bunitid = b.fixed
		local bname = b.strings[UNITNAME]

		if string.sub(bname, 1, 6) == "orbit_" then
			if (orbit_types[bname] == 0) then
				table.insert(orbitnouns, b)
			elseif (orbit_types[bname] == 1) then
				table.insert(orbitverbs, b)
			elseif (orbit_types[bname] == 3) then
				table.insert(orbitconds, b)
			end
		end
	end

	for a,b in ipairs(orbitnouns) do
		local conds = {}
		local condids = {}
		
		for c,d in ipairs(orbitconds) do
			local nx, ny = b.values[XPOS], b.values[YPOS]
			local vx, vy = d.values[XPOS], d.values[YPOS]
			local cx, cy = nx-vx, ny-vy
			local allhere = findallhere(nx + cx, ny + cy) or {}

			if not inbounds(nx + cx, ny + cy) then
				allhere = {}
			end

			local arg = orbit_argtypes[d.strings[UNITNAME]]

			for e,f in ipairs(allhere) do
				local funit = mmf.newObject(f)
				local fname = funit.strings[UNITNAME]

				if (string.sub(fname, 1, 6) == "orbit_") then
					if arg then
						for g,h in ipairs(arg) do
							if (h == orbit_types[funit.strings[UNITNAME]]) or ((b.strings[UNITTYPE] ~= "orbit") and hasfeature(getname(b), "is", "center") and (h == 0)) then
								local subconds = {}
								if (h ~= -1) then
									table.insert(subconds, string.sub(fname, 7))
								end
								table.insert(conds, {string.sub(d.strings[UNITNAME], 7),subconds})
								table.insert(condids, {d.fixed})
								table.insert(condids, {f})
							end
						end
					end
				end
			end
		end

		for c,d in ipairs(orbitverbs) do
			local nx, ny = b.values[XPOS], b.values[YPOS]
			local vx, vy = d.values[XPOS], d.values[YPOS]
			local cx, cy = nx-vx, ny-vy
			local allhere = findallhere(nx + cx, ny + cy) or {}

			if not inbounds(nx + cx, ny + cy) then
				allhere = {}
			end

			local arg = orbit_argtypes[d.strings[UNITNAME]]
			local option = {string.sub(b.strings[UNITNAME], 7), string.sub(d.strings[UNITNAME], 7)}

			if (string.sub(b.strings[UNITNAME], 1, 6) ~= "orbit_") then
				option[1] = getname(b)
			end

			local ids = clonetable(condids)

			table.insert(ids, {b.fixed})
			table.insert(ids, {d.fixed})

			for e,f in ipairs(allhere) do
				local funit = mmf.newObject(f)
				local fname = funit.strings[UNITNAME]

				if (string.sub(fname, 1, 6) == "orbit_") then
					local thisruleoption = clonetable(option)
					local thisruleids = clonetable(ids)

					table.insert(thisruleoption, string.sub(fname, 7))
					table.insert(thisruleids, {f})

					for g,h in ipairs(arg) do
						if (h == orbit_types[funit.strings[UNITNAME]]) then
							addoption(thisruleoption,conds,thisruleids,true,nil,{"orbit"})
						end
					end
				end
			end
		end
	end
end

function clonetable(toclone)
	if toclone then
		local cloned = {}
		
		for i,v in ipairs(toclone) do
			table.insert(cloned, v)
	    	end
		
		return cloned
	end

	return nil
end


function orbitbaserule()
	addbaserule("orbit", "is", "push")
end

function chartfix()
	for a, b in ipairs(units) do
		if b.strings[UNITTYPE] == "object" then
			objectlist["orbit_" .. b.strings[UNITNAME]] = 1
		end
		if b.strings[UNITTYPE] == "text" then
			local textrefer = string.sub(b.strings[UNITNAME], 6)
			objectlist["orbit_" .. textrefer] = 1
		end
		if b.strings[UNITTYPE] == "orbit" then
			if orbit_types[b.strings[UNITNAME]] == 0 then
				local orbitrefer = string.sub(b.strings[UNITNAME], 7)
				objectlist[orbitrefer] = 1
			end
		end
	end
end

table.insert(mod_hook_functions.rule_baserules, orbitbaserule)
table.insert(mod_hook_functions.level_start, chartfix)

function findcenterunits()
	local result = {}
	local alreadydone = {}
	local checkrecursion = {}
	local related = {}

	local identifier = ""
	local fullid = {}

	if (featureindex["center"] ~= nil) then
		for i, v in ipairs(featureindex["center"]) do
			local rule = v[1]
			local conds = v[2]
			local ids = v[3]

			local name = rule[1]
			local subid = ""

			if (rule[2] == "is") then
				if ((objectlist[name] ~= nil) or (name == "text")) and (name ~= "orbit") and (alreadydone[name] == nil) then
					local these = findall({ name, {} })
					alreadydone[name] = 1

					if (#these > 0) then
						for a, b in ipairs(these) do
							local bunit = mmf.newObject(b)
							local unitname = ""
							if (name == "orbit") then
								unitname = bunit.strings[UNITNAME]
							else
								unitname = name
							end
							local valid = true

							if (featureindex["broken"] ~= nil) then
								if (hasfeature(getname(bunit), "is", "broken", b, bunit.values[XPOS], bunit.values[YPOS]) ~= nil) then
									valid = false
								end
							end

							if valid then
								table.insert(result, { b, conds })
								subid = subid .. unitname
								-- LISÄÄ TÄHÄN LISÄÄ DATAA
							end
						end
					end
				end

				if (#subid > 0) then
					for a, b in ipairs(conds) do
						local condtype = b[1]
						local params = b[2] or {}

						subid = subid .. condtype

						if (#params > 0) then
							for c, d in ipairs(params) do
								subid = subid .. tostring(d)

								related = findunits(d, related, conds)
							end
						end
					end
				end

				table.insert(fullid, subid)

				--MF_alert("Going through " .. name)

				if (#ids > 0) then
					if (#ids[1] == 1) then
						local firstunit = mmf.newObject(ids[1][1])

						local notname = name
						if (string.sub(name, 1, 4) == "not ") then
							notname = string.sub(name, 5)
						end

						if (firstunit.strings[UNITNAME] ~= "text_" .. name) and (firstunit.strings[UNITNAME] ~= "text_" .. notname) and (firstunit.strings[UNITNAME] ~= "orbit_" .. name) and (firstunit.strings[UNITNAME] ~= "orbit_" .. notname) then
							--MF_alert("Checking recursion for " .. name)
							table.insert(checkrecursion, { name, i })
						end
					end
				else
					MF_alert(
						"No ids listed in Word-related rule! rules.lua line 1302 - this needs fixing asap (related to grouprules line 1118)")
				end
			end
		end

		table.sort(fullid)
		for i, v in ipairs(fullid) do
			-- MF_alert("Adding " .. v .. " to id")
			identifier = identifier .. v
		end

		--MF_alert("Identifier: " .. identifier)

		for a, checkname_ in ipairs(checkrecursion) do
			local found = false

			local checkname = checkname_[1]

			local b = checkname
			if (string.sub(b, 1, 4) == "not ") then
				b = string.sub(checkname, 5)
			end

			for i, v in ipairs(featureindex["center"]) do
				local rule = v[1]
				local ids = v[3]
				local tags = v[4]

				if (rule[1] == b) or ((rule[1] == "orbit") and (string.sub(b, 1, 6) == "orbit_")) or (rule[1] == "all") or ((rule[1] ~= b) and (string.sub(rule[1], 1, 3) == "not")) and (rule[3] == "center") then
					for c, g in ipairs(ids) do
						for a, d in ipairs(g) do
							local idunit = mmf.newObject(d)

							-- Tässä pitäisi testata myös Group!
							if ((idunit.strings[UNITNAME] == "text_" .. rule[1]) and (tags[1] ~= "orbit")) or (idunit.strings[UNITNAME] == "orbit_" .. rule[1]) or ((idunit.strings[UNITNAME] == rule[1]) and (tags[1] ~= "orbit")) or ((rule[1] == "all") and (rule[1] ~= "text")) then
								--MF_alert("Matching objects - found")
								found = true
							elseif (string.sub(rule[1], 1, 5) == "group") then
								--MF_alert("Group - found")
								found = true
							elseif (rule[1] ~= checkname) and (((string.sub(rule[1], 1, 3) == "not") and (rule[1] ~= "text")) or ((rule[1] == "not all") and (rule[1] == "text"))) then
								--MF_alert("Not Object - found")
								found = true
							end
						end
					end

					for c, g in ipairs(tags) do
						if (g == "mimic") then
							found = true
						end
					end
				end
			end

			if (found == false) then
				identifier = "null"
				centerunits = {}

				for i, v in pairs(featureindex["center"]) do
					local rule = v[1]
					local ids = v[3]

					--MF_alert("Checking to disable: " .. rule[1] .. " " .. ", not " .. b)

					if (rule[1] == b) or (rule[1] == "not " .. b) then
						v[2] = { { "never", {} } }
					end
				end

				if (string.sub(checkname, 1, 4) == "not ") then
					local notrules_center = notfeatures["center"]
					local notrules_id = checkname_[2]
					local disablethese = notrules_center[notrules_id]

					for i, v in ipairs(disablethese) do
						v[2] = { { "never", {} } }
					end
				end
			end
		end
	end

	--MF_alert("Current id (end): " .. identifier)

	return result, identifier, related
end

function checkcenterchanges(unitid, unitname)
	if (#centerunits > 0) then
		for i, v in ipairs(centerunits) do
			if (v[1] == unitid) then
				updatecode = 1
				return
			end
		end
	end

	if (#centerrelatedunits > 0) then
		for i, v in ipairs(centerrelatedunits) do
			if (v[1] == unitid) then
				updatecode = 1
				return
			end
		end
	end
end