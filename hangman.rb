words = []
number_of_guesses = 10

File.open("5desk.txt", "r") do |file|
	file.readlines.each_with_index do |line| # Iterates over the entire file of words
		line = line.strip # Strips the whitespace away from the words
		line_size = line.length
		words.append(line)if (line_size > 4) && (line_size < 13) # Appends the word to the words array if it is between 5 and 12
	end
end

class Game
	def initialize(dict) # Pass in the dicitonary for the current game
		@number_of_guesses = 10
		@word_array = dict
		@the_word = ""
		pick_random_word # Calls the method to get a random word from the dictionary in the constructor
	end

	def pick_random_word
		@the_word = @word_array[rand(@word_array.length)]
	end

	def get_word
		return @the_word
	end

end

new_game = Game.new(words)
puts new_game.get_word