require "chromedriver_proxy_pool/version"
require "chromedriver_proxy_pool/app"

module ChromedriverProxyPool
  def self.main
    ChromedriverProxyPool::App.run!(:port => ARGV.fetch(0, "8883").to_i)
  end
end
