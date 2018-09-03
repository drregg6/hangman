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
end