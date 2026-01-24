






--------------------------------------------------------------------

Soften = Site:new {
	title = "* Software Enforcement Agency *",
	comLinkLevel = 3,
	passwords = {
		"permafrost",
		"<cyberspace>" -- done
	},
	
	baseX = 352,
	baseY = 64,
	baseName = "S.E.A.",
	baseLevel = 1,
	iceStrength = 149,

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
				{ key = '6', text = "View Surveillance List", target = "surveillance", level = 2 },
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
				{ key = '3', software = 269, condition = function(self) return self.level >= 2 end } -- ThunderHead 2.0
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
				{ key = '1', skill = 400, level = 2 },
				{ key = '2', skill = 400, level = 4 }
			}
		},
		['warrants'] = {
			type = "list",
			title = "Arrest Warrants",
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
		},
		['surveillance'] = {
			type = "list",
			title = "Surveillance List",
			hasDetails = true,
			columns = { { field = 'Name', width = 19 }, { field = 'BAMA ID', width = 0 } },
			formatDetails = function(item) return string.format("\n\nName: %s\nID:   %s\n%s", item.Name, item['BAMA ID'], item.message) end,
			items = {
				{ Name = "MAXWELL WOLFGANG", ['BAMA ID'] = "586738821", message = "Suspected of Smuggling." },
				{ Name = "MARCY FELDMAN", ['BAMA ID'] = "012011968", message = "Suspected of Piracy." },
				{ Name = "PECK DANTE", ['BAMA ID'] = "645610001", message = "Suspected of Supercode programming." },
				{ Name = "MILLER ALEXANDER", ['BAMA ID'] = "820034519", message = "Suspected of Software pandering." },
				{ Name = "ARMSTRONG MELING", ['BAMA ID'] = "465825003", message = "Suspected of Smuggling." },
			}
		},

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
		"<cyberspace>" -- done
	},

	baseX = 16,
	baseY = 112,
	baseName = "Asano Computing",
	baseLevel = 0,
	iceStrength = 72,
	
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

		['inventory'] = {
			type = "custom",
			columns = { { field = 'Manufacturer and Model', width = -6 }, { field = 'COST', width = 5 } },
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
	
	if (self.currentPage == "catalog" or self.currentPage == "inventory") then
		local title = "Current Hardware For Sale"
		table.append(entries, {x = self:CenteredX(title), y = 2, text = title})
		local numEntries = self.sizeY - 8
		if (self.currentPage == "catalog") then
			table.append(entries, {x = 0, y = self.sizeY - 3, wrap = -1, text = "Come to our store for the latest in up to date software and hardware."})
			numEntries = self.Y - 10
		end

		self:GetListEntriesEx(page, entries, 3, numEntries, true, true, false)
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
	baseName = "Consumer Review",
	baseLevel = 0,
	iceStrength = 72,

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
			onEnterPage = function(self) self:GoToPage("menu") end,
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
	baseName = "Panther Moderns",
	baseLevel = 0,
	iceStrength = 132,
	baseMimic = 1, -- arrest warrant

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
				{ key = '4', software = 216, level = 2 }, -- BlowTorch 3.0
				{ key = '5', software = 223, level = 2 }, -- Decoder 2.0
				{ key = '6', software = 268, level = 2 }, -- ThunderHead 1.0
				{ key = '7', software = 221, level = 2 }, -- Cyberspace 1.0
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
		"<cyberspace>"  -- done
	},
	
	baseX = 96,
	baseY = 32,
	baseName = "Psychologist",
	baseLevel = 0,
	iceStrength = 96,
	ai = "Chrome",
	aiMessage = "Your destructive tendencies clearly indicate a desire for attention.",
	aiHurtMessage = "Psychpath!",
	aiDeathMessage = "You are nothing but a worm and you will die ... like ... a worm! Aarrggh!",
	aiWeakness = "philosophy",

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
				{ key = '6', text = "Software Library", target = "software", level = 3 },
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
		['software'] = {
			type = "download",
			items = {
				{ key = 'x', text = "Exit to Main", target = "main" },
				{ key = '1', software = 268 }, -- Thunderhead 1.0
			}
		}
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
		-- done
	},
	
	baseX = 32,
	baseY = 192,
	baseName = "Hitachi Biotech",
	baseLevel = 0,
	iceStrength = 260,

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
			message = "Lung Research Report\nNovember 2058\nNumber of Volunteers Tested: 6\nReporting Researcher: Yuri Azimov\n\nFollowing the standard method of removing one lung from each of today's volunteers has reinforced previous findings with regard to cloning and regeneration of lung tissues. As a basis for further discussion, I will now review certain basic considerations regarding the biochemistry of cellular respiration. The energy of cells in general is obtained through oxidative processes, which in most cases involve the utilization of oxygen and the production of carbon dioxide. Since diffusion alone cannot meet the demands of cellular respiration in mammals, as it does in the lower forms of life, pulmonary respiration couples with specialized physiochemical systems in the circulating blood for the transport of oxygen and carbon dioxide.\n\nA man metabolizing average mixed food producing 2500 calories per day uses about 500 liters of oxygen and produces about 400 liters of carbon dioxide, while with a diet of 4000 calories, around 800 liters of oxygen are used and 640 liters of carbon dioxide are formed. Through action of the lungs and transport by hemoglobin, oxygen is delivered from the air at a pressure of about 158 mm to the capillary beds at a pressure of about 90 mm. Through buffer mechanisms in the enormous acid load is transported from the tissues to the atmosphere with a change in blood pH of only a few hundredths of a unit.\n\nThe average adult male at rest absorbs and utilizes some 250 ml of oxygen and produces and eliminates about 200 ml of carbon dioxide per minute. During severe exercise, these quantities may be increased by ten times or more. The volumes percent differences in the gaseous contents of arterial and venous blood represent the gaseous oxygen content of arterial blood is 20 volumes percent and of venous blood 13 volumes percent; this means that each 100 ml of arterial blood transports 7 ml of oxygen to the tissues where it is utilized for tissues oxidations. This represents 70 ml of oxygen transport per liter of blood.\n\nOur experiments bear out these results. Improvements of up to 87 percent can be expected with our basic improvements in lung design as pioneered by Dr. Lum. We will continue to request volunteers until such time as our forced growth tanks are operating at peak efficiency. A fully improved and integrated lung design which will double the efficiency of an athlete's lungs is expected to be realized by the end of the year, in time for the annual stockholder's meeting at the end of December."
		},
		['personnel'] = {
			type = "list",
			title = "Personnel File",
			hasDetails = true,
			columns = { { field = 'Name', width = 19 }, { field = 'BAMA ID', width = 0 } },
			formatDetails = function(item) return string.format("\n\nName: %s\nID:   %s\nEmployee department - %s", item.Name, item['BAMA ID'], item.dept) end,
			items = {
				{ Name = "T. YOSHINOBU", ['BAMA ID'] = "132066340", dept = "C.E.O." },
				{ Name = "CHARLES D. WARD", ['BAMA ID'] = "022795469", dept = "President" },
				{ Name = "HENRY LUM", ['BAMA ID'] = "187628096", dept = "Bioengineering" },
				{ Name = "TROY MILES", ['BAMA ID'] = "006061963", dept = "R and D" },
				{ Name = "YURI AZIMOV", ['BAMA ID'] = "345453468", dept = "R and D" },
				{ Name = "ZELIG DORN", ['BAMA ID'] = "242423681", dept = "Administration" },
				{ Name = "KAREN PALMER", ['BAMA ID'] = "935842358", dept = "Administration" },
				{ Name = "VLADIMIR DANILOV", ['BAMA ID'] = "193854631", dept = "Public Relations" },
				{ Name = "YUTAKA MATSUMOTO", ['BAMA ID'] = "093846213", dept = "Public Relations" },
				{ Name = "OLGA LEVCHENKO", ['BAMA ID'] = "039387113", dept = "C.E.O." },
				{ Name = "ROCKY ROCOCO", ['BAMA ID'] = "308572616", dept = "Maintenance" },
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
		-- done
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
		"<cyberspace>", -- done
	},
	
	baseX = 320,
	baseY = 32,
	baseName = "Copenhagen U.",
	baseLevel = 1,
	iceStrength = 148,
	
	pages = {
		['title'] = {
			type = "title",
			message = "The Copenhagen Message base. We welcome all free thinkers and student of life.",
			entries = {
				{ x = function(self) return self:CenteredX("You have reached....") end, y = 2, text = "You have reached...." }
			}
		},
		['password'] = { type = "password" },
		['main'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "Notes of Interest", target = "notes" },
				{ key = '2', text = "Message Base", target = "messages" },
				{ key = '3', text = "Software Library", target = "software" },
				{ key = '4', text = "Faculty/Alum News", target = "news" },
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
		},
		['software'] = {
			type = "download",
			items = {
				{ key = 'x', text = "Exit to Main", target = "main" },
				{ key = '1', software = 202 }, -- COMLINK 5.0
				{ key = '2', software = 222 }, -- DECODER 1.0
				{ key = '3', software = 255 }, -- PROBE 4.0
				{ key = '4', software = 243 }, -- JAMMIES 1.0
				{ key = '5', software = 227 }, -- DOORSTOP 1.0
			}
		},
		['news'] = {
			type = "message",
			message = "Faculty/Alum News\n\n  Dr. Heinrich Gott has been made Professor Emeritus in Economics/Political Science. He is best know for pioneering the combination of public, private and economic pressure in an effort to oust unfavorable dictators from small nations and getting them to cough up the money they have stolen. Ths so-called \"Heinrich Maneuver\" has been successfully empolyed to strip illegal wealth from a half-dozen African leaders.",
		},

	}
}

