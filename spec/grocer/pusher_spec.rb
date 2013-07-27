require 'spec_helper'
require 'grocer/pusher'

describe Grocer::Pusher do
  let(:connection) { stub_everything }

  subject { described_class.new(connection) }

  describe '#push' do
    it 'serializes a notification and sends it via the connection' do
      notification = stub(:to_bytes => 'abc123')
      subject.push(notification)

      connection.should have_received(:write).with('abc123')
    end
  end

  def stub_reply
    connection.stubs(:read).
               with(6).
               returns([8, 8, 523].pack('CCN')).
               then.
               returns(nil)
  end

  let(:identifier) { 523 }
  let(:command) { 8 }
  let(:status) { 8 }

  it 'reads a reply from the connection' do
    stub_reply

    reply = subject.read_reply
    reply.identifier.should == identifier
    reply.command.should == command
    reply.status.should == status
  end

  it 'timeout on reading reply' do
    connection.stubs(:read).with(6) { sleep 10 }

    reply = subject.read_reply
    reply.should == nil
  end
end
