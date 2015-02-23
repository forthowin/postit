class PostsController < ApplicationController
  before_action :set_post, only: [:edit, :update, :show, :vote]
  before_action :require_user, except: [:index, :show]
  before_action :require_same_user, only: [:edit, :update]

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
    binding.pry
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

    respond_to do |format|
      format.html do
        redirect_to :back
      end
      format.js
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :url, :description, category_ids: [])
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def require_same_user
    if current_user != @post.creator
      flash[:error] = "You cannot do that"
      redirect_to root_path
    end
  end
end
