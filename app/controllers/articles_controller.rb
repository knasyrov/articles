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
      render :new
    end
  end

  def update
    if @record.update article_params
      flash[:notice] = I18n.t('messages.successfully_updated')
      load_collection
      redirect_to articles_path
    else
      render action: :edit
    end    
  end

  protected

  def article_params
    params.require(:article).permit(:title, :author, :body)
  end

  def version_param(param_name: :version)
    params[param_name].to_i.positive? ? params[param_name].to_i : :last
  end

  def query_param
    @query ||= params[:query].blank? ? '*' : params[:query]
  end


  def load_record
    object = controller_name.classify.constantize.find(params[:id])
    instance_variable_set("@record", object)
  end
  
  def load_collection
    @collection = Article.search(query_param, limit: per_page_parameter, offset: per_page_parameter*(page_parameter-1))
  end
end
