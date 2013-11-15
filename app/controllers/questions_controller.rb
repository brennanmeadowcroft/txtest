class QuestionsController < ApplicationController
  before_filter :signed_in_user

  def show
    @question = current_user.questions.find(params[:id])
    @courses = current_user.courses.all
    @course = @question.course
    question_dashboard(@question)

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
    @course = @question.course

    respond_to do |format|
      if @course.questions.count >= current_user.plan.max_questions
        flash[:fail] = "You are limited to #{ current_user.plan.max_questions } questions per course. Creating this question would exceed your limit."
        format.html { redirect_to @course }
      elsif @question.save
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

  private
    def question_dashboard(question)
      response_time = question.average_response_time
      response_time_data = GoogleVisualr::DataTable.new   
      response_time_data.new_column('string', 'Date (mm-dd)' ) 
      response_time_data.new_column('number', 'Correct Percentage') 
      response_time_data.add_rows(response_time)
      response_time_options = { title: 'Correct Over Time',
            vAxis: {title: 'Tag',  titleTextStyle: {color: 'red'}},
            hAxis: {showTextEvery: 1},
            backgroundColor: '#ECF0F1',
            legend: {position: 'none'},
            height: 300 }
      @response_time_chart = GoogleVisualr::Interactive::ColumnChart.new(response_time_data, response_time_options)

      total_correct = question.answers_on_time
      total_correct_data = GoogleVisualr::DataTable.new   
      total_correct_data.new_column('number', 'Correct & In Time' ) 
      total_correct_data.new_column('number', 'Correct & Out of Time') 
      total_correct_data.new_column('number', 'Incorrect & In Time') 
      total_correct_data.new_column('number', 'Incorrect & Out of Time') 
      total_correct_data.add_rows(total_correct)
      total_correct_option = { title: 'Answers Correct Metrics',
            vAxis: {title: 'Tag',  titleTextStyle: {color: 'red'}},
            backgroundColor: '#ECF0F1',
            legend: {position: 'none'},
            height: 300 }
      @total_correct_chart = GoogleVisualr::Interactive::ColumnChart.new(total_correct_data, total_correct_option)
    end

end
