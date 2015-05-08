require "chromedriver_proxy_pool/driver_process"

module ChromedriverProxyPool
  class PoolManager
    def initialize
      @limit = 8
      @acquired = []

      establish_drivers
    end

    def stats
      {
        :limit    => limit,
        :acquired => acquired_count,
      }
    end

    def acquire
      driver = drivers.pop
      acquired << driver

      {
        :port => driver.port
      }
    end

    def release(port)
      driver = acquired.find {|x| x.port == port}
      acquired.delete(driver)
      drivers << driver

      {
        :success => true
      }
    end

    private

    attr_reader :limit, :acquired, :drivers

    def acquired_count
      @acquired.count
    end

    def establish_drivers
      @drivers = (0...limit).map {
        DriverProcess.new
      }
    end
  end
end
