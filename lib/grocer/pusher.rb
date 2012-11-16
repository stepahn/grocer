require 'grocer/reply'

module Grocer
  class Pusher
    def initialize(connection)
      @connection = connection
    end

    def push(notification)
      @connection.write(notification.to_bytes)
    end

    def read_reply
      buf = @connection.read_nonblock(Reply::LENGTH)
      return Reply.new(buf)
    rescue IO::WaitReadable
      # Reading would block, that means there is nothing to read yet
    rescue EOFError
      # EOF, nothing to read
    end
  end
end
