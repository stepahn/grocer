require 'spec_helper'
require 'grocer/reply'

describe Grocer::Reply do
  let(:identifier) { 423 }
  let(:command) { 8 }
  let(:status) { 8 }
  let(:binary_tuple) { [command, status, identifier].pack('CCN') }
  let(:invalid_binary_tuple) { 'totally not the right format' }

  describe 'decoding' do
    it 'accepts a binary tuple and sets each attribute' do
      reply = described_class.new(binary_tuple)
      reply.identifier.should == identifier
      reply.command.should == command
      reply.status.should == status
    end

    it 'raises an exception when there are problems decoding' do
      -> { described_class.new(invalid_binary_tuple) }.should
        raise_error(Grocer::InvalidFormatError)
    end
  end
end
