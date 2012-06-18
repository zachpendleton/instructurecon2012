class Example < Sinatra::Base
  get '/' do
    erb :index
  end

  # Use some simple pagination code to pull page links from header
  # and use then to navigate classes. Setting per_page to 1 in this
  # example so any user with > 1 courses will see pagination links.
  get '/pagination' do
    page     = params[:page]     || 1
    per_page = params[:per_page] || 2

    result = CANVAS.get("accounts/#{ACCOUNT_ID}/users") do |req|
      req.params['per_page'] = per_page
      req.params['page'] = page
    end

    @users = result.body
    @pages = parse_page_links(result)
    erb :pagination
  end

  protected
  def parse_page_links(resp)
    link_header  = resp.headers['link'].split(',')

    # Matches the name of each link: "next," "prev," "first," or "last."
    name_regex = /rel="([a-z]+)/

    # Matches the full link, e.g. "/api/v1/accounts/1/users?page=1&per_page=15"
    link_regex = /^<([^>]+)/

    # Matches only the querystring in the link, e.g. "?page=1&per_page=15"
    params_regex = /(\?[^>]+)/

    # Reduce the link header into a hash.
    link_header.inject({}) do |links, link|
      key = link.match(name_regex)[1].to_sym
      val = link.match(params_regex)[1]
      links[key] = val

      links
    end
  end
end
