class CommentsController < ApplicationController
  before_action :authenticate_admin!, except: [:index]
  before_action :find_post!

  private

  def find_post!
    @post = Post.find_by_slug!(params[:post_slug])
  end

  def comment_params
   params.require(:comment).permit(:body)
 end

  def index
    @comments = @post.comments.order(created_at: :desc)
  end
 
  def create
    @comment = @post.comments.new(comment_params)
    @comment.admin = current_admin

    render json: { errors: @comment.errors }, status: :unprocessable_entity unless @comment.save
  end

 def destroy
    @comment = @post.comments.find(params[:id])

    if @comment.admin_id == @current_admin_id
      @comment.destroy
      render json: {}
    else
      render json: { errors: { comment: ['not owned by user'] } }, status: :forbidden
    end
  end
  
end
