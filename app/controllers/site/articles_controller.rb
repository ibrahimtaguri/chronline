class Site::ArticlesController < Site::BaseController

  def index
    @taxonomy = Taxonomy.new("/#{params[:section]}/")
    @articles = Article.find_by_section(@taxonomy)
  end

  def show
    @article = Article.find(params[:id])
    @disqus = {
      production: Rails.env.production?,
      shortname: Settings.disqus_shortname,
      identifier: @article.id,  # TODO: should be old unique identifier for backwards compatibility
      title: @article.title,
      url: site_article_url(@article, subdomain: 'www'),
    }
  end

  def print
    @article = Article.find(params[:id])
    render 'print', layout: 'print'
  end

end
