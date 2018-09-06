######################################
#               TODO                 #
# ---------------------------------- #
# QUIT to end game                   #
# file only writes when user SAVEs   #
# continue cleaning up code          #
# Continue game vs. New game         #
# Comment Loseboard and Gameboard    #
# PUTS strings put into vars         #
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
    File.delete("saved_file.txt")
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

        @saved_json = {
            "word" => nil,
            "wrong_letters" => nil
        }

        puts @@rules + "\n\n"
    end

    # def to_json(*a)
    #     {
    #         "json_class" => self.class.name,
    #         "data" => {
    #             "word" => @word,
    #             "wrong_letters" => @wrong_letters
    #         }
    #     }.to_json(*a)
    # end

    # def self.json_create(o)
    #     new(o["data"]["word"], o["data"]["wrong_letters"])
    # end

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
                break
            elsif gameboard.check_loser(@wrong_letters) == 1
                puts "Loser loser, you're a loser!"
                puts "The word was #{@word.capitalize}..."
                break
            end


            @saved_json["word"] = @word
            @saved_json["wrong_letters"] = @wrong_letters
            # @data = "#{@word},#{@wrong_letters}"

            # write_file(@data)
            # File.open("saved_file.txt").readlines.each do |line|
            #     puts line
            # end

        end # end loop
    end # end method
end

game = Hangman.new
game.play_game