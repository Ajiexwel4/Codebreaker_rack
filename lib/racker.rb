require 'erb'
require 'codebreaker'

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
    redirect_to('/')
  end

  def update_guess
    @request.session[:guess] = @request.params['guess']
    redirect_to('/')
  end

  def game
    @request.session[:game]
  end

  def guess
    @request.session[:guess]
  end

  def hint
    @request.session[:hint]
  end

  def save_score
    save_score_file(@request.params['player_name'])
    redirect_to('/score')
  end

  def read_score
    File.open(score_file_path, &:readlines)
  end

  private

  def redirect_to(path)
    Rack::Response.new { |response| response.redirect(path) }
  end

  def render(template)
    path = File.expand_path("../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end

  def save_score_file(name)
    File.open(score_file_path, 'a') { |file| file.puts "#{name} got #{game.score} score on #{Time.now.asctime}" }
  end

  def score_file_path
    File.expand_path('../../score/score.txt', __FILE__)
  end
end
