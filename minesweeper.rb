class Minesweeper
  def initialize(grid_size)
    @board = Board.new(grid_size)
  end

  def play
    start_time = Time.now.to_i
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

    puts "You took an eternally long #{Time.now.to_i - start_time} seconds."
  end

  def prompt_user_for_move
    print "Input move: (x y <f>, save, load) "
    move_string = gets.chomp.split
    if move_string[0] == "save"
      save_game
      puts "You're game has been saved."
      prompt_user_for_move
    elsif move_string[0] == "load"
      load_game
      @board.print_board
      prompt_user_for_move
    else
      move = []
      move << move_string[0].to_i << move_string[1].to_i
      move << move_string[2] if move_string[2]
      move
    end
  end

  def save_game
    f = File.open("saved_game.yaml", 'w+')
    f.print(@board.to_yaml)
  end


  def load_game
    f = File.open("saved_game.yaml")
    @board = YAML::load(f)
  end
end

