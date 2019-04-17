# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Clear all tables
[User, Poll, Question, AnswerChoice, Response].each do |c|
  ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{c.table_name} RESTART IDENTITY;")
end

# Create users
%w[Arlene Batsmaru Catnap Darth Engelbert].each do |name|
  User.create(username: name)
end

# Create polls
%w[Darth Catnap].each do |name|
  Poll.create(author_id: User.find_by_username(name).id, title: "Poll by #{name}")
end

# Create questions
2.times do |num|
  Question.create(poll_id: 1, body: "Poll 1 Question #{num + 1}?")
  Question.create(poll_id: 2, body: "Poll 2 Question #{num + 1}?")
end

# Create answer choices
4.times do |num|
  AnswerChoice.create(question_id: num + 1, choice: "Question #{num + 1} Choice 1")
  AnswerChoice.create(question_id: num + 1, choice: "Question #{num + 1} Choice 2")
end

# Create responses
Question.all.each_with_index do |_q, idx|
  Response.create(user_id: 1, answer_id: idx * 2 + 1)
  Response.create(user_id: 2, answer_id: idx * 2 + 2)
end