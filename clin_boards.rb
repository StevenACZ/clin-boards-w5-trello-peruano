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
    until welcome
      option = gets.chomp
      case option
      when "create" then create
      when "show" then show(id)
      when "update" then update(id)
      when "delete" then delete(id)
      when "exit"
        exit
        break
      end
    end
  end

  def parse_json
    data = JSON.parse(File.read(@filename))
    data.map! do |board|
      board_to_object(board)
      Board.new(id = board["id"], name = board["name"], description = board["description"], lists = board["lists"])
    end
    data
  end

  def create
  end
  def show(id)
  end
  def update(id)
  end
  def delete(id)
  end
  def exit
    puts "####################################"
    puts "#   Thanks for using CLIn Boards   #"
    puts "####################################"
  end

  private

  def board_to_object(board)
    board["lists"].map! do |list|
      list["cards"].map! do |card|
        card["checklist"].map! { |check| Checklist.new(title = check["title"], completed = check["completed"]) }
        Card.new(id = card["id"], title = card["title"], members = card["members"], labels = card["labels"], due_date = card["due_date"], checklist = card["checklist"])
      end
      List.new(id = list["id"], name = list["name"], cards = list["cards"])
    end
  end

end

app = ClinBoards.new
app.start
