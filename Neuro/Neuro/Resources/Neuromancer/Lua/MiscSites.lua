
BozoBank = ComingSoon:new {
	comLinkLevel = 6,
	passwords = {
		"<sequencer>"
	},
	
	baseX = 336,
	baseY = 368,
}
bozobank=BozoBank

Justice = ComingSoon:new {
	comLinkLevel = 6,
	passwords = {
		"<sequencer>"
	},
	
	baseX = 416,
	baseY = 112,
}
justice=Justice

FreeMatrix = ComingSoon:new {
	comLinkLevel = 5,
	passwords = {
		"CFM",
		"<cyberspace>"
	},
	
	baseX = 352,
	baseY = 112,
}
freematrix=FreeMatrix


Voyager = ComingSoon:new {
	comLinkLevel = 6,
	passwords = {
		"apollo",
		"<cyberspace>",
	},
	
	baseX = 448,
	baseY = 32,
}
voyager=Voyager





--------------------------------------------------------------------

x = Site:new {
	title = "* Software Enforcement Agency *",
	comLinkLevel = 3,
	passwords = {
		"permafrost",
		"<cyberspace>"
	},
	
	baseX = 352,
	baseY = 64,
	
	pages = {
		['title'] = {
			type = "title",
			message = " ",
		},

		['password'] = { type = "password" },

		['main'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "Supervisor's Memo", target = "memo" },
				{ key = '2', text = "Bulletin Board", target = "bbs" },
				{ key = '3', text = "Software Library", target = "library" },
				{ key = '4', text = "Skill Upgrade", target = "skills" },
				{ key = '5', text = "View Arrest Warrant List", target = "warrants" },
			}
		},
		
		['memo'] = {
			type = "message",
			message = "\nSEA FIELD SUPERVISORS:\n\nField Supervisors should take note of the new matrix simulator protection softwarez that have just been made available on this system. It will be the responsibility of the Field Supervisors to disseminate copies of these warez to their qualified cyberspace operatives.\nDue to the high number of requests for current information, the Administrative Bureau has approved the activation of of a question-and-answer bulletin board service should increase the speed of response for Field Supervisor information-gathering purposes.\n\nSEA FIELD AGENTS:\n\nField agents who would like to improve their interrogation and conversational abilities would be well advisted to make use of the COPTALK tutorial. Fourth level CopTalk ability is required for Senior Field Agent status. While this tutorial has been available to download for the last eight months, our records show that usage has been light. Let's see more ambition out there!"
		},
		
		['library'] = {
			type = "download",
			items = {
				{ key = 'x', text = "Exit to Main", target = "main" },
				{ key = '1', software = 202 }, -- COMLINK 4.0
				{ key = '2', software = 262 }, -- SEQUENCER
			}
		},

		['bbs'] = {
			type = "list",
			hasDetails = true,
			columns = { { field = 'date', width = 8 }, { field = 'to', width = 15 }, { field = 'from', width = 0 } },
			formatDetails = function(item)
				if (item.to == "SEA") then
					return string.format("Date: %s\nFrom: Gibson, W.\n%s", string.fromDate(item.date), item.message)
				else
					return string.format("Date: %s\nTo: Gibson, W.\n%s", string.fromDate(item.date), item.message)
				end
			end,
			items = {
				{ date = 111658, to = "SEA", from = "W. Gibson", message = "One of my field agents, working undercover as a cyberspace cowboy known as \"MR. DOS,\" seems to have vanished. He was on the trail of some microsoft design thieves in cyberspace when I last heard from him. Now he's been missing for two weeks. Has he been reassigned to a deep cover on another operation? Is he on loan to the Turing people? And why wasn't I informed that he was off my team?" },
				{ date = 111658, to = "W. Gibson", from = "SEA", message = "With regard to your missing field agent, operating as \"MR. DOS,\"we have no idea where he is. He has not been reassigned elsewhere. Maybe you misplaced him?" },
				{ date = 111658, to = "SEA", from = "W. Gibson", message = "Regarding my field agent, \"MR. DOS,\" I respectfully request an explanation as to how you think I could have misplaced him. This isn't a piece of software we're talking about. MR. DOS is a human field agent." },
				{ date = 111658, to = "W. Gibson", from = "SEA", message = "Solve your own problems. That's what we hired you for in the first place." },
			}
		},
		['skills']  = {
			type = "skills",
			items = {
				{ key = 'x', text = "Exit to Main", target = "main" },
				{ key = '1', skill = 400, level = 2 }
			}
		},
		['warrants'] = {
			type = "list",
--			title = "Arrest Warrants",
			hasDetails = true,
			columns = { { field = 'Name', width = 19 }, { field = 'BAMA ID', width = 0 } },
			formatDetails = function(item) return string.format("\n\nName: %s\nID:   %s\n%s", item.Name, item['BAMA ID'], item.message) end,
			items = {
				{ Name = "MATSUMOTU MIKI", ['BAMA ID'] = "781346759", message = "Wanted for Smuggling." },
				{ Name = "PARSIFAL", ['BAMA ID'] = "673638269", message = "Wanted for Piracy." },
				{ Name = "FARGO FERGUS", ['BAMA ID'] = "666999666", message = "Wanted for Supercode programming." },
				{ Name = "STACKPOLNIK MIKL", ['BAMA ID'] = "426813202", message = "Wanted for Software pandering." },
				{ Name = "ROBINSON ASHLEY", ['BAMA ID'] = "042385003", message = "Wanted for Smuggling." },
			}
		}

	},
}
soften=Soften




function MakeRAMColumn(id)
	return string.appendRightPadded("", tostring(Items[id].capacity), 3)
end

function MakeCostColumn(id)
	return string.appendRightPadded("", tostring(Items[id].cost), 5)
end

function MakeNameColumn(id)
	local out = ""
	if (Items[id].manufacturer ~= nil) then
		out = Items[id].manufacturer .. " "
	end
	out = out .. Items[id].name
	return out
end

