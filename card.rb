class Card
  @@id = 0

  def initialize(id: nil, title: "", **rest)
    @id = id || next_id
    @@id = @id > @@id ? @id : @@id
    @title = title
    @members = rest[:members] || []
    @labels = rest[:labels] || []
    @due_date = rest[:due_date] || ""
    @checklist = rest[:checklist] || []
  end

  def next_id
    @@id += 1
  end
end
