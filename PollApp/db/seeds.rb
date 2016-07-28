# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user1 = User.create!(name: "Lily")
user2 = User.create!(name: "Anthony")
user3 = User.create!(name: "Bob")
user4 = User.create!(name: "Cindy")
user5 = User.create!(name: "Emily")

poll1 = Poll.create!(title: "food", author_id: user1.id)
poll2 = Poll.create!(title: "movie", author_id: user2.id)
poll3 = Poll.create!(title: "color", author_id: user2.id)

question1 = Question.create!(text: "do you like bagels", poll_id: poll1.id)
question2 = Question.create!(text: "do you eat pasta", poll_id: poll1.id)
question3 = Question.create!(text: "did you watch finding dory", poll_id: poll2.id)
question4 = Question.create!(text: "blue or red", poll_id: poll3.id)

answer1_1 = AnswerChoice.create!(question_id: question1.id, text: "yes!!")
answer1_2 = AnswerChoice.create!(question_id: question1.id, text: "no!!")
answer2_1 = AnswerChoice.create!(question_id: question2.id, text: "i don't like pasta")
answer2_2 = AnswerChoice.create!(question_id: question2.id, text: "i love pasta")
answer3_1 = AnswerChoice.create!(question_id: question3.id, text: "no, but i watched finding nemo")
answer3_2 = AnswerChoice.create!(question_id: question3.id, text: "it was good")
answer4_1 = AnswerChoice.create!(question_id: question4.id, text: "red")
answer4_2 = AnswerChoice.create!(question_id: question4.id, text: "blue")
answer4_3 = AnswerChoice.create!(question_id: question4.id, text: "green")

# emily, yes!!
response1_1 = Response.create!(answer_id: answer1_1.id, user_id: user5.id)
# anthony, no
response1_2 = Response.create!(answer_id: answer1_2.id, user_id: user2.id)
# lily, finding nemo
response3_1 = Response.create!(answer_id: answer3_1.id, user_id: user1.id)
# emily, finding nemo
response3_2 = Response.create!(answer_id: answer3_1.id, user_id: user5.id)
# cindy, finding nemo
response3_3 = Response.create!(answer_id: answer3_1.id, user_id: user4.id)
# bob, blue
response4_1 = Response.create!(answer_id: answer4_2.id, user_id: user3.id)
# cindy, green
response4_2 = Response.create!(answer_id: answer4_3.id, user_id: user4.id)
