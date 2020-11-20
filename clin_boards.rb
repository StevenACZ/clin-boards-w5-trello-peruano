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
    res = name_and_description
    new_one = Board.new(name: res[0], description: res[1])
    @store.push(new_one)
  end

  def update(id)
    res = name_and_description
    new_one = Board.new(id: id.to_i, name: res[0], description: res[1])
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
      show_options(option_list, id_list, id_board)
      break if option_list == "back"
    end
  end

  def create_card(id_board)
    list_select = requester_create_card_option(id_board)
    resul = requester_create_card
    card_data = { id: nil, title: resul[0], members: resul[1], labels: resul[2], due_date: resul[3] }
    new_card = Card.new(card_data)
    card_created_send(id_board, list_select, new_card)
  end

  def delete_card(id_board, id_list)
    @store.each do |item|
      next unless item.id == id_board.to_i

      item.lists.each { |list| list.cards.reject! { |card| card.id == id_list.to_i } }
    end
  end

  private

  def show_options(option_list, id_list, id_board)
    list_options(option_list, id_list)
    card_options(option_list, id_list, id_board)
  end

  def list_options(option_list, id_list)
    case option_list
    when "create-list" then create_list
    when "update-list" then update_list(id_list)
    when "delete-list" then delete_list(id_list)
    end
  end

  def card_options(option_list, id_list, id_board)
    case option_list
    when "create-card" then create_card(id_board)
    when "update-card" then update_card(id_list)
    when "delete-card" then delete_card(id_board, id_list)
    when "checklist" then checklist(id_list)
    end
  end

  def card_created_send(id_list, list_select, new_card)
    @store.each do |board|
      next unless board.id == id_list.to_i

      board.lists.each do |list|
        list.cards.push(new_card) if list.name == list_select
      end
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
