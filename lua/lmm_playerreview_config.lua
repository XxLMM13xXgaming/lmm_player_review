LMMPRConfig = {}
LMMPRConfig.QuestionTable = {}
LMMPRConfig.DevMode = false
/*
	Made By: XxLMM13xXgaming
*/
-- How to do this...
-- LMMPRConfig.QuestionTable.Qnext number = {question, how many choices, the choice(1), the choice(2)ect.}
-- examples below

-- TIPS:
-- using !n will replease it with the players name! (player they are reviewing)
-- putting 0 in the 2nd var will make a text entry box!
LMMPRConfig.QuestionTable.Q1 = {"Is !n your friend?", 2, "Yes", "No"}
LMMPRConfig.QuestionTable.Q2 = {"Have you had any problems with this player before?", 2, "Yes", "No"}
LMMPRConfig.QuestionTable.Q3 = {"How trust worthy do you think !n is?", 5, "5 - Very trust worthy", "4 - trust worthy", "3 - I dont know", "2 - Not trust worthy", "1 - Not Very trust worthy"}
LMMPRConfig.QuestionTable.Q4 = {"What makes this player trustworthy?", 0}
LMMPRConfig.QuestionTable.Q5 = {"Have you ever seen this player in trouble?", 2, "Yes", "No"}
LMMPRConfig.QuestionTable.Q6 = {"If you saw anything bad happen to this player what was it?", 0}
LMMPRConfig.QuestionTable.Q7 = {"Would you like to see !n as a admin?", 2, "Yes", "No"}

LMMPRConfig.HowManyQuestions = 7 -- How many entrys are there ^ THIS MUST BE CORRECT

LMMPRConfig.AdminGroups = {"superadmin", "admin", "owner"}