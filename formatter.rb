require_relative 'Board'
require 'terminal-table'

module Formatter #Board_Menu

  def give_board(boards)
    table = Terminal::Table.new
    table.title = boards.name
    table.headings = %w[ID Name Description List]
    table.rows = [[boards.id, boards.name, boards.description, boards.list]]
    puts table
    puts "Board options: create | show ID | update ID | delete ID" 
    gets.chomp
  end
  give_board(board)
end



board = Board.new(name: "Default", description: "Description default")