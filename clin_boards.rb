require_relative "formatter"
require_relative "requester"
require_relative "options_board"
require_relative "options_card"
require_relative "options_list"
require_relative "list"
require_relative "card"
require_relative "checklist"
require_relative "board"
require "terminal-table"
require "json"

class ClinBoards
  include Formatter
  include Requester
  include OptionsBoard
  include OptionsList
  include OptionsCard

  def initialize(filename = "store.json")
    @filename = filename
    @store = parse_json
  end

  def start
    option_board = ""
    greeting
    until option_board == "exit"
      welcome(@store)
      option_board, id_board = gets.chomp.split(" ")
      case option_board
      when "create" then create
      when "update" then update(id_board)
      when "delete" then delete(id_board)
      when "show" then show(id_board)
      else puts "Your option is invalid, try again!"
      end
    end
    finish
  end
  
  def show_checklist(id_board, id_list)
    loop do
      show_card_checklist(id_board, id_list)
      puts "-------------------------------------"
      puts "Checklist options: add | toggle INDEX | delete INDEX"
      option_list, id_list, extra = gets.chomp.split(" ")
      show_options(option_list, id_list, id_board, extra)
      break if option_list == "back"
    end
  end

  private

  def show_options(option_list, id_list, id_board, extra)
    list_options(option_list, id_list, id_board, extra)
    card_options(option_list, id_list, id_board)
  end

  def list_options(option_list, id_list, id_board, extra)
    case option_list
    when "create-list" then create_list(id_board)
    when "update-list" then update_list(id_board, id_list, extra)
    when "delete-list" then delete_list(id_board, id_list, extra)
    end
  end

  def card_options(option_list, id_list, id_board)
    case option_list
    when "create-card" then create_card(id_board)
    when "update-card" then update_card(id_board, id_list)
    when "delete-card" then delete_card(id_board, id_list)
    when "checklist" then show_checklist(id_board, id_list)
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
