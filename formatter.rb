require_relative "board"
require "terminal-table"

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
    board.lists.map(&:name)
  end

  def list_get_cards_size(board)
    board.lists.map { |list| list.cards.size }
  end

  def show_list(id)
    (@store.select { |board| board.id == id.to_i })[0].lists.each do |list|
      table = Terminal::Table.new
      table.title = list.name.to_s
      table.headings = %w[ID Title Members Labels Due\ Date Checklist]
      table.rows = list.cards.map do |card|
        [card.id, card.title, card.members.join(", "), card.labels.join(", "), card.due_date, n_check(card.checklist)]
      end
      puts table
    end
  end

  def n_check(checklist)
    completed = 0
    checklist.each do |check|
      check.completed == true && completed += 1
    end
    "#{completed}/#{checklist.size}"
  end
end
