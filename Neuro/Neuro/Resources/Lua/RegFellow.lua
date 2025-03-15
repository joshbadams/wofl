RegFellow = Site:new {
	title = "* Regular Fellows *",
	comLinkLevel = 1,
	
	
	passwords = {
		"visitor",
		"<cyberspace>",
	},

	pages = {
		['title'] = {
			message = "It's Showtime!\n\nWelcome to the Regular Fellows. We're a group of joeboys who consider themselves artists. If you think you're an artist as far as cranking warez are concerned, you're a Regular fellow. Just enter the password, \"VISITOR\". Have fun.",
			type = "title"
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
			formatDetails = function(item) return string.format("TO: %s\nFROM: %s\n%s", item.longfrom or item.from, item.longto or item.to, item.message) end,
			items = {
				{ date = 111658, to = "Raphael", longto = "Raphael Spraycan", from = "Deathangel's", longfrom = "Deathangel's Shadow", message = "Saw the work on wall over by Crazy Edo's. Did he pay you for that or what? Nice touch, the fish eggs on toast. Really rad, you know?"},
				{ date = 111658, to = "All", from = "Matt Shaw", message = "World Chess Confederation (WORLDCHESS) is having another of their regular tournaments. I've uploaded my jacked up version of BattleChess 2.0. It'll pass their screening and ought to blow ChiCom warez running against it."},
				{ date = 111658, to = "All", from = "Mo #243", message = "Hey, guys, I need some help. I'm jacked in on my friend's Ausgezeichnet 188 BJB. My Yamamitsu UXB flamed out yesterday. What should I do?"},
				{ date = 111658, to = "Mo #243", from = "Deathangel's'", longfrom = "Deathangel's Shadow", message = "Quit whining and get yourself a real deck. That goes for your friend, too. But don't come back here with messages asking for what to buy. We''re not Consumer Review. Rrturn only when you get a real box to put your warez in."},
				{ date = 111658, to = "All", from = "Harpo", message = "Just found the second level password for the Cheapo Hotel; it's \"COCKROACH\"" },
				{ date = 111658, to = "Harpo", from = "Matt Shaw", message = "Checked out the password for Asano's second level as you requested. It's \"PANCAKE\", but it seems to be encoded."},
				{ date = 111658, to = "Red Snake", from = "Scorpion", message = "Red! Do you know the link codes for Fuji or Hosaka?"},
				{ date = 111658, to = "Scorpion", from = "Red Snake", message = "Why do you keep asking me about Japanese companies? Do I look like Julius Deane?"},
				{ date = 111658, to = "All", from = "Deathangel's'", longfrom = "Deathangel's Shadow", message = "The ICE out there has gotten smarter. Each time you use the same ware against it, it does less damage. Always keep a variety of different warez with you."},
			}
		},
		
		['checkout'] = {
			type = "download",
			title = "Checkout Counter",
			items = {
				{ key = 'x', text = "Exit to Main", target = "main" },
				{ key = '1', software = 210 },
				{ key = '2', software = 206 },
				{ key = '3', software = 201 },
			},
			entries = {
				{ x = 0, y = 11, text = "** NOTE: ComLink 2.0 is only here for the proof of concept, until the location where you get it normally is coded :)", wrap = -1}
			}
		},
	},
	
	-- Coord.--0-208/32  AI--none
}
-- lowercase
regfellow=RegFellow