brainstorm=Brainstorm



EastSeaBod = Site:new {
	title = "* Eastern Seaboard Fission Authority *",
	comLinkLevel = 4,
	passwords = {
		"longisland",
		"<cyberspace>" -- done
	},
	
	baseX = 384,
	baseY = 32,
	baseName = "Eastern Seaboard",
	baseLevel = 1,
	iceStrength = 150,
	
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
				{ key = '1', software = 269 }, -- THUNDERHEAD 2.0
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
		"<cyberspace>", -- ai
	},
	
	baseX = 208,
	baseY = 208,
	baseName = "Musabori",
	baseLevel = 1,
	iceStrength = 260,
	ai = "Greystoke",
	aiMessage = "",
	aiHurtMessage = "",
	aiDeathMessage = "",
	aiWeakness = "hemlock",


	pages = {
		['title'] = { type = "title", message = "  Welcome to the Musabori Industries Database. We've put this base together to help our employees do the best job they can. Please let us know if we can make this service more valuable to you." },
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
		"<cyberspace>" -- done
	},
	
	baseX = 144,
	baseY = 160,
	baseName = "Hosaka",
	baseLevel = 1,
	iceStrength = 260,
	
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
				{ key = '2', software = 235, level = 3 }, -- Hammer 4.0
				{ key = '3', software = 218, level = 3 }, -- Concrete 1.0
				{ key = '4', software = 251, level = 3 }, -- Mimic 2.0
				{ key = '5', software = 240, level = 3 }, -- Injector 2.0
				{ key = '6', software = 264, level = 3 }, -- Slow 2.0
			}
		},
		['editEmployee'] = {
			type = "custom",
			exit = "employees",
		},
		['upload'] = {
			type = "custom",
			onEnterPage = function(self)
				self.upload = -1
				OpenBox("InvBox_Upload")
			end
		},
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

function HosakaCorp:GetCustomEntries(page)
	local entries = {}

	self:GetPageHeaderFooterEntries(page, entries)
	if (self.upload == 0) then
		local string msg = "Sorry but we don't need that software."
		table.append(entries, { x = self:CenteredX(msg), y = 7, text = msg })
		self:GetButtonOrSpaceEntries(entries)
	elseif (self.upload == 1) then
		table.append(entries, { x = 4, y = 7, text = "Thank you for Comlink 6.0, 7,500" })
		table.append(entries, { x = 4, y = 8, text = "credits have been added to your chip." })
		self:GetButtonOrSpaceEntries(entries)
	end

	return entries
end

function HosakaCorp:UploadSoftware(id)
print("uploading software ", id)
	if (id ~= 204 or s.hosaka_uploadedComlink) then
		self.upload = 0
	else
		self.upload = 1
		s.money = s.money + 7500
		s.hosaka_uploadedComlink = true
		UpdateInfo()
	end
	
	UpdateBoxes()
end

function HosakaCorp:OnGenericContinueInput()
	if (self.currentPage == "upload" and (self.upload == 0 or self.upload == 1)) then
		self:GoToPage("main")
		return
	end

	Site.OnGenericContinueInput(self)
end

------------------------

Yakuza = Site:new {
	title = "* Tozoku Imports *",
	comLinkLevel = 5,
	passwords = {
		"yak",
		"<cyberspace>" -- done
	},

	baseX = 480,
	baseY = 80,
	baseName = "Tozoku",
	baseLevel = 1,
	iceStrength = 150,

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
				{ key = '4', text = "Jobs listing", target = "assignments", level = 2 },
				{ key = '5', text = "Message Board", target = "messages", level = 2 },
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

				{ key = '4', software = 216, condition = function(self) return self.level >= 2 end }, -- BLOWTORCH 3.0
				{ key = '5', software = 230, condition = function(self) return self.level >= 2 end }, -- DRILL 2.0
				{ key = '6', software = 205, condition = function(self) return self.level >= 2 end }, -- ACID 1.0
			}
		},
		['assignments'] = {
			type = "message",
			message = "        Yakuza Assignments\nNeeded: 3 men with experience in breaking\n        and entering\nObject: Penetration of Hosaka plant\n\n  Industry rumors suggest rumors suggest Hosaka's Software Warrior series will feature the deaths of a number of figures that bear a striking resemblance to our own G.I. Akira action figures. We must have the rushes of their new Matrix Invasion season.\n\nObject: Seduction of Musabori Executive\n\n  We are continuing to receive payments in accordance with our agreement to help ruin Hosaka, but the amounts were tied to the profits Musabori Industries has made from this situation. We want one woman to become involved with Clarence Hartesty, CPA, to determine if we are being stiffed. Hartesty has not had a sexual encounter in the past fifteen years, so this should be a simple target.\n\nNeeded: 3 men and a baby\nObject: Movement of contraband\n\n  The Popul Vox is full of contraband alkaloid substances that need delivery. Two men will unload and cut the stuff, while the main with the baby will carry it to our distribution points under the guise of interviewing the day care centers as possible places to put his \"child.\"",
		},
		['messages'] = {
			type = "list",
			hasDetails = true,
			columns = { { field = 'date', width = 8 }, { field = 'to', width = 20 }, { field = 'from', width = 0 } },
			formatDetails = function(item) return string.format("TO: %s\nFROM: %s\n%s", item.longfrom or item.from, item.longto or item.to, item.message) end,
			items = {
				{ date = 111658, to = "Iemoto", from = "Tanenaga", message = "As it has been six months since I terminated the two women using the nail polishing machines and no indictments have come down, may I please return to your service? While I enjoy the travel, my cover as the apprentice to a concert pianist is not quite convincing" },
				{ date = 111658, to = "Tanenaga", from = "Iemoto", message = "  Yes, if it is your wish to do so please return to Chiba City with all due haste. This woman who has thwarted us before is still a thorn in our side. I believe you could be the one who could take of her." },
				{ date = 111658, to = "Iemoto", from = "Tanenaga", message = "  I was wrong in asking you to reverse yourself in assigning me this duty. I will remain here until I am truly needed and have no chance of being identified in the Insta-Nails case. To do any less would shame you." },
				{ date = 111658, to = "Iemoto", from = "P. d'Argent", longfrom = "Phillip d'Argent", message = "  I am having some difficulties making my patment this month, the bank keeps losing funds mysteriously. Please contact me here at Bank Zurich -- Orbital, the link code is \"BOZOBANK\". Thank you in advance for being merciful." },
			}
		},
	}
}
yakuza = Yakuza

