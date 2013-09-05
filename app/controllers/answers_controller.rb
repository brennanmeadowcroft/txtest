class AnswersController < ApplicationController
  def index
    @answers = Answer.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @answer = Answer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @answer = Answer.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @answer = Answer.find(params[:id])
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
    @answer = Answer.find(params[:id])

    respond_to do |format|
      if @answer.update_attributes(params[:answer])
        format.html { redirect_to @answer, notice: 'Answer was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy

    respond_to do |format|
      format.html { redirect_to answers_url }
    end
  end
end
