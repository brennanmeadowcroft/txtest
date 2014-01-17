class ExamsController < ApplicationController
  before_filter :signed_in_user

  def index
    @exams = Exam.all

    respond_to do |format|
      format.html
    end
  end

  def show
    @exam = Exam.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def new
    @exam = Exam.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @exam = Exam.find(params[:id])
  end

  def take
    # Display the page to actually take the test
    @exam = Exam.find(params[:id])
    @questions = @exam.answers

    respond_to do |format|
      format.html
    end
  end

  def create
    @exam = Exam.new(params[:exam])

    respond_to do |format|
      if @exam.save
        flash[:success] = "Exam created successfully"
        format.html { redirect_to @exam }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @exam = Exam.find(params[:id])

    respond_to do |format|
      if @exam.update_attributes(params[:exam])
        flash[:success] = "Exam updated successfully"
        format.html { redirect_to @exam }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def submit_exam
    @exam = Exam.find(params[:id])

    respond_to do |format|
      if @exam.submit_results(params[:exam])
        flash[:success] = "Your exam has been submitted and graded"
        format.html { redirect_to @exam }
      else
        flash[:fail] = "We were unable to submit your exam for grading"
        format.html { redirect_to @exam }
      end
    end
  end

  def destroy
    @exam = Exam.find(params[:id])
    @exam.destroy

    respond_to do |format|
      flash[:success] = "Exam successfully deleted"
      format.html { redirect_to exams_url }
    end
  end
end
