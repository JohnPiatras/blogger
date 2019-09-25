class ArticlesController < ApplicationController
    before_action :require_login, except: [:show, :index]
    before_action :validate_author, only: [:edit, :update, :destroy]

    include ArticlesHelper

    

    def index
        @articles = Article.all
    end

    def show_popular
        @articles = Article.all.order(view_count: :desc).limit(5)
    end

    def show_month
        m = params[:month].to_i
        @month = Date::MONTHNAMES[m]
        
        @articles = Article.where("cast(strftime('%m', created_at) as int) = ?", m)
    end

    def show
        @article = Article.find(params[:id])
        @article.inc_views
        @comment = Comment.new
        @comment.article_id = @article.id
    end

    def new
        @article = Article.new
    end

    def create
        @article = Article.new(article_params)
        @article.author_id = current_user.id
        @article.save
        flash.notice = "Article '#{@article.title}' Created!"
        redirect_to article_path(@article)
    end

    def destroy
        @article = Article.find(params[:id])
        flash.notice = "Article '#{@article.title}' Deleted!"
        @article.destroy
        redirect_to articles_path
    end

    def edit
        @article = Article.find(params[:id])
    end

    def update
        @article = Article.find(params[:id])
        @article.update(article_params)
      
        flash.notice = "Article '#{@article.title}' Updated!"
        redirect_to article_path(@article)
    end

    private
        def validate_author
            @article = Article.find(params[:id])
            unless current_user.id == @article.author_id
                flash.notice = "You must be the article's author to perform this action!"
                redirect_to article_path(@article)
            end
        end
end
