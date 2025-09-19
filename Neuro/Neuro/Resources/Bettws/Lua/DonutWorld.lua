
-- state:
-- 0: walking in first time, or after using coptalk
-- 1: has chosen "I came in for a donut. Is there some law against that?", which activates some options without kicking out
-- 2: has left room and come back, angering cop
-- 11: said CopTalk level 1 line
-- 12: said CopTalk level 2 line
s.donutworld = 0
s.usingCopTalk = 0
DonutWorld = Room:new {
	
	name = "donutworld",
	onEnterConversation = "onEnter",
	hasPerson = true,
	
	north = "streetwest2",
	
	longDescription = "This is a Donut World. A SEA cop who looks like a sumo wrestler is eating donuts and caffeine at a table by the door. He gives you an ugly look when you walk in.",
	description = "This is Donut World.",
	
	conversations = {
		{
			tag = "onEnter",
			lines = { function() if (s.donutworld < 2) then return "Hey! We don't allow your kind in Donut World, hamsterhead." else
				return "Back again? I warned you once. Looking for trouble, citizen?" end end }
		},
				
		{
			condition = function() return s.donutworld < 2 end,
			options = {
				{
					condition = function() return s.donutworld == 0 and s.usingCopTalk >= 2 end,
					line = "Saint Patty's Day. I'm looking for the Little People, don't you know..",
					response = "Mulligan! I can barely understand your thick Irish accent! And I almost didn't recognize you!",
					onEnd = function() s.donutworld = 12; end
				},
				{
					condition = function() return s.donutworld == 0 and s.usingCopTalk >= 1; end,
					line = "Sure and begorrah, O'Riley. If you don't recognize me, you'll get my Irish up.",
					response = "Finnegan, old pal! Top of the mornin' to you! I didn't recognize you!",
					onEnd = function() s.donutworld = 11; end
				},
				{
					condition = function() return s.donutworld == 0 end,
					line = "I came in for a donut. Is there some law against that?",
					response = "This is a donut shop, citizen. Only cops are allowed in donut shops.",
					onEnd = function() s.donutworld = 1 end
				},
				{
					condition = function() return s.donutworld == 0 end,
					line = "I'm looking for pirated software.",
					response = "That's it your under arrest.",
					onEnd = function() GoToRoom("streetwest2"); ShowMessage("<You were arrested>") end
				},
				{
					line = "Drop dead, flatfoot.",
					response = "That's it your under arrest.",
					onEnd = function() ShowMessage("<You were arrested>"); GoToRoom("streetwest2") end
				},
				{
					line = "You'll never take me alive, copper!",
					response = "That's it your under arrest.",
					onEnd = function() ShowMessage("<You were arrested>"); GoToRoom("streetwest2") end
				},
				{
					line = "Forgive me, sir. I thoroughly despise myself for making such a blunder.",
					response = "Just don't let me catch you in here again. How get out of here.",
					onEnd = function() GoToRoom("streetwest2") end
				},
				{
					condition = function() return s.donutworld == 1 end,
					line = "Am I ever going to catch a break in this game?",
					response = "Just don't let me catch you in here again. How get out of here.",
					onEnd = function() GoToRoom("streetwest2") end
				},
			}
		},
		{
			condition = function() return s.donutworld == 2 end,
			options = {
				{
					condition = function() return s.usingCopTalk >= 2; end,
					line = "Sure and begorrah, O'Riley. If you don't recognize me, you'll get my Irish up.",
					response = "FMulligan! I can barely understand your thick Irish accent! And I almost didn't recognize you!",
					onEnd = function() s.donutworld = 12; end
				},
				{
					condition = function() return s.usingCopTalk >= 1 end,
					line = "Well, now! My Irish eyes are smiling, O'Riley! Corned beef and cabbage! Got any news?",
					response = "Finnegan, old pal! Top of the mornin' to you! I didn't recognize you!",
					onEnd = function() s.donutworld = 11; end
				},
				{
					line = "Can't a man get a donut in this town without getting arrested?",
					response = "That's it your under arrest.",
					onEnd = function() ShowMessage("<You were arrested>"); GoToRoom("streetwest2") end
				},
				{
					line = "Yeah, I'm looking for trouble. Have you seen any?",
					response = "That's it your under arrest.",
					onEnd = function() ShowMessage("<You were arrested>"); GoToRoom("streetwest2") end
				},
				{
					line = "Sorry, my mistake. I left my brain in my other pants.",
					response = "I've warned you about this before! You're under arrest!",
					onEnd = function() ShowMessage("<You were arrested>"); GoToRoom("streetwest2") end
				},
			}
		},
		
		{
			condition = function() return s.donutworld >= 11 end,
			options = {
				{
					line = "Begorrah! I forgot the comlink number for the Chiba Tactical Police!",
					response = "Don't worry. It's KEISATSU. Better write it down this time.",
				},
				{
					line = "What's the password for the Software Enforcement Agency? Is it \"Wild Irish Rose?\"",
					response = "Wild Irish Rose is a hooker on Memory Lane! The coded SEA password is SMEEGLDIPO, remember?",
				},
				{
					line = "O'Riley! I heard the changed the Fuji Electric password to \"Uisquebaugh.\" Is that right?",
					response = "The coded Fuji password is ABURAKKOI. They haven't changed it in years.",
				},
				{
					condition = function() return s.donutworld >= 12 end,
					line = "Have you heard any news, then, O'Riley? Found out where the Little People keep their warez?",
					response = "Just got through questioning Shiva. She says illegal warez are available on the Gentleman Loser DB.",
				},
				{
					condition = function() return s.donutworld >= 12 end,
					line = "Fergus gave me the second level password for the Chiba Tactical Police but I seem to have forgotten it again!",
					response = "You seem to be forgetting a lot! The coded word is SNORSKEE.",
				},
			}
		},
	}
}

function DonutWorld:UseSkill(skill)
	-- if using CopTalk before we've opened our mouth, active cop mode
	if (skill.name == "CopTalk" and not s.hasTalkedInRoom) then
		s.usingCopTalk = s.skillLevels[400]

print("using coptalk", skill.name, s.usingCopTalk)

		-- immediately talk
		self:ActivateConversation()
	end

end

function DonutWorld:OnEnterRoom()
	s.usingCopTalk = 0
	Room.OnEnterRoom(self)
end

function DonutWorld:OnExitRoom()
	-- if we used coptalk, reset to "happy cop" on next enter
	if (s.usingCopTalk) then
		s.donutworld = 0
	-- otherwise use "angry cop" mode
	else
		s.donutworld = 2
	end
end

donutworld = DonutWorld
