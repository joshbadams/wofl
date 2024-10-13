
IRS = Site:new {
	
	title = "** Internal Revenue Service **",

	pages = {
		['password'] = {
			type = "password",
		},
		['main'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "TaxInfo Board", target = "irsboard" },
				{ key = '2', text = "Supervisor's Notice", target = "notice", level = 2 },
				{ key = '3', text = "Special Audit Report", target = "auditreport", level = 2 },
				{ key = '4', text = "View Audit List", target = "auditlist", level = 2 }
			}
		},
		
		['irsboard'] = {
			type = "list",
			exit = "main",
			hasDetails = true,
			columns = { { field = 'date', width = 8 }, { field = 'to', width = 15 }, { field = 'from', width = 0 } },
			items = {
				{
					date = 111658,
					tp = "IRS",
					longto = "--",
					from = "L. Zone",
					headers = "BAMA ID: 1404726431",
					message = "I had twenty million credits worth of incoming this year in my black market pituitary extract operation. This is my first year in business. Which forms should I use to report this income? Can my business startup expenses be deducted?"
				},
				{
					date = 111658,
					to = "L. Zone",
					from = "IRS",
					longfrom = "--",
					message = "Your business is an illegal operation. We have identified you to the proper law encorcement agencies. Pending further investigation, your total incoming for theyear has been turned over to us."
				},
				{
					date = 111658,
					to = "IRS",
					longto = "--",
					from = "R. Hammer",
					longfrom = "Rafaella Hammer",
					headers = "BAMA ID: 2776081129",
					message = "Due to an oversight on the part of my accountant, I failed to report all of my income for the last year. What form should I file to correct this oversight and how much of a penalty will I have to pay?"

				},
				{
					date = 111658,
					to = "R. Hammer",
					longto = "Rafaella Hammer",
					from = "IRS",
					longfrom = "--",
					message = "We have given your case careful consideration and have decided that there will be no penalty incurred on the income you failed to report last year. However, you and your tax accountant are you going to jail."
				},
			}
		},
		
		['auditreport'] = {
			type = "message",
			message = "No report at this time."
		},

		['auditlist'] = {
			type = "list",
			exit = "main",
			header = "Field Audit List",
			hasDetails = true,
			columns = { { field = "Name", width = 15 } , { field = "BAMA ID", width = 0 } },
			items = {
				{
					Name = "%name%",
					['BAMA ID'] = "%bamaid%",
					message = "Reason: Tax evasion."
				},
				{
					Name = "FINDLEY MATTHEW",
					['BAMA ID'] = "001131968",
					message = "Reason: Tax evasion."
				},
				{
					Name = "CHUNG LO DUC",
					['BAMA ID'] = "471294819",
					message = "Reason: Tax evasion."
				},
				{
					Name = "NAKASONE SANDRA",
					['BAMA ID'] = "255885697",
					message = "Reason: Tax evasion."
				},
				{
					Name = "MARTINEZ RAUL",
					['BAMA ID'] = "549887110",
					message = "Reason: Tax evasion."
				},
			}
		}
		
	}
}
-- lowercase
irs = IRS