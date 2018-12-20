class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    uid = auth[:uid]
    session[:uid] = uid
    User.where(uid: uid).delete_all
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['API_KEY']
      config.consumer_secret     = ENV['API_SECRET']
      config.access_token        = auth[:credentials][:token]
      config.access_token_secret = auth[:credentials][:secret]
    end

    def collect_with_max_id(collection=[], max_id=nil, &block)
      response = yield(max_id)
      collection += response
      response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
    end

    def client.get_all_favorites(user)
      collect_with_max_id do |max_id|
	options = {count: 200}
	options[:max_id] = max_id unless max_id.nil?
	favorites(user, options)
      end
    end

    favorites = client.get_all_favorites(uid.to_i)
    favorites.each do |favorite|
      User.create(uid: uid, favorite: favorite.text)
    end
    redirect_to root_path
  end
end
