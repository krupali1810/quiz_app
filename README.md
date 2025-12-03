# Quiz Management System

A comprehensive Ruby on Rails application for creating, managing, and taking quizzes with administrative controls and user analytics.

## 🛠 Technology Stack

- **Framework**: Ruby on Rails 8.1
- **Database**: PostgreSQL with custom table naming
- **Authentication**: BCrypt with secure password hashing
- **Frontend**: ERB templates with modern CSS and JavaScript
- **Styling**: Custom CSS with responsive design and dropdown interactions
- **HTTP**: Turbo for modern Rails interactions

## 📋 Prerequisites

- Ruby 3.4.5
- PostgreSQL 12 or higher
- Node.js (for asset compilation)
- Git

## ⚙️ Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/krupali1810/quiz_app.git
   cd quiz_app
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Database setup**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Start the server**
   ```bash
   rails server
   ```

5. **Access the application**
   - Homepage: http://localhost:3000
   - Admin Login: http://localhost:3000/admin/login

## 🗄️ Database Schema

### Core Models
- **User**: Admin users with secure authentication
- **Quiz**: Quiz entities with title, description, and publication status
- **Question**: Questions belonging to quizzes with multiple types support
- **Option**: Answer options for multiple-choice questions with correct/incorrect flags
- **QuizAttempt**: User quiz sessions with participant information and completion tracking
- **Answer**: Individual question responses with correctness validation

### Key Relationships
```
User (1) -----> (*) Quiz
Quiz (1) -----> (*) Question
Question (1) -> (*) Option
Quiz (1) -----> (*) QuizAttempt
QuizAttempt (1) -> (*) Answer
Question (1) -> (*) Answer
Option (1) ---> (*) Answer
```

## 🔧 Configuration

### Admin Setup
Create an admin user via Rails console:
```ruby
User.create!(
  name: "Admin User",
  email: "admin@example.com",
  password: "secure_password",
  password_confirmation: "secure_password"
)
```

## 🎯 Usage

### For Quiz Takers
1. Visit the homepage to see available quizzes
2. Click "Take Quiz" on any published quiz
3. Enter your name and email
4. Answer all questions in the quiz
5. View your results with detailed feedback

### For Administrators
1. Login at `/admin/login`
2. Use the dashboard to manage quizzes and view statistics
3. Create new quizzes with dynamic questions and options
4. Publish/unpublish quizzes to control availability
5. Monitor quiz attempts and participant performance
6. Use bulk operations for efficient data management

## 🔒 Security Features

- **Password Security**: BCrypt hashing with secure defaults
- **Session Management**: Secure session-based authentication
- **CSRF Protection**: Built-in Rails CSRF tokens
- **SQL Injection Prevention**: Parameterized queries and ActiveRecord ORM
- **Admin Authorization**: Controller-level access control
```
