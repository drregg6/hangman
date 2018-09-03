require './gameboard'

# global for now
$words = []
File.open("words.txt").readlines.each do |line|
    if line.length >= 5 && line.length <= 12
        $words << line.downcase
    end
end
# puts words

# set up game
    # generate game
        # dictionary of hangman words
        # between 5 - 12 characters
    # continue saved game?
        # File.open("saved_game.txt", "r")
        # continue game where it's left off
    # else
        # loop
            # ask for a letter
                # if letter is in the word
                    # place letter
                    # display the board
                # else
                    # strike against player
            # if there are 6 strikes
                # player loses
            # if player guesses the word
                # player wins

class Hangman
    attr_accessor :word, :gameboard

    @@rules = %q{
        RULES OF HANGMAN
    -------------------------
guess the hidden word letter by letter
six strikes and you are out
    }

    def initialize
        puts @@rules
        @word = $words.sample
        @guessed_letters = Array.new
        @gameboard = Gameboard.new
        @gameboard.populate(@word.length, @gameboard.board)
    end

    def play_game
        loop do
            puts "Guess a letter!"
            $stdout.flush
            @letter = gets.chomp

            # if @letter has already been guessed
            if @guessed_letters.include?(@letter)
                puts "Guess again dumb dumb"
                p @guessed_letters
            end
                # guess again dumb dumb
            # if @letter is more than one letter
                # shame shame shame! no cheating!
            # if @letter is anything but a letter
                # guess a letter dumb dumb
            # if @letter exists in @word
                # place @letter in the correct place on @gameboard
                # place in @guessed_letters arr
            # if not
                # add a strike
                # place in @guessed_letters arr
            if @letter == "f"
                break
            end
            @guessed_letters << @letter
        end
        @letter
    end
end


# set up save option
    # when player enters "SAVE"
        # File.open("saved_game.txt", "w")
        # write over file
        # csv format?

game = Hangman.new
puts game.word
puts "\n\n"
puts game.gameboard.board
game.play_game