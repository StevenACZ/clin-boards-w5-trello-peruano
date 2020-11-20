module OptionsBoard
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
      option_list, id_list, extra = gets.chomp.split(" ")
      show_options(option_list, id_list, id_board, extra)
      break if option_list == "back"
    end
  end
end
