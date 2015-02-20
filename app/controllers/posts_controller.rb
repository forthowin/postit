class PostsController < ApplicationController
  before_action :set_post, only: [:edit, :update, :show, :vote]
  before_action :require_user, except: [:index, :show]

  def index
    @posts = Post.all
  end

  def show
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.creator = current_user
    if @post.save
      flash[:notice] = "Your post has been created"
      redirect_to posts_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      flash[:notice] = "Your post has been updated"
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def vote
    @vote = Vote.where("user_id = ? AND voteable_type = ? AND voteable_id = ?", current_user.id, @post.class.name, @post.id).first
    if @vote.nil? #check to see if a vote exists
      @vote = Vote.create(creator: current_user, vote: params[:vote], voteable: @post) #create if vote does not exists
    else #update vote if it exists
      if @vote.vote.to_s == params[:vote]
        Vote.destroy(@vote)
      else
        @vote.update(vote: params[:vote])
      end
    end
    redirect_to :back
  end

  private

  def post_params
    params.require(:post).permit(:title, :url, :description, category_ids: [])
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
