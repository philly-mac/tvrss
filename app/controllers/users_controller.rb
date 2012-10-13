class UsersController < ApplicationController

  before_filter :authenticate_user!

  def edit
    @user = current_user
    render 'edit'
  end

  def show
    @user = current_user
  end

  def update
    @user = current_user
    @user.update(permitted_attributes)

    if @user.valid?
      redirect_to root_path, :notice => "Success"
    else
      flash.now[:alert] = "Unsuccessful"
      render 'new'
    end
  end

end

