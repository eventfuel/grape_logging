module GrapeLogging
  module Formatters
    class Logstash
      def call(severity, datetime, _, data)
        load_dependencies

        if data.is_a?(String)
          data = {
            severity: severity,
            datetime: datetime,
            location: 'api',
            message: data
          }
        elsif data.is_a?(Exception)
          format_exception(data)
        elsif !data.is_a?(Hash)
          data = data.inspect
        end
        response = LogStash::Event.new(data).to_json
        response
      end

      def format_exception(exception)
        {
          exception_message: exception.message,
          exception_backtrace: exception.backtrace
        }
      end

      def load_dependencies
        require 'logstash-event'
      rescue LoadError
        puts 'You need the logstash-event gem installed to use logstash output.'
        raise
      end
    end
  end
end
