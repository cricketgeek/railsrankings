RAILS_ROOT = "/var/www/railsrankings/current"
SHARED = "/var/www/railsrankings/shared"
#RUBY = `which ruby`.chomp
#MONGREL_RAILS = `which mongrel_rails`.chomp
RAILS_ENV = 'production'
#MEMCACHED = `which memcached`.chomp
#MONGRELS = 4
#MONGREL_START_PORT= 8000


#mongrels
%w{8000 8001 8002}.each do |port|
  God.watch do |w|
    w.group           = 'mongrels'
    w.name            = "mongrel_#{port}"
    #w.uid             =  'cricketgeek'
    # w.gid             = 'cricketgeek'
    w.interval        = 30.seconds
		w.start						= "mongrel_cluster_ctl start" #"mongrel_rails start -c #{RAILS_ROOT} -p #{port} -P #{RAILS_ROOT}/log/mongrel_#{port}.pid -e #{RAILS_ENV} -d"
    w.start_grace     = 90.seconds
    w.restart_grace   = 90.seconds
    w.log             = File.join(RAILS_ROOT, "log/mongrel_#{port}.log")
		w.stop 						= "mongrel_cluster_ctl stop"#"mongrel_rails stop -P #{RAILS_ROOT}/log/mongrel_#{port}.pid" 
		w.restart 				= "mongrel_cluster_ctl restart"#"mongrel_rails restart -P #{RAILS_ROOT}/log/mongrel_#{port}.pid" 
		w.pid_file 				= "#{RAILS_ROOT}/log/mongrel_#{port}.pid" 

    w.start_if do |start|
      start.condition(:process_running) do |c|
        c.interval = 5.seconds
        c.running = false
      end
    end

    w.restart_if do |restart|
      restart.condition(:memory_usage) do |c|
        c.above = 150.megabytes
        c.times = [3, 5] # 3 out of 5 intervals
      end

      restart.condition(:cpu_usage) do |c|
        c.above = 50.percent
        c.times = 5
      end

      restart.condition(:http_response_code) do |c|
        c.code_is_not = 200
        c.host = 'localhost'
        c.path = '/'
        c.port = port
        c.timeout = 30.seconds
        c.times = [3, 5]
      end
    end

    # If this watch is started or restarted five times withing 5 minutes, then unmonitor it
    #...then after ten minutes, monitor it again to see if it was just a temporary problem;
    #if the process is seen to be flapping five times within two hours, then give up completely.
    w.lifecycle do |on|
      on.condition(:flapping) do |c|
        c.to_state = [:start, :restart]
        c.times = 5
        c.within = 5.minute
        c.transition = :unmonitored
        c.retry_in = 10.minutes
        c.retry_times = 5
        c.retry_within = 2.hours
      end
    end
  end
end

#nginx
# God.watch do |w|
#   w.name              = "nginx"
#   w.interval          = 5.seconds
#   w.start = "service nginx start"
#   w.stop = "service nginx stop"
#   w.restart = "service nginx restart"
#   w.start_grace       = 10.seconds
#   w.restart_grace     = 10.seconds
#   w.log               = File.join(RAILS_ROOT, "log/nginx.log")
#   w.pid_file          = File.join(SHARED, "pids/nginx.pid")
# 
#   w.start_if do |start|
#     start.condition(:process_running) do |c|
#       c.running = false
#     end
#   end
# 
#   w.restart_if do |restart|
#     restart.condition(:memory_usage) do |c|
#       c.above = 30.megabytes
#       c.times = [3, 5] # 3 out of 5 intervals
#     end
# 
#     restart.condition(:cpu_usage) do |c|
#       c.above = 50.percent
#       c.times = 5
#     end
# 
#     restart.condition(:http_response_code) do |c|
#       c.code_is_not = 200
#       c.host = 'localhost'
#       c.path = '/robots.txt'
#       c.port = 80
#       c.timeout = 1
#     end
#   end
# 
#   # If this watch is started or restarted five times withing 5 minutes, then unmonitor it
#   #...then after ten minutes, monitor it again to see if it was just a temporary problem;
#   #if the process is seen to be flapping five times within two hours, then give up completely.
#   w.lifecycle do |on|
#     on.condition(:flapping) do |c|
#       c.to_state = [:start, :restart]
#       c.times = 5
#       c.within = 5.minute
#       c.transition = :unmonitored
#       c.retry_in = 10.minutes
#       c.retry_times = 5
#       c.retry_within = 2.hours
#     end
#   end
# end
#memcached
#God.watch do |w|
#  w.name            = "memcached"
#  w.uid             = 'deploy'
#  w.gid             = 'deploy'
#  w.interval        = 30.seconds
#  w.start           = "#{MEMCACHED} -m 64 -p 11211"
#  w.start_grace     = 15.seconds
#  w.restart_grace   = 15.seconds
#  w.log             = File.join(RAILS_ROOT, "log/memcached.log")

#  w.start_if do |start|
#    start.condition(:process_running) do |c|
#      c.interval = 5.seconds
#      c.running = false
#    end
#  end

#  w.restart_if do |restart|
#    restart.condition(:memory_usage) do |c|
#      c.above = 150.megabytes
#      c.times = [3, 5] # 3 out of 5 intervals
#    end

#    restart.condition(:cpu_usage) do |c|
#      c.above = 50.percent
#      c.times = 5
#    end
#  end

  # If this watch is started or restarted five times withing 5 minutes, then unmonitor it
  #...then after ten minutes, monitor it again to see if it was just a temporary problem;
  #if the process is seen to be flapping five times within two hours, then give up completely.
#  w.lifecycle do |on|
#    on.condition(:flapping) do |c|
#      c.to_state = [:start, :restart]
#      c.times = 5
#      c.within = 5.minute
#      c.transition = :unmonitored
#      c.retry_in = 10.minutes
#      c.retry_times = 5
#      c.retry_within = 2.hours
#    end
#  end
#end

#email
  # God::Contacts::Email.message_settings = {
  # :from => 'support@railsrankings.com'
  # }
  # God::Contacts::Email.server_settings = {
  # :address => "localhost",
  # :port => 25,
  # :domain => "railsrankings.com",
  # :authentication => :plain,
  # }
  # God.contact(:email) do |c|
  #   c.name = 'support'
  #   c.email = 'support@railsrankings.com'
  #   c.group = 'ops'
  # end
