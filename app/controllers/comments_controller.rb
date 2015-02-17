class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(params.require(:comment).permit(:body))
    @comment.user_id = User.first.id #temp

    if @comment.save
      flash[:notice] = 'Comment has been made'
      redirect_to post_path(@post)
    else
      render 'posts/show'
    end
  end
end