AsanoComp = Site:new {
	title = "* Asano Computing *",

	comLinkLevel = 1,
	passwords = {
		"customer",
		"vendors",
		"<cyberspace>"
	},

	baseX = 16,
	baseY = 112,
	
	pages = {
		['title'] = {
			type = "title",
			message = "When you use the best, you are never disappointed....\n\nTo look at our current hardware list, just enter the password \"CUSTOMER\".",
		},

		['password'] = { type = "password" },

		['main'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "Catalog", target = "catalog" },
				{ key = '2', text = "Manufacturers", target = "vendors", level = 2 },
				{ key = '3', text = "Inventory", target = "inventory", level = 3 },
			}
		},
		
		['catalog'] = {
			type = "custom",
			columns = { { field = 'Manufacturer and Model', width = -4 }, { field = 'RAM', width = 3 } },
			items = {
				{ ['Manufacturer and Model'] = MakeNameColumn(100), RAM = MakeRAMColumn(100) },
				{ ['Manufacturer and Model'] = MakeNameColumn(101), RAM = MakeRAMColumn(101) },
				{ ['Manufacturer and Model'] = MakeNameColumn(102), RAM = MakeRAMColumn(102) },
				{ ['Manufacturer and Model'] = MakeNameColumn(103), RAM = MakeRAMColumn(103) },
				{ ['Manufacturer and Model'] = MakeNameColumn(104), RAM = MakeRAMColumn(104) },
				{ ['Manufacturer and Model'] = MakeNameColumn(105), RAM = MakeRAMColumn(105) },
				{ ['Manufacturer and Model'] = MakeNameColumn(106), RAM = MakeRAMColumn(106) },
				{ ['Manufacturer and Model'] = MakeNameColumn(107), RAM = MakeRAMColumn(107) },
				{ ['Manufacturer and Model'] = MakeNameColumn(108), RAM = MakeRAMColumn(108) },
				{ ['Manufacturer and Model'] = MakeNameColumn(109), RAM = MakeRAMColumn(109) },
				{ ['Manufacturer and Model'] = MakeNameColumn(110), RAM = MakeRAMColumn(110) },
				{ ['Manufacturer and Model'] = MakeNameColumn(111), RAM = MakeRAMColumn(111) },
				{ ['Manufacturer and Model'] = MakeNameColumn(112), RAM = MakeRAMColumn(112) },
				{ ['Manufacturer and Model'] = MakeNameColumn(113), RAM = MakeRAMColumn(113) },
				{ ['Manufacturer and Model'] = MakeNameColumn(114), RAM = MakeRAMColumn(114) },
				{ ['Manufacturer and Model'] = MakeNameColumn(115), RAM = MakeRAMColumn(115) },
				{ ['Manufacturer and Model'] = MakeNameColumn(116), RAM = MakeRAMColumn(116) },
				{ ['Manufacturer and Model'] = MakeNameColumn(117), RAM = MakeRAMColumn(117) },
				{ ['Manufacturer and Model'] = MakeNameColumn(118), RAM = MakeRAMColumn(118) },
				{ ['Manufacturer and Model'] = MakeNameColumn(119), RAM = MakeRAMColumn(119) },
				{ ['Manufacturer and Model'] = MakeNameColumn(120), RAM = MakeRAMColumn(120) },
				{ ['Manufacturer and Model'] = MakeNameColumn(121), RAM = MakeRAMColumn(121) },
				{ ['Manufacturer and Model'] = MakeNameColumn(122), RAM = MakeRAMColumn(122) },
				{ ['Manufacturer and Model'] = MakeNameColumn(123), RAM = MakeRAMColumn(123) },
			}
		},
		
		['vendors'] = {
			type = "generic",
			showHeader = true,
			showButtonOrSpace = true,
			exit = "main",
			entries = {
				{x = 5,  y = 2, text = "Manufacturer"},
				{x = 30, y = 2, text = "Link Code"},
				{x = 0,  y = 3, text = function(self) return string.rep("-", self.sizeX) end},
				{x = 5,  y = 4, text = "Fuji Electric"},
				{x = 30, y = 4, text = "FUJI"},
				{x = 5,  y = 5, text = "Hosaka"},
				{x = 30, y = 5, text = "HOSAKACORP"},
				{x = 5,  y = 6, text = "Musabori Industries"},
				{x = 30, y = 6, text = "MUSABORIND"},
				{x = 0,  y = 7, text = function(self) return string.rep("-", self.sizeX) end},
				{x = 0,  y = 8, text = "For reordering, these mfg. sales reps. must be seen personally:", wrap = -1},
				{x = 7,  y = 10, text = "Cray"},
				{x = 27, y = 10, text = "Yamamitsu"},
				{x = 7,  y = 11, text = "Moriyama"},
				{x = 27, y = 11, text = "Ono-Sendai"},
				{x = 7,  y = 12, text = "Ausgezeichnet"},
				{x = 27, y = 12, text = "Ninja"},
			}
		},

		['catalog'] = {
			type = "custom",
			columns = { { field = 'Manufacturer and Model', width = -4 }, { field = 'RAM', width = 5 } },
			items = {
				{ ['Manufacturer and Model'] = MakeNameColumn(100), COST = MakeCostColumn(100) },
				{ ['Manufacturer and Model'] = MakeNameColumn(101), COST = MakeCostColumn(101) },
				{ ['Manufacturer and Model'] = MakeNameColumn(102), COST = MakeCostColumn(102) },
				{ ['Manufacturer and Model'] = MakeNameColumn(103), COST = MakeCostColumn(103) },
				{ ['Manufacturer and Model'] = MakeNameColumn(104), COST = MakeCostColumn(104) },
				{ ['Manufacturer and Model'] = MakeNameColumn(105), COST = MakeCostColumn(105) },
				{ ['Manufacturer and Model'] = MakeNameColumn(106), COST = MakeCostColumn(106) },
				{ ['Manufacturer and Model'] = MakeNameColumn(107), COST = MakeCostColumn(107) },
				{ ['Manufacturer and Model'] = MakeNameColumn(108), COST = MakeCostColumn(108) },
				{ ['Manufacturer and Model'] = MakeNameColumn(109), COST = MakeCostColumn(109) },
				{ ['Manufacturer and Model'] = MakeNameColumn(110), COST = MakeCostColumn(110) },
				{ ['Manufacturer and Model'] = MakeNameColumn(111), COST = MakeCostColumn(111) },
				{ ['Manufacturer and Model'] = MakeNameColumn(112), COST = MakeCostColumn(112) },
				{ ['Manufacturer and Model'] = MakeNameColumn(113), COST = MakeCostColumn(113) },
				{ ['Manufacturer and Model'] = MakeNameColumn(114), COST = MakeCostColumn(114) },
				{ ['Manufacturer and Model'] = MakeNameColumn(115), COST = MakeCostColumn(115) },
				{ ['Manufacturer and Model'] = MakeNameColumn(116), COST = MakeCostColumn(116) },
				{ ['Manufacturer and Model'] = MakeNameColumn(117), COST = MakeCostColumn(117) },
				{ ['Manufacturer and Model'] = MakeNameColumn(118), COST = MakeCostColumn(118) },
				{ ['Manufacturer and Model'] = MakeNameColumn(119), COST = MakeCostColumn(119) },
				{ ['Manufacturer and Model'] = MakeNameColumn(120), COST = MakeCostColumn(120) },
				{ ['Manufacturer and Model'] = MakeNameColumn(121), COST = MakeCostColumn(121) },
				{ ['Manufacturer and Model'] = MakeNameColumn(122), COST = MakeCostColumn(122) },
				{ ['Manufacturer and Model'] = MakeNameColumn(123), COST = MakeCostColumn(123) },
			}
		},
	},
}
asanocomp=AsanoComp

function AsanoComp:GetCustomEntries(page)
	local entries = {}

	self:GetPageHeaderFooterEntries(page, entries)
	
	if (self.currentPage == "catalog") then
		local title = "Current Hardware For Sale"
		table.append(entries, {x = self:CenteredX(title), y = 2, text = title})
		table.append(entries, {x = 0, y = self.sizeY - 3, wrap = -1, text = "Come to our store for the latest in up to date software and hardware."})

		self:GetListEntriesEx(page, entries, 3, self.sizeY - 10, true, true, false)
	end

	return entries
end



Consumerev = Site:new {
	title = "$ Consumer Review $",
	comLinkLevel = 1,
	passwords = {
		"review",
		"<cyberspace>"
	},
	
	baseX = 32,
	baseY = 64,
	
	pages = {
		['title'] = {
			type = "title",
			message = "Did you know that there are currently 24 cyberdecks avilable from 9 different manufacturers? How do you choose between them? CONSUMER REVIEW gives you up-to-date ratings by experts, telling you which products to off the most in terms of performance, value and, quality.",
			entries = {
				{x = 0, y = 10, text = "      Type 'REVIEW' for access."}
			}
		},
		['password'] = { type = "password" },
		['main'] = {
			type = "generic",
			exit = "menu",
			entries = {
				{ x = 0, y = function(self) return self.sizeY - 3 end, wrap = -1, text = function(self)
						if (self.hadMoney) then return "200 credits have been deducted from your chip."
						else return "Insufficient credits in chip."
						end
					end
				}
			}
		},
		['menu'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "Rankings of all models", target = "all" },
				{ key = '2', text = "Flatline category", target = "flatline" },
				{ key = '3', text = "Triff category", target = "triff" },
				{ key = 'a', text = "Ausgezeichnet", target = "a" },
				{ key = 'b', text = "Blue Light Special", target = "b" },
				{ key = 'm', text = "Moriyama", target = "m" },
				{ key = 'n', text = "Ninja", target = "n" },
				{ key = 'o', text = "Ono-Sendai", target = "o" },
				{ key = 's', text = "Samurai", target = "s" },
				{ key = 'y', text = "Yamamitsu", target = "y" },
			},
			entries = {
				{x = 0, y = 2, text = "    * denots cyberspace capable decks."}
			}
		},
		['all'] = {
			type = "message",
			exit = "menu",
			message = "Rankings of all tested models in order of preference:\n\nOno-Sendai Cyberspace VII *\nSamurai Seven *\nNinja 5000 *\nMoriyama Bushido\nBlue Light Special\nAsugezeichnet 188 BJB\nYamamitsu UXB",
		},
		['flatline'] = {
			type = "message",
			exit = "menu",
			message = "FLATLINE\nThe special FLATLINE category is reserved for those decks that our experts \"wouldn't touch with a ten foot logic probe.\"\n\nManufacturer: YAMAMITSU\nModel: UXB\nRAM: 5\n\nOur experts agreethat the Yamamitsu UXB is the absolute worst of the worst. When our test was powered up, it exploded and put our expert operator in hospital downtime for two weeks.\n\nManufacturer: AUSGEZEICHNET\nModel: 188 BJB\nRAM: 5\n\nAusgezeichnet is the German word for \"excellent,\" but nothing is could be further from the truth in this case. The low price has created a high demand for this model, despite its notorious repair record. Out test model destroyed all of our softwarez!\n\nManufacturer: UNKNOWN\nModel: BLUE LIGHT SPECIAL\nRAM: 10\n\nThe Blue Light Special is the cheapest deck on the market today. The bugs in this system are subtle and may not appear for some time. However, as soon as the bugs do appear, the Blue Light Special should be considered armed and dangerous.",
		},
		['triff'] = {
			type = "message",
			exit = "menu",
			message = "TRIFF:\nThe TRIFF category is reserved for those few matrix simulators that exceed the high standards of the CONSUMER REVIEW staff.\n\nManufacturer: ONO-SENDAI\nModel: CYBERSPACE VII *\nRAM: 25\n\nThe Cyberspace Seven is the top of the line. The case is indestructible and the interphase is smooth. The only disadvantage of the Cyberspace Seven is its price, which is astronomical. If you're not just another joeboy, you'll sell your whole body to raise the creditw for buying one of these.\n\nManufacturer: SAMURAI\nModel: SEVEN *\nRAM: 25\n\nWhile the Samurai Seven is less expensive than the Ono-Sendai Cyberspace Seven, it shares many of the same features. However, Samurai is a new company and has not yet established the sort of reliability record which will allow it to compete with Ono-Sendai. By next year, we may be able to recommend this deck as a cheaper substitute for the Cyberspace Seven.\n\nManufacturer: NINJA\nModel: 5000 *\nRAM: 25\n\nAccording to Ninja promotional material, the 5000 is a \"cyberspace cowboy's dream,\" (although to be honest, there was some confusion in translating the Japanese word for \"dream\" into English. \"Nightmare\" was another possible translation). The 5000 seems to perform at least as well as the Samurai Seven, but at a cheaper price.",
		},
		['a'] = {
			type = "message",
			exit = "menu",
			message = "AUSGEZEICHNET:\nGood prices, but their models vary greatly in quality.\nManufacturer: AUSGEZEICHNET\nModel: 188 BJB\nRAM: 5\n\nAusgezeichnet is the German word for \"excellent,\" but nothing is could be further from the truth in this case. The low price has created a high demand for this model, despite its notorious repair record. Out test model destroyed all of our softwarez!\n\nOther AUSGEZEICHNET models:\nModel: 350 SL   RAM: 11\nModel: 440 SDI  RAM: 15\nModel: 550 GT   RAM: 20 *",
		},
		['b'] = {
			type = "message",
			exit = "menu",
			message = "BLUE LIGHT SPECIAL:\nWe've never been able to discover who manufacturers the Blue Light Special., but they've been marketing their one deck for five years now. Like a cockroach, you know they're around somewhere but they're hard to find and kill.\n\nManufacturer: UNKNOWN\nModel: BLUE LIGHT SPECIAL\nRAM: 10\n\nThe Blue Light Special is the cheapest deck on the market today. The bugs in this system are subtle and may not appear for some time. However, as soon as the bugs do appear, the Blue Light Special should be considered armed and dangerous.",
		},
		['m'] = {
			type = "message",
			exit = "menu",
			message = "MORIYAMA:\nA reliable manufacturer with a solid line of matrix simulators. They may not have all the bells and whistles of an Ono-Sendai, but they don't cost as much either. A good buy for the amateur cyberspace enthusiast.\n\nManufacturer: MORIYAMA\nModel: BUSHIDO\nRAM: 12\n\nThe Moriyama Bushido is one of the bet starter decks available. The interphase linking system is very smooth. Repairs are rarely necessary with a Moriyama and our test model met all specifications without exceeding them.\n\nOther MORIYAMA models:\nModel: Hiki-Gaeru  RAM: 5\nModel: Gaijin      RAM: 10\nModel: Edokko      RAM: 15\nModel: Katana      RAM: 18\nModel: Tofu        RAM: 20 *\nModek: Shogun      RAM: 24 *",
		},
		['n'] = {
			type = "message",
			exit = "menu",
			message = "NINJA:\nNinja has been in the biz, wth some success, for one whole month now. In that time, very few of their decks have been returned to the dealers as unacceptable.\n\nManufacturer: NINJA\nModel: 5000 *\nRAM: 25\n\nAccording to Ninja promotional material, the 5000 is a \"cyberspace cowboy's dream,\" (although to be honest, there was some confusion in translating the Japanese word for \"dream\" into English. \"Nightmare\" was another possible translation). The 5000 seems to perform at least as well as the Samurai Seven, but at a cheaper price.\n\nOther NINJA models:\nModel: 4000  RAM: 20 *\nModel: 3000  RAM: 12\nModel: 2000  RAM: 10",
		},
		['o'] = {
			type = "message",
			exit = "menu",
			message = "ONO-SENDAI:\nOno-Sendai is the most respected name in the biz.\n\nManufacturer: ONO-SENDAI\nModel: CYBERSPACE VII *\nRAM: 25\n\nThe Cyberspace Seven is the top of the line. The case is indestructible and the interphase is smooth. The only disadvantage of the Cyberspace Seven is its price, which is astronomical. If you're not just another joeboy, you'll sell your whole body to raise the creditw for buying one of these.\n\nOther ONO-SENDAI models:\nModel: Cyberspace  II  RAM: 11 *\nModel: Cyberspace III  RAM: 15 *\nModel: Cyberspace  VI  RAM: 20 *",
		},
		['s'] = {
			type = "message",
			exit = "menu",
			message = "SAMURAI:\nAn old and respected company since six months ago. The make one model of matrix simulator and this is it.\n\nManufacturer: SAMURAI\nModel: SEVEN *\nRAM: 25\n\nWhile the Samurai Seven is less expensive than the Ono-Sendai Cyberspace Seven, it shares many of the same features. However, Samurai is a new company and has not yet established the sort of reliability record which will allow it to compete with Ono-Sendai. By next year, we may be able to recommend this deck as a cheaper substitute for the Cyberspace Seven.",
		},
		['y'] = {
			type = "message",
			exit = "menu",
			message = "YAMAMITSU:\nYamamitsu has been in the bix for four years under its current name, producing middle-of-the-road matrix simulators. They have turned mediocrity into a new art form with the introduction of two new models in their XB line of decks.:\n\nManufacturer: YAMAMITSU\nModel: UXB\nRAM: 5\n\nOur experts agreethat the Yamamitsu UXB is the absolute worst of the worst. When our test was powered up, it exploded and put our expert operator in hospital downtime for two weeks.\n\nOther YAMAMITSU models:\nModel: XXB  RAM: 6\nModel: ZXB  RAM: 10",
		},
	}
}
consumerev=Consumerev

