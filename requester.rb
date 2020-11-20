module Requester
  def option_table; end

  def requester_create_card_option(id_list)
    puts "Select a list:"
    board = (@store.select { |item| item.id == id_list.to_i })[0]
    lists_names = board.lists.map(&:name)
    puts lists_names.join(" | ")
    gets.chomp
  end

  def requester_create_card
    print "Title: "
    title = gets.chomp
    print "Members: "
    members = gets.chomp
    print "Labels: "
    labels = gets.chomp
    print "Due Date: "
    due_date = gets.chomp
    [title, members, labels, due_date]
  end
end
