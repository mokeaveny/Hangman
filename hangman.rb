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
		@letter_spaces = []
		@won = false
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

	def display_letter_spaces
		the_letter_spaces = @letter_spaces.join
		print the_letter_spaces
	end
	
	def turn
		valid_letter = false
		alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
		while valid_letter == false
			print "Guess a letter: "
			letter = gets.chomp
			letter.downcase!
			if alphabet.include?(letter)
				valid_letter = true
			else
				puts "That isn't a valid letter!"
			end
		end

		if @the_word.include?(letter)
			puts "The letter is #{letter} is included within the hangman word!"
			word_length = @the_word.length
			for i in 0...word_length
				if @the_word[i] == letter
					@letter_spaces[i] = letter
				end
			end

		else
			puts "The letter #{letter} is not included within the word!"
			@number_of_guesses -= 1
		end
	end

	def check_won
		if @letter_spaces.all? { |letter| letter != "_ " } # If all of the letter_spaces are not blank then return true
			@won = true
		end
	end
	
	def play
		pick_random_word # Picks the word for the player to guess
		set_letter_spaces # Sets the blank letter spaces to let them know how long the word is
		while (@number_of_guesses > 0) && (@won == false)
			display_letter_spaces
			print "\n"
			print "\n"
			turn
			check_won 
		end
		
		if @won == true
			puts "You won! The word was #{@the_word}! Well done!"
		else
			puts "You lost! The word was #{@the_word}! Good luck next time!"
		end
	end
	
end

new_game = Game.new(get_dict)
new_game.play
