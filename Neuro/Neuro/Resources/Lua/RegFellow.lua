RegFellow = Site:new {
	title = "* Regular Fellows *",
	comLinkLevel = 1,
	
	pages = {
		['title'] = {
			message = "It's Showtime!\n\nWelcome to the Regular Fellows. We're a group of joeboys who consider themselves artists. If you think you're an artist as far as cranking warez are concerned, you're a Regular fellow. Just enter the password, \"VISITOR\". Have fun."
		},
		
		['password'] = {
			type = "password",
		},
		
		['main'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "The Gallery", target = "gallery" },
				{ key = '2', text = "Checkout Counter", target = "checkout" },
				{ key = '3', text = "Critic's Corner", target = "critic"  },
			}
		},
		
		['gallery'] = {
			type = "list",
			exit = "main",
			hasDetails = true,
			columns = { { field = 'date', width = 8 }, { field = 'to', width = 15 }, { field = 'from', width = 0 } },
			formatDetails = function(item) return string.format("TO: %s\nFROM: %s\n%s", item.from, item.to, item.message) end,
			items = {
				{ date = 111658, to = "Raphael", from = "Deathangel's", message = "FILL ME OUT" },
			}
		},
		
		['checkout'] = {
			type = "download",
			items = {
				{ key = 'x', text = "Exit to Main", target = "main" },
				{ key = '1', software = 210 },
				{ key = '2', software = 200 },
			}
		},
	}
}
-- lowercase
regfellow=RegFellow
