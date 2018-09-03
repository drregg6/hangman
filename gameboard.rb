class Gameboard
    attr_accessor :board

    def initialize
        @board = ''
    end

    def populate(num, gameboard)
        @count = 1
        while @count < num
            if @count == 1
                @board = "_"
            else
                @board += " _"
            end
            @count += 1
        end
    end

    def add_to_board(str, letter, gameboard)
        @str_arr = str.split('')
        @str_arr.pop
        @gameboard_arr = gameboard.split(' ')
        @found_indices = []
        # get placement of the letter in the string
        @str_arr.each_index.select do |i|
            if @str_arr[i] == letter
                @found_indices << i
            end
        end
        # p @found_indices
        # get placement in the gameboard
        # add letter to that placement
        @found_indices.each do |el|
            @gameboard_arr[el] = letter
        end
        @gameboard_arr.join(' ')
        # this displays the @gameboard, but i need to update the existing gameboard
    end
end