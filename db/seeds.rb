# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create sample users
admin_user = User.find_or_create_by!(email: "admin@quizapp.com") do |user|
  user.name = "Admin User"
  user.password = "admin123" # This will be automatically hashed by has_secure_password
end

teacher1 = User.find_or_create_by!(email: "john.doe@example.com") do |user|
  user.name = "John Doe"
  user.password = "password123"
end

teacher2 = User.find_or_create_by!(email: "jane.smith@example.com") do |user|
  user.name = "Jane Smith"
  user.password = "password123"
end

puts "Created users: #{User.count}"

# Create sample quizzes
quiz1 = Quiz.find_or_create_by!(title: "General Knowledge Quiz") do |quiz|
  quiz.description = "Test your general knowledge with this comprehensive quiz covering various topics including history, science, and current events."
  quiz.created_by_id = teacher1.id
  quiz.published = true
end

quiz2 = Quiz.find_or_create_by!(title: "Science Basics") do |quiz|
  quiz.description = "A beginner-friendly science quiz covering basic concepts in physics, chemistry, and biology."
  quiz.created_by_id = teacher2.id
  quiz.published = true
end

quiz3 = Quiz.find_or_create_by!(title: "World History") do |quiz|
  quiz.description = "Journey through major historical events and civilizations that shaped our world."
  quiz.created_by_id = teacher1.id
  quiz.published = true
end

quiz4 = Quiz.find_or_create_by!(title: "Mathematics Challenge") do |quiz|
  quiz.description = "Put your mathematical skills to the test with these challenging problems and equations."
  quiz.created_by_id = teacher2.id
  quiz.published = false # Draft quiz
end

puts "Created quizzes: #{Quiz.count}"

# Create sample questions for Quiz 1 (General Knowledge)
unless quiz1.questions.exists?
  q1 = quiz1.questions.create!(
    question_text: "What is the capital of France?",
    question_type: "multiple_choice"
  )
  
  q1.options.create!([
    { option_text: "Paris", is_correct: true },
    { option_text: "London", is_correct: false },
    { option_text: "Berlin", is_correct: false },
    { option_text: "Madrid", is_correct: false }
  ])
  
  q2 = quiz1.questions.create!(
    question_text: "Which planet is known as the Red Planet?",
    question_type: "multiple_choice"
  )
  
  q2.options.create!([
    { option_text: "Venus", is_correct: false },
    { option_text: "Mars", is_correct: true },
    { option_text: "Jupiter", is_correct: false },
    { option_text: "Saturn", is_correct: false }
  ])
  
  q3 = quiz1.questions.create!(
    question_text: "What is the largest ocean on Earth?",
    question_type: "multiple_choice"
  )
  
  q3.options.create!([
    { option_text: "Atlantic Ocean", is_correct: false },
    { option_text: "Indian Ocean", is_correct: false },
    { option_text: "Pacific Ocean", is_correct: true },
    { option_text: "Arctic Ocean", is_correct: false }
  ])
end

# Create sample questions for Quiz 2 (Science Basics)
unless quiz2.questions.exists?
  q1 = quiz2.questions.create!(
    question_text: "What is the chemical symbol for water?",
    question_type: "multiple_choice"
  )
  
  q1.options.create!([
    { option_text: "H2O", is_correct: true },
    { option_text: "CO2", is_correct: false },
    { option_text: "O2", is_correct: false },
    { option_text: "H2", is_correct: false }
  ])
  
  q2 = quiz2.questions.create!(
    question_text: "How many bones are there in an adult human body?",
    question_type: "multiple_choice"
  )
  
  q2.options.create!([
    { option_text: "186", is_correct: false },
    { option_text: "206", is_correct: true },
    { option_text: "226", is_correct: false },
    { option_text: "246", is_correct: false }
  ])
end

# Create sample questions for Quiz 3 (World History)
unless quiz3.questions.exists?
  q1 = quiz3.questions.create!(
    question_text: "In which year did World War II end?",
    question_type: "multiple_choice"
  )
  
  q1.options.create!([
    { option_text: "1944", is_correct: false },
    { option_text: "1945", is_correct: true },
    { option_text: "1946", is_correct: false },
    { option_text: "1947", is_correct: false }
  ])
  
  q2 = quiz3.questions.create!(
    question_text: "Who was the first person to walk on the moon?",
    question_type: "multiple_choice"
  )
  
  q2.options.create!([
    { option_text: "Buzz Aldrin", is_correct: false },
    { option_text: "Neil Armstrong", is_correct: true },
    { option_text: "John Glenn", is_correct: false },
    { option_text: "Alan Shepard", is_correct: false }
  ])
end

puts "Created questions and options for quizzes"
puts "Seed data creation complete!"
puts "Published quizzes: #{Quiz.published.count}"
puts "Draft quizzes: #{Quiz.draft.count}"
