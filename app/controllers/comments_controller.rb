class CommentsController < ApplicationController
  before_action :set_comment, only: [:vote]
  before_action :require_user

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(params.require(:comment).permit(:body))
    @comment.creator = current_user

    if @comment.save
      flash[:notice] = 'Comment has been made'
      redirect_to post_path(@post)
    else
      render 'posts/show'
    end
  end

  def vote
    @vote = Vote.where("user_id = ? AND voteable_type = ? AND voteable_id = ?", current_user.id, @comment.class.name, @comment.id).first
    if @vote.nil? #check to see if a vote exists
      @vote = Vote.create(creator: current_user, vote: params[:vote], voteable: @comment) #create if vote does not exists
    else #update vote if it exists
      if @vote.vote.to_s == params[:vote]
        Vote.destroy(@vote)
      else
        @vote.update(vote: params[:vote])
      end
    end

    respond_to do |format|
      format.html{ redirect_to :back}
      format.js
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end
end