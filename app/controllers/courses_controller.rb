class CoursesController < ApplicationController
  before_filter :signed_in_user
  
  def index
    @courses = current_user.courses.all
    @course = @courses.first

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @courses = current_user.courses.all
    @course = current_user.courses.find(params[:id])

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
        flash[:error] = "There was a problem #{ status } the course!"
      end
      format.html { redirect_to @course }
    end
  end

  def create
    @course = current_user.courses.new(params[:course])

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @course = current_user.courses.find(params[:id])

    respond_to do |format|
      if @course.update_attributes(params[:course])
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @course = current_user.courses.find(params[:id])
    @course.destroy

    respond_to do |format|
      format.html { redirect_to courses_url }
    end
  end
end
