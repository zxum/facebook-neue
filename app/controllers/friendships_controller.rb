class FriendshipsController < ApplicationController

  def create
    @friendship = current_user.friendships.build(friend_id: params[:friend_id], confirmed: false)
    @friendship.save
    redirect_to users_path, notice: "Friend Request sent."
  end 

  def index 
    @friend_requests = current_user.friend_requests
    @friends = current_user.friends
  end

  def destroy 
    @friend = User.find(params[:id])
    @friend_request = current_user.friendships.find_by_friend_id(params[:id]) || current_user.inverse_friendships.find_by_user_id(params[:id])
    if params[:id].to_i == @friend_request.friend_id
      @friendship = current_user.friendships.find_by_friend_id(params[:id])
      @friendship.destroy
      redirect_to users_path, notice: "Friend request canceled."
    elsif params[:id].to_i -- @friend_request.user_id 
      @friendship = current_user.inverse_friendships.find_by_user_id(params[:id])
      @friendship.destroy 
      redirect_to users_path, notice: "Unfriended"
    else 
      raise
      redirect_to users_path, notice: "Something went wrong."
    end 
  end

  def update
    @friendship= Friendship.find(params[:id])
    @user = @friendship.user 
    current_user.confirm_friend(@user)
    redirect_to friendships_path, notice: "Friend request accepted."
  end

end