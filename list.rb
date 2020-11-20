class List
  @@id = 0

  attr_reader :id, :name, :cards

  def initialize(id: nil, name: "", cards: [])
    @id = id || next_id
    @@id = @id > @@id ? @id : @@id
    @name = name
    @cards = cards
  end

  def next_id
    @@id += 1
  end
end
