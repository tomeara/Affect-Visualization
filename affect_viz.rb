require 'rubygems'
require 'osc-ruby'

#Set up the Server to recieve UDP->OSC packets
@server = OSC::Server.new(7400)

#Filter, clean and show OSC data
def osc_parse(affect)
  @server.add_method "/AFF/#{affect}" do | message |
    message.instance_variable_get(:@args).each do |arg|
      puts arg.instance_variable_get(:@val).inspect
    end
  end
end

#Get Affect from the EPOC Affectiv Suite
osc_parse("Excitement")
osc_parse("Frustration")
osc_parse("Meditation")
osc_parse("Engagement")

#Run the server...
Thread.new do
  @server.run
end

# ...for however long
sleep(3)

