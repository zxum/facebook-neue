class LikesController < ApplicationController
  before_action :find_post
  before_action :find_like, only: [:destroy]

  def create
    if already_liked?
      flash[:notice] = "You've already liked this post."
    else
      @like = @post.likes.build(user_id: current_user.id)
      if @like.save 
        redirect_back(fallback_location: root_path)
        flash[:notice] = 'You liked a post' 
      else 
        render :new
      end
    end
  end

  def destroy
    if !(already_liked?)
      flash[:notice] = "Cannot Unlike"
    else
      @like.destroy
    end 
    flash[:notice] = "You have unliked a post"
    redirect_back(fallback_location: root_path)
  end


  private

  def find_like
    @like = @post.likes.find_by(user_id: current_user.id)
  end

  def find_post
    @post = Post.find(params[:post_id])
  end

  def already_liked?
    Like.where(user_id: current_user.id, post_id: params[:post_id]).exists?
  end
end
