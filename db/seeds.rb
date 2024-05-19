# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create users
# users = [
#   { name: "Dimas", email: "dimas@example.com", password: "password", photo_url: "https://picsum.photos/200" },
#   { name: "Samid", email: "samid@example.com", password: "password", photo_url: "https://picsum.photos/200" },
#   { name: "Mukhlish", email: "mukhlish@example.com", password: "password", photo_url: "https://picsum.photos/200" },
#   { name: "Syarif", email: "syarif@example.com", password: "password", photo_url: "https://picsum.photos/200" },
# ]

# users.each do |user|
#   User.create!(user)
# end

# puts "Seed data for users has been successfully created."

# Create Conversations
dimas = User.find_by(name: "Dimas")
samid = User.find_by(name: "Samid")
mukhlish = User.find_by(name: "Mukhlish")
syarif = User.find_by(name: "Syarif")

# Create conversations & messages
conversations = [
  { user: dimas, with_user: samid },
  { user: samid, with_user: mukhlish },
  { user: syarif, with_user: mukhlish },
  { user: dimas, with_user: syarif },
]

conversations.each do |conversation_params|
  conversation = Conversation.create!(conversation_params)

  5.times do |i|
    sender = i.even? ? conversation_params[:user] : conversation_params[:with_user]
    content = Faker::Lorem.sentence

    ChatMessage.create!(conversation: conversation, sender: sender, content: content, read_at: nil)
  end
end

puts "Seed data for conversations and messages has been successfully created."
