require 'rubygems'
require 'osc-ruby'

#Set up the Server to recieve UDP->OSC packets
@server = OSC::Server.new(7400)

#Filter and show packets w/ "Excitement"
@server.add_method '/AFF/Excitement' do | message |
  puts message.inspect
end

#Filter and show packets w/ "Frustration"
@server.add_method '/AFF/Frustration' do |message|
  puts message.inspect
end

Thread.new do
  @server.run
end


sleep(2000)

