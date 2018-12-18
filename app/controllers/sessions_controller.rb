class SessionsController < ApplicationController
  def create
    user_data = request.env['omniauth.auth']
    session[:nickname] = user_data[:info][:nickname]
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['API_KEY']
      config.consumer_secret     = ENV['API_SECRET']
      config.access_token        = user_data[:credentials][:token]
      config.access_token_secret = user_data[:credentials][:secret]
    end

    def collect_with_max_id(collection=[], max_id=nil, &block)
      response = yield(max_id)
      collection += response
      response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
    end

    def client.get_all_tweets(user)
      collect_with_max_id do |max_id|
	options = {count: 200}
	options[:max_id] = max_id unless max_id.nil?
	favorites(user, options)
      end
    end

    @favorites = client.get_all_tweets(user_data[:info][:nickname])
    flash.now[:notice] = "ログインしました"
    render 'homes/index'
    #redirect_to root_path, notice: 'ログインしました'
  end
end