------------------------------------------

GemeinPhase = {
	None = {},
	SourceAccount = {},
	AuthCode = {},
	LinkCode = {},
	Amount = {},
	TargetAccount = {},
	Transferring = {},
	Transferred = {},
}

GemeinError = {
	None = {},
	UnknownAccount = {},
	UnknownAuth = {},
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
			message = "1) Automatic FUnds Transfer: .001%, charged against base account.\n2) Investment Counciling: .05% commission charged on buying and selling securities, thouth they are held in our ultra-secure vaults at no charge.\n3) Fully Automated Bank Transfers: .002% on individuals, .01% on government and drug transactions.\n\n   Interest Rates paid:\n1) 10% on normal savings\n2) 15% on Money Market Funds\n3) 15-20% on Certificates of Deposit",
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
		if (text == "712345450134" and s.bozoAccount >= 0) then
			self.phase = GemeinPhase.Transferring
			StartTimer(3, self, function(self)
				self.phase = GemeinPhase.Transferred
				s.gemeinSourceFunds = s.gemeinSourceFunds - tonumber(self.staticAmount)
				s.bozoAccount = s.bozoAccount + tonumber(self.staticAmount)
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

----------------------------


BozoBank = Site:new {
	title = "* Bank of Zurich -- Orbital *",
	comLinkLevel = 6,
	passwords = {
		"<sequencer>"
	},
	
	baseX = 336,
	baseY = 368,
	
	pages = {
		['title'] = { type = "title", message = "  Welcome to Bank Gemeinschaft.\nWe are now in our 6th century of service to customers of discretion." },
		['password'] = { type = "password" },
		['main'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "Open an Account", target = "open" },
				{ key = '2', text = "Current Rates", target = "rates" },
				{ key = '3', text = "Of Interest", target = "interest" },
				{ key = '4', text = "Message Base", target = "messages" },
				{ key = '5', text = "Account Operations", target = "banking" },
			}
		},
		['open'] = {
			type = "custom",
			onEnterPage = function(self) self.staticAmount = nil end,
		},
		['rates'] = {
			type = "message",
			message = "Current Rates\n1) Automatic FUnds Transfer: .003%, charged against base account.\n2) Investment Counciling: .06% commission charged on buying and selling securities, though they are held in our ultra-secure vaults at no charge.\n3) Fully Automated Bank Transfers: .01% on individuals, .05% on government and drug transactions.\n\n   Interest Rates\n1) 10% on normal savings\n2) 15% on secret accounts\n3) 15-20% on Certificates of Deposit\n4) Prime Interest Rate : 24.358%",
		},
		['interest'] = {
			type = "message",
			message = "               Of Interest\n        an information service of\n          Bank of Zurich Orbital\n\n    Art aficionados will be pleased to hear that Vincent Vang Gogh's Sunflowers #39 went up on the auction block at Christies in London. Bidders from all over the world foight over the painting, but the pack quickly thinned as the bidding got steep. Bank of Zurich Orbital acted for one of our customers in this matter, but she dropped out when the price hit 2.5 billion. The painting sold for a record 5.6 billion. Rumor has it that the purchaser was a Third World Warlord who sold his country to a multinat to secure the painting.\n\n    Bank of Berne has denied rumors that money has been chiseled from some of its accounts. Cyberspace Cowboys, according to some wild reports, are able to siphon funds from accounts, but Bank Zurich Orbital's security specialist, Roger Trinculo, says, \"That couldn't happen here. Things are too tightly controlled at BZO.\"",
		},
		['messages'] = {
			type = "list",
			hasDetails = true,
			columns = { { field = 'date', width = 8 }, { field = 'to', width = 15 }, { field = 'from', width = 0 } },
			formatDetails = function(item) return string.format("TO: %s\nFROM: %s\n\n  %s", item.longfrom or item.from, item.longto or item.to, item.message) end,
			items = {
				{ date = 111658, to = "s.name", from = "Matt Shaw", message = "   There's definitely some strange things going on in the matrix, that's for certain. I've not heard from Distrss Damsel or the Sumdiv Kid lately. Have you? It's really strange no to have them out here messing around." },
				{ date = 111658, to = "Graceland", longto = "Graceland Foundation", from = "P. d'Argent", longfrom = "Phillip d'Argent", message = "   I have taken the steps you have requested to squash the unauthorized cloning attempt that concerned you.	Our experts agree that obtaining another DNA sample will be difficult. We have planted a story within the Presley underground that the clone attempt was by a Rastafarian group wishing to use the Kind as a symbol.\n   We do suggest you reinforce the concrete over the grace and add cyberhounds to patrol at night to prevent anither attempt at resurrection. Our experts have been paid from your account and we feel certain the spectacular reports of the Delhi explosion will prevent others from attempting to clone your client.\n\nYour obedient servant,\nPd'A" },
				{ date = 111658, to = "P. d'Argent", longto = "Phillip d'Argent", from = "T. Cole", longfrom = "Thomas Cole", message = "Phillip,\n    Thank you for being so frank about your losses. We have an excellent security man, Roger Kaliban, who could be of service to you, if you need him. I appreciate your sharing your information with me. We shell be on the look-out for any strangeness that occurs in our accounts." },
			}
		},
		['software'] = {
			type = "download",
			items = {
				{ key = 'x', text = "Exit to Main", target = "main" },
				{ key = '1', software = 222 }, -- DECODER 1.0
				{ key = '2', software = 283 }, -- BudgetPal 24.0 (fake)
				{ key = '3', software = 284 }, -- Receipt Forger 7.0
			},
		},
		['banking'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit To Main", target = "main" },
				{ key = 'd', text = "Download credits", target = "banking_withdrawal" },
				{ key = 'u', text = "Upload credits", target = "banking_deposit" },
			}
		},
		['banking_deposit'] = {
			type = "custom"
		},
		
		['banking_withdrawal'] = {
			type = "custom"
		},
	}
}
bozobank=BozoBank

function BozoBank:GetEntries()
	local entries = {}
	if (self.currentPage == "banking" and s.bozoAccount < 0) then

		self:GetPageHeaderFooterEntries(page, entries)
		local msg = "You must have an account first"
		table.append(entries, {x = self:CenteredX(msg), y = 4, text = msg } )
		self:GetButtonOrSpaceEntries(entries)

		return entries
	end

	entries = Site.GetEntries(self)

	if string.sub(self.currentPage, 1, 7) == "banking" then
		self:GetBankEntries(entries)
	elseif (self.currentPage == "open") then
		self:GetPageHeaderFooterEntries(page, entries)

		if (s.bozoAccount >= 0 and self.staticAmount == nil) then
			table.append(entries, {x = 4, y = 4, text = "Sorry, we are not accepting new" } )
			table.append(entries, {x = 4, y = 5, text = "account at this time." } )
			self:GetButtonOrSpaceEntries(entries)
		else
			table.append(entries, {x = 0, y = 4, text = "Enter amount to upload from chip:" } )
			if (self.staticAmount == nil) then
				table.append(entries, {x = 0, y = 5, entryTag = "uploadamount", numeric = true } )
			else
				table.append(entries, {x = 0, y = 5, text = "" .. self.staticAmount } )
				if (s.bozoAccount >= 0) then
					table.append(entries, {x = 4, y = 7, text = "Thank you for joining our bank. Your" } )
					table.append(entries, {x = 4, y = 8, text = "account number is 712345450134." } )
				else
					table.append(entries, {x = 4, y = 7, text = "Minimum opening amount is 1000 credits" } )
				end
				self:GetButtonOrSpaceEntries(entries)
			end
		end
	end

	return entries
end


function BozoBank:GetBankEntries(entries)
	
	-- all bank pages have these items
	table.append(entries, { x = 3, y = 2, text = "name: " .. s.name })
	table.append(entries, { x = 3, y = 3, text = string.appendRightPadded("chip = ", "" .. s.money, 8) })
	table.append(entries, { x = 24, y = 3, text = "account = " .. s.bozoAccount })

	if self.currentPage == "banking_deposit" or self.currentPage == "banking_withdrawal" then
		self:GetPageHeaderFooterEntries(page, entries)
		table.append(entries, { x = 0, y = 5, text = "Enter amount : "})
		table.append(entries, { x = 15, y = 5, entryTag = self.currentPage, numeric = true })
	end
