require 'pp'

class Minesweeper

  def self.play

  end

  def initialize

  end

end


class Board
  def initialize (grid_size)
    @grid_size = grid_size

    populate_tiles
  end

  def populate_tiles
    num_mines = (@grid_size ** 2) / 7

    @board = Array.new(@grid_size) { Array.new(@grid_size) { Tile.new() } }

    # mine_tiles = []
    @mine_tile_coords = []

    # while mine_tiles.length < num_mines do
    while @mine_tile_coords.length < num_mines do

      x = rand(@grid_size)
      y = rand(@grid_size)

      # mine_tiles << @board[x][y] unless mine_tiles.include?(@board[x][y])
      @mine_tile_coords << [x, y]
      @board[x][y].is_mine = true
    end

    count_mines

  end

  def print
    update_user_board
    @user_board.each do |row|
      p row
    end
  end

  def update_user_board
    @user_board = []
    @board.each_with_index do |row, index|
      @user_board << []

      row.map do |tile|
        if tile.selected == true and tile.num_close_mines != 0
          @user_board[index] << tile.num_close_mines
        elsif tile.selected == false and tile.is_mine == true
          @user_board[index] << "m"
        elsif tile.selected == false
          @user_board[index] << tile.num_close_mines.to_s #:*
        elsif tile.selected == true and tile.num_close_mines == 0
          @user_board[index] << :_
        end
      end

    end
  end

  def count_mines
    coord_mods = [[1, 1], [0, 1], [1, -1], [-1, 0], [-1, -1], [0, -1], [-1, 1], [1, 0]]

    @mine_tile_coords.each do |mine_coord|
      # @board[coord[0]][coord[1]]
      coord_mods.each do |coord_mod|
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
end





class Tile
  attr_reader :selected
  attr_accessor :is_mine, :num_close_mines

  def initialize
    @is_mine = false
    @flagged = false
    @num_close_mines = 0
    @selected = false
  end
end

b = Board.new(9)

b.print

# p tile1 = Tile.new(true)