function Consumerev:GoToPage(pageName)
	if (pageName == "main") then
		if (s.money >= 200) then
			self.hadMoney = true
			s.money = s.money - 200
		else
			self.hadMoney = false
		end
	end

	Site.GoToPage(self, pageName)
end


Chaos = Site:new {
	title = "* Panther Moderns *",
	comLinkLevel = 2,
	passwords = {
		"mainline",
		"<cyberspace>"
	},
	
	baseX = 224,
	baseY = 112,
	
	pages = {
		['title'] = {
			type = "title",
			message = " "
		},
		['password'] = { type = "password" },
		['main'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "Software Library", target = "library" },
				{ key = '2', text = "Modern BBS", target = "bbs_view" },
				{ key = '3', text = "Send Message", target = "bbs_send" },
			}
		},
		['library'] = {
			type = "download",
			items = {
				{ key = 'x', text = "Exit to Main", target = "main" },
				{ key = '1', software = 201 }, -- COMLINK 3.0
				{ key = '2', software = 280 }, -- MINDBENDER [fake]
				{ key = '3', software = 281 }, -- VIDEOSOFT [fake]
				{ key = '4', software = 216, passwordLevel = 2 }, -- BlowTorch 3.0
				{ key = '5', software = 223, passwordLevel = 2 }, -- Decoder 2.0
				{ key = '6', software = 268, passwordLevel = 2 }, -- ThunderHead 1.0
				{ key = '7', software = 221, passwordLevel = 2 }, -- Cyberspace 1.0
			}
		},
		['bbs_view'] = {
			type = "list",
			title = "Bulletin Board",
			unlockid = "chaos_bbs",
			hasDetails = true,
			columns = { { field = 'date', width = 8 }, { field = 'to', width = 15 }, { field = 'from', width = 0 } },
			formatDetails = function(item) return string.format("TO: %s\nFROM: %s\n%s", item.longfrom or item.from, item.longto or item.to, item.message) end,
			items = {
				{ date = 111658, to = "Everyone", from = "Mod Yutaka", longfrom = "Modern Yutaka", message = "Good one. Cuwboy named Chipdancer owed me a favor. Broke into the Hosaka base with Comlink 5.0, used \"FUNGEKI\", and then added my name to their employee list. Received paychecks for six weeks before anyone noticed. Only risk was walking in to pick up check." },
				{ date = 111658, to = "All", from = "Modern Miles", message = "Julius Deane knows Cryptology. He also wanted to let people know he's got some hard to find skill chips, in case anyone's interested." },
				{ date = 111658, to = "Everyone", from = "Polychrome", message = "Screaming Fist has Easy Rider 1.0 in their base. Lets you cross zones without having to go to another cyberjack." },
				{ date = 111658, to = "Angelo", from = "Lupus", longfrom = "Lupus Yonderboy", message = "Mr. Who paid us on the SENSE/NET gog. He'll remain a Mr. Who, not  Mr. Name. He understands now. Chaos is our mode and modus. Our central kick. Stories to be told, offline in the meeting room. All you have to do is ask." },
				{ date = 111658, to = "Everyone", from = "Modern Larry", longfrom = "Larry Moe", message = "Don't worry about the meet room, no wilsons will get past me. If you're Modern, you're in. Good place for biz. I've got CopTalk now, Lupus has Evasion. See you on the other side." },
				{ date = 111658, to = "Modern Miles", from = "Polychrome", message = "Heard you were looking for a place. Cheap Hotel link code is CHEAPO." },
				{ date = 111658, to = "Everyone", from = "Modern Bob", message = "I have the link code for Hitachi and the SEA. If anyone's interested, leave me a message." },
				{ date = 111658, to = "Lupus", from = "Modern Jane", message = "Congrats on burning Gemeinschaft. Heard the fire was so small they don't even know who started it." },
				{ date = 111658, to = s.name, from = "Matt Shaw", message = "Word of warning: some dumb wilson just got fried by jacking into cyberspace from the Loser's outlet. His first (and last) try. The ICE is softer at the bases you can reach from the Cheap Hotel's jack, so brush up on your cyberspace techniques there first." },
				{ date = 0, to = s.name, from = "Modern Bob", condition = function() return s.mail_modernbob == 1 end, message = "Got your message. Hitachi link code is \"HITACHIBIO\". SEA link code is \"SOFTEN\". Regular Fellows link code is \"REGFELLOW\"." },
			}
		},
		['bbs_send'] = {
			type = "sendmessage"
		}
	}
}
chaos=Chaos

function Chaos:ProcessMessage(recipient, message)
	local to = string.lower(recipient)
	if (string.find(string.lower(message), "%f[%a]" .. "link" .. "%f[%A]")) then
		if (to == "modern bob" or to == "mod bob" or to == "bob") then
			s.mail_modernbob = 1
		end
	end
end