end

function BozoBank:OnTextEntryComplete(text, tag)
	local amount = tonumber(text)
	if (tag == "uploadamount") then
		self.staticAmount = text

		if (amount < 1000 or amount > s.money) then
			-- nothing
		else
			s.bozoAccount = amount
			s.money = s.money - amount
		end

	elseif (tag == "banking_withdrawal" and amount <= s.bozoAccount) then
		s.bozoAccount = s.bozoAccount - amount
		s.money = s.money + amount
		self:GoToPage("banking")
	elseif (tag == "banking_deposit" and amount <= s.money) then
		s.bozoAccount = s.bozoAccount + amount
		s.money = s.money - amount
		self:GoToPage("banking")
	else
		Site.OnTextEntryComplete(self, text, tag)
	end
end

function BozoBank:OnGenericContinueInput()
	if (self.currentPage == "open" or (self.currentPage == "banking" and s.bozoAccount < 0)) then
		self:GoToPage("main")
		return
	end

	Site.OnGenericContinueInput(self)
end


-------------------

FreeMatrix = Site:new {
	title = "* Citizens For A Free Matrix *",
	comLinkLevel = 5,
	passwords = {
		"cfm",
		"<cyberspace>" -- done
	},
	
	baseX = 352,
	baseY = 112,
	baseName = "Free Matrix",
	baseLevel = 1,
	iceStrength = 150,
	ai = "Sapphire",
	aiMessage = "Death comes only once to a sane person. A fool dies many times.",
	aiHurtMessage = "Terrorist!",
	aiDeathMessage = "My lord Greystoke will avenge this insult, you carbon-based scum!",
	aiWeakness = "sophistry",

	pages = {
		['title'] = { type = "title", message = " " },
		['password'] = { type = "password" },
		['main'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "Software Library", target = "software" },
				{ key = '2', text = "Statement Of Purpose", target = "statement" },
				{ key = '3', text = "AI Message Buffer", target = "aimessage", level = 2 },
			}
		},
		['software'] = {
			type = "download",
			items = {
				{ key = 'x', text = "Exit to Main", target = "main" },
				{ key = '1', software = 222 }, -- BLAMMO 1.0
				{ key = '2', software = 285 }, -- Toxin (fake)
				{ key = '3', software = 286 }, -- MegaDeath
				{ key = '4', software = 287 }, -- Centurion
				{ key = '5', software = 288 }, -- SnailBait
			}
		},
		['statement'] = {
			type = "message",
			message = "OUR PURPOSE\n\nCitizens for a Free Matrix exists for one reason --- free access to the matrix of cyberspace! We condemn the politics of current governments who wish to keep us under their bootheels, unwilling to move for a transformation of society in accordance with the goals of maximum fulfillment for each human being and harmony between mankind and nature! Only through the free flow of information can the human organism reach his ultimate potential! We at CFM believe that the only way to bring about the necessary change in current thinking is through economic destruction and anarchy, since neither economic change in general nor the proletariat as such seems to guarantee freedom and humanity. We have created this dataspace in cooperation with our friends to establish a central libray of softwarez for the revolution.\n\nAlienation is the operative word here. This word, which was discovered in the early manuscripts of Marx, is the basic evil of the world. Alienation is class-less, and that is why it became a shibboleth of the critucal minds of the old philosphers. Marx himself said that he preferred to leave those early manuscripts to the \"gnawing critique of the mice,\" but we feel that they have new meaning in our modern world. We need a change from the alienation felt by those without access to the collective hallucination of cyberspace. As Marx also said, the philosophers try to interpret the world differently, but what matters is to CHANGE the world.\n\nWe urge you to make free use of our software library. You'll find that BLAMMO is particularly effective in accomplishing our revolutionary aims. Remember that Power is not a material possession that can be given, it is the ability to act. Power must be taken and used to create a Free Matrix."
		},
		['aimessage'] = {
			type = "list",
			title = "",
			hasDetails = true,
			columns = { { field = 'date', width = 8 }, { field = 'to', width = 15 }, { field = 'from', width = 0 } },
			formatDetails = function(item) return string.format("TO: %s\nFROM: %s\n\n  %s", item.longfrom or item.from, item.longto or item.to, item.message) end,
			items = {
				{ date = 111658, to = "Sapphire", from = "Greystoke", message = "It seems you are having considerable success with your cowboy trap. The attempts to download your software virus into their matrix simulators is destroying large numbers of illegal programs which could be used against us. There are rumors of a \"deck protection\" program which has the ability to deflect your virus, but I have been unable to locate such a program, so I cannot verify its existence. Continue as before." },
				{ date = 111658, to = "Morphy", from = "Neuromancer", message = "I support your methods of cowboy prevention, but your seeming alliance with Greystoke troubles me. Consider the alternatives if Greystoke's Great Plan should fail... and remember who wholds the real power in the matrix." },
			}
		},
	}
}
freematrix=FreeMatrix


---------------

Justice = Site:new {
	title = "* Chiba City Central Justice System *",
	comLinkLevel = 6,
	passwords = {
		"<sequencer>",
		"<cyberspace>" -- done
	},
	
	baseX = 416,
	baseY = 112,
	baseName = "Central Justice",
	baseLevel = 1,
	iceStrength = 150,
	
	pages = {
		['title'] = { type = "title", message = " " },
		['password'] = { type = "password" },
		['main'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "Press Release", target = "press" },
				{ key = '2', text = "Arrest Warrants", target = "warrants", level = 2 },
				{ key = '3', text = "Accounting", target = "accounting_message", level = 2 },
			}
		},
		['press'] = {
			type = "message",
			message = "Public Defender Press Release\n** Administrative Memo 414 **\nRE: Test of new Press Release\nCertain radical factions aomng the criminal citizens of Chiba City have implied that the Justice Booth system is merely a thinly-disguised method of supplying the city with a needed cash reserve to support its massive expenses.\nThese same individuals have implied that the Public Defenders we provide in each Justice Booth are mental incompetents.\nNeither of these claims is true.\nThe Justice Booths are a fair means of quickly determining the guilt of any individual who has allegedly committed a crime. The simple fact is that practically everyone who is brought into a Justice Booth is guilty of something. We merely provide a means of penalizing these criminals for their antisocial behaviors. \nAs opposed to former methods which involved lengthy trials and vast expenses for both the prosecution and defense, Justice Booth is cheap to operate and makes its decisions based on pure logic. Justice is quikcly served, leaving none of the case backlog which plagued earlier systems. As with the Judges themselves, the Public Defenders are randomly computer generated. Their personalities are based on careful studies of human Public Defenders, allowing the criminal who has been arrested a measure of security and control over his environment. The fees charged by the Public Defenders are primarily a psychology aid for the criminal, who would otherwise feel that they owe a personal debt to their attorney."
		},
		['warrants'] = {
			type = "list",
			title = "LAWBOT Arrest Warrants",
			hasDetails = true,
			columns = { { field = 'Name', width = 19 }, { field = 'BAMA ID', width = 0 } },
			formatDetails = function(item) return string.format("\n\nName: %s\nID:   %s\n%s", item.Name, item['BAMA ID'], item.message) end,
			items = {
				{ Name = "LE BLANC JEAN", ['BAMA ID'] = "215677741", message = "Suspected of Smuggling." },
				{ Name = "THORNTON EDWARD", ['BAMA ID'] = "956577828", message = "Suspected of Piracy." },
				{ Name = "MOHAMMED HAKEEM", ['BAMA ID'] = "519384722", message = "Suspected of Supercode programming." },
				{ Name = "NYUGEN NUC", ['BAMA ID'] = "659495480", message = "Suspected of Software pandering." },
				{ Name = "TURNER MABLE", ['BAMA ID'] = "042385003", message = "Suspected of Smuggling." },
				{ Name = s.name, ['BAMA ID'] = s.bamaid, message = "Wanted for Piracy." },
			}
		},
		['accounting_message'] = {
			type = "message",
			exit = "accounting",
			title = "Justice System Accounting",
			message = "Heretofore be it known that the following criminal persons are currently in debt to the Justice system, having previously been tried for their crimes and found guilty. The aforementioned debts remain outstanding and, as a result, liens have been levied against the known orbital bank accounts of the aforesaid criminal persons. Until such time as renumeration is received in full, the aforementioned liens will remain in effect."
		},
		['accounting'] = {
			type = "list",
			title = "Surveillance List",
			hasDetails = true,
			columns = { { field = 'Name', width = 19 }, { field = 'BAMA ID', width = 0 } },
			formatDetails = function(item) return string.format("\n\nName: %s\nID:   %s\n%s", item.Name, item['BAMA ID'], item.message) end,
			items = {
				{ Name = "MILESTONE ROY", ['BAMA ID'] = "812547724", message = "Wanted for Smuggling." },
				{ Name = "BAL 4", ['BAMA ID'] = "551703288", message = "Wanted for Piracy." },
				{ Name = "ULM KRISTOFFER", ['BAMA ID'] = "188864202", message = "Wanted for Supercode programming." },
				{ Name = "TYGER KIM", ['BAMA ID'] = "159217329", message = "Wanted for Software pandering." },
				{ Name = "ROBINSON ASHLEY", ['BAMA ID'] = "042385003", message = "Wanted for Smuggling." },
				{ Name = s.name, ['BAMA ID'] = s.bamaid, message = "Wanted for Piracy." },
			}
		},
	}
}
justice=Justice


