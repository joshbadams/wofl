s.mail_armitage = 0


PAX = Site:new {
	hasPassword = false,
	title = "",
	
	pages = {
		['main'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "First Time PAX User Info.", target = "firsttime" },
				{ key = '2', text = "Access Banking Interlink", target = "banking_menu" },
				{ key = '3', text = "Night City News", target = "nightcity" },
				{ key = '4', text = "Bulletin Board", target = "bbs_menu" }
			}
		},
		
		['firsttime'] = {
			type = "message",
			message = "PAX, the Public Access System, was first implemented as a result of the Gibson Mandate of 2036. PAX allows general access to the Central Database Interlink (CDI) with Friendly Interface System Hardware (FISH) designed for Limited Free Access (LFA) to the Multi-Phased Public Information Library Core (MPPILC) in conjunction with the Swiss Orbital Banking (SOB) network, which is regulated by the Chiba City Public Database Regulating Agency (CCPDRA) in concordance with the World Holographic Organizational Obligation for Electronic Eavesdropped (WHOOPEE) Guidlines established by the Balfour Act. With the institution of WHOOPEE protocol, LFA became possible with the MPPILC system and the SOB network. The FISH, contained within the PAX Booth, was ergonomically designed for Optimal Ease of Use (OEU) within the specifications of the agencies involved, primarily CCPDRA and the SOB network. OEU makes operation of the PAX system a simple task for both the First Time User (FTU) and the Experienced Adept (EA) through implementation of menus and Simple Directions (SD) available in Lucid Help Files (LHF) such as this one, in which Simplified Grammatical Syntax (SGS) and Simple Word Choice (SWC) algorithms have been employed to benefit User Understanding (UU).",
			exit = "main"
		},
		
		['banking_menu'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit To Main", target = "main" },
				{ key = 'd', text = "Download credits", target = "banking_withdrawal" },
				{ key = 'u', text = "Upload credits", target = "banking_deposit" },
				{ key = 't', text = "Transaction record", target = "record" },

			}
		},
		
		['banking_deposit'] = {
			type = "custom"
		},
		
		['banking_withdrawal'] = {
			type = "custom"
		},

		['nightcity'] = {
			type = "list",
			columns = { { field = 'date', width = 8 }, { field = 'subject', width = 0 } },
			hasDetails = true,
			items = {
				{
					date = 111658,
					subject = "BAR FOOD DECLARED FATAL",
					message = "BAR FOOD DECLARED FATAL\nThe Chatsubo bar will be permanentoy closed today, according to the Chiba Health Department. Contaminated food and toxic beer are the main reasons for the closure, although there have been other health violations. So far, 87 fatalities have been reported in connection with this investigation.\n\nMost of the fatalities occurred with Chatsubo patrons who drank more than 3 glasses of beer and ate the synth-spaghetti, which is based on a home recipe. The spaghetti and beer combined in the bodies of the victims to create an explosive chemical which was ignited by stomach acids."
				},
				{
					date = 111658,
					subject = "COWBOY DISAPPEARS",
					message = "COWBOY DISAPPEARS\nRumors are flying among the elite cyberspace cowboy community. Well-known logic gate crasher, Jonathan E, has mysteriously vanished, causing speculation that he was killed in cyberspace by \"black ice,\" an illegal form of base protection."
				},
				{
					date = 111658,
					subject = "News In Brief",
					message = "**** News In Brief ****\n\nFARM ANIMALS KIDNAP UFO\nSheep says, \"We were just hoyriding!\"\nMAN EATS HIS OWN HEAD\n\"He thought it was just a donut,\"says the owner of Donut World, where the incident occurred.\n\nSON OF FUJI PREZ MISSING\nMother wails, \"He's gone!\" Prez of Fuji Electric denies any connection with rumored corporate takeover."
				},
				{
					date = 111758,
					subject = "NASA AND FUJI DO BUSINESS",
					message = "NASA AND FUJI DO BUSINESS\nAnticipating increased space activity, NASA has signed a multi-million dollar contract with Fuji Electric to provide ROMcards for future spacecraft. Fuji President Harry Watkins, recently in the news when his son was kidnapped, said, \"This is great. I'm thrilled.\" Watkins expects to be hiring hundreds of new employees as a result of the contract."
				},
				{
					date = 111758,
					subject = "News In Brief",
					message = "**** News In Brief ****\n\nSAVAGE NIGHT OF TORTURE\nStrange Chatsubo patron spends night sleeping in synth-spaghetti. Customers shocked.\n\nSON RETURNED TO FUJI PREZ\nChoked with emotion, Fuji Prez says, \"We must have misplaced him.\" As to his son's condition, the Prez reports, \"He's in one piece, more or less.\""
				},
				{
					condition = function() return justice > 0 end,
					date = 110058,
					subject = "CRIMINAL HITS CHIBA CITY",
					message = "CRIMINAL HITS CHIBA CITY\n%name%, a notorious criminal who recently arrived in Chiba City, has been arrested and taken to the Justice Booth. This comes as no surprise to police, who have been watching this criminal ever since he arrived. \"We knew he'd break the law eventually,\" said Officer Watanabe. \"These habitual criminals can't go a whole day without committing a crime.\""
				},
				{
					condition = function() return hotel > 100 end,
					date = 110058,
					subject = "VAGRANT PAYS HOTEL BILL",
					message = "VAGRANT PAYS HOTEL BILL\nPaul Stack, owner of Cheap Hotel, called a news conference this morning to report that Cowboy %name% has finally paid his hotel bill. Stack is referring to this payment as \"a momentous event in my life. Being the kind-hearted kind of guy that I am, I let that blll accumulate far too long before demanding payment. Imagine my surprise when the scum finally paid it. I was ready to call the Tactical Police.\""
				},
				{
					condition = function() return s.chatsubo > 1 end,
					date = 110058,
					subject = "CHATSUBO DEBT",
					message = "Thisis a story that will appear when chatsubo is paid off but not before."
				}
			}
		},
		
		['bbs_menu'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit To Main", target = "main" },
				{ key = 'v', text = "View Messages", target = "bbs_view" },
				{ key = 's', text = "Send Messages", target = "bbs_send_tofield" },
			}
		},
		
		['bbs_view'] = {
			type = "list",
			title = "Bulletin Board",
			hasDetails = true,
			columns = { { field = 'date', width = 8 }, { field = 'to', width = 15 }, { field = 'from', width = 0 } },
			formatDetails = function(item) return string.format("TO: %s\nFROM: %s\n%s", item.from, item.to, item.message) end,
			items = {
				{ date = 111458, to = "All", from = "sysop", message = "Due to a lighting strike on the PAX building, all BBS messages on the system before 11/14/58 were trashed. Sorry for the inconvenience." },
				{ date = 111458, to = "%name%", from = "Matt Shaw", message = "Take some advice, man. There's a lot of good software showing up on the BBS's. You'll need it to figure out what's going on, so find as much as you can. Upgrade your Comlink warez and your equipment so you can reach the better bases. When you're ready, and you've got enough money together, find us in cyberspace. We need your help bad, but I can't talk about it here. Don't want to start a panic, know what I mean?"	},
				{ date = 111458, to = "%name%", from = "FFargo", message = "You still own me 2000 credits. Will I have to sell your lungs to get it?" },
				{ date = 111458, to = "%name%", from = "Shin", message = "Better pick up your deck at my pawn shop, otherwise I'll have to sell it." },
				{ date = 111458, to = "%name%", from = "Crazy Edo", message = "Where's my caviar? I said I'd trade you some software for it, remember?" },
				{ date = 111558, to = "%name%", from = "Matt Shaw", message = "Since you've been out of touch for a while, and since you're an old friend, I thought I'd help you out with some comlink numbers to get you started. Use them as soon as you get your deck back (yeah, I heard you had to pawn it). The link codes are : CHEAPO for Cheap Hotel, REGFELLOW for the Regular Fellows, CONSUMEREV for Consumer Review, ASANOCOMP for Asano Computing, WORLDCHESS for the World Chess Confederation. These ought to help keep you busy until you can afford a cyberspace-capable deck." },
				{ date = 111558, to = "%name%", from = "Bosch", message = "Remember your old pal Anonymous Bosch? Remember how I borrowed your Cryptology skill chip siz month ago and forgot to give it back? Well, I dropped it off with Shive at the Gentleman Loser for you to pick up. Thanks. Sorry I took so long." },
				{ date = 111658, to = "%name%", from = "Emp. Norton", message = "Heard you were in town and thought you ought to know something weird's going on in cyberspace. Sharpen your skills and keep your head down." },
				{ date = 111658, to = "Ratz", from = "Red Snake", message = "Read about your problem in the Night City News. Did you forget to pay off the Health Department this month? I can fix it. Talk to me." },
				{ date = 111658, to = "Ratz", from = "Interplay", message = "CREDITS HERE" },
				{ date = 111658, to = "All", from = "Armitage", message = "We're looking for a few good cowboys. Seeking adventure? Like money? Like living on the razor's edge? Good with a cyberspace deck? Simply by answering this ad with your BAMA id number, you can earn instant money and learn about an exciting opportunity." },
				{ date = 111658, to = "All", from = "Hitachi", message = "Need some quick cash? Come and see us at Hitachi Biotech in the high-tech zone of Chiba City. We need volunteers for a simple experiment that won't require much of your time." },
				{ date = 111758, to = "%name%", from = "Emp. Norton", message = "Shiva at the Gentleman Loser has a Matrix Restaurant guest pass for you. Let's talk." },
				{ date = 111758, to = "All", from = "CFM", message = "Are you angry about being locked out of cyberspace just because special equipment is required? Does it bug you that thousands of common workers have access to cyberspace every day? Why can't the general public have access to cyberspace information? We're angry too. Contact us for more information at link code FREEMATRIX. The password for those who are non-members is CFM. Fight back and get what's coming to you!" },
				{ date = 111758, to = "All", from = "IRS", message = "Got a problem with your taxes? Are the hourly tax law changes to hard to keep up with? Give us a call. We've set up a new Tax Information service that allows you, John Q. Taxpayer, to ask us, the Internal Revenu Service, for anwers to your difficult questions.\nThe comlnk number is IRS (that ought to be easy enough to remember), and the password is TAXINFO. Remember the last word in our ame is Service!" },
				{ date = 110058, condition = function() return s.mail_armitage == 1 end, to = "%name%", from = "Armitage", message = "Thanks for your response to my ad. The amount of $10,000 has been deposited to your bank account. Please meet me, General Armitage, in the street directly outside the Matrix Restaurant as soon as possible." }
			}
		},
		
		['bbs_send_tofield'] = {
			type = "custom"
		},
		
		['bbs_send_messagefield'] = {
			type = "custom"
		},
		
		['bbs_send_verify'] = {
			type = "custom"
		}
	}
}