s.psychosentmessage = false
Psycho = Site:new {
	title = "* Psychologist *",
	comLinkLevel = 2,
	passwords = {
		"new mo",
		"babylon",
		"<cyberspace>"
	},
	
	baseX = 96,
	baseY = 32,

	pages = {
		['title'] = {
			type = "title",
			message = "If you wish to initiate your own mindprobe session by entering inormation for the Psych to analyze, you must log in under your personal password. The reasonable fee for this service will vary according to the severity of your problem. If you're a new user, enter the password, \"NEW MO\".",
		},
		['password'] = { type = "password" },
		['main'] = {
			type = "message",
			exit = "menu",
			message = function(self)
					if (self.passwordLevel == 1) then return "Welcome to PSYSCHOLOGIST. If it makes you feel more comfortable, you can think of me as \"Sigmund.\" If you decide to proceed with analysis under your personal password, I will be your analyst. At the moment, however, your options are limited to browsing through other people's mindprobe sessions.\nIn future contact with this service, your personal password will be:\nBABYLON"
					else return "Welcome to PSYCHOLOGIST. I'm Sigmund, your personal mindprobe analyst. You now have the choice of browsing through other mindprobe sessions or starting one of your own. Your fee will be based on the severity of your problem if you proceed with a personal mindprobe. After completing a mindprobe session, I'll need a few hours to review your case, so there's no need for you to wait around. I won't be offended if you leave abruptly.\n\nBy activating a mindprobe session, you accept full responsibility for your own well-being. You also agree to hold the Psych staff harmless from any loss, expense, mental damange, or liability arising out of mindprobe analysis. This is no place for a weak mind."
					end
				end,
		},
		['menu'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "Read Molly Sample", target = "holly" },
				{ key = '2', text = "Read Corto Sample", target = "corto" },
				{ key = '3', text = "Read Snowman Sample", target = "snowman" },
				{ key = '4', text = "Activate mindprobe", target = "mindprobe", level = 2 },
				{ key = '5', text = "Review last session", target = "review", level = 2 },
			}
		},
		['holly'] = {
			type = "message",
			message = "MINDPROBE FILE 4918\nPROBEE:  Molly\nPSYCH:   Sigmund\nVISIT:   Fourth\nTRANSCRIPT OF LAST SESSION:\n\nOkay, Sig, I'll tell you about my past. My Johnny, see, he was smart, real flash boy. Started out as a stash on Memory Lane, chips in his head and people paid to hide data there. Had the Yak after him, night I met him, and I did for their assassin. More luck than anything else, but I did for him. And after that, it was tight and sweet. We had a set-up with a squid, so we could read the traces of everything he'd ever stored. Ran it all out on tape and started twisting selected clients, ex-clients. I was bagman, muscle, watchdog. I was real happy. You ever been happy, Sig? He was my boy. We worked together. Partners. I was maybe eight weeks out of the puppet house when I met him... Tight, sweet, just ticking along, we were. Like nobody could ever touch us. I wasn't going to let them. Yakuza, I guess, they still wanted Johnny's ass. 'Cause I'd killed their main. 'Cause Johnny'd burned them. And the Yak, they can afford to move slow, man, they'll wait years and years. Give you a whole life, just so you'll have more to lose when they come and take it away. Patient like a spider. Zen spiders.\nI think he's after me now.... What do you think, Sig?\n\nDIAGNOSIS OF FOURTH VISIT:\nSad story, Molly. It's too complex for me to analyze all in one visit, but I think we're getting somewhere. I think the strain of your illegal activities is distorting your view of reality by directing your psychic energies into unhealthy channels, such as paranoia. Visit me more often and we'll try to work it out.",
		},
		['corto'] = {
			type = "message",
			message = "MINDPROBE FILE 4948\nPROBEE:  Colonel Corto\nPSYCH:   Friedrich\nVISIT:   Tenth\nTRANSCRIPT OF LAST SESSION:\n\nFriedrich? Read you, Friedrich. I'm sorry, but it has to be this way. One of us has to get out. One of us has to testify. If we all go down here, it ends here. I'll tell them, Friedrich, I'll tell them all of it. About Girling and the others. And I'll make it, Friedrich, I know I'll make it. To Helsinki. But it's so hard, Friedrich. So darn hard. I'm blind.\nRemember the training, Friedrich. That's all we can do. We are down, repeat, Omaha Thunder is down.\n\nDIAGNOSIS OF TENTH VISIT:\nSOunds like you're on a bad trup, Corto. I think the strain of your activities in Screaming Fist is distorting your view of reality. This is clearly unhealthy. You're no longer living on this planet. I've scheduled you for a long series of daily therapy sessions. This is Omaha Control, over and out.",
		},
		['snowman'] = {
			type = "message",
			message = "MINDPROBE FILE 4911\nPROBEE:  Snowman\nPSYCH:   Alfred\nVISIT:   Third\nTRANSCRIPT OF LAST SESSION:\n\nI'm really gettin worried, Ald. I was hangin out in the matrix, just kinda buzzin the green cubes of the Mitsubishi B of A, when this... thing starts tailin me. That's never happened before, man. So I rack in another Mimic soft and the thing stays behind me, like a heat-seeker or somethin. So I turn around and Mimic into an IRS audit. It doesn't care! It speeds up! I toss a Probe at it and this eats it. I never see it again! I barely had time to hack out before the thing nailed me. It's getting so a cowboy can't crack a base anymore without settin off some kinda alarm. Thing is, I don't remember what I did to attracy it's attention. It's almost like it was controlled by some sorta intelligence. You don't think an AI could have... no, that's impossible. AI's can't wander around in the matrix. Turing would nail em before they crossed two grids. Maybe I'm just being paranoid. Do you think I'm paranoid, Alf? Give it to me straight. I can take it.\n\nDIAGNOSIS OF THIRD VISIT:\nSnowman, my friend, I'm getting worried too. I don't want to alarm you, but things like that just can't happen in cyberspace. Maybe you ran into a loose data transmission, or something. I don't know. But I really think you're overreacting to what you perceive to be a threat. Maybe it's time for you to reture from cyberspace and get a real job. I think the strain of your illegal activities is directing itself into your paranoia. Visit me more often and we'll try to work it out.",
		},
		['mindprobe'] = {
			type = "sendmessage",
			noDateTo = true,
			messagePrompt = "Enter your thoughts",
			sendPrompt = "Send this thought",
			exit = "menu",
		},
		['review'] = {
			type = "message",
			exit = "menu",
			message = "Yours was an interesting case. Whether you're aware of it or not, yoy have deep psychological problems. It's too deep for me to analyze all in one visit, but I think we're getting somewhere. Your reality-view seems to be bipolar, but further analysis will be required before I can reach a conclusion. I recommend that you stop your illegal actiities before your problems get worse. Thanks for stopping by. I hope I'll see you again... for your sake."
		},
	},
}
psycho=Psycho

function Psycho:GoToPage(pageName)
	if (pageName == "review" and not s.psychosentmessage) then
		return
	end
	
	Site.GoToPage(self, pageName)
end

function Psycho:ProcessMessage(recipient, message)
	s.psychosentmessage = true
end


