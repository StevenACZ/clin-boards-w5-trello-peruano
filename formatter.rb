require_relative 'Board'
require 'terminal-table'

module Formatter
  def welcome(boards)
    table = Terminal::Table.new
    table.title = "CLIn Boards"
    table.headings = %w[ID Name Description List]
    table.rows = boards.map do |board|
      [board.id, board.name, board.description, list_get_name_size(board)]
    end
    puts table
    puts "Board options: create | show ID | update ID | delete ID" 
  end

  def list_get_name_size(board)
    lists = []
    name = list_get_name(board)
    size = list_get_cards_size(board)
    name.each_with_index do |item, index|
      lists.push("#{item}(#{size[index]})")
    end
    lists.join(", ")
  end

  def list_get_name(board)
    board.lists.map { |list| list.name }
  end
  
  def list_get_cards_size(board)
    board.lists.map { |list| list.cards.size }
  end
end