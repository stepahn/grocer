require 'timeout'
require 'grocer/error_response'

module Grocer
  class Pusher
    def initialize(connection)
      @connection = connection
    end

    def push(notification)
      @connection.write(notification.to_bytes)
    end

    def read_reply
      Timeout::timeout(2) do
        buf = @connection.read(ErrorResponse::LENGTH)
        return ErrorResponse.new(buf)
      end
    rescue EOFError
      # EOF, nothing to read
    rescue Timeout::Error
      # nothing to read
    end
  end
end