Fuji = Site:new {
	title = "* Fuji Electric *",
	comLinkLevel = 3,
	passwords = {
		"romcards",
		"uchikatsu",
	},
	
	baseX = 112,
	baseY = 240,
	
	pages = {
		['title'] = {
			type = "title",
			message = " ",
			entries = {
				{ x = 10, y = 10, text = "Our Romcards Never Forget"}
			}
		},
		['password'] = { type = "password" },
		['main'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "Company News", target = "news" },
				{ key = '2', text = "Executive Survival Kit", target = "survival" },
				{ key = '3', text = "Press Releases", target = "press" },
				{ key = '4', text = "Personnel Management", target = "personnel", level = 2 },
				{ key = '5', text = "Memo", target = "memo", level = 2 },
			}
		},
		['news'] = {
			type = "message",
			message = "\nCompany News\n\n***3rd quarter profits are up! Thanks to the effort of each and every one of you, our employees, we've increased productivity. This drives our costs down and jacks our profits ever higher. With the demand for quality products out there as insatiable as it is, we;ve going to be on top of the world. Management has increased meat puppt breaks from 10 to 11.5 minutes for all line employees just to show you they care.\n\n***R and D's Esther Radklif and Andy Raymod have finally gotten married. THey had planned a skiing honeymoon in the Alps, but Andy would have had to have sold both legs to afford it, so they decided to forego that please. They'll just remain here in Chiba City and cozy up their nest a bit. I know we all wish them well.\n\n***New Hires:\n\nMishiji, Takoda  Securty\nO'Brien, Akira   Management\nKharkov, Sven    Line production\nBord, Melissa    Employee Services\nWang, P. Ryan    Acquisitions\nBear, M. C.      Legal\nMoe, Larry       Consultant"
		},
		['survival'] = {
			type = "message",
			message = "\nExecutive Survival Kit\nWelcome.\nWe have two rules around here:\n1) Mr. Watkins is always right\n2) see rule  #1\n\nFollow the rules and we'll get along fine. Remember to cover your ass with paper, but never stray far from a paper shredder and you'll have a long career with Fuji Electric.\nWelcome aboard -- don't rock the boat.\n(signed)\nHarry Watkins"
		},
		['press'] = {
			type = "message",
			message = "\n***For Immediate Release\nNASA and FUJI ELECTRIC DO BUSINESS\n\nIn anticipation of next century's manned shot at Alpha Centuri, NASA signed a multi-trillion dollar contract with Fuji Electric to provide ROMcards and software development for the Prometheus ship. Fuji Spokesman Harry Watkins said, \"This is the smartest move NASA has made since the dawn of their program.\"\nFuji anticipates unparalleled growth over the next decare. \"We'll have new employees coming on every day. If not for our own computer system, we'd have no way to keep track of them. Technology has made the human race great, and we want to lead the pack,\" said Watkins.\n\nFor further information contact Watkins at FUJI or Bob Shepherd at VOYAGER.\n\n(Just want you to know, my fellow employees, this contract was awarded on the strength of your work. Thanks, Harry...)"
		},
		['personnel'] = {
			type = "list",
			title = "New Employees List",
			hasDetails = true,
			columns = { { field = 'Name', width = 19 }, { field = 'BAMA ID', width = 0 } },
			formatDetails = function(item) return string.format("\n\nName: %s\nID:   %s\n%s", item.Name, item['BAMA ID'], item.message) end,
			items = {
				{ Name = "LYNENE ROBINSON", ['BAMA ID'] = "211149931", message = "Position -  Security" },
				{ Name = "LISA ARNOLD", ['BAMA ID'] = "230057291", message = "Position - Management" },
				{ Name = "BILL DUGAN", ['BAMA ID'] = "199455756", message = "Position - Line production" },
				{ Name = "TOM DECKER", ['BAMA ID'] = "217453565", message = "Position - Employee services" },
				{ Name = "JAY PATEL", ['BAMA ID'] = "454781171", message = "Position - Acquisitions" },
				{ Name = "BRUCE SCHLICKBERND", ['BAMA ID'] = "175385636", message = "Legal" },
				{ Name = "LARRY MOE", ['BAMA ID'] = "062788138", message = "Position - Consultant" },
			}
		},
		['memo'] = {
			type = "message",
			message = "\nTo:Management Level Employees\nFromL Harry Watkins\nRE: TOZOKU merger\n\nIt is true that TOZOKU has made us an offer we have accepted concerning the ownership of FUJI. The days of a dynastic company have ended and I gladly consider turning control over to the people of TOZOKU I know of you think of them as common criminals, but I can assure you there is nothing common about them at all. I think all of you who were concerned about my wife and child. They've been returned to me and we've found all of little Harry's parts. The doctors say he's got an excellent chance of recovery and I agree that he doesn't really look like the Frankenstein monster at all.\n\nHarry"
		}

	}
}
fuji=Fuji

HitachiBio = Site:new {
	title = "* Hitachi Biotech *",
	comLinkLevel = 3,
	passwords = {
		"genesplice",
		"biotech"
	},
	
	baseX = 32,
	baseY = 192,
	
	pages = {
		['title'] = { type = "title", message = "<editor note: this is a totally pointless site>" },
		['password'] = { type = "password" },
		['main'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "Lung Report", target = "report" },
				{ key = '2', text = "Personnel File", target = "personnel", level = 2 },
			}
		},
		['report'] = {
			type = "message",
			message = "Imagine a long winded description of how lung experiments work..."
		},
		['personnel'] = {
			type = "list",
			title = "Personnel File",
			hasDetails = true,
			columns = { { field = 'Name', width = 19 }, { field = 'BAMA ID', width = 0 } },
			formatDetails = function(item) return string.format("\n\nName: %s\nID:   %s\nEmployee department - %s", item.Name, item['BAMA ID'], item.dept) end,
			items = {
				{ Name = "T. YOSHINOBU", ['BAMA ID'] = "132066340", dept = "C.E.O." },
				{ Name = "...", ['BAMA ID'] = "...", dept = "..." },
			}
		},
	}
}
hitachibio=HitachiBio

Keisatsu = Site:new {
	title = "* Chiba City Tactical Police *",
	comLinkLevel = 3,
	passwords = {
		"warrants",
		"supertac",
	},
	
	baseX = 288,
	baseY = 112,

	pages = {
		['title'] = { type = "title", message = " " },
		['password'] = { type = "password" },
		['main'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "View Warrants", target = "warrants" },
				{ key = '2', text = "Edit Warrants", target = "warrants", level = 2 },
			}
		},
		['warrants'] = {
			type = "list",
			title = "Tactical Strike Warrants",
			targetOnClick = 'warrant',
--			hasDetails = true,
--			canEditDetails = function(self) return self.comLinkLevel > 1 end,
			columns = { { field = 'Name', width = 19 }, { field = 'BAMA ID', width = 0 } },
--			formatDetails = function(item) return string.format("\n\nName: %s\nID:   %s\nWanted for %s.", item.Name, item['BAMA ID'], item.crime) end,
			items = s.arrestWarrants,
		},
		['warrant'] = {
			type = "custom",
			exit = "warrants",
		}

	}
}
keisatsu=Keisatsu

function Keisatsu:GoToPage(pageName)
	if (pageName == 'warrants') then
		self.pages['warrants'].items = s.arrestWarrants
	end

	Site.GoToPage(self, pageName)
end

function Keisatsu:HandleClickedEntry(id)
	if (self.currentPage == 'main' and id > 0) then
		self.editMode = id - 2
	end

	Site.HandleClickedEntry(self, id)
end

function Keisatsu:GetCustomEntries(page)
	local entries = {}

	self:GetPageHeaderFooterEntries(page, entries)

	local title = "Tactical Strike Warrants"
	local titleX = self:CenteredX(title)
	table.append(entries, { x=titleX, y = 2, text = title})
	
	table.append(entries, { x = 0, y = 5, text = "Name:"})
	table.append(entries, { x = 0, y = 6, text = "ID:"})
	table.append(entries, { x = 0, y = 7, text = string.format("Wanted for %s.", s.arrestWarrants[self.selectedListItem].crime)})
	
	if (self.editMode == 2) then
		table.append(entries, { x = 6, y = 5, entryTag = "name"})
	else
		table.append(entries, { x = 6, y = 5, text = s.arrestWarrants[self.selectedListItem].Name})
	end
	if (self.editMode == 3) then
		table.append(entries, { x = 6, y = 6, entryTag = "id"})
	else
		table.append(entries, { x = 6, y = 6, text = s.arrestWarrants[self.selectedListItem]['BAMA ID']})
	end

	self:AddExitEditEntries(entries, self.editMode > 0)

	return entries
end

function Keisatsu:HandleClickedEdit()
	self.editMode = 2
end


function Keisatsu:OnTextEntryComplete(text, tag)

	if (tag == "name") then
		s.arrestWarrants[self.selectedListItem].Name = text
		self.editMode = 3
	elseif (tag == "id") then
		s.arrestWarrants[self.selectedListItem]['BAMA ID'] = text
		self.editMode = 1
		if (string.lower(s.arrestWarrants[self.selectedListItem].Name) == "larry moe" and text == "062788138") then
			s.larry_arrested = true
		end
	else
		Site.OnTextEntryComplete(self, text, tag)
	end
end


Brainstorm = Site:new {
	title = "* Copenhagen University *",
	comLinkLevel = 4,
	passwords = {
		"perilous",
		"<cyberspace>",
	},
	
	baseX = 320,
	baseY = 32,
	
	pages = {
		['title'] = { type = "title", message = "The Copenhagen Message base. We welcome all free thinkers and student of life." },
		['password'] = { type = "password" },
		['main'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "Notes of Interest", target = "notes" },
				{ key = '2', text = "Message Base", target = "messages" },
			}
		},
		['notes'] = {
			type = "message",
			message = "Notes of Interest\n\n        Copenhagen University\n\n  Our Polar Bears finished their Bloodsport season 12-3-1, winning the Pan European Championship in a hard fought contest against Leningrad University's Molotov Cocktails. Our star, Lars Mbutu, finished the final game despite nearly having his left leg severed halfway through the first day of competition. Doctors report his replacemnt will work almost like new, and we hope he'll beback for Cross-Country competition in the fall.\n\n\"Cyberspace and Addictive Peronalities\" was a paper delivered by our own Professor Marshe Sanderson at last month's Psychologists' Convention in Paris. She suggested that computers can be addictive and very time consuming, but she reports no hard evidence that computers are harmful. \"Computers are the soul of current society -- to embrace them is to embrace life itself.\" She also pointed out that the pseuodyms used by so-called \"Cyberspce Cowboys\" are merely a manifestation of their true selves and \"no different from the Japanese custom in which samurai would adopt new names repeatedly during their careers.\"\n\n  Copenhagen University is leading the effort to discover why numbers of very adept cyberspace operators have been dropping out of the communications network. Said Michael Austin, an aide to Dr. Marsha Sanderson, \"We're focusing our study on withdrawal symptoms and feelings of rejection on the networks. Something out there is alienating users, and we hope to determine what it is.\" The research, funded by a grant from Tessier-Ashpool funneled through their Allard Technologies subdivision, begins immediately.",
		},
		['messages'] = {
			type = "list",
			hasDetails = true,
			columns = { { field = 'date', width = 8 }, { field = 'to', width = 15 }, { field = 'from', width = 0 } },
			formatDetails = function(item) return string.format("TO: %s\nFROM: %s\n\n  %s", item.longfrom or item.from, item.longto or item.to, item.message) end,
			items = {
				{ date = 111658, to = "Lars Mbutu", from = "Deathangel's", longfrom = "Deathangel's Shadow", message = "Great game, Lars. Sorry about those fingers you lost in the last period. I guess you won't be typing back a reply that quickly will you? Hope the spare parts shop in Copenhagen is better than the one in Chiba City. This pancreas I got sucks." },
				{ date = 111658, to = "Dr.Sanderson", longto = "Dr. Marsha Sanderson", from = "Habitual", longfrom = "Habitual User", message = "Saw a vid of your paper delivery the other day. Think I got most of the French. Hit the nail on the head -- no harm in the decks. Promote intellectual development." },
				{ date = 111658, to = "Deathangel's", longto = "Deathangel's Shadow", from = "Lars Mbutu", message = "Thnk you for your msg bout th gm. you r right tht loing fingr on my lft hn ill mk for iffikult riting, but i ill try. i njoy th gm. my lg i lot bttr no. on't brly limp. By for no." },
				{ date = 111658, to = s.name, from = "Deathangel's", longfrom = "Deathangel's Shadow", message = "It's getting really spooky out here. Was supporsed to get some information from the Sumdiv Kid, but he's gone null. Have you seen him?" },
				{ date = 111658, to = "All", from = "Deathangel's", longfrom = "Deathangel's Shadow", message = "All you new moes remember that all ICE breakers aren't created equal. So being the cool guy that I am, I leave the following info for all.\n\nGood:   Decoder, BlowTorch, Hammer\nBetter: DoorStop, Drill\nBest:   Concrete, DepthCharge, Logic Bomb\n\nGood Luck" },
			},
		}

	}
}

