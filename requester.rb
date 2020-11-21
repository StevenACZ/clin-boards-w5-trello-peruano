module Requester
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

  def name_and_description
    print "Name: "
    name = gets.chomp
    print "Description: "
    description = gets.chomp
    [name, description]
  end

  def only_name
    print "Name: "
    gets.chomp
  end

  def only_title
    print "Title: "
    gets.chomp
  end
end
