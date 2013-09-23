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
    p num_mines

    @board = Array.new(@grid_size) { Array.new(@grid_size) { Tile.new() } }

    mine_tiles = []

    while mine_tiles.length < num_mines do

      x = rand(@grid_size)
      y = rand(@grid_size)

      mine_tiles << @board[x][y] unless mine_tiles.include?(@board[x][y])
      @board[x][y].is_mine = true
    end
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
        elsif tile.selected == false
          @user_board[index] << :*
        elsif tile.selected == true and tile.num_close_mines == 0
          @user_board[index] << :_
        end
      end
    end

  end

end

class Tile
  attr_reader :num_close_mines, :selected
  attr_accessor :is_mine

  def initialize
    @is_mine = false
    @flagged = false
    @num_close_mines = 0
    @selected = false
  end

  def get_nieghbors

  end


end

b = Board.new(9)

b.print

# p tile1 = Tile.new(true)