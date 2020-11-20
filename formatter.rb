require_relative "board"
require "terminal-table"

module Formatter

  def greeting
    puts "####################################"
    puts "#     Welcome to CLIn Boards       #"
    puts "####################################"
  end
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
      show_list_table(list)
    end
  end

  def show_list_table(list)
    table = Terminal::Table.new
    table.title = list.name.to_s
    table.headings = %w[ID Title Members Labels Due\ Date Checklist]
    table.rows = show_list_table_rows(list)
    puts table
  end

  def show_list_table_rows(list)
    list.cards.map do |card|
      members = array_or_string(card.members)
      labels = array_or_string(card.labels)
      due_date = card.due_date
      [card.id, card.title, members, labels, due_date, n_check(card.checklist)]
    end
  end

  def array?(value)
    value.class.to_s == "Array"
  end

  def array_or_string(value)
    array?(value) ? value.join(", ") : value
  end

  def n_check(checklist)
    completed = 0
    checklist.each do |check|
      check.completed == true && completed += 1
    end
    "#{completed}/#{checklist.size}"
  end

  def finish
    puts "####################################"
    puts "#   Thanks for using CLIn Boards   #"
    puts "####################################"
  end
end
