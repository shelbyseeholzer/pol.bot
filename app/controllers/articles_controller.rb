class ArticlesController < ApplicationController
  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
    #  the  @ defines it in the controller so you can use it later in a view that is going to be rendered.
    #  no @ symbol, the view cant access it. Its called scoping, only accessable in certain places.
    #  https://guides.rubyonrails.org/layouts_and_rendering.html 3.4.5 Rendering Collections
  end

  def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    @comment.destroy
    redirect_to article_path(@article), status: :see_other
  end
end

# Get show page working for showing an article
# might not be working because the model is still called blog
#
