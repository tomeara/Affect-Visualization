require 'rubygems'
require 'ruby-processing'
require 'osc-ruby'

class Affect_viz < Processing::App
  
  def setup
    self.server
    
    size 800, 600
    noStroke()
    smooth()
  end

  def draw
    background((@@excite * 255), (@@meditate * 255), (@@frustrate * 255))
    line(0, 0, (@@excite * 800), (@@frustrate * 600))
    stroke(255);
  end
    
  def server
    #Set up the Server to recieve UDP->OSC packets
    @server = OSC::Server.new(7400)

    #Filter, clean and show OSC data

      @server.add_method "/AFF/Excitement" do | message |
        message.instance_variable_get(:@args).each do |arg|
          puts arg.instance_variable_get(:@val).to_s.to_f
          @@excite = arg.instance_variable_get(:@val).to_s.to_f
        end
      end

      @server.add_method "/AFF/Meditation" do | message |
        message.instance_variable_get(:@args).each do |arg|
          puts arg.instance_variable_get(:@val).to_s.to_f
          @@meditate = arg.instance_variable_get(:@val).to_s.to_f
        end
      end
  
      @server.add_method "/AFF/Frustration" do | message |
        message.instance_variable_get(:@args).each do |arg|
          puts arg.instance_variable_get(:@val).to_s.to_f
          @@frustrate = arg.instance_variable_get(:@val).to_s.to_f
        end
      end
      
      @server.add_method "/AFF/Engagement" do | message |
        message.instance_variable_get(:@args).each do |arg|
          puts arg.instance_variable_get(:@val).to_s.to_f
          @@engage = arg.instance_variable_get(:@val).to_s.to_f
        end
      end

    #Run the server...
    Thread.new do
      @server.run
    end

    # ...for however long
    sleep(3)
  end
    
end

