class CommentsController < ApplicationController
  # http_basic_authenticate_with name: 'dhh', password: 'secret', only: :destroy

  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.create(comment_params)
    redirect_to article_path(@article)
  end

  #  the  @ defines it in the controller so you can use it later in a view that is going to be rendered.
  #  no @ symbol, the view cant access it.
  #
  def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    @comment.destroy
    redirect_to article_path(@article), status: :see_other
  end

  def edit
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
  end

  private

  def comment_params
    params.require(:comment).permit(:commenter, :body, :status)
  end
end
