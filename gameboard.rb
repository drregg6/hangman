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
        puts @str_arr.length
        # get placement in the gameboard
        puts @gameboard_arr.length
        # add letter to that placement
    end
end