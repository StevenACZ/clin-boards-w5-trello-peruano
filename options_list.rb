module OptionsList
  def create_list(id_board)
    name = only_name
    @store.each do |item|
      next unless item.id == id_board.to_i

      item.lists.push(List.new(id: nil, name: name, cards: []))
    end
  end

  def delete_list(id_board, id_list, extra)
    list_name = extra.nil? ? id_list.chomp : [id_list, extra].join(" ")
    @store.each do |item|
      next unless item.id == id_board.to_i

      item.lists.reject! { |list| list.name == list_name }
    end
  end
end