function PAX:GetEntries()
	entries = Site.GetEntries(self)

	if (self.currentPage == "main") then
		table.append(entries, {x = 9, y = 11, text = "choose a function"})
	end

	if self.currentPage == "firsttime" then
		table.append(entries, {x = 0, y = 0, text = "FIRST TIME USER INFORMATION"})
	end

	if string.sub(self.currentPage, 1, 7) == "banking" then
		self:GetBankEntries(entries)
	end

	if string.sub(self.currentPage, 1, 8) == "bbs_send" then
		self:GetSendMessageEntries(entries)
	end

	return entries
end


function PAX:GetBankEntries(entries)
	
	-- all bank pages have these items
	table.append(entries, { x = 3, y = 0, text = "First Orbital Bank of Switzerland"})
	table.append(entries, { x = 3, y = 2, text = string.format("name: %s", s.name) })
	table.append(entries, { x = 3, y = 3, text = string.format("chip = %d", s.money) })
	table.append(entries, { x = 24, y = 2, text = string.format("BAMA id: %d", s.bamaid) })
	table.append(entries, { x = 24, y = 3, text = string.format("account: %s", s.bankaccount) })

	if self.currentPage == "banking_deposit" or self.currentPage == "banking_withdrawal" then
		table.append(entries, { x = 0, y = 5, text = "Enter amount : "})
		table.append(entries, { x = 15, y = 5, entryTag = self.currentPage, numeric = true })
	end
