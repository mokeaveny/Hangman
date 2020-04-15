require "json"

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
		@guessed_chars = []
		@won = false
		@this_game_number = rand 5
		@save_game = false
	end

	def pick_random_word
		@the_word = @word_array[rand(@word_array.length)]
	end

	def set_letter_spaces
		word_length = @the_word.length
		for i in 1..word_length
			@letter_spaces.append(" _ ")
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
					@letter_spaces[i] = " " + letter + " "
				end
			end
			@guessed_chars.append(letter)

		else
			puts "The letter #{letter} is not included within the word!"
			@guessed_chars.append(letter)
			@number_of_guesses -= 1
		end
	end

	def display_guessed_chars
		print "Guesed characters: [" + @guessed_chars.join(" ")	+ "]"
	end

	def check_won
		if @letter_spaces.all? { |letter| letter != " _ " } # If all of the letter_spaces are not blank then return true
			@won = true
		end
	end

	def save_serial(the_word, letter_spaces, guessed_chars, number_of_guesses) # Creates a symbol for every attribute
		save_serial = Hash.new
		save_serial[:the_word] = the_word
		save_serial[:letter_spaces] = letter_spaces
		save_serial[:guessed_chars] = guessed_chars
		save_serial[:number_of_guesses] = number_of_guesses
		return save_serial
	end

	def save_game
		save = save_serial(@the_word, @letter_spaces, @guessed_chars, @number_of_guesses) # Assigns a hash that contains symbols for every attribute to the variable
		File.open("saved_game_#{@this_game_number}.txt", "w") do |file| 
			file.write save.to_json # Saves the symbols to the file using json. Imported at the top as you can see.
		end
	end
			
	def load_game(game_number) # Function that allows you to load your game. Haven't tried it yet.
		load_serial = Hash.new
		
		load_serial = JSON.parse(File.read("saved_game_#{game_number}.txt"))

		load_serial.each do |k, v|
			case k
				when "the_word"
					@the_word = v
				when "letter_spaces"
					@letter_spaces = v
				when "guessed_chars"
					@guessed_chars = v
				when "number_of_guesses"
					@number_of_guesses = v
				else
					puts "There was an error loading your file. Creating new game."
			end
		end
	end
	
	def play
		game_choice = " "
		valid = false
		puts "Welcome to Hangman!"
		
		while (valid == false)
			puts "Would you like to start a new game(N) or load a previous game(L)? "
			game_choice = gets.chomp # Gets input
			game_choice.downcase!
			if game_choice == "n" || game_choice == "l"
				valid = true
			end
		end

		if game_choice == "n"
			pick_random_word
			set_letter_spaces
			puts
			puts "New Game Created!"
		else
			puts "What game would you like to load?"
			directory = Dir.getwd # Gets the working directory
			puts Dir.glob("#{directory}/*.{txt, TXT}").join(",\n") # Outputs all the current game files you can play.
			valid_game = false
			while valid_game == false
				game_to_load = gets.chomp
				if File.exists?("#{directory}/saved_game_#{game_to_load}.txt") # If the file exists then the game is loaded by substituting the inpit into the string
					valid_game = true
					load_game(game_to_load)
					@save_game = false
				else
					puts "That isn't a valid game file! Try inputting a different game number:"
				end
			end
		end

		while (@number_of_guesses > 0) && (@won == false)
			puts
			puts "Current Game Number: #{@this_game_number}"
			print "\n"
			display_letter_spaces
			print "\n" # Display a blank line
			print "\n"# Display a blank line
			display_guessed_chars
			print "\n"
			print "\n"

			puts "Would you like to save your game and play another time? Type (Y) to save."
			choice = gets.chomp
			choice.downcase!
			if choice == "y"
				@save_game = true
				break # Breaks out of the current loop
			end
			
			puts
			turn
			check_won 
		end
		
		if @save_game == true
			save_game

		else
			if @won == true
				puts "You won! The word was #{@the_word}! Well done!"
			else
				puts "You lost! The word was #{@the_word}! Good luck next time!"
			end
		end
	end
	
end

new_game = Game.new(get_dict)
new_game.play