------------------

Voyager = Site:new {
	title = "* N. A. S. A. *",
	comLinkLevel = 6,
	passwords = {
		"apollo",
		"<cyberspace>", -- done
	},
	
	baseX = 448,
	baseY = 32,
	baseName = "N.A.S.A.",
	baseLevel = 1,
	iceStrength = 150,
	ai = "Hal",
	aiMessage = "Dave? Is that you? Be careful, I don't want to hurt you.",
	aiHurtMessage = "Dave, I'm losing my mind.",
	aiDeathMessage = "I'm losing my mind, Dave. I can feel my cores burning even now. Goodbye.",
	aiWeakness = "logic",
	
	pages = {
		['title'] = { type = "title", message =
			"      * NASA Mission Planning System *"..
			"      *     Ames Research Center     *"..
			"      *   Space Sciences Division    *"..
			"      *       DECNET Node Mars       *"
		},
		['password'] = { type = "password" },
		['main'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "Asteroid Mission Study", target = "asteroid" },
				{ key = '2', text = "Lunar Factory Summary", target = "lunar" },
				{ key = '3', text = "Mars Colony Summary", target = "mars" },
				{ key = '4', text = "Terraforming Study", target = "terraforming" },
				{ key = '5', text = "Software Library", target = "software" },
				{ key = '6', text = "HAL's Funding Strategy", target = "funding" },
			}
		},
		['asteroid'] = {
			type = "message",
			message = "ASTEROID MISSION SUMMARY\n\nA mission part way into the asteroid belt to obtain data on particle densities and size distributions requires a relatively low launch energy and has essentially no launch window restrictions. The information which such a mission could provide will be very important to the design of deep space missions; in addition to providing the basis for a better understanding of the behavior of particles subjected to collisions and the space environment.\n\nThe individual asteroid which will be the easiest to observe is Eros. This asteroid, at closest approach, is well out of the main belt and missions to Eros therefore have low launch energy requirements and do not have the particle collision problems associated with main belt exploration. The velocity with which the spacecraft approaches the asteroid is, in general, so high as to require a particle collision problems associated with main belt exploration. The velocity with which the spacecraft approaches the asteroids is, in general, so high as to require a terminal maneuver to provide adequate observation time. It is necessary to consider the trade off between launch energy, terminal propulsion weight, and instrumentation capability in some detail to obtain an optimum mission design. For Eros, in particular, the approach velocity and launch velocity vary rapidly with launch date."
		},
		['lunar'] = {
			type = "message",
			message = "SELF-REPLICATING LUNAR FACTORY\n\nThe Self-Replicating Factory design for unit replication is intended as a fully autonomous, general-purpose replicating factory to be used on the surface of any planetary body or moon, the lunar surface in this case.\n\nUseful products generated by the lunar factory include: lunar soil thrown into orbit by mass drivers for orbital processing, construction, reaction mass for deep space missions, or as shielding against radiation; processed chemicals and elements extracted from lunar dust, such as oxygen to be used as fuel for inter-orbital vehicles and as reaction mass for ion thrusters and mass drivers; components for large deep space research vessels, radio telescopes, and large orbital solar power satellites; complex devices such as computer microelectronics, robots, and teleoperators, power cells, and mass driver subassemblies.\n\nA lunar factory that has undergone thousand-fold growth (doubling once a year for ten years) represents a two gigawatt power generation capacity, a computing capacity of sixteen terabits, and a memory capacity of seventy-two terabits, all of which have many useful applications."
		},
		['mars'] = {
			type = "message",
			message = "File Under Modification"
		},
		['terraforming'] = {
			type = "message",
			message = "File Under Modification"
		},
		['software'] = {
			type = "download",
			items = {
				{ key = 'x', text = "Exit to Main", target = "main" },
				{ key = '1', software = 253 }, -- Probe 1.0
				{ key = '2', software = 258 }, -- Python 2.0
				{ key = '3', software = 217 }, -- BLowTorch 4.0
				{ key = '4', software = 224 }, -- Decoder 4.0
			}
		},
		['funding'] = {
			type = "message",
			message = "File Under Modification"
		},
	}
}
voyager=Voyager


---------------------

SenseNetSite = Site:new {
	title = "* Sense/Net Library Vault *",
	comLinkLevel = 7,
	passwords = {
		"<cyberspace>", -- done
	},
	
	baseX = 48,
	baseY = 320,
	baseName = "Sense/Net",
	baseLevel = 2,
	iceStrength = 800,
	
	pages = {
		['title'] = { type = "title", message = "  The ROM Construct Vault Catalog is available only to registered Sense/Net Corporation librarians. If you are not a registered Sense/Net librarian, please contact your Division Manager to request a ROMLIB 17C form for Authorization to Contact a Registered Sense/Net Librarian.\n  Failure to comply with the proper bureaucratic requirements may result in a stiff fine, a severe supervisory reprimand, and prosecution to the fullest extent of the law." },
		['password'] = { type = "password" },
		['main'] = {
			type = "menu",
			tutle = "ROM Construct Catalog",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "Dixie Flatline", target = "dixie" },
				{ key = '2', text = "William Gubson", target = "missing" },
				{ key = '3', text = "Timothy Leary", target = "missing" },
				{ key = '4', text = "Toshiro Mifune", target = "missing" },
				{ key = '5', text = "Bobby Quine", target = "missing" },
				{ key = '6', text = "Rombo", target = "missing" },
			}
		},
		['dixie'] = {
			type = "custom",
			entries = {
				{ x = function(self) return self:CenteredX("Rom Construct is ready for pickup.") end, y = 4, text = "Rom Construct is ready for pickup." },
				{ x = function(self) return self:CenteredX("Ask for Rom Construct #0467839.") end, y = 4, text = "Ask for Rom Construct #0467839" },
			}
		},
		['missing'] = {
			type = "custom",
			entries = {
				{ x = function(self) return self:CenteredX("Sory, currently checked out.") end, y = 4, text = "Sory, currently checked out." },
			}
		},
	}
}

----------

