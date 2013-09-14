class QuestionsController < ApplicationController
  before_filter :signed_in_user
  
  def index
    @questions = current_user.questions.all

    respond_to do |format|
      format.html
    end
  end

  def show
    @question = current_user.questions.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def new
    @question = Question.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @question = current_user.questions.find(params[:id])
  end

  def create
    @question = Question.new(params[:question])

    respond_to do |format|
      if @question.save
        format.html { redirect_to @question, notice: 'Question was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @question = current_user.questions.find(params[:id])

    respond_to do |format|
      if @question.update_attributes(params[:question])
        format.html { redirect_to @question, notice: 'Question was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @question = current_user.questions.find(params[:id])
    @question.destroy

    respond_to do |format|
      format.html { redirect_to questions_url }
      format.json { head :no_content }
    end
  end
end
