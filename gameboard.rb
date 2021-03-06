######################################
#               TODO                 #
# ---------------------------------- #
# generate a gameboard based on data #
#                                    #
######################################

def found_indices(arr, str)
    result = []

    arr.each_index.select do |i|
        if arr[i] == str
            result << i
        end
    end

    result
end



class Gameboard
    attr_accessor :board

    def initialize()
        @board = ''
    end

    def populate_gboard(num)
        @count = 0
        @result = ''
        while @count < num
            if @count == 0
                @result = "_"
            else
                @result += " _"
            end
            @count += 1
        end
        @result
    end

    def add_to_board(str, gameboard, letter)
        # str and gameboard should match arr.length
        # to accurately match them up
        @str_arr = str.split('')
        # @str_arr.pop # removes the newline char

        @gameboard_arr = gameboard.split(' ')

        # search through str array and find each index that the letter matches
        @indices_arr = found_indices(@str_arr, letter)

        # go through the matched indexes and update gameboard at those indexes
        @indices_arr.each do |el|
            @gameboard_arr[el] = letter
        end

        # return the updated gameboard
        @gameboard_arr.join(' ')
    end

    def check_winner(board, word)
        board = board.gsub(/\s+/, '')
        return 1 if board == word
    end

    def check_loser(arr)
        return 1 if arr.length == 6
    end
end