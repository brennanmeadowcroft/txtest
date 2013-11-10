class PlansController < ApplicationController
  layout "admin"
  
  def index
    @plans = Plan.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @plan = Plan.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @plan = Plan.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @plan = Plan.find(params[:id])
  end

  def create
    params[:plan]['make_annual'] ||= 0
    @plan = Plan.new(params[:plan])

    respond_to do |format|
      if @plan.save
        if params[:plan]['make_annual'] == 1
          Plan.create_annual_plan(@plan)
        end
        format.html { redirect_to @plan, notice: 'Account type was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @plan = Plan.find(params[:id])

    respond_to do |format|
      if @plan.update_attributes(params[:plan])
        format.html { redirect_to @plan, notice: 'Account type was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @plan = Plan.find(params[:id])
    @plan.destroy

    respond_to do |format|
      format.html { redirect_to plans_url }
    end
  end
end
