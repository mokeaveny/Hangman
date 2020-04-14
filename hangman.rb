def get_dict
	words = []
	File.open("5desk.txt", "r") do |file|
		file.readlines.each_with_index do |line| # Iterates over the entire file of words
			line = line.strip # Strips the whitespace away from the words
			line.downcase! # Converts the word to lowercase
			line_size = line.length
			words.append(line)if (line_size > 4) && (line_size < 13) # Appends the word to the words array if it is between 5 and 12
		end
	end
	return words
end

class Game
	def initialize(dict) # Pass in the dicitonary for the current game
		@number_of_guesses = 10
		@word_array = dict
		@the_word = ""
		pick_random_word
		puts @the_word
		@letter_spaces = []
		set_letter_spaces
		print @letter_spaces
		print "\n"
		turn
	end

	def pick_random_word
		@the_word = @word_array[rand(@word_array.length)]
	end

	def set_letter_spaces
		word_length = @the_word.length

		for i in 1..word_length
			@letter_spaces.append("_ ")
		end
	end
	
	def turn
		valid_letter = false
		alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
		while valid_letter == false
			puts "Guess a letter: "
			letter = gets.chomp
			letter.downcase!
			if alphabet.include?(letter)
				valid_letter = true
			end
		end
		puts letter
		if @the_word.include?(letter)
			puts "The letter is included within the hangman word!"
			letter_index = []
			word_length = @the_word.length
			for i in 0...word_length
				if @the_word[i] == letter
					letter_index.append(i) # Appends the position in the hangman word at which the letter guessed occured
				end
			end
			puts letter_index
		else
			puts "The letter #{letter} is not included within the word!"
		end
	end
		
end

new_game = Game.new(get_dict)
puts new_game
