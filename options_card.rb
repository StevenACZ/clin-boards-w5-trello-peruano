module OptionsCard
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

  def card_created_send(id_list, list_select, new_card)
    @store.each do |board|
      next unless board.id == id_list.to_i

      board.lists.each do |list|
        list.cards.push(new_card) if list.name == list_select
      end
    end
  end
end
