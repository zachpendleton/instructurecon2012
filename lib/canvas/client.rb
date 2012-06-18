module Canvas
  class Client
    attr_reader :conn

    # Create a new Faraday instance for connecting to Canvas.
    #
    # opts - A hash of options used to init the client.
    #        domain - The url Canvas it located at. Should be something like
    #                 "http://canvas.local".
    #        access_token - An access token for a user with permissions to make
    #                       the example calls.
    #
    # Examples
    #
    # client = Canvas::Client.new(:url => 'http://canvas.local',
    #                             :key => 'SOOxF61Qdyb...')
    def initialize(opts = {})
      opts = opts.inject({}) { |n, o| n[o[0].to_sym] = o[1]; n }

      @conn = Faraday.new(:url => "#{opts[:domain]}/api/v1/") do |conn|
        conn.request :oauth2, opts[:access_token]
        conn.request :json
        conn.response :json, :content_type => /\bjson$/
        conn.adapter Faraday.default_adapter
      end
    end

    # If an unknown method is called, pass it to the Faraday client.
    def method_missing(method, *args, &block)
      args.first.sub!(%r{^/api/v1/}, '')
      @conn.send(method, *args, &block)
    end
  end
end
