class ArticlesController < ApplicationController
  before_action :load_collection, only: :index
  before_action :load_record, only: %w(show edit destroy update)

  def index
    @search_filter ||= {}

  end

  def new
    @record = Article.new
  end

  def edit

  end

  def show
    version = params[:version].to_i
    unless version.negative?
      @version = OpenStruct.new @record.versions[version].object
    else
      @version = OpenStruct.new @record.versions.last
    end
  end

  def create
    @record = Article.new(article_params)
    if @record.save
      flash[:notice] = I18n.t('messages.successfully_created')
      load_collection
      redirect_to articles_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @record.update update_params
      flash[:notice] = I18n.t('messages.successfully_updated')
      load_collection
      redirect_to articles_path
    else
      render action: :edit, status: :unprocessable_entity
    end    
  end

  protected

  def article_params
    params.require(:article).permit(:title, :author, :body)
  end

  def update_params
    params.require(:article).permit(:title)
  end

  def version_param(param_name: :version)
    params[param_name].to_i.positive? ? params[param_name].to_i : :last
  end

  def query_param
    @query ||= params[:query]
  end


  def load_record
    @record = Article.find(params[:id])
  end
  
  def load_collection
    @collection = Article.search('*', 
                                  #fields: [:title],
                                  where: {
                                    title: {like: "%#{query_param}%"}
                                  },
                                  limit: per_page_parameter, 
                                  offset: per_page_parameter*(page_parameter-1))
  end
end
