class LikesController < ApplicationController
  before_action :find_post
  before_action :find_like, only: [:destroy]

  def create
    if already_liked?
      flash[:notice] = "You've already liked this post."
    else
      @like = @post.likes.build(user_id: current_user.id)
      respond_to do |format|
        if @like.save 
          format.html { redirect_back(fallback_location: root_path), notice: 'You liked a post' }
          format.json { render :show, status: :created, location: @like }
        else 
          format.html { render :new }
          format.json { render json: @like.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def destroy
    if !(already_liked?)
      flash[:notice] = "Cannot Unlike"
    else
      @like.destroy
    end 
    redirect_to post_path(@post)
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