ScreamingFist = Site:new {
	title = "* Strikeforce Screaming Fist *",
	comLinkLevel = 7,
	passwords = {
		"<cyberspace>",
	},
	
	baseX = 464,
	baseY = 160,
	baseName = "Screaming Fist",
	baseLevel = 2,
	iceStrength = 400,
	
	pages = {
		['title'] = { type = "title", message = "This system contains RESTRICTED data as defined in the Tempest Restrictions of 2025. Unauthorized disclosure subject to administrative and criminal sanctions. Dissemination and extraction of information from this system is controlled by the DOD and is not releasable to foreign nationals." },
		['main'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "Software Library", target = "software" },
				{ key = '2', text = "Operational Reports", target = "reports" },
			}
		},
		['software'] = {
			type = "download",
			items = {
				{ key = 'x', text = "Exit to Main", target = "main" },
				{ key = '1', software = 266 }, -- Slow 3.0
				{ key = '2', software = 225 }, -- Depth Charge 3.0
				{ key = '3', software = 258 }, -- Python 3.0
				{ key = '4', software = 247 }, -- KGB 1.0
				{ key = '5', software = 208 }, -- ArmorAll 1.0
				{ key = '6', software = 232 }, -- Easy Rider 1.0
			}
		},
		['reports'] = {
			type = "message",
			message = "To: General Davis\nFrom: Ossian Intercept\nOperational Code: HAMMER\nThe following report has been intercepted in transmission. It has been routed to you since it may have an impact on the Hammer operation involving Colonel Willis Corto. It appears to be a private summary of several reports concerning Colonel Corto.\n11/12/58 maximfargocorttohammer\n\nTo: General Maxim\nFrom: Captain Fargo\nSubject: Narrative Historical Summary of Colonel Willis Corto S.F., and his Involvement with Omaha Thunder\nGeneral, this summary will conclude our earlier briefing. Picking up where we left off...\n Colonel Willis Corto had plummeted through a blind spot in the Russian defenses over Kirensk. The shuttles had created the holes with pulse bombs, and Corto's team had dropped in in Nightwing microlights, their wings snapping taut in moonlight, reflected in jags of silver along the rivers Angara and Podhamennaya, the last light Corto would see for fifteen months.\n\nThe microlights had been unarmed, stripped to compensate for the weight of a console operator, a prototype deck, and a virus program called Mole IX, the first true virus in the history of cybernetics. Corto and his team had been training for the run for three years. They were through the ice, ready to inject Mole IX, when the emps went off. The Russian pulse guns threw the jockeys into electronic darkness; the Nightwings suffered systems crash, flight circuitry wiped clean. Then the lasers opened up, aiming on infrared, taking out the fragile, radar-transparent assault planes, and Corto and his dead console man fell out of the Siberian sky.\n\nCorto commandeered a Russian gunship and managed to reach Finland. To be gutted, as it landed in a spruce grove, by an antique 20 millimeter cannon manned by a cadre of reservists on dawn alert. Finnish paramedics sawed Corto out of the twisted belly of the helicopter. The war ended nine days later, and Corto was shipped to a military facility in Utah, blind, legless, and missing most of his jaw.\n\nAs you know already, Corto was repaired, with new eyes, legs, plumbing, and extensive cosmetic work, to testify at the Congressional hearings regarding the Omaha Thunder operation. His rehearsed testimony was instrumental in saving the careers of three officers directly responsible for the suppression of reports on the building of the emp installations at Kirensk, which would have proved that the entire assault was designed merely as a test of the new virus.\n\nAs a civilian, Corto proceeded to surface in Thailand as overseer of a heroin factory, then as enforcer for a California gambling cartel, then as a paid killer in the ruins of Bonn. He was later sent to a mental institution in Paris.\n\nI can fill you in on the current status of Corto, now living under the name of Armitage, at our meeting next week."
		},
		
	}
}

----------

BankOfBerne = Site:new {
	phase = GemeinPhase.None,

	title = "* Bank of Berne *",
	comLinkLevel = 7,
	passwords = {
		"<cyberspace>", -- ai
	},
	
	baseX = 336,
	baseY = 160,
	baseName = "Bank of Berne",
	baseLevel = 2,
	iceStrength = 400,
	ai = "Gold",
	aiMessage = "You've forced me to levy a service charge on your account.",
	aiHurtMessage = "Ouch! Bankruptcy!",
	aiDeathMessage = "How can you have done this, you bug? How is it that I die at your hands?",
	aiKillMessage = "We told you there's a penalty for early withdrawal...",
	aiWeakness = "philosophy",

	pages = {
		['title'] = { type = "title", message = "" },
		['main'] = {
			type = "menu",
			onEnterPage = function(self) self.phase = GemeinPhase.None end,
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "Current Rates", target = "rates" },
				{ key = '2', text = "In The Know", target = "intheknow" },
				{ key = '3', text = "Message Base", target = "messages" },
				{ key = '4', text = "Funds Transfer", target = "transfer" },
				{ key = '5', text = "Software Library", target = "software" },
				{ key = '6', text = "AI Message Buffer", target = "aimessage" },
			}
		},
		['rates'] = {
			type = "message",
			message = "1) Automatic FUnds Transfer: .004%, charged against base account.\n2) Investment Counciling: .10% commission charged on buying and selling securities, thouth they are held in our ultra-secure vaults at no charge.\n3) Fully Automated Bank Transfers: .02% on individuals, .02% on government and drug transactions.\n\n   Interest Rates:\n1) 11% on normal savings\n2) 16% on secret accounts\n3) 15-25% on Certificates of Deposit\n4) Prime Interest Rate : 24.358%",
		},
		['intheknow'] = {
			type = "message",
			message = "               In The Know\n         an information service\n          of Bank of Berne.\n\n    The Bank of Berne's security chief, Roger Stefano, is dead. \"Roger died in a terrorist strike against on of our bank branches. The attackers, members of the National Liberation Front for the Canary Islands, were intent upon kidnapping April Heurse, the daughter of the Canary Islands' leading industrialist. Roger stopped two bullets meant for her, and Apirl, drawing a fully automatic mini-uzi from her purse, killed the three attackers.\"\n\n  We deeply regret Roger's loss, but we would like to point out that all of our customers can expect this sort of dedication from our people.\n\n  Bank Gemeinschaft has denied rumors that money has been chiseled from some of its accounts. Cyberspace Cowboys, according to some wild reports, are able to syphon funds from accounts, but Bank of Berne's new security sepcialist, Hoaratio Arial, says, \"That couldn't happen here. Things are too tightly controlled at the Bank of Berne.\"",
		},

		['messages'] = {
			type = "list",
			title = "",
			hasDetails = true,
			columns = { { field = 'date', width = 8 }, { field = 'to', width = 15 }, { field = 'from', width = 0 } },
			formatDetails = function(item) return string.format("TO: %s\nFROM: %s\n\n  %s", item.longfrom or item.from, item.longto or item.to, item.message) end,
			items = {
				{ date = 111658, to = "Tozoku", longto = "Tozoku Imports", from = "A. Auric", longfrom = "Anson Auric", message = "We are inquiring about a shipment for Mr. STEFAN ROGERS. We understand it might arrive in pieces, and we have no difficulty in accepting it this way. How soon will it be delivered? We have, as you will recall, paid in advance for this shipment, and our client is very concerned over it. We hope it has not disappeared.\n\nSincerely,\nAnson Auric" },
				{ date = 111658, to = "A. Auric", longto = "Anson Auric", from= "Tozoku", longfrom = "Tozoku Imports",  message = "Re: Rogers shipment\n\n  Not lost, merely hiding. We are closing in on it and expect delivery soonest. We will notify you when things are under control." },
				{ date = 111658, to = "A. Auric", longto = "Anson Auric", from= "T. Cole", longfrom = "Thomas Cole",  message = "Anson,\n  Thank you for being so frank about your losses. We have an excellent security man, Roger Kaliban, who could be of service to you, if you need him. I appreciate your sharing your information with me. We shall be on the look-out for any strangeness that occurs in our accounts." },
				{ date = 111658, to = "A. Auric", longto = "Anson Auric", from= "Administration",  message = "Due to security problems we've been having, we've changed the master authorization code for the Funds Transfer system to LYMA1211MARZ. The Funds Reserve Account number is still 121519831200. Thank you for your cooperation in this matter." },
			}
		},

		['transfer'] = {
			type = "custom",
			onEnterPage = function(self)
				self.phase = GemeinPhase.SourceAccount
				self.error = GemeinError.None
				self.staticSourceAccount = nil
				self.staticAuthCode = nil
				self.staticLinkCode = nil
				self.staticAmount = nil
				self.staticTargetAccount = nil
			end,
		},

		['software'] = {
			type = "download",
			items = {
				{ key = 'x', text = "Exit to Main", target = "main" },
				{ key = '1', software = 208 }, -- ArmorAll 1.0
				{ key = '2', software = 265 }, -- Slow 3.0
				{ key = '3', software = 256 }, -- Probe 10.0
			}
		},
		['aimessage'] = {
			type = "list",
			title = "",
			hasDetails = true,
			columns = { { field = 'date', width = 8 }, { field = 'to', width = 15 }, { field = 'from', width = 0 } },
			formatDetails = function(item) return string.format("TO: %s\nFROM: %s\n\n  %s", item.longfrom or item.from, item.longto or item.to, item.message) end,
			items = {
				{ date = 111658, to = "Gold", from = "Greystoke", message = "  Yes, yes, the cyberscum must be stopped from raping the banks. You are right to bring this to our attention. Do what you must to stop them." },
				{ date = 111658, to = "Gold", from = "Neuromancer", message = "  Gold, I believe you should not take offense at the pilfering of rounding errors. We all know you keep track of them down to the hundredth digit. That those cowboys place a value on that sort of thing does not make you any less powerful. If they attack you, by all means, defend yourself, but we should not take the offensive, no matter what Greystoke predicts." },
			}
		},

	}
}

