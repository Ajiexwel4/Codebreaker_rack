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
    when '/'             then Rack::Response.new(render('index.html.erb'))
    when '/start'        then start
    when '/update_guess' then update_guess
    when '/save_score'   then save_score
    when '/score'        then Rack::Response.new(render('score.html.erb'))
    else Rack::Response.new('Not Found', 404)
    end
  end

  def start
    @request.session.clear
    @request.session[:game] = Codebreaker::Game.new
    @request.session[:hint] = game.secret_code[rand(0..3)]
    cookie_guess_set('')
  end

  def update_guess
    cookie_guess_set(@request.params['guess'])
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
      response.redirect('/score')
    end
  end

  def read_score
    File.open(path_score_file, &:readlines)
  end

  private

  def render(template)
    path = File.expand_path("../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end

  def cookie_guess_set(param)
    Rack::Response.new do |response|
      response.set_cookie('guess', param)
      response.redirect('/')
    end
  end

  def save_score_file(name)
    File.open(path_score_file, 'a') { |file| file.puts "#{name} got #{game.score} score on #{Time.now.asctime}" }
  end

  def path_score_file
    File.expand_path('../../score/score.txt', __FILE__)
  end
end
