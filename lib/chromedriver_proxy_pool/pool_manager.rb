require "chromedriver_proxy_pool/driver_process"
require "thread"

module ChromedriverProxyPool
  class PoolManager
    def initialize
      @limit = 8
      @acquired = []
      @lock = Mutex.new

      establish_drivers
    end

    def stats
      lock.synchronize {
        {
          :limit    => limit,
          :acquired => acquired_count,
        }
      }
    end

    def acquire
      lock.synchronize {
        return { :success => false } if drivers.empty?

        driver = drivers.pop
        acquired << driver

        {
          :port    => driver.port,
          :success => true,
        }
      }
    end

    def release(port)
      lock.synchronize {
        driver = acquired.find {|x| x.port == port}
        acquired.delete(driver)
        drivers << driver

        {
          :success => true,
        }
      }
    end

    private

    attr_reader :limit, :acquired, :drivers, :lock

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
