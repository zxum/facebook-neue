class UsersController < ApplicationController
  before_action :authenticate_user!

  def show 
    months = {
      1=> 'January',
      2=> 'Feburary',
      3=> 'March',
      4=> 'April',
      5=> 'May',
      6=> 'June',
      7=> 'July',
      8=> 'August',
      9=> 'September',
      10=> 'October',
      11=> 'November',
      12=> 'December'
    }
    @user = User.find(params[:id])
    @profile = @user.profile
    birthday = @profile.birthdate.split('-').map(&:to_i)
    year = birthday[0].to_s
    month = months[birthday[1]]
    day = birthday[2].to_s

    if @profile.birthdate != ''
      @birthdate = "#{month} #{day}, #{year}"
    else 
      @birthdate = ""
    end


    @posts = @user.authored_posts.order(created_at: :desc)
  end

  def index
    @users = User.where.not(id: current_user.id)
  end

end