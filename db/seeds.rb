require 'faker'

topics = []
15.times do
  topics << Topic.create(
    name: Faker::Lorem.words(rand(3..7)).join(" "),
    description: Faker::Lorem.paragraphs(rand(1..4)).join("\n"))
end

rand(4..10).times do
  password = Faker::Lorem.characters(10)
  u = User.new(
    name: Faker::Name.name, 
    email: Faker::Internet.email, 
    password: password, 
    password_confirmation: password)
  u.skip_confirmation!
  u.save

  rand(10..30).times do
    topic = topics.first
    p = u.posts.create(
      topic: topic,
      title: Faker::Lorem.words(rand(4..10)).join(" "), 
      body: Faker::Lorem.paragraphs(rand(1..4)).join("\n"))
    p.update_attribute(:created_at, Time.now - rand(600..31536000))
    p.update_rank
    p.save

    topics.rotate!

  end
end

post_count = Post.count
User.all.each do |user|
  rand(30..50).times do
    p = Post.find(rand(1..post_count))
    c = user.comments.create(
      body: Faker::Lorem.paragraphs(rand(1..2)).join("\n"),
      post: p)
    c.update_attribute(:created_at, Time.now - rand(600..31536000))
  end
end 

# u = User.first
# u.skip_reconfirmation!
# u.update_attributes(email: 'akanpurwala@gmail.com', password: 'helloworld', password_confirmation: 'helloworld')

u = User.new(
  name: 'Admin User',
  email: 'admin@example.com', 
  password: 'helloworld', 
  password_confirmation: 'helloworld')
u.skip_confirmation!
u.save
u.update_attribute(:role, 'admin')

u = User.new(
  name: 'Moderator User',
  email: 'moderator@example.com',
  password: 'helloworld',
  password_confirmation: 'helloworld')
u.skip_confirmation!
u.save
u.update_attribute(:role, 'moderator')

u = User.new(
  name: 'Member User',
  email: 'member@example.com',
  password: 'helloworld',
  password_confirmation: 'helloworld')
u.skip_confirmation!
u.save

puts "Seed finished"
puts "#{User.count} users created"
puts "#{Post.count} posts created"
puts "#{Comment.count} comments created"

