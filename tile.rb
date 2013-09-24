class Tile
  attr_accessor :is_mine, :num_close_mines, :flagged, :selected

  def initialize
    @is_mine = false
    @flagged = false
    @num_close_mines = 0
    @selected = false
  end
end