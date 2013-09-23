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

    @board = Array.new(@grid_size) { Array.new(@grid_size, Tile.new(false)) }
  end

  def print
    #@user_board = @board
    @user_board = []
    @board.each_with_index do |row, index|
      @user_board << []
      row.map do |tile|
        @user_board[index] << tile.num_close_mines
      end
    end

    pp @user_board

  end

  def compute

  end
end

class Tile
  attr_reader :num_close_mines

  def initialize (is_mine)
    @is_mine = is_mine
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