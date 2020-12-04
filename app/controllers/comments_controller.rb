class CommentsController < ApplicationController
  def new 
    @comment = Comment.new
  end 

  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.comments.build(content: params[:comment][:content], post: @post)

    if @comment.save
      redirect_to post_path(@post)
    else
      flash[:alert] = "Something went wrong"
      redirect_to post_path(@post)
    end
  end

  # DELETE /comments/1
  def destroy
    @comment = Comment.find(params[:id])
    @post = @comment.post
    @comment.destroy 
    if @comment.destroy
      flash[:notice] = 'Comment successfully destroyed'
      redirect_to post_path(@post)
    end
  end

end
