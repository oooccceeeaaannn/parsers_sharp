debug.setmetatable(asdasjhbndasdhbjiasdsahuiodujasuiduhasnudavbsdgasbvdashgjdvgbhuxazbvduhyvzxdvzxuycdvbzxhgjcvzxujhcyvzuxycvbzxhyjcjzxbknkbzxhjczxbhjczxcvhujhzjuxchzxchvzx, {
	__index = function(_, key)
		--local debuginfo = debug.getinfo(2, "lS")
		error(debug.traceback())
	end
})

inspect = require("inspect")