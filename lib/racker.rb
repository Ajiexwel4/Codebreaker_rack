require 'erb'
require_relative 'game'

class Racker
  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
  end

  def response
    case @request.path
    when '/' then Rack::Response.new(render('index.html.erb'))
    when '/start' then start
    when '/update_guess' then update_guess
    when '/save_score' then save_score
    when '/scores' then Rack::Response.new(render('scores.html.erb'))
    else Rack::Response.new('Not Found', 404)
    end
  end

  def start
    @request.session.clear
    @request.session[:game] = Codebreaker::Game.new
    @request.session[:hint] = game.secret_code[rand(0..3)]
    Rack::Response.new do |response|
      response.set_cookie('guess', '')
      response.redirect('/')
    end
  end

  def update_guess
    Rack::Response.new do |response|
      response.set_cookie('guess', @request.params['guess'])
      response.redirect('/')
    end
  end

  def game
    @request.session[:game]
  end

  def guess
    @request.cookies['guess']
  end

  def hint
    @request.session[:hint]
  end

  def save_score
    save_score_file(@request.params['player_name'])
    Rack::Response.new do |response|
      response.redirect('/scores')
    end
  end

  def path_score_file
    File.expand_path("../../score/scores.txt", __FILE__)
  end

  def read_scores
    File.open(path_score_file) { |file| file.readlines }
  end

  def save_score_file(name)
    File.open(path_score_file, 'a') {|file| file.puts "#{name}: #{game.score} - #{Time.now.asctime}" }
  end

  def render(template)
    path = File.expand_path("../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end
end
