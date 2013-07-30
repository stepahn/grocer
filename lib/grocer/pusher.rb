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
      sleep 2
      buf = @connection.read_nonblock(ErrorResponse::LENGTH)
      return ErrorResponse.new(buf) unless buf.nil?
    rescue IO::WaitReadable
      # Reading would block, that means there is nothing to read yet
    rescue EOFError
      # EOF, nothing to read
    end
  end
end
