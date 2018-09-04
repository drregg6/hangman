class Loserboard
    attr_accessor :board

    def initialize
        @board = String.new
    end

    def populate_lboard(strikes)
        result = ''

        case strikes
            when 1
                result = %q{
        0
                }
            when 2
                result = %q{
        0
        |
                }
            when 3
                result = %q{
        0
      --|
                }
            when 4
                result = %q{
        0
      --|--
                }
            when 5
                result = %q{
        0
      --|--
       /
                }
            when 6
                result = %q{
        0
      --|--
       / \
                }
        end

        result
    end
end