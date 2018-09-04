class Loserboard
    attr_accessor :board

    def initialize
        @board = ""
    end

    def populate_lboard(strikes, board)
        puts "\n\n"
        puts "Hello from populate_lboard"
        puts strikes
        case strikes
            when strikes == 1
                p board = %q{
        0
                }
            when strikes == 2
                board = %q{
        0
        |
                }
            when strikes == 3
                board = %q{
        0
      --|
                }
            when strikes == 4
                board = %q{
        0
      --|--
                }
            when strikes == 5
                board = %q{
        0
      --|--
       /
                }
            when strikes == 6
                board = %q{
        0
      --|--
       / \
                }
        end

        p board
    end
end