local AnswerService = {}

-- Function to check if userAnswer contains enough content from correctAnswer(s) to be considered correct
function AnswerService.checkAnswer(userAnswer, correctAnswers)
	-- Convert userAnswer to lowercase for case-insensitive comparison
	userAnswer = string.lower(userAnswer)

	-- Function to split a string into words
	local function splitIntoWords(input)
		local words = {}
		for word in string.gmatch(input, "%S+") do
			table.insert(words, word)
		end
		return words
	end

	-- Function to check if userAnswer contains enough words from correctAnswer to be considered correct
	local function enoughContentMatch(userWords, correctWords)
		local matchCount = 0
		for _, correctWord in ipairs(correctWords) do
			for _, userWord in ipairs(userWords) do
				if string.find(userWord, correctWord, 1, true) then
					matchCount = matchCount + 1
					break
				end
			end
		end
		local threshold = 0.85
		return matchCount >= (#correctWords * threshold)
	end

	if type(correctAnswers) == "string" then
		-- If correctAnswers is a single string, convert it to a table for easier handling
		correctAnswers = {correctAnswers}
	elseif type(correctAnswers) ~= "table" then
		-- Return false if correctAnswers is neither a string nor a table
		return false
	end

	-- Check each correct answer
	for _, correctAnswer in ipairs(correctAnswers) do
		-- Convert correctAnswer to lowercase for case-insensitive comparison
		correctAnswer = string.lower(correctAnswer)

		-- Split correctAnswer into words
		local correctWords = splitIntoWords(correctAnswer)

		-- Split userAnswer into words
		local userWords = splitIntoWords(userAnswer)

		-- Check if userAnswer contains enough content from correctAnswer
		if enoughContentMatch(userWords, correctWords) then
			return true
		end
	end

	return false  -- Return false if no match meets the threshold
end

return AnswerService
