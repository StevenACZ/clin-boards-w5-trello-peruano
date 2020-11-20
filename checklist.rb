class Checklist
  attr_reader :title, :completed

  def initialize(title: "", completed: false)
    @title = title
    @completed = completed
  end
end
