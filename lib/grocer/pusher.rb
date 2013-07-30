require 'grocer/reply'
require 'timeout'

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
        buf = @connection.read(Reply::LENGTH)
        return Reply.new(buf)
      end
    rescue EOFError
      # EOF, nothing to read
    rescue Timeout::Error
      # nothing to read
    end
  end
end
