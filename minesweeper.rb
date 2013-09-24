class Minesweeper
  def initialize(grid_size)
    @board = Board.new(grid_size)
  end

  def play
    loop do
      @board.print_board

      move = prompt_user_for_move
      @board.make_move(move)

      if @board.game_won?
        puts "You won!"
        break
      elsif @board.game_lost?
        puts "You have exploded!"
        break
      end
    end
  end

  def prompt_user_for_move
    print "Input move: (x y <f>) "
    move_string = gets.chomp.split
    move = []
    move << move_string[0].to_i << move_string[1].to_i
    move << move_string[2] if move_string[2]
    move
  end
end

