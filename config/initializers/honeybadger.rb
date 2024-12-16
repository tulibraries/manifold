# frozen_string_literal: true

# Errors for honeybadger to ignore.
Honeybadger.configure do |config|
  config.before_notify do |notice|
    # Ignore errors that occur during overnight maintenance
    start_time = Time.now.utc.change(hour: 5, min: 0, sec: 0)
    end_time = Time.now.utc.change(hour: 8, min: 30, sec: 0)
    current_time = Time.now.utc

    notice.halt! if current_time.between?(start_time, end_time)
  end
end
