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
  # rubocop:disable Metrics/AbcSize

  def update_card(id_board, id_list)
    update_card_selecter(id_list)
    update_card_requester
    card_updated = Card.new(id: id_list.to_i, title: @info[0], members: @info[1], labels: @info[2], due_date: @info[3])

    @store.each do |board|
      next unless board.id == id_board.to_i

      board.lists.each do |list|
        next unless list.name == @list_select

        list.cards.reject! { |card| card.id == id_list.to_i }
        list.cards.push(card_updated)
      end
    end
    p @card_updated
  end
  # rubocop:enable Metrics/AbcSize
end
