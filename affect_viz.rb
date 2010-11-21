require 'rubygems'
require 'ruby-processing'
require 'osc-ruby'

module Runnable
  def run
    self.reject! { |particle| particle.dead? }
    self.each    { |particle| particle.run   }
  end
end

class Vector
  attr_accessor :x, :y

  def initialize(x, y)
    @x, @y = x, y
  end

  def +(other)
    if other.is_a?(Numeric)
      Vector.new(@x + other, @y + other)
    elsif other.is_a?(Vector)
      Vector.new(@x + other.x, @y + other.y)
    else
      self
    end
  end

  def heading
    -1 * Math::atan2(-@y, @x)
  end

  def magnitude
    @x * @x + @y * @y
  end
end

class Affect_viz < Processing::App
  
  def setup
    self.server

    size 1000, 1000
    smooth
    color_mode(RGB, 255, 255, 255, 100)
    ellipse_mode(CENTER)

    @particles = []
    @history = []
    @particles.extend Runnable
  end

  def draw
    background((@@excite * 255), (@@engage * 255), (@@frustrate * 255))
    stroke(255, 20)
    ellipse(@@engage * 1000, @@meditate * 1000, 10, 10)
    triangle((@@excite * 1000) - 5, (@@frustrate * 1000) - 10, (@@excite * 1000) + 5, (@@frustrate* 1000) - 10, @@excite * 1000, @@frustrate * 1000)
    @particles.run
    @particles << Particle.new(Vector.new(@@excite * 1000, @@frustrate * 1000), @@engage, @@excite, @@frustrate, @@meditate)
  end
    
  def server
    #Set up the Server to recieve UDP->OSC packets
    @server = OSC::Server.new(7400)

    #Filter, clean and show OSC data

      @server.add_method "/AFF/Excitement" do | message |
        message.instance_variable_get(:@args).each do |arg|
          puts "Excitement - #{arg.instance_variable_get(:@val).to_s.to_f}"
          @@excite = arg.instance_variable_get(:@val).to_s.to_f
        end
      end

      @server.add_method "/AFF/Meditation" do | message |
        message.instance_variable_get(:@args).each do |arg|
          puts "Meditation - #{arg.instance_variable_get(:@val).to_s.to_f}"
          @@meditate = arg.instance_variable_get(:@val).to_s.to_f
        end
      end
  
      @server.add_method "/AFF/Frustration" do | message |
        message.instance_variable_get(:@args).each do |arg|
          puts "Frustration - #{arg.instance_variable_get(:@val).to_s.to_f}"
          @@frustrate = arg.instance_variable_get(:@val).to_s.to_f
        end
      end

      @server.add_method "/AFF/Engaged" do | message |
        message.instance_variable_get(:@args).each do |arg|
          puts "Engage - #{arg.instance_variable_get(:@val).to_s.to_f}"
          @@engage = arg.instance_variable_get(:@val).to_s.to_f
        end
      end

      @server.add_method "/AFF/ExcitementLT" do | message |
        message.instance_variable_get(:@args).each do |arg|
          puts "Long-term Excitement - #{arg.instance_variable_get(:@val).to_s.to_f}"
          @@exciteLT = arg.instance_variable_get(:@val).to_s.to_f
        end
      end

    #Run the server...
    Thread.new do
      @server.run
    end

    # ...for however long
    sleep(3)
  end
  
  class Particle
    def initialize(origin, engage, excite, frustrate, meditate)
      @origin = origin
      @velocity = Vector.new(rand * 2 - 1, rand * 2 - 2)
      @acceleration = Vector.new(0, 0.1 * frustrate)
      @engage = engage * 1000
      @meditate = meditate * 1000
      @lifespan = engage * 100
    end

    def run
      update
      grow
      render
    end
    
    def update
      @velocity += @acceleration
      @origin += @velocity
    end

    def grow
      @lifespan -= 1
    end

    def dead?
      @lifespan <= 0
    end

    def render
      stroke(255, @lifespan)
      fill(100, @lifespan)
      line(@origin.x, @origin.y, @engage, @meditate)
    end
  end
end
#Affect_viz.new(:width => 1000, :height => 1000, :title => "Affect Viz", :full_screen => true)