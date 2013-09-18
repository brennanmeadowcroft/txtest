class CoursesController < ApplicationController
  before_filter :signed_in_user
  
  def index
    @courses = current_user.courses.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @course = current_user.courses.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @course = current_user.courses.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @course = current_user.courses.find(params[:id])
  end

  def create
    @course = current_user.courses.new(params[:course])
    if @course.save!
      setting = Settings.new(:course_id => @course.id)
      setting.save!
    end

    respond_to do |format|
      if !@course.nil? and !setting.nil?
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
