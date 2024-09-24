# frozen_string_literal: true

# Errors for honeybadger to ignore.
Honeybadger.configure do |config|
  config.before_notify do |notice|
    # Ignore errors that occur during overnight maintenance
    start_time = Time.parse("00:00").utc
    end_time = Time.parse("03:30").utc
    current_time = Time.now.utc

    notice.halt! if current_time.between?(start_time, end_time)
  end
end
