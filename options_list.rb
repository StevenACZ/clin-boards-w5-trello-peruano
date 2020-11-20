module OptionsList
  def create_list(id_board)
    name = only_name
    @store.each do |item|
      next unless item.id == id_board.to_i

      item.lists.push(List.new(id: nil, name: name, cards: []))
    end
  end
end
