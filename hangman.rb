# two gameboards, a winner and a loser
# winner is when a letter is entered correctly
# loser is a hangman character

require './gameboard'
require './loserboard'

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

def user_feedback(letter, word, board, arr)
    message = ""
    result = :bad

    if letter.length != 1
        message = "Guess one at a time"
        result = :neutral
    elsif !all_letters(letter)
        message = "You did it wrong, please guess a l-e-t-t-e-r!"
        result = :neutral
    elsif arr.include?(letter) || board.include?(letter)
        message = "You already guessed that!"
    elsif !word.include?(letter)
        message = "You guessed incorrectly..."
    elsif word.include?(letter)
        message = "You guessed correctly!"
        result = :good
    end

    puts message
    result
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
    attr_accessor :word, :gameboard, :loserboard

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
        @gameboard.populate_gboard(@word.length, @gameboard.board)

        @loserboard = Loserboard.new

        @wrong_letters = Array.new
        @strikes = 0
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

            @result = user_feedback(@letter, @word, @gameboard.board, @wrong_letters)
            if @result == :bad
                @wrong_letters << @letter
            elsif @result == :good
                @gameboard.board = @gameboard.add_to_board(@word, @gameboard.board, @letter)
            end

            @strikes = @wrong_letters.length
            @loserboard.board = @loserboard.populate_lboard(@strikes)
            puts @loserboard.board

            # win / loss check
            if gameboard.check_winner(@gameboard.board, @word) == 1
                puts "Winner winner, chicken dinner!"
                break
            elsif gameboard.check_loser(@wrong_letters) == 1
                puts "Loser loser, you're a loser!"
                break
            end

            puts "\n\n"
            puts "The word: #{@word}"
            puts "Your letter guess: #{@letter}"
            puts "Gameboard: #{@gameboard.board}"
            puts "Incorrect guesses: #{@wrong_letters}"
            puts "\n\n"
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
# puts "\n\n"
# puts game.gameboard.board
game.play_game





            # if @letter has already been guessed
            # if @wrong_letters.include?(@letter) || @gameboard.board.include?(@letter)
            #     # guess again dumb dumb
            #     # puts "You have already guessed that!"
            #     @wrong_letters << @letter

            # # if @letter exists in @word
            # elsif @word.include?(@letter)
            #     # place @letter in the correct place on @gameboard
            #     @gameboard.board = @gameboard.add_to_board(@word, @gameboard.board, @letter)
            #     puts @gameboard.board
            #     # puts "You guessed one correctly!"

            # # if not
            # elsif !@word.include?(@letter)
            #     # add a strike
            #     # puts "You guessed one incorrectly!"
            #     # place in @wrong_letters arr
            #     @wrong_letters << @letter
            # end


            # user_feedback(@letter, @word, @gameboard.board, @wrong_letters)