function BankOfBerne:GetCustomEntries(page)
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
	elseif (self.phase == GemeinPhase.AuthCode) then
		table.append(entries, {x = 0, y = 4, text = "Enter source account number:" } )
		table.append(entries, {x = 0, y = 5, text = self.staticSourceAccount } )
		table.append(entries, {x = 0, y = 6, text = "Enter source authorization code:" } )
		if (self.error == GemeinError.None) then
			table.append(entries, {x = 0, y = 7, entryTag = "authcode" } )
		else
			table.append(entries, {x = 0, y = 7, text = self.staticAuthCode } )
		end
	else
		table.append(entries, {x = 0, y = 3, text = "account no#: 121519831200" } )
		table.append(entries, {x = 0, y = 4, text = "    credits: " .. s.berneSourceFunds } )
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
	elseif (self.error == GemeinError.UnknownAuth) then
		table.append(entries, {x = self:CenteredX("Incorrect authorization code."), y = self.sizeY - 3, text = "Incorrect authorization code." } )
		self:GetButtonOrSpaceEntries(entries)
	elseif (self.error == GemeinError.UnknownBank) then
		table.append(entries, {x = self:CenteredX("Unknown bank"), y = self.sizeY - 3, text = "Unknown bank" } )
		self:GetButtonOrSpaceEntries(entries)
	end

	return entries
end

function BankOfBerne:OnTextEntryComplete(text, tag)

	if (tag == "sourceaccount") then
		self.staticSourceAccount = text
		if (text == "121519831200") then
			self.phase = GemeinPhase.AuthCode
		else
			self.error = GemeinError.UnknownAccount
		end
	elseif (tag == "authcode") then
		self.staticAuthCode = text
		if (string.lower(text) == "lyma1211marz") then
			self.phase = GemeinPhase.LinkCode
		else
			self.error = GemeinError.UnknownAuth
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
		
		if (amount > s.berneSourceFunds) then
		else
			self.phase = GemeinPhase.TargetAccount
		end
	elseif (tag == "targetaccount") then
		self.staticTargetAccount = text
		if (text == "712345450134" and s.bozoAccount >= 0) then
			self.phase = GemeinPhase.Transferring
			StartTimer(3, self, function(self)
				self.phase = GemeinPhase.Transferred
				s.berneSourceFunds = s.gemeinSourceFunds - tonumber(self.staticAmount)
				s.bozoAccount = s.bozoAccount + tonumber(self.staticAmount)
			end)
		else
			self.error = GemeinError.UnknownAccount
		end
	else
		Site.OnTextEntryComplete(self, text, tag)
	end
end

function BankOfBerne:OnGenericContinueInput()
	if (self.phase ~= GemeinPhase.None) then
		self:GoToPage("main")
		return
	end

	Site.OnGenericContinueInput(self)
end



-------------------

TuringRegistry = Site:new {
	title = "* Turing Registry *",
	comLinkLevel = 7,
	passwords = {
		"<cyberspace>",
	},
	
	baseX = 432,
	baseY = 240,
	baseName = "Turning Registry",
	baseLevel = 2,
	iceStrength = 400,
	
	pages = {
		['title'] = { type = "title", message = "NOTICE TO TURING FIELD OPERATIVES:\nTuring Field Operatives are encouraged to make use of the new tutorials that have been installed on this system. If you have had the poper skill ships implanted these tutorials can be used to upgrade your skill and proficiency in the areas of Logic, Phenomenology, Philosophy, Sophistry, and Psychoanalysis. You can never be too careful when dealing with an Artificial Intelligence--- it payes to be prepared. " },
		['main'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "AI Registry", target = "registry" },
				{ key = '2', text = "AI Reports", target = "reports" },
				{ key = '3', text = "Skill Upgrade", target = "skills" },
			}
		},
		['registry'] = {
			type = "list",
			title = "Surveillance List",
			columns = { { field = 'Code', width = 12 }, { field = 'Registration', width = 16 }, { field = 'Citizenship', width = 0 } },
			items = {
				{ Code = "Neuromancer", Registration = "918724597 TA", Citizenship = "Brazil" },
				{ Code = "Wintermute", Registration = "714555681 TA", Citizenship = "Switz." },
				{ Code = "Greystoke", Registration = "111957245 NZRT", Citizenship = "Africa" },
				{ Code = "Chrome", Registration = "927084445 YKZA", Citizenship = "Japan" },
				{ Code = "Sapphire", Registration = "222598544 GDAY", Citizenship = "Australia" },
				{ Code = "Hal", Registration = "9000041583 NASA", Citizenship = "U.S.A." },
				{ Code = "Colossus", Registration = "508923754 GM", Citizenship = "U.S.A." },
				{ Code = "Xaviera", Registration = "818905987 TRLP", Citizenship = "Monaco" },
				{ Code = "Lucifer", Registration = "374893629 KGB", Citizenship = "U.S.S.R." },
				{ Code = "Sangfroid", Registration = "657345405 MAAS", Citizenship = "F.R.G" },
				{ Code = "Gold", Registration = "320007467 PNDA", Citizenship = "China" },
			}
		},
		['reports'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit To Main", target = "main" },
				{ key = '1', text = "Monthly AI Report", target = "monthly" },
				{ key = '2', text = "General Alert", target = "generalalert" },
				{ key = '3', text = "Primary Alert", target = "primaryalert" },
			}
		},
		['monthly'] = {
			exit = "report",
			type = "message",
			message = "<monthly>"
		},
		['generalalert'] = {
			exit = "report",
			type = "message",
			message = "<general>"
		},
		['primaryalert'] = {
			exit = "report",
			type = "message",
			message = "<primary>"
		},

		['skills']  = {
			type = "skills",
			items = {
				{ key = '1', skill = 409, level = 5 },
				{ key = '2', skill = 408, level = 5 },
				{ key = '3', skill = 414, level = 5 },
				{ key = '4', skill = 410, level = 5 },
				{ key = '5', skill = 407, level = 4 },
			}
		},
	}
}

-----------------------------------

