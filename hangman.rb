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


# set up save option
    # when player enters "SAVE"
        # File.open("saved_game.txt", "w")
        # write over file
        # csv format?



######################################
#               TODO                 #
# ---------------------------------- #
# Clean up code                      #
# Get rid of test PUTS statements    #
# Save implementation                #
# Continue game vs. New game         #
# Comment Loseboard and Gameboard    #
#                                    #
######################################

require './gameboard'
require './loserboard'
require 'json'

# global for now
# I feel as though these could be used in a module
$words = []
File.open("words.txt").readlines.each do |line|
    if line.length >= 5 && line.length <= 12
        $words << line.downcase.delete("\n")
    end
end


# helpers
def all_letters(str)
    str[/[a-zA-Z]+/] == str
end

def user_feedback(letter, word, board, arr)
    message = ""
    result = :bad

    if letter == "save"
        message = "SAVING..."
        result = :save
    elsif letter.length != 1
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

    puts "\n\n"
    puts message
    result
end




class Hangman
    attr_accessor :word, :gameboard, :loserboard

    @@rules = %q{
        RULES OF HANGMAN
    -------------------------
guess the hidden word letter by letter
six strikes and you are out
    }

    def initialize
        @word = $words.sample

        @gameboard = Gameboard.new
        @gameboard.board = @gameboard.populate_gboard(@word.length)

        @loserboard = Loserboard.new

        @wrong_letters = Array.new
        @strikes = 0

        puts @@rules + "\n\n"
    end

    def to_str
        "In Hangman:\n Word: #{@word}\n Wrong letters: #{@wrong_letters}\n"
    end
    def to_json(*a)
        {
            "json_class" => self.class.name,
            "data" => {"word" => @word, "wrong_letters" => @wrong_letters}
        }.to_json(*a)
    end
    def self.json_create(o)
        new(o["data"]["word"], o["data"]["wrong_letters"])
    end

    def play_game
        loop do
            puts "The Current Gameboard: #{@gameboard.board}"
            puts "You currently have #{@strikes} #{@strikes != 1 ? 'strikes' : 'strike'}"

            if @wrong_letters.length != 0
                puts "Incorrect guesses: #{@wrong_letters.join(" - ")}\n"
            end
            puts "Guess a letter!"


            $stdout.flush
            @letter = gets.chomp
            @letter.downcase!

            @result = user_feedback(@letter, @word, @gameboard.board, @wrong_letters)

            if @result == :save
                puts "Goodbye!"
                break
            elsif @result == :bad
                @wrong_letters << @letter

                @strikes = @wrong_letters.length
                @loserboard.board = @loserboard.populate_lboard(@strikes)

                puts @loserboard.board
            elsif @result == :good
                @gameboard.board = @gameboard.add_to_board(@word, @gameboard.board, @letter)
            end



            # win / loss check
            if gameboard.check_winner(@gameboard.board, @word) == 1
                puts "Winner winner, chicken dinner!"
                puts "The word was #{@word.upcase}!"
                break
            elsif gameboard.check_loser(@wrong_letters) == 1
                puts "Loser loser, you're a loser!"
                puts "The word was #{@word.capitalize}..."
                break
            end

            # json is being updated
            puts self.to_json

        end # end loop
    end # end method
end

game = Hangman.new
game.play_game