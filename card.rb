class Card
  @@id = 0

  def initialize(id = nil, title = "", members = [], labels = [], due_date = "", checklist = [])
    @id = id || next_id
    @@id = @id > @@id ? @id : @@id
    @title = title
    @members = members
    @labels = labels
    @due_date = due_date
    @checklist = checklist
  end

  def next_id
    @@id += 1
  end
end