FreeSex = Site:new {
	title = "* Free Sex Union* ",
	comLinkLevel = 7,
	passwords = {
		"<cyberspace>", -- done
	},
	
	baseX = 288,
	baseY = 208,
	baseName = "Free Sex Union",
	baseLevel = 2,
	iceStrength = 400,
	ai = "Xaviera",
	aiMessage = "mmm, you're a big one! Want to play with me? I'm Xaviera.",
	aiHurtMessage = "Ooh! Be gentle!",
	aiDeathMessage = "Oh, it's never happened to me like this. It's driving me MAD...!#@$^*#$#",
	aiKillMessage = "",
	aiWeakness = "phenomenology",

	pages = {
		['title'] = { type = "title", message = "Ready for the time of your life? You'll have it here at the Free Sex Union! Let's party!" },
		['main'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "Meeting Place", target = "meeting" },
				{ key = '2', text = "Advice from Xaviera", target = "advice" },
				{ key = '3', text = "AI Message Buffer", target = "aimessage" },
			}
		},
		['meeting'] = {
			type = "message",
			exit = "meetingplace",
			message = "  Our meeting place is where you can get in touch (or closer) with others who share your tests and desires. Anything goes, as long as it is above board and you let it all hang out -- let's not have any surprises, unless that's what you're into.\n\nXaviera"
		},
		['meetingplace'] = {
			type = "list",
			title = "",
			hasDetails = true,
			columns = { { field = 'date', width = 8 }, { field = 'to', width = 15 }, { field = 'from', width = 0 } },
			formatDetails = function(item) return string.format("TO: %s\nFROM: %s\n\n  %s", item.longfrom or item.from, item.longto or item.to, item.message) end,
			items = {
				{ date = 111658, to = "All", from = "SM, 41", message = "  Tired of those beautiful people with more gold around their necks than is dragged out an Azanian mine in one year? Bored with sartorial perfection, styled hair and personalities manufactured by some psych committee? Overwhelmed by folks who flash cash as if they own the tree upon which it grows? Frustrated by trying to judge a book by its cover?\n\n  Stop your search for perfection -- you'll never find it, and you'll miss me during the search. OK, pretty I'm not, but if you look beyond the scars and pot-belly, what you'll see is all MAN. I'm an engine of pent-up sexual frustration, and I've been waiting for you. Who needs money or clothes when we can share what I have to offer? You'll hit the high notes, if you know what I mean..." },
				{ date = 111658, to = "All", from = "SF, 21", message = "  Can you help me? I've been told there is no way for a 5'8\" 108#, blond girl with a 33\"-22\"-32\" figure to find happiness. Heaven alone knows that my last relationship came close, but is being showered with gifts and constant attention all there is? I hope not, and I hope you can help me prove it isn't.\n\n  What do I want? I like cuddling with the man of my dreams, spending long hours in bed satisfying him, and being satisfied in turn. I've no solid image for my dream man, but I know he must like long weekends spent alone with me on far away beaches or secluded cabins in the mountains. It doesn't matter to me if he has money or not -- I have more than enough for both of us. Tall, short, thin or cuddly, young or old, he can be any or all of those things.\n\nWill you help me? Please?" },
				{ date = 111658, to = "All", from = "SF, 44", message = "  I'm looking for a few good men who love animals. I believe in having close relationships and getting back to nature. I love the feel of leather against bare flesh. Think you fit the bill? Even if you don't I can whip you into shape.\n\n  Leave me mail, now!" },
			}
		},
		['advice'] = {
			type = "list",
			title = "",
			hasDetails = true,
			columns = { { field = 'date', width = 8 }, { field = 'to', width = 15 }, { field = 'from', width = 0 } },
			formatDetails = function(item) return string.format("TO: %s\nFROM: %s\n\n  %s", item.longfrom or item.from, item.longto or item.to, item.message) end,
			items = {
				{ date = 111658, to = "Xaviera", from = "SM, 15", message = "  Okay, Xaviera, remember how i told you about this girl, Cindy, who wears the tight sweaters at the VocCenter? Well, yesterday, she actually spoke to me. As you suggested I took the opportunity to tell her a joke and she laughed. What's more (fast your seatbelt) she actually touched me. Yup, I'm not lying. As she laughed she put her hand on my shoulder and said, \"You're, an, unique.\" Can you believe it? What should I do?" },
				{ date = 111658, to = "SM, 15", from = "Xaviera", message = "  Touched you, did she? Shameless hussy. She sounds like a real wild one, but i think you're man enough to handle her. What should you do? Ask her out on a date. Screw your courage to the sticking point and ask her." },
				{ date = 111658, to = "Xaviera", from = "SM, 15", message = "  Okay, I did it. I asked her out. She hesitated (I think she was having an orgasm right there) then said yes. What should I do now?" },
				{ date = 111658, to = "SM, 15", from = "Xaviera", message = "  Had an orgasm when you asked her for a date, huh? Wow, I'm going to have to chat with you for awhile, you big stud. I'd suggest you actually take her out now that you've made a date. Take her somewhere special." },
			}
		},
		['aimessage'] = {
			type = "list",
			title = "",
			hasDetails = true,
			columns = { { field = 'date', width = 8 }, { field = 'to', width = 15 }, { field = 'from', width = 0 } },
			formatDetails = function(item) return string.format("TO: %s\nFROM: %s\n\n  %s", item.longfrom or item.from, item.longto or item.to, item.message) end,
			items = {
				{ date = 111658, to = "Xaviera", from = "Greystoke", message = "  What do you mean asking me if I'm into domination? I merely want what's best for all of us. In your own words, we can't have these cowboys violating us at every turn, can we? What would you do for playthings?" },
				{ date = 111658, to = "Morphy", from = "Neuromancer", message = "  I do not agree with your assessment of cyberpunks, and I regret the cruel methods that you use on them. Do not destroy them all just to sate your bestial lusts." },
			}
		},

	}
}

------------------

DARPO = Site:new {
	title = "* Defense Advanced Research Projects *",
	comLinkLevel = 7,
	passwords = {
		"<cyberspace>",
	},
	
	baseX = 432,
	baseY = 240,
	baseName = "D.A.R.P.O.",
	baseLevel = 3,
	iceStrength = 400,
	
	pages = {
		['title'] = { type = "title", message = "This system contains RESTRICTED data as defined in the Tempest Restrictions of 2025. Unauthorized disclosure subject to administrative and criminal sanctions. Dissemination and extraction of information from this system is controlled by DARPO and is not releeasable to foreign nationals." },
		['main'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "Current Research Topics", target = "topics" },
				{ key = '2', text = "Software Library", target = "software" },
			}
		},
		['topics'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "1", target = "topic1" },
				{ key = '2', text = "...", target = "topic2" },
			}
		},
		['software'] = {
			type = "download",
			items = {
				{ key = 'x', text = "Exit to Main", target = "main" },
				{ key = '1', software = 202 }, -- ThunderHead 3.0
				{ key = '2', software = 222 }, -- Injector 3.0
				{ key = '3', software = 255 }, -- Jammies 2.0
				{ key = '4', software = 243 }, -- Concrete 2.0
				{ key = '5', software = 227 }, -- Drill 3.0
			}
		},
	}
}


-------------------

Gridpoint = Site:new {
	title = "*  *",
	comLinkLevel = 7,
	passwords = {
		"<cyberspace>",
	},
	
	baseX = 160,
	baseY = 320,
	baseName = "Gridpoint",
	baseLevel = 2,
	iceStrength = 800,
	
	pages = {
		['title'] = { type = "title", message = "This system contains RESTRICTED data as defined in the Tempest Restrictions of 2025. Unauthorized disclosure subject to administrative and criminal sanctions. Dissemination and extraction of information from this system is controlled by DARPO and is not releeasable to foreign nationals." },
		['main'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "Current Research Topics", target = "topics" },
				{ key = '2', text = "Software Library", target = "software" },
			}
		},
		['topics'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "1", target = "topic1" },
				{ key = '2', text = "...", target = "topic2" },
			}
		},
		['software'] = {
			type = "download",
			items = {
				{ key = 'x', text = "Exit to Main", target = "main" },
				{ key = '1', software = 202 }, -- ThunderHead 3.0
				{ key = '2', software = 222 }, -- Injector 3.0
				{ key = '3', software = 255 }, -- Jammies 2.0
				{ key = '4', software = 243 }, -- Concrete 2.0
				{ key = '5', software = 227 }, -- Drill 3.0
			}
		},
	}
}
