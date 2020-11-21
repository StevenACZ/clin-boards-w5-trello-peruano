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

  def update_list(id_board, id_list, extra)
    list_name = extra.nil? ? id_list.chomp : [id_list, extra].join(" ")
    name = only_name
    update(id_board, id_list, list_name, name)
  end

  # rubocop:disable Metrics/AbcSize
  def update(id_board, id_list, list_name, name)
    @store.each do |item|
      next unless item.id == id_board.to_i

      new_list = nil
      item.lists.each do |list|
        next unless list.name == list_name

        list_cards = list.cards
        id_save = list.id
        new_list = List.new(id: id_save, name: name, cards: list_cards)
      end
      item.lists.push(new_list)
      item.lists.reject! { |list| list.name == id_list }
    end
  end
  # rubocop:enable Metrics/AbcSize
end
