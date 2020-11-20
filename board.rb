class Board
  @@id = 0

  attr_reader :id, :name, :description, :lists

  def initialize(id = nil, name = "", description = "", lists = [])
    @id = id || next_id
    @@id = @id > @@id ? @id : @@id
    @name = name
    @description = description
    @lists = lists
  end

  def next_id
    @@id += 1
  end
end
