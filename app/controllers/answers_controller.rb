class AnswersController < ApplicationController
  before_filter :signed_in_user, only: [:new, :answer_question, :edit, :create, :update, :destroy]

  def new
    @answer = Answer.new

    respond_to do |format|
      format.html # new.html.erb
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

  def mark_correct
    answer = current_user.answers.find(params[:id])

    answer.correct = 1
    respond_to do |format|
      if answer.save
        flash[:success] = "The status of the answer has been marked as correct"
        format.html { redirect_to question_path(answer.question) }
      else
        flash[:error] = "There was a problem updating the status of the answer"
        format.html { redirect_to question_path(answer.question) }
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

  def text_receipt
    answer = Answer.find(params[:id])

    if answer.update_text_receipt
      render nothing: true, status: :ok
    else 
      render nothing: true, status: :internal_server_error
    end
  end
end
