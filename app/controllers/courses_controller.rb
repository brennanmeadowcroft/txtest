class CoursesController < ApplicationController
  before_filter :signed_in_user
  
  def index
    @courses = current_user.courses.all
    @course = @courses.first
    if @courses.count > 0 
      course_dashboard(@course)
    end

    respond_to do |format|
      format.html { render action: "show" }
    end
  end

  def show
    @courses = current_user.courses.all
    @course = current_user.courses.find(params[:id])
    course_dashboard(@course)

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @course = current_user.courses.new
    @courses = current_user.courses.all

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @courses = current_user.courses.all
    @course = current_user.courses.find(params[:id])
  end

  def pause
    @course = current_user.courses.find(params[:id])

    @course.paused_flag == 1 ? new_status = 0 : new_status = 1
    @course.paused_flag = new_status

    respond_to do |format|
      if @course.save
        new_status == 1 ? status = 'Paused' : status = 'Unpaused'
        flash[:success] = "#{ @course.description } has been #{ status }"
      else
        new_status == 1 ? status = 'Pausing' : status = 'Unpausing'
        flash[:fail] = "There was a problem #{ status } the course!"
      end
      format.html { redirect_to @course }
    end
  end

  def create
    @course = current_user.courses.new(params[:course])

    respond_to do |format|
      if @course.save
        flash[:success] = "#{@course.description} was successfully created"
        format.html { redirect_to @course }
      else
        flash[:fail] = "There was a problem creating the course"
        format.html { render action: "new" }
      end
    end
  end

  def update
    @course = current_user.courses.find(params[:id])

    respond_to do |format|
      if @course.update_attributes(params[:course])
        flash[:success] = "#{@course.description} was successfully updated"
        format.html { redirect_to @course }
      else
        flash[:fail] = "There was a problem updating #{@course.description}"
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @course = current_user.courses.find(params[:id])
    @course.destroy

    respond_to do |format|
      flash[:fail] = "Your course was successfully deleted"
      format.html { redirect_to courses_url }
    end
  end

  private
    def course_dashboard(course)
      correct_time = Course.correct_over_time(current_user, course.id)
      correct_time_data = GoogleVisualr::DataTable.new   
      correct_time_data.new_column('string', 'Date (mm-dd)' ) 
      correct_time_data.new_column('number', 'Correct Percentage') 
      # correct_time_data.new_column('number', 'Questions Asked')
      correct_time_data.add_rows(correct_time)
      correct_time_options = { title: 'Correct Over Time',
            vAxis: {title: 'Tag',  titleTextStyle: {color: 'red'}},
            hAxis: {showTextEvery: 1},
            backgroundColor: '#ECF0F1',
            legend: {position: 'none'},
            height: 300 }
      @correct_time_chart = GoogleVisualr::Interactive::ColumnChart.new(correct_time_data, correct_time_options)

      total_correct = Course.answers_on_time(current_user, course.id)
      total_correct_data = GoogleVisualr::DataTable.new   
      total_correct_data.new_column('number', 'Correct & In Time' ) 
      total_correct_data.new_column('number', 'Correct & Out of Time') 
      total_correct_data.new_column('number', 'Incorrect & In Time') 
      total_correct_data.new_column('number', 'Incorrect & Out of Time') 
      total_correct_data.add_rows(total_correct)
      total_correct_option = { title: 'Questions Correct Metrics',
            vAxis: {title: 'Tag',  titleTextStyle: {color: 'red'}},
            backgroundColor: '#ECF0F1',
            legend: {position: 'none'},
            height: 300 }
      @total_correct_chart = GoogleVisualr::Interactive::ColumnChart.new(total_correct_data, total_correct_option)
    end
end
