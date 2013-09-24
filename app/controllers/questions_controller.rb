class QuestionsController < ApplicationController
  before_filter :signed_in_user

  def show
    @question = current_user.questions.find(params[:id])
    @courses = current_user.courses.all
    @course = @question.course

    respond_to do |format|
      format.html
    end
  end

  def new
    @question = Question.new
    @courses = current_user.courses.all
    @course = current_user.courses.find(params[:course_id])

    respond_to do |format|
      format.html
    end
  end

  def edit
    @question = current_user.questions.find(params[:id])
    @course = @question.course
    @courses = current_user.courses.all
  end

  def create
    @question = Question.new(params[:question])

    respond_to do |format|
      if @question.save
        flash[:success] = "Question was successfully added"
        format.html { redirect_to @question.course }
      else
        flash[:fail] = "There was a problem creating the question"
        format.html { render action: "new" }
      end
    end
  end

  def update
    @question = current_user.questions.find(params[:id])

    respond_to do |format|
      if @question.update_attributes(params[:question])
        flash[:success] = "Question was successfully updated"
        format.html { redirect_to @question }
      else
        flash[:fail] = "There was a problem updating the question"
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @question = current_user.questions.find(params[:id])
    @question.destroy

    respond_to do |format|
      flash[:success] = "Question was successfully deleted"
      format.html { redirect_to questions_url }
      format.json { head :no_content }
    end
  end
end
