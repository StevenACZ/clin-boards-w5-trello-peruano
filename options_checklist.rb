module OptionsCheckList
  def show_checklist(id_board, id_list)
    back_id_list = id_list.nil? ? back_id_list : id_list
    loop do
      show_card_checklist(id_board, back_id_list)
      puts "-------------------------------------"
      puts "Checklist options: add | toggle INDEX | delete INDEX"
      option_list, index, extra = gets.chomp.split(" ")
      show_options_checklist(option_list, id_list, id_board, index, extra)
      break if option_list == "back"
    end
  end

  def toggle_check_item(id_board, id_list, index)
    @store.each do |item|
      next unless item.id == id_board.to_i

      item.lists.each do |list|
        list.cards.each do |card|
          next unless card.id == id_list.to_i

          toggle_check(card, index)
        end
      end
    end
  end

  def toggle_check(card, index)
    title = card.checklist[index.to_i - 1].title
    completed = card.checklist[index.to_i - 1].completed
    toggle(title, completed, card)
  end

  def toggle(title, completed, card)
    new_check = Checklist.new(title: title, completed: !completed)
    card.checklist.reject! { |check| check.title == title }
    card.checklist.push(new_check)
  end
end
