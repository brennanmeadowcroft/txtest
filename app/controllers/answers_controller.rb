class AnswersController < ApplicationController
  before_filter :signed_in_user
  
  def show
    @answer = current_user.answers.find(params[:id])

    respond_to do |format|
      if @answer.question.user == current_user
        format.html # show.html.erb
      else
        format.html { redirect_to courses_path }
      end
    end
  end

  def new
    @answer = Answer.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def answer_question
    @answer = current_user.answers.find(params[:id])

    @answer.answer_question(params[:answer])

    respond_to do |format|
      if @answer.save
        format.html { redirect_to @answer }
      else
        format.html { redirect_to @answer }
      end
    end
  end

  def edit
    @answer = current_user.answers.find(params[:id])
  end

  def create
    @answer = Answer.new(params[:answer])

    respond_to do |format|
      if @answer.save
        format.html { redirect_to @answer, notice: 'Answer was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @answer = current_user.answers.find(params[:id])

    respond_to do |format|
      if @answer.update_attributes(params[:answer])
        format.html { redirect_to @answer, notice: 'Answer was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @answer = current_user.answers.find(params[:id])
    @answer.destroy

    respond_to do |format|
      format.html { redirect_to answers_url }
    end
  end
end
