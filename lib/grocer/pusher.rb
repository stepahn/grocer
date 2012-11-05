module Grocer
  class Pusher
    def initialize(connection)
      @connection = connection
    end

    def push(notification)
      @connection.write(notification.to_bytes)
    end

    def read_reply
      packet = @connection.read_nonblock(6).unpack("CCN")
      {command: packet[0], status: packet[1], id: packet[2]}
    rescue IO::WaitReadable
      # Reading would block, that means there is nothing to read yet
    rescue EOFError
      # EOF, nothing to read
    end
  end
end
