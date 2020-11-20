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
    until welcome(boards)
      option, id = gets.chomp.split(" ")
      case option
      when "create" then create
      when "show" then show(id)
      when "update" then update(id)
      when "delete" then delete(id)
      when "exit"
        exit
        # break
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

  def create
    print "Name: "
    name = gets.chomp
    print "Description: "
    description = gets.chomp
    new_one = Board.new(name: name, description: description)
    @store.push(new_one)
  end

  def show(_id)
    p @store
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

  def exit
    puts "####################################"
    puts "#   Thanks for using CLIn Boards   #"
    puts "####################################"
  end

  private

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