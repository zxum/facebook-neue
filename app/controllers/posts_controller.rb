class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /posts
  # GET /posts.json
  def index
      @posts = Post.where(author_id: current_user.friends).or(Post.where(author_id: current_user)).order(created_at: :desc)
    end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    @user = @post.author
    
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
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = current_user.authored_posts.build(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.permit(:content, :picture)
    end
end