brainstorm=Brainstorm



EastSeaBod = Site:new {
	title = "* Eastern Seaboard Fission Authority *",
	comLinkLevel = 4,
	passwords = {
		"longisland",
		"<cyberspace>"
	},
	
	baseX = 384,
	baseY = 32,
	
	pages = {
		['title'] = { type = "title", message = "This is the Eastern Seaboard Fission Authority. Unquthorized access will be shut down and trespassers will be prosecuted to the full extend of the law." },
		['password'] = { type = "password" },
		['main'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "Company News", target = "newa" },
				{ key = '2', text = "Software Library", target = "software" },
				{ key = '3', text = "Messages", target = "messages" },
			}
		},
		['news'] = {
			type = "message",
			message = "Company News\n  We recently completed a shift of computers in our main office which guarantees system security. This has required some changes in our methods of service, but nothing to alarm you. We still will respond to complains with our usual alacrity and accuracy. Rest assured, we have not changed.\n  We have determined that the power down in the K-7 sector was caused by sabotage. It seems one operator at the New Jersey Nuclear Power Station was using his computer to do some trolling on the Free Sex Union system. He left his access code hoping for some response. He got it. K-7 went down for three days before we found and destroyed the offending code. Three lines, that's all it took, and all the power was funneled info the Chernobyl/Kiev grid.",
		},
		['software'] = {
			type = "download",
			items = {
				{ key = 'x', text = "Exit to Main", target = "main" },
				{ key = '1', software = 203 }, -- COMLINK 5.0
			}
		},
		['messages'] = {
			type = "list",
			hasDetails = true,
			columns = { { field = 'date', width = 8 }, { field = 'to', width = 15 }, { field = 'from', width = 0 } },
			formatDetails = function(item) return string.format("TO: %s\nFROM: %s\n\n  %s", item.longfrom or item.from, item.longto or item.to, item.message) end,
			items = {
				{ date = 111658, to = "Inspector B.", longto = "Inspector Boggs", from = "The Chairman", message = "Re: Moving Allowance\n\n  The moving allowance you requested has been cleared and deposited in Bank Gemeinschaft. Codeword: \"AGABATUR\". Thanks for filling out the forms in triplicate." },
				{ date = 111658, to = "The Chairmain", from = "GrnMtn Power", message = "We've been getting strange fluctuations from the New Hampshire/Seabrook plant. One of my engineers says it looks like the beginning of a runaway reaction. I'd not be concerned, but this time of the year the prevailing winds blow east to west, if you catch my drift." },
				{ date = 111658, to = "GrnMtn Power", from = "The Chairman", longfrom = "Deathangel's Shadow", message = "We'll be sending an inspector up there real soon now." },
				{ date = 111658, to = "Mrs. Waxman", longto = "Mrs. Edith Waxman", from = "Inspector B.", longfrom = "Inspector Boggs", message = "I resent being called an idiot, Madam. I merely suggested that the interference on your television COULD be the sort caused by a cracked shielding element at the Devil's Gorge powerplant beside your house. I did not say that WAS the cause, now did I? I've been to the plant and I assure you there is nothing to worry about.\n  As for your assertion that I and my family moved from the neighborhood last month because of the danger, well, I assure you that is utterly false. My wife Marie merely wanted a yellow house with black shutters so we move to one.\nYours,..." },
				{ date = 111658, to = "Inspector B.", longto = "Inspector Boggs", from = "Mes. Waxman", longfrom = "Edith Waxman", message = "No Danger! Listen Boggs, my cat cglows in the dark and has lost all its fur. I expect you to get out here, and damn fast. This leak is beginning to affect everything! *%#kh&f texxd\\jjihbf# kj) 34 JVJ% hgff## 1}'\"|lk jeignbal dkj gljsn dxf -+" },
				{ date = 111658, to = "The Chairman", from = "GrnMtn Power", message = "  You'll get an inspector over there soon? What do you think this is? It's not safe up here. I'm sending my kids to visit their grandmother down at Devil's Gorge. I know nothing's going to go wrong there -- one of your inspectors lives next to my mother-in-law.\n  Move it guys, this thing could be dangerous." },
				{ date = 111658, to = "Mes. Waxman", longto = "Edith Waxman", from = "Inspector B.", longfrom = "Inspector Boggs", message = "I believe Mrs. Waxman, you have blown all of this out of proportion. Of course your cat has lost its fur -- cats shed at this time of year, and having three screaming grandchildren running aorund the house can't help. I have relayed your concerns to the DEvil's Gorge supervisor and he promises to contact you as soon as he gets a new rad suit." },
				{ date = 111658, to = "All", from = "Deathangel's", longfrom = "Deathangel's Shadow", message = "The Eastern Seaboard Fission Authority doesn't know we're here! That's right, folks ESFA thinks they are safe. Little do they know we leeched this upper section onto their board. We're filling it with some great stuff, too. Check out the new addition to their software library." },
				{ date = 111658, to = s.name, from = "Deathangel's", longfrom = "Deathangel's Shadow", message = "Be careful if you cruise new the Citizens for a Free Matrix db. I got some bad vibes off that one. Someone said they're running a Trojan Horse program, you know, with viruses in it, but I didn't see anything like that. Maybe they used to do that, or are gunna in the future. Forewarned is unflatlined. Later..." },
				
				{ date = 111658, to = "Matt Shaw", from = "Sumdiv Kid", message = "You gunna do another rev of BattleChess? Deuce was great -- kinda hoping you'd be on trey or four. Deathangel's Shadow, Bosch and I all tinkered with your logic in BattleChess deuce. I did the least mods -- just weighted pieces differently to suit my style, you know? -- and trashed them. Not enough to make a new rev. I leave that to you -- a master at work and all that." },
				{ date = 111658, to = "All", from = "Modern Miles", message = "Invites to all cowboys, from the Gentleman Loser DB. There are warez to be had. The link code is \"LOSER\"m and so is the word." },
				{ date = 111658, to = "Deathangel's", longto = "Deathangel's Shadow", from = "Gabby", message = "Thanks for the tip about Finn. He does have loads of stuff, he even has tried to sell me a joystick. Like what would I do with that?" },
			},
		}

	}
}
eastseabod=EastSeaBod

Musaborind = Site:new {
	title = "* Musabori Industries *",
	comLinkLevel = 5,
	passwords = {
		"subaru",
		"<cyberspace>",
	},
	
	baseX = 208,
	baseY = 208,

	pages = {
		['title'] = { type = "title", message = "This is the Eastern Seaboard Fission Authority. Unquthorized access will be shut down and trespassers will be prosecuted to the full extend of the law." },
		['password'] = { type = "password" },
		['main'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "From the President", target = "president" },
				{ key = '2', text = "New Products", target = "products" },
				{ key = '3', text = "Answer Man", target = "answerman" },
				{ key = '4', text = "Employee of the Month", target = "employee" },
			}
		},
		['president'] = {
			type = "message",
			message = "Long winded thing",
		},
		['products'] = {
			type = "message",
			message = "Long winded thing",
		},
		['answerman'] = {
			type = "message",
			message = "Long winded thing",
		},
		['employee'] = {
			type = "message",
			message = "          Employee of the Month:\n               Stan Barlow\n\n  Stan is one of those amazing people that really makes Musabori what it has become today. For the last twenty years Stan has screwed the restraining bolt into the engine sub-structure for all our B-2a Swinging Bomber Assemblies.\n\n  Way to go, Stan. Hope you stay with use for another twenty.",
		},
	}
}
musaborind=Musaborind