end

function PAX:GetSendMessageEntries(entries)
	table.append(entries, { x = 5, y = 0, text = "Send Message" })
	table.append(entries, { x = 0, y = 4, text = "date: " .. string.fromDate() })
	table.append(entries, { x = 0, y = 5, text = "to:   " })

	if (self.currentPage == "bbs_send_verify") then
		table.append(entries, { x = 5, y = 2, text = "Send this message (" })
		table.append(entries, { x = 24, y = 2, text = "Y", clickId = 1, key = "y" })
		table.append(entries, { x = 25, y = 2, text = "/" })
		table.append(entries, { x = 26, y = 2, text = "N", clickId = 2, key = "n" })
		table.append(entries, { x = 27, y = 2, text = ")" })
		table.append(entries, { x = 1, y = 6, text = self.message, multiline = true })
	elseif (self.currentPage == "bbs_send_messagefield") then
		table.append(entries, { x = 5, y = 2, text = "Press ESC when done" })
		table.append(entries, { x = 0, y = 6, text = ">" })
		table.append(entries, { x = 1, y = 6, entryTag = "message", multiline = true })
	end

	if (self.currentPage == "bbs_send_tofield") then
		table.append(entries, { x = 6, y = 5, entryTag = "to" })
	else
		table.append(entries, { x = 6, y = 5, text = self.recipient })
	end
end


function PAX:HandleClickedEntry(id)
	if (self.currentPage == "bbs_send_verify") then
		if id == 1 then
			self:ProcessMessage()
		end
		self:GoToPage("bbs_menu")
	end
end

function PAX:ProcessMessage()
	if (s.mail_armitage ~= 1 and string.lower(self.recipient) == "armitage" and self.message == s.bamaid) then
		s.mail_armitage = 1
		s.bankaccount = s.bankaccount + 10000
	end
end

function PAX:OnTextEntryComplete(text, tag)
	amount = tonumber(text)

	if tag == "banking_withdrawal" and amount <= s.bankaccount then
		s.bankaccount = s.bankaccount - amount
		s.money = s.money + amount
		self:GoToPage("banking_menu")
	end

	if tag == "banking_deposit" and amount <= s.money then
		s.bankaccount = s.bankaccount + amount
		s.money = s.money - amount
		self:GoToPage("banking_menu")
	end

print("text done, tag = ", tag)
	if tag == "to" then
		self.recipient = text
		self:GoToPage("bbs_send_messagefield")
	end

	if tag == "message" then
		self.message = text
		self:GoToPage("bbs_send_verify")
	end
end

pax = PAX
