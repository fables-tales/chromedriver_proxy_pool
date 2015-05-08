require "sinatra/base"
require "sinatra/json"
require "chromedriver_proxy_pool/pool_manager"
require "sinatra/json"

module ChromedriverProxyPool
  class App < Sinatra::Base
    def initialize(*args, &blk)
      super(*args, &blk)

      @pool_manager = ChromedriverProxyPool::PoolManager.new
    end

    get "/" do
      json(pool_manager.stats)
    end

    post "/acquire" do
      json(pool_manager.acquire)
    end

    post "/release" do
      json(pool_manager.release(params.fetch("port").to_i))
    end

    private

    def pool_manager
      @pool_manager
    end
  end
end
