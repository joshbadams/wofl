
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
			type = "custom"
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
			type = "messages"

		},
		
		['bbs_menu'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit To Main", target = "main" },
				{ key = 'v', text = "View Messages", target = "bbs_view" },
				{ key = 's', text = "Send Messages", target = "bbs_send" },
			}
		},
		
		['bbs_view'] = {
			type = "bbs",
			title = "Bulletin Board",
			items = {
				{ date = 111458, to = "All", from = "sysop", message = "Due to a lighting strike on the PAX building, all BBS messages on the system before 11/14/58 were trashed. Sorry for the inconvenience." },
				{ date = 111458, to = "%name%", from = "Matt Shaw", message = "Take some advice, man. There's a lot of good software showing up on the BBS's. You'll need it to figure out what's going on, so find as much as you can. Upgrade your Comlink warez and your equipment so you can reach the better bases. When you're ready, and you've got enough money together, find us in cyberspace. We need your help bad, but I can't talk about it here. Don't want to start a panic, know what I mean?"	},
				{ date = 111458, to = "%name%", from = "FFargo", message = "You still own me 2000 credits. Will I have to sell your lungs to get it?" },
				{ date = 111458, condition = function() return false end, to = "NONO", from = "BAD", message = "Should never see this" },
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
				{ date = 110058, condition = function() return mail_armitage == 1 end, to = "%name%", from = "Armitage", message = "Thanks for your response to my ad. The amount of $10,000 has been deposited to your bank account. Please meet me, General Armitage, in the street directly outside the Matrix Restaurant as soon as possible." }
			}
		},
		
		['bbs_send'] = {
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

	return entries
end


function PAX:GetBankEntries(entries)
	
	-- all bank pages have these items
	table.append(entries, { x = 3, y = 0, text = "First Orbital Bank of Switzerland"})
	table.append(entries, { x = 3, y = 2, text = string.format("name: %s", name) })
	table.append(entries, { x = 3, y = 3, text = string.format("chip = %d", money) })
	table.append(entries, { x = 24, y = 2, text = string.format("BAMA id: %d", bamaid) })
	table.append(entries, { x = 24, y = 3, text = string.format("account: %s", bankaccount) })

	if self.currentPage == "banking_deposit" or self.currentPage == "banking_withdrawal" then
		table.append(entries, { x = 0, y = 5, text = "Enter amount : "})
		table.append(entries, { x = 15, y = 5, entryTag = self.currentPage, numeric = true })
	end
end




function PAX:GoToPage(pageName)
	Site.GoToPage(self, pageName)

	if pageName == "firsttime" then
		self.detailsIndex = 1
	end
end

function PAX:GetDetailsString()
	print("PAX get details", self)
	if self.currentPage == "firsttime" and self.detailsIndex == 1 then
		return "@paxfirsttime"
	else
		return Site.GetDetailsString(self)
	end
end

function PAX:OnMessageComplete()
	Site.OnMessageComplete(self)

	if self.currentPage == "firsttime" then
		self:GoToPage("main")
	end
end

function PAX:OnTextEntryComplete(text, tag)
	amount = tonumber(text)

	if tag == "banking_withdrawal" and amount <= bankaccount then
		bankaccount = bankaccount - amount
		money = money + amount
	end

	if tag == "banking_deposit" and amount <= money then
		bankaccount = bankaccount + amount
		money = money - amount
	end

	self:GoToPage("banking_menu")

end

pax = PAX
