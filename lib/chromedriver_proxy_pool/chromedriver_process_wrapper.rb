require "open3"
require "faraday"
require "json"

module ChromedriverProxyPool
  class ChromedriverProcessWrapper
    def initialize
      @port = 50000 + rand(10000)

      p "starting process on port #{port}"

      @chromedriver_process_pipes = Open3.popen3("chromedriver", "--port=#{port}")
      sleep(0.1)
    end

    def port
      @port
    end

    def kill
      Process.kill("TERM", chromedriver_process_pipes.last.pid)
      sleep(0.1)
    end

    def has_status?
      begin
        p http_connection.get("/status").body
        JSON.parse(http_connection.get("/status").body).fetch("value", {}).include?("build")
      rescue Faraday::Error
        false
      end
    end

    protected

    attr_reader :chromedriver_process_pipes

    def http_connection
      Faraday.new("http://localhost:#{port}") do |f|
        f.adapter Faraday.default_adapter
      end
    end
  end
end
