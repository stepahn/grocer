module Grocer
  class Reply
    LENGTH = 6

    attr_accessor :identifier, :command, :status

    def initialize(binary_tuple)
      # C   =>  1 byte command
      # C   =>  1 byte statis
      # N   =>  4 byte identifier
      @command, @status, @identifier = binary_tuple.unpack("CCN")
      raise InvalidFormatError unless @command && @status && @identifier
    end
  end
end