HosakaCorp = Site:new {
	title = "* Hosaka Corporation *",
	comLinkLevel = 5,
	passwords = {
		"biosoft",
		"fungeki",
		"<cyberspace>"
	},
	
	baseX = 144,
	baseY = 160,
	
	pages = {
		['title'] = { type = "title", message = "Welcome to the Hosaka Corporation Database. We provide this database as a server to our customers, employees and stockholders." },
		['password'] = { type = "password" },
		['main'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "New Products", target = "products" },
				{ key = '2', text = "Corporate Sales Figures", target = "sales" },
				{ key = '3', text = "New Employee Listing", target = "employees", level = 2 },
				{ key = '4', text = "Employee Memos", target = "memos", level = 2 },
				{ key = '5', text = "Software Library", target = "software", level = 2 },
				{ key = '6', text = "Upload Software", target = "upload", level = 2 },
			}
		},
		['products'] = {
			type = "message",
			message = "    The 68000000 chip is finally in production, with the first batch heading off to Ono-Sendai for inclusion in their newest deck. Our research and development department is very proud of this new chip. \"The 68000000 has the capabilities of 1000 chips of older design, with them configured to run in sequential or parallel modes,\" said Dr. Nakamura, Nobel Laureate and head of R and D.\n\n    The latest two figures in our \"Masters of Cyberspace\" playset have been released with great success. \"The Jerk\" and \"Doctor Death\" are the newest characters to be immortalized in petrochemical form. These two figures are part of the \"Interplayers\" collection, but can used in conjunction with the \"Cyberenegades\" and \"Matrix Marauders\" figure sets. Added to the \"Interplayers\" before the end of the year, bringing that group up to the roster features in the \"Matrix Invasion\" season of video dramas in the ongoing \"Software Warriors\" series.",
		},
		['sales'] = {
			type = "message",
			message = "        Corporate Sales Figures\n" ..
				" Item Name          Last year   to Date\n" ..
				" ---------          ---------   -------\n" ..
				" 1. Capt. Midnight  1350000     1377000\n" ..
				" 2. Evil Albrect    1400000     1375000\n" ..
				" 3. AZ482a          1200000      950000\n" ..
				" 4. Spelldeck        822000      855230\n" ..
				" 5. Safe Sex ROM    1200000      825000\n" ..
				" 6. Blackjack ROM    800000      774321\n" ..
				" 7. 68000000          ***        750500\n" ..
				" 8. Nobel ROM         ***        650000\n" ..
				" 9. The Jerk          ***        550000\n" ..
				"10. Dr Death          ***        500000\n",
		},
		['employees'] = {
			type = "list",
			title = "New Eployees List",
			targetOnClick = 'editEmployee',
--			hasDetails = true,
			columns = { { field = 'Name', width = 19 }, { field = 'BAMA ID', width = 0 } },
			formatDetails = function(item) return string.format("\n\nName: %s\nID:   %s\n%s", item.Name, item['BAMA ID'], item.message) end,
			items = s.hosakaEmployees
		},
		['memos'] = {
			type = "list",
			hasDetails = true,
			columns = { { field = 'date', width = 8 }, { field = 'to', width = 20 }, { field = 'from', width = 0 } },
			formatDetails = function(item) return string.format("TO: %s\nFROM: %s\n%s", item.longfrom or item.from, item.longto or item.to, item.message) end,
			items = {
				{ date = 111658, to = "All", from = "E. D. Cooper", message = "    I must once again urge all emplyees to avoid contact with the employees of Tozoku or any of its subsidiearies -- now including Fuji Electric. How much more plainly do I have to say it, people? Tozoku are YAKUZA, pure and simple. They're pumping tons of money into Matelbro's G.I. Akira figure set, to the detriment of our sales. Every time you buy something from Tozoku you're helping finance yourself out of a job. Think about it. They're turning out warez that allow for DB raiding, and they're behind our inability to get Comlink 6.0. It is's paranoia if they ARE out to get you." },
				{ date = 111658, to = "All", from = "E. D. Cooper", message = "    I know some of you employees are in contact with certain \"cyberspace cowboys.\" Hosaka requires Comlinbnk 6.0. We are prepared to pay handsomely for it. Any employee who puts us in touc hwith someone who has the software will get a 10% bonus on the price we pay for the item." },
			}
		},
		['software'] = {
			type = "download",
			items = {
				{ key = 'x', text = "Exit to Main", target = "main" },
				{ key = '1', software = 203 }, -- Comlink 5.0
			}
		},
		['editEmployee'] = {
			type = "custom",
			exit = "employees",
		}
	}
}
hosakacorp=HosakaCorp

function HosakaCorp:GoToPage(pageName)
	if (pageName == 'employees') then
		self.pages['employees'].items = s.hosakaEmployees

	end

	Site.GoToPage(self, pageName)
end

function HosakaCorp:HandleClickedEntry(id)
	if (self.currentPage == 'main' and id > 0) then
		self.editMode = 1
	end

	Site.HandleClickedEntry(self, id)
end

function HosakaCorp:GetCustomEntries(page)
	local entries = {}

	self:GetPageHeaderFooterEntries(page, entries)

	local title = "New Eployees List"
	local titleX = self:CenteredX(title)
	table.append(entries, { x=titleX, y = 2, text = title})
	
	table.append(entries, { x = 0, y = 5, text = "Name:"})
	table.append(entries, { x = 0, y = 6, text = "ID:"})
	table.append(entries, { x = 0, y = 7, text = string.format("Wanted for %s.", s.hosakaEmployees[self.selectedListItem].message)})
	
	if (self.editMode == 2) then
		table.append(entries, { x = 6, y = 5, entryTag = "name"})
	else
		table.append(entries, { x = 6, y = 5, text = s.hosakaEmployees[self.selectedListItem].Name})
	end
	if (self.editMode == 3) then
		table.append(entries, { x = 6, y = 6, entryTag = "id"})
	else
		table.append(entries, { x = 6, y = 6, text = s.hosakaEmployees[self.selectedListItem]['BAMA ID']})
	end

	self:AddExitEditEntries(entries, self.editMode > 0)

	return entries
end

function HosakaCorp:HandleClickedEdit()
	self.editMode = 2
end


function HosakaCorp:OnTextEntryComplete(text, tag)
	if (tag == "name") then
		s.hosakaEmployees[self.selectedListItem].Name = text
		self.editMode = 3
	elseif (tag == "id") then
		s.hosakaEmployees[self.selectedListItem]['BAMA ID'] = text
		self.editMode = 1
		if (string.lower(s.hosakaEmployees[self.selectedListItem].Name) == string.lower(s.name) and text == s.bamaid) then
			s.employed = true
		end
	else
		Site.OnTextEntryComplete(self, text, tag)
	end
end

------------------------

Yakuza = Site:new {
	title = "* Tozoku Imports *",
	comLinkLevel = 5,
	passwords = {
		"yak",
		"<cyberspace>"
	},
	
	baseX = 480,
	baseY = 80,
	
	pages = {
		['title'] = { type = "title", message = " " },
		['password'] = { type = "password" },
		['main'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "Order Status", target = "status" },
				{ key = '2', text = "Specials Available", target = "specials" },
				{ key = '3', text = "Software Library", target = "software" },
			}
		},
		['status'] = {
			type = "message",
			message = "                Order Status\n  The Star of Iowa is reported to be on its way from the People's Republic of New Zealand. It has most of our mutton orders, as well as the Johnson sweater order. We expect it in dock soon.\n\n  The Popul Vox is due in port next week with its cargo hold full of pre-Columbian artwork. Some of the cargo has been damaged because of the shifting during a typhoon, but insurance will cover all damages. The crew has assured us that all damage is minor.",
		},
		['specials'] = {
			type = "message",
			message = "    Tozoku Imports Special Offers\n  We anticipate a certain number of cosmetically imperfect examples of pre-Columbian artwork to be made available in the near future. These works, crafted by long-dead workers, do show some signs of deterioration as caused by acid rain, but the original work is still visible and quite beautiful. Many of the pieces are hollow and make for a perfect place to hide valuables. Prices will vary depending upon condition of the piece, but each and every one of them would make a perfect addition to any home.",
		},
		['software'] = {
			type = "download",
			items = {
				{ key = 'x', text = "Exit to Main", target = "main" },
				{ key = '1', software = 204 }, -- COMLINK 6.0
				{ key = '2', software = 215 }, -- BLOWtoRCH 1.0
				{ key = '3', software = 222 }, -- DECODER 1.0
			}
		},
	}
}
yakuza = Yakuza

------------------------------------------

GemeinPhase = {
	None = {},
	SourceAccount = {},
	LinkCode = {},
	Amount = {},
	TargetAccount = {},
	Transferring = {},
	Transferred = {},
}

GemeinError = {
	None = {},
	UnknownAccount = {},
	UnknownBank = {},
}

