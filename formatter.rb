module Formatter
  def welcome
    rows = []
    rows << ["One", 1]
    rows << ["Two", 2]
    rows << ["Three", 3]
    table = Terminal::Table.new title: "Cheatsheet", headings: %w[Word Number], rows: rows
    puts table
  end

  def table; end
end
