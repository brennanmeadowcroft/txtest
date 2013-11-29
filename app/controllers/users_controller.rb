class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user, only: [:edit, :update, :show, :edit_account, :account]
  before_filter :admin_user, only: [:index, :destroy, :toggle_admin]

  def index
    @users = User.all

    respond_to do |format|
      format.html { render layout: 'admin' }
    end
  end

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def account
    @user = User.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @user = User.new
    @plans = Plan.public_plans

    respond_to do |format|
      format.html { render layout: 'public' }
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def edit_account
    @user = User.find(params[:id])
    @plans = Plan.public_plans
  end

  def verify_phone
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        if @user.create_settings
          sign_in @user
          flash[:success] = "Welcome to TxTest.com!"
          format.html { redirect_to @user }
        else
          flash[:fail] = "We were unable to create the settings for your user"
          @user.destroy
          format.html { render action: "new" }
        end
      else
        flash[:fail] = "There was a problem creating your account"
        format.html { render action: "new" }
      end
    end
  rescue Stripe::CardError => e
    flash[:fail] = "There was a problem with your credit card: #{ e.message }"
    @user.errors.add :base, e.message
    @user.stripe_token = nil
    render :action => :new
  rescue Stripe::CardError => e
    flash[:fail] = "There was a problem with your credit card: #{ e.message }"
    logger.error e.message
    @user.errors.add :base, "There was a problem with your credit card"
    @user.stripe_token = nil
    render :action => :new
  end

  def update
    @user = User.find(params[:id])
    params[:user][:active] ||= 0

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:success] = "Your profile was successfully updated"
        format.html { redirect_to @user }
        format.json { head :no_content }
      else
        flash[:error] = "There was a problem updating your account"
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  rescue Stripe::StripeError => e
    logger.error e.message
    @user.errors.add :base, "There was a problem with your credit card"
    @user.stripe_token = nil
    render :action => :edit
  end

  def toggle_admin
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.toggle_admin
        flash[:success] = "Admin toggled successfully"
        format.html { redirect_to users_path }
      else
        flash[:error] = "There was a problem toggling the admin"
        format.html { redirect_to users_path }
      end
    end
  end

  def update_phone_verification
    @user = User.find(params[:id])

    phone_code = params[:user][:phone_verification_code]

    if phone_code == @user.phone_verification_code
      @user.phone_verified = 1
    end

    respond_to do |format|
      if @user.save!
        flash[:success] = "Your phone has been verified"
        format.html { redirect_to @user }
      else
        flash[:error] = "There was a problem verifying your phone"
        format.html { redirect_to verify_phone_path }
      end
    end
  end

  def verify_email
    @user = User.find(params[:id])

    email_code = params[:code]

    if email_code == @user.email_validation_code
      @user.email_verified = 1
    end

    respond_to do |format|
      if @user.save!
        flash[:success] = "Your email has been verified"
        format.html { redirect_to @user }
      else 
        flash[:success] = "There was a problem validating your email"
        format.html { redirect_to @user }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      flash[:success] = "The user has been successfully deleted"
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(app_root_path) unless current_user.admin?
    end
end