BankGemein = Site:new {
	phase = GemeinPhase.None,
	
	title = "* Bank Gemeinschaft *",
	comLinkLevel = 5,
	passwords = {
		"eintritt",
		"verboten"
	},
	
	baseX = 304,
	baseY = 320,
	
	pages = {
		['title'] = { type = "title", message = "  Welcome to Bank Gemeinschaft.\nWe are now in our 6th century of service to customers of discretion." },
		['password'] = { type = "password" },
		['main'] = {
			type = "menu",
			onEnterPage = function(self) self.phase = GemeinPhase.None end,
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "List of Services", target = "services" },
				{ key = '2', text = "Current Rates", target = "rates" },
				{ key = '3', text = "Recommended Securities", target = "securities" },
				{ key = '4', text = "Message Base", target = "messages", level = 2 },
				{ key = '5', text = "Software Library", target = "software", level = 2 },
				{ key = '6', text = "Funds Transfer", target = "transfer", level = 2 },
			}
		},
		['services'] = {
			type = "message",
			message = "    Bank Gemeinschaft prides itself on its long years of service to individuals and nations. The North family still draws a substantial \"pension\" fro the funds we hid from Congressional investigators and the funds entrusted to us by President Nkrumah are still gathering interest. Below is a list of our services.\n1) Automatic Funds Transfer: Our AFT program runs 3.7 nanoseconds faster than our competition, yet we credit you with interest including the time of the transfer.\n2) Investment Counciling: We maintain vast portfolios of securities making us a force within world markets. If we decide to rock the boat we will inform our customers.\n3) Full Automated Bank Transfers: Need an anonymous deposit in a discreet account at another bank? We do that eaier than pouring cash into a paper bag.",
		},
		['rates'] = {
			type = "message",
			message = "1) Automatic FUnds Transfer: .001%, charged against baee account.\n2) Investment Counciling: .05% commission charged on buying and selling securities, thouth they are held in our ultra-secure vaults at no charge.\n3) Fully Automated Bank Transfers: .002% on individuals, .01% on government and drug transactions.\n\n   Interest Rates paid:\n1) 10% on normal savings\n2) 15% on Money Market Funds\n3) 15-20% on Certificates of Deposit",
		},
		['securities'] = {
			type = "message",
			message = "    As always, we suggest Bank Gemeinschaft as a viable investment. Our investments have a 99.4% security rating, and show an annual return rate of 22.1% per year. Out stock reflects this. In the interest of those who wish to diversify their portfolios, we provide the following list of other solid investments, all of which can be access through our brokerage affiliate.\n\n1) Bell Europa\n2) Musabori\n3) Hitachi Biotech\n4) Maas Biolabs\n5) Hosaka\n6) Fuji Electric\n7) Tessier-Ashbppol\n8) Allard Technologies\n   (a T-A subsidiary)",
		},
		['messages'] = {
			type = "list",
			hasDetails = true,
			columns = { { field = 'date', width = 8 }, { field = 'to', width = 15 }, { field = 'from', width = 0 } },
			formatDetails = function(item) return string.format("TO: %s\nFROM: %s\n\n  %s", item.longfrom or item.from, item.longto or item.to, item.message) end,
			items = {
				{ date = 111658, to = "Herr Geistjager", from = "M. Godot", message = "Thank you for the tip about Fuji Electric. I have transferred the $30,000 to your discretionary account as you requested." },
				{ date = 111658, to = "Herr Geistjager", from = "R. Kaliban", longfrom = "Roger Kaliban", message = "I resent very stronglt your suggestion that I am in any way involved i banking irregularities, but I do appreciate your having brought your suspicions to me before taking them to banking officials. I have deposited a token of my appreciation in your discretionary account." },
				{ date = 111658, to = "Epkot", longto = "Epkot Foundation", from = "R. Kaliban", longfrom = "Roger Kaliban", message = "I have looked into your complaint concerning the delay in cash transfers to the Kruo-sleep Corp. of Veracruz. I have apologixed to them on your behalf and have assured them there will be no further delays in forwarding payments to them. They said Walt had not begun to thaw anyway, so no hard was done.\nYour obedient servant,\nRK." },
				{ date = 111658, to = "Adrian Finch", from = "T. Cole", longfrom = "Thomas Cole", message = "Adrian\n   I'm uneasy about the moves Musabori is making on the international scene. Phillip over at Bank of Zurich is uncovering all sorts of irregularities with their accounts. Musabori says it is because of cyberspace Cowboy meddling, but I am ont conviced. They've lost some money over there to an embezzler, if rumors are at all true. We should be careful." },
				{ date = 111658, to = "T. Cole", longto = "Thomas Cole", from = "Adrian Finch", message = "I've foreseen the problem, Thomas, and have taken staps to correct it. Roger Kaliban is a security expert. If Zurich had had him on their staff, they'd not have had any problem." },
			}
		},
		['software'] = {
			type = "download",
			items = {
				{ key = 'x', text = "Exit to Main", target = "main" },
				{ key = '1', software = 222 }, -- DECODER 1.0
				{ key = '2', software = 283 }, -- BudgetPal 24.0 (fake)
				{ key = '3', software = 284 }, -- Receipt Forger 7.0
			}
		},
		['transfer'] = {
			type = "custom",
			onEnterPage = function(self)
				self.phase = GemeinPhase.SourceAccount
				self.error = GemeinError.None
				self.staticSourceAccount = nil
				self.staticLinkCode = nil
				self.staticAmount = nil
				self.staticTargetAccount = nil
			end,
		}
	}

}
bankgemein=BankGemein





function BankGemein:GetCustomEntries(page)
	local entries = {}

	self:GetPageHeaderFooterEntries(page, entries)

	table.append(entries, {x = self:CenteredX("Funds Transfer"), y = 2, text = "Funds Transfer" } )

	if (self.phase == GemeinPhase.SourceAccount) then
		table.append(entries, {x = 0, y = 4, text = "Enter source account number:" } )
		if (self.error == GemeinError.None) then
			table.append(entries, {x = 0, y = 5, entryTag = "sourceaccount", numeric = true } )
		else
			table.append(entries, {x = 0, y = 5, text = self.staticSourceAccount } )
		end
	else
		table.append(entries, {x = 0, y = 3, text = "account no#: 646328356481" } )
		table.append(entries, {x = 0, y = 4, text = "    credits: " .. s.gemeinSourceFunds } )
		table.append(entries, {x = 0, y = 5, text = "Enter destineation bank link code: "} )
		if (self.phase == GemeinPhase.LinkCode and self.error == GemeinError.None) then
			table.append(entries, {x = 0, y = 6, entryTag = "linkcode" } )
		else
			table.append(entries, {x = 0, y = 6, text = self.staticLinkCode } )
			if (self.error == GemeinError.None or self.phase ~= GemeinPhase.LinkCode) then
				table.append(entries, {x = 0, y = 7, text = "Enter amount to transfer:" } )

				if (self.phase == GemeinPhase.Amount and self.error == GemeinError.None) then
					table.append(entries, {x = 0, y = 8, entryTag = "amount", numeric = true } )
				else
					table.append(entries, {x = 0, y = 8, text = self.staticAmount } )
					if (self.error == GemeinError.None or self.phase ~= GemeinPhase.Amount) then
						table.append(entries, {x = 0, y = 9, text = "Enter destination account number:" } )

						if (self.phase == GemeinPhase.TargetAccount and self.error == GemeinError.None) then
							table.append(entries, {x = 0, y = 10, entryTag = "targetaccount", numeric = true } )
						else
							table.append(entries, {x = 0, y = 10, text = self.staticTargetAccount } )
						end
						if (self.phase == GemeinPhase.Transferring) then
							table.append(entries, {x = self:CenteredX("Transferring...Transfer complete"), y = 12, text = "Transferring..." } )
						elseif (self.phase == GemeinPhase.Transferred) then
							table.append(entries, {x = self:CenteredX("Transferring...Transfer complete"), y = 12, text = "Transferring...Transfer complete" } )
							self:GetButtonOrSpaceEntries(entries)
						end
					end
				end
			end
		end
	end

	if (self.error == GemeinError.UnknownAccount) then
		table.append(entries, {x = self:CenteredX("Unknown account"), y = self.sizeY - 3, text = "Unknown account" } )
		self:GetButtonOrSpaceEntries(entries)
	elseif (self.error == GemeinError.UnknownBank) then
		table.append(entries, {x = self:CenteredX("Unknown bank"), y = self.sizeY - 3, text = "Unknown bank" } )
		self:GetButtonOrSpaceEntries(entries)
	end

--	if (self.currentPage == "catalog") then
--		local title = "Current Hardware For Sale"
--		table.append(entries, {x = self:CenteredX(title), y = 2, text = title})
--		table.append(entries, {x = 0, y = self.sizeY - 3, wrap = -1, text = "Come to our store for the latest in up to date software and hardware."})
--
--		self:GetListEntriesEx(page, entries, 3, self.sizeY - 10, true, true, false)
--	end

	return entries
end

function BankGemein:OnTextEntryComplete(text, tag)

	if (tag == "sourceaccount") then
		self.staticSourceAccount = text
		if (text == "646328356481") then
			self.phase = GemeinPhase.LinkCode
		else
			self.error = GemeinError.UnknownAccount
		end
	elseif (tag == "linkcode") then
		self.staticLinkCode = text
		if (text == "bozobank") then
			self.phase = GemeinPhase.Amount
		else
			self.error = GemeinError.UnknownBank
		end
	elseif (tag == "amount") then
		local amount = tonumber(text)
		self.staticAmount = text
		
		if (amount > s.gemeinSourceFunds) then
		else
			self.phase = GemeinPhase.TargetAccount
		end
	elseif (tag == "targetaccount") then
		self.staticTargetAccount = text
		if (text == "712345450134") then
			self.phase = GemeinPhase.Transferring
			StartTimer(3, self, function(self)
\				self.phase = GemeinPhase.Transferred
				s.gemeinSourceFunds = s.gemeinSourceFunds - tonumber(self.staticAmount)
				s.gemeinAccount = s.gemeinAccount + tonumber(self.staticAmount)
			end)
		else
			self.error = GemeinError.UnknownAccount
		end
	else
		Site.OnTextEntryComplete(self, text, tag)
	end
end

function BankGemein:OnGenericContinueInput()
	if (self.phase ~= GemeinPhase.None) then
		self:GoToPage("main")
		return
	end

	Site.OnGenericContinueInput(self)
end

