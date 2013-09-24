# TODO: 0s spread out functionality,

require 'pp'

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


class Board

  COORD_MODS = [[1, 1], [0, 1], [1, -1], [-1, 0], [-1, -1], [0, -1], [-1, 1], [1, 0]]

  def initialize (grid_size)
    @grid_size = grid_size
    @flag_count = 0

    populate_tiles
  end

  def populate_tiles
    @num_mines = (@grid_size ** 2) / 7

    @board = Array.new(@grid_size) { Array.new(@grid_size) { Tile.new() } }

    @mine_tile_coords = []

    while @mine_tile_coords.length < @num_mines do

      x = rand(@grid_size)
      y = rand(@grid_size)

      @mine_tile_coords << [x, y] unless @mine_tile_coords.include?([x, y])
      @board[x][y].is_mine = true
    end

    count_mines
  end

  def print_board
    system('clear')
    update_user_board
    print " "
    p (0..(@grid_size - 1)).to_a.join(" ")

    @user_board.each_with_index do |row, index|
      print "#{index} "

      row_string = ""

      row.each do |value|
        row_string << "#{value} "
      end

      puts row_string
    end
  end

  def update_user_board
    @user_board = []
    @board.each_with_index do |row, index|
      @user_board << []

      row.map do |tile|
        if tile.flagged
          @user_board[index] << :F
        elsif tile.selected == true and tile.num_close_mines != 0
          @user_board[index] << tile.num_close_mines
        elsif tile.selected == false
          @user_board[index] << :*
        elsif tile.selected == true and tile.num_close_mines == 0
          @user_board[index] << :_
        end
      end
    end
  end

  def cheat_user_board
    @user_board = []
    @board.each_with_index do |row, index|
      @user_board << []

      row.map do |tile|
        if tile.flagged
          @user_board[index] << :F
        elsif tile.selected == true and tile.num_close_mines != 0
          @user_board[index] << tile.num_close_mines
        elsif tile.selected == false and tile.is_mine == true
          @user_board[index] << :b
        elsif tile.selected == false and tile.is_mine == false
          @user_board[index] << tile.num_close_mines
        elsif tile.selected == true and tile.num_close_mines == 0
          @user_board[index] << :_
        end
      end
    end
  end

  def count_mines
    @mine_tile_coords.each do |mine_coord|
      COORD_MODS.each do |coord_mod|
        new_coord = [coord_mod[0] + mine_coord[0], coord_mod[1] + mine_coord[1]]

        next unless is_legit_coord?(new_coord)

        @board[new_coord[0]][new_coord[1]].num_close_mines += 1
      end
    end
  end

  def is_legit_coord? (coord)
    return false if coord[0] < 0 or coord[0] >= @grid_size
    return false if coord[1] < 0 or coord[1] >= @grid_size
    true
  end

  def make_move coord
    x = coord[0]
    y = coord[1]

    flag = coord[2]

    if flag != nil and @flag_count < @num_mines
      @board[x][y].flagged = true
      @flag_count += 1
    elsif flag != nil and @flag_count >= @num_mines
      puts
      puts "whoops, can't have more flags than mines!"
      puts
    elsif flag == nil and is_legit_coord?([x, y])
      @board[x][y].selected = true
      spread([x, y]) if @board[x][y].num_close_mines == 0
    elsif !is_legit_coord?([x, y])
      puts "Whoops, looks like you're off the board!"
    end
  end

  def spread (coord)
    COORD_MODS.each do |coord_mod|
      move = [coord_mod[0] + coord[0], coord_mod[1] + coord[1]]
      make_move(move) if is_legit_coord?(move) and @board[move[0]][move[1]].selected == false
    end
  end

  def game_won?
    @board.each do |row|
      row.each do |tile|
        return false if tile.is_mine == true and tile.flagged == false
      end
    end

    true
  end

  def game_lost?
    @board.any? do |row|
      row.any? do |tile|
        tile.selected and tile.is_mine
      end
    end
  end
end





class Tile
  attr_accessor :is_mine, :num_close_mines, :flagged, :selected

  def initialize
    @is_mine = false
    @flagged = false
    @num_close_mines = 0
    @selected = false
  end
end



#b = Board.new(9)

#b.print_board

# p tile1 = Tile.new(true)


ms = Minesweeper.new(9)
ms.play

