require_relative 'game'
require 'erb'

class Racker
  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
    @game = Codebreaker::Game.new
  end

  def response
    case @request.path
    when '/' then Rack::Response.new(render('index.html.erb'))
    when '/update_guess' then update_guess
    else Rack::Response.new('Not Found', 404)
    end
  end

  def update_guess
    Rack::Response.new do |response|
      response.set_cookie('guess', @request.params['guess'])
      response.redirect('/')
    end
  end

  def render(template)
    path = File.expand_path("../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end

  def input_code
    player_code = @request.cookies['guess']
    player_code if player_code.size == 4 || player_code == 'hint'
  end
end
