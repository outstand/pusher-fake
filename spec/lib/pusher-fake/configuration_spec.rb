require "spec_helper"

describe PusherFake::Configuration do
  it { should have_configuration_option(:app_id).with_default("PUSHER_APP_ID") }
  it { should have_configuration_option(:key).with_default("PUSHER_API_KEY") }
  it { should have_configuration_option(:logger).with_default(STDOUT.to_io) }
  it { should have_configuration_option(:secret).with_default("PUSHER_API_SECRET") }
  it { should have_configuration_option(:verbose).with_default(false) }
  it { should have_configuration_option(:webhooks).with_default([]) }
  it { should have_configuration_option(:host).with_default('127.0.0.1') }
  it { should have_configuration_option(:socket_port) }
  it { should have_configuration_option(:web_port) }

  it "should have configuration option :socket_options" do
    expect(subject.socket_options).to be_a(Hash)
    expect(subject.socket_options[:host]).to eq("127.0.0.1")
    expect(subject.socket_options[:port]).to be_a(Integer)
  end

  it "should have configuration option :web_options" do
    expect(subject.web_options).to be_a(Hash)
    expect(subject.web_options[:host]).to eq("127.0.0.1")
    expect(subject.web_options[:port]).to be_a(Integer)
  end

  context 'when the host is set' do
    let(:host) { '192.168.1.1' }

    before do
      subject.host = host
    end

    it 'sets the host' do
      expect(subject.host).to eq host
    end

    it 'sets the host for socket_options' do
      expect(subject.socket_options[:host]).to eq host
    end

    it 'sets the host for web_options' do
      expect(subject.web_options[:host]).to eq host
    end
  end

  context 'when the web_port is set' do
    let(:web_port) { 4444 }

    before do
      subject.web_port = web_port
    end

    it 'sets the web_port' do
      expect(subject.web_port).to eq web_port
    end

    it 'sets the port for web_options' do
      expect(subject.web_options[:port]).to eq web_port
    end
  end

  context 'when the socket_port is set' do
    let(:socket_port) { 4444 }

    before do
      subject.socket_port = socket_port
    end

    it 'sets the socket_port' do
      expect(subject.socket_port).to eq socket_port
    end

    it 'sets the port for socket_options' do
      expect(subject.socket_options[:port]).to eq socket_port
    end
  end

  it "defaults socket and web ports to different values" do
    expect(subject.socket_options[:port]).to_not eq(subject.web_options[:port])
  end
end

describe PusherFake::Configuration, "#to_options" do
  it "includes the socket host as wsHost" do
    options = subject.to_options

    expect(options).to include(wsHost: subject.socket_options[:host])
  end

  it "includes the socket port as wsPort" do
    options = subject.to_options

    expect(options).to include(wsPort: subject.socket_options[:port])
  end

  it "supports passing custom options" do
    options = subject.to_options(custom: "option")

    expect(options).to include(custom: "option")
  end
end
