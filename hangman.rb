# two gameboards, a winner and a loser
# winner is when a letter is entered correctly
# loser is a hangman character

require './gameboard'

# global for now
# i feel as though these could be used in a module
$words = []
File.open("words.txt").readlines.each do |line|
    if line.length >= 5 && line.length <= 12
        $words << line.downcase.delete("\n")
    end
end

def all_letters(str)
    str[/[a-zA-Z]+/] == str
end

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
        @gameboard = Gameboard.new
        @gameboard.populate(@word.length, @gameboard.board)

        @wrong_letters = Array.new
    end

    def play_game
        loop do
            puts "\n\n"
            if @wrong_letters.length != 0
                puts "Incorrect guesses: " + @wrong_letters.join(" - ")
            end
            puts "Guess a letter!"
            $stdout.flush
            @letter = gets.chomp
            @letter.downcase!

            # if @letter has already been guessed
            if @wrong_letters.include?(@letter) || @gameboard.board.include?(@letter)
                # guess again dumb dumb
                puts "You have already guessed that!"
                @wrong_letters << @letter


            # if @letter is more than one letter
            elsif @letter.length != 1
                # shame shame shame! no cheating!
                puts "Shame! No cheating, guess one at a time!"


            # if @letter is anything but a letter
            elsif !all_letters(@letter)
                # guess a letter dumb dumb
                puts "You did it wrong... guess a LETTER!"

            # if @letter exists in @word
            elsif @word.include?(@letter)
                # place @letter in the correct place on @gameboard
                @gameboard.board = @gameboard.add_to_board(@word, @gameboard.board, @letter)
                puts @gameboard.board
                puts "You guessed one correctly!"

            # if not
            elsif !@word.include?(@letter)
                # add a strike
                puts "You guessed one incorrectly!"
                # place in @wrong_letters arr
                @wrong_letters << @letter
            end

            # win / loss check
            if gameboard.check_winner(@gameboard.board, @word) == 1
                puts "Winner winner, chicken dinner!"
                break
            elsif gameboard.check_loser(@wrong_letters) == 1
                puts "Loser loser, you're a loser!"
                break
            end

            # if @letter == "f"
            #     break
            # end
            @letter
        end
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