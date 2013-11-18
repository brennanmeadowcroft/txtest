# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131118144551) do

  create_table "answers", :force => true do |t|
    t.text     "submitted_answer"
    t.datetime "time_answered"
    t.integer  "question_id"
    t.integer  "correct"
    t.integer  "in_time"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.datetime "time_sent"
    t.integer  "text_receipt"
    t.datetime "receipt_date"
  end

  create_table "courses", :force => true do |t|
    t.string   "description"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "paused_flag"
  end

  create_table "events", :force => true do |t|
    t.integer  "user_id"
    t.string   "stripe_event_id"
    t.string   "stripe_customer_id"
    t.string   "type"
    t.string   "sub_type"
    t.string   "action"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.date     "stripe_time"
  end

  create_table "plans", :force => true do |t|
    t.string   "name"
    t.integer  "fee"
    t.string   "interval"
    t.integer  "trial_period_days"
    t.integer  "max_texts"
    t.integer  "max_courses"
    t.integer  "max_questions"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "annual_plan"
    t.integer  "private_plan"
  end

  create_table "questions", :force => true do |t|
    t.integer  "course_id"
    t.text     "question"
    t.text     "correct_answer"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "paused_flag"
  end

  create_table "settings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "texts_per_day"
    t.integer  "start_time"
    t.integer  "end_time"
    t.integer  "response_time"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone_number"
    t.string   "password_digest"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "remember_token"
    t.string   "text_code"
    t.integer  "admin"
    t.string   "stripe_token"
    t.string   "last_4_digits"
    t.string   "expiration_date"
    t.integer  "plan_id"
    t.string   "stripe_id"
    t.integer  "active"
    t.integer  "card_problem_flag"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["phone_number"], :name => "index_users_on_phone_number", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
