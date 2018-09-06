######################################
#               TODO                 #
# ---------------------------------- #
# comment Loserboard and Gameboard   #
# place PUT strings into vars        #
#                                    #
# code is SUPER sloppy               #
# clean this SHIT up                 #
# continue cleaning up code          #
#                                    #
# helper methods placed in module    #
# end_game is useless                #
#    File.delete is being repeated   #
#    message should be updated       #
#    based on the situation          #
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

def end_game
    puts "Deleting data..."
    File.delete("saved_file.json")
    puts "Deletion complete!"
end

def user_feedback(letter, word, board, arr)
    message = ""
    result = :bad

    if letter == "save"
        message = "SAVING..."
        result = :save
    elsif letter == "quit"
        end_game
        result = :quit
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

def write_file(data)
    File.open("saved_file.txt", "w") do |line|
        line.puts 'word,wrong_letters'
        line.puts data
    end
end



class Hangman
    attr_accessor :word, :gameboard, :loserboard

    @@rules = %q{
            RULES OF HANGMAN
    -----------------------------
  GUESS the hidden word, letter by letter
      HANGMAN and you lose the game

         SAVE to save your game
    QUIT to leave game and erase data
    }

    def initialize
        @word = $words.sample
        @wrong_letters = Array.new
        @strikes = @wrong_letters.length
        @saved_json = {}

        @gameboard = Gameboard.new
        @loserboard = Loserboard.new

        puts @@rules + "\n\n"


        if File.exist?("saved_file.json")
            puts "Would you like to continue the saved game?"
            puts "Please answer YES or NO"
            loop do
                $stdout.flush
                @answer = gets.chomp.downcase

                if @answer == "yes" || @answer == "y"
                    puts "Continuing saved data..."
                    # read data from JSON file
                    @file = File.read("saved_file.json")
                    # parse data
                    @data = JSON.parse(@file)
                    # replace the randomly generated word and empty arr
                    # with data from last game
                    @word = @data["word"]
                    @wrong_letters = @data["wrong_letters"]
                    # generate game
                    generate_game(@word)
                    # replace generated board with real board
                    # TODO: this needs to be replaced
                    @gameboard.board = @data["gameboard"]
                    break
                elsif @answer == "no" || @answer == "n"
                    puts "Starting new game..."
                    # delete old data
                    File.delete("saved_file.json")
                    # generate a brand new game based on a new word
                    generate_game(@word)
                    break
                else
                    puts "Please choose YES or NO"
                end
            end
        else
            generate_game(@word)
        end
    end

    def generate_game(word)
        @gameboard.board = @gameboard.populate_gboard(word.length)

        @strikes = @wrong_letters.length
        @loserboard.board = @loserboard.populate_lboard(@strikes)
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
                # save the data needed to generate game
                @saved_json["word"] = @word
                @saved_json["wrong_letters"] = @wrong_letters
                @saved_json["gameboard"] = @gameboard.board

                # save that data into a json file
                File.open("saved_file.json", "w") do |file|
                    file.write(JSON.pretty_generate(@saved_json))
                end

                puts "Goodbye!"
                break
            elsif @result == :quit
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
            # these two can be checked in the same method
            if gameboard.check_winner(@gameboard.board, @word) == 1
                puts "Winner winner, chicken dinner!"
                puts "The word was #{@word.upcase}!"

                File.delete("saved_file.json")
                break
            elsif gameboard.check_loser(@wrong_letters) == 1
                puts "Loser loser, you're a loser!"
                puts "The word was #{@word.capitalize}..."

                File.delete("saved_file.json")
                break
            end

        end # end loop
    end # end method
end

game = Hangman.new
game.play_game