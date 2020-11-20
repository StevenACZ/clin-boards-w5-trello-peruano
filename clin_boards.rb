require_relative "formatter"
require_relative "requester"
require_relative "list"
require_relative "card"
require_relative "checklist"
require_relative "board"
require "terminal-table"
require "json"

class ClinBoards
  include Formatter
  include Requester

  def initialize(filename = "store.json")
    @filename = filename
    @store = parse_json
  end

  def start
    until welcome(@store)
      option_board, id_board = gets.chomp.split(" ")
      case option_board
      when "create" then create
      when "update" then update(id_board)
      when "delete" then delete(id_board)
      when "show" then show(id_board)
      when "exit" then exit
      end
    end
  end

  def create
    print "Name: "
    name = gets.chomp
    print "Description: "
    description = gets.chomp
    new_one = Board.new(name: name, description: description)
    @store.push(new_one)
  end

  def update(id)
    print "Name: "
    name = gets.chomp
    print "Description: "
    description = gets.chomp
    new_one = Board.new(id: id.to_i, name: name, description: description)
    @store.reject! { |board| board.id == id.to_i }
    @store.push(new_one)
  end

  def delete(id)
    @store.reject! { |board| board.id == id.to_i }
  end

  def show(id_board)
    loop do
      show_list(id_board)
      puts "List options: create-list | update-list LISTNAME | delete-list LISTNAME"
      puts "Card options: create-card | checklist ID | update-card ID | delete-card ID"
      option_list, id_list = gets.chomp.split(" ")
      show_options(option_list, id_list)
      break if option_list == "back"
    end
  end

  def exit
    puts "####################################"
    puts "#   Thanks for using CLIn Boards   #"
    puts "####################################"
  end

  private

  def show_options(option_list, id_list)
    list_options(option_list, id_list)
    card_options(option_list, id_list)
  end

  def list_options(option_list, id_list)
    case option_list
    when "create-list" then create_list
    when "update-list" then update_list(id_list)
    when "delete-list" then delete_list(id_list)
    end
  end

  def card_options(option_list, id_list)
    case option_list
    when "create-card" then create_card(id_list)
    when "update-card" then update_card(id_list)
    when "delete-card" then delete_card(id_list)
    when "checklist" then checklist(id_list)
    end
  end

  def parse_json
    data = JSON.parse(File.read(@filename), symbolize_names: true)
    data.map! do |board|
      board_to_object(board)
      Board.new(board)
    end
    data
  end

  def board_to_object(board)
    board[:lists].map! do |list|
      list[:cards].map! do |card|
        card[:checklist].map! { |check| Checklist.new(check) }
        Card.new(card)
      end
      List.new(list)
    end
  end
end

app = ClinBoards.new
app.start
