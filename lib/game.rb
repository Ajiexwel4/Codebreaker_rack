require_relative 'modules/marker'

module Codebreaker
  class Game
    include Marker

    ATTEMPTS  = 7
    HINT      = 1
    CODE_SIZE = 4
    RANGE     = 1..6

    attr_accessor :secret_code, :player_code, :hint, :attempts, :score
    def initialize(score = 0)
      @secret_code = Array.new(CODE_SIZE) { rand(RANGE) }.join
      @player_code = ''
      @hint        = HINT
      @attempts    = ATTEMPTS
      @score       = score
    end

    def check_guess(guess)
      @player_code = guess
      hinter
      check_win
    end

    def hinter
      if @player_code == 'hint' && @hint.nonzero?
        puts 'Hint: Secret code contains: ' + @secret_code[rand(0..3)]
        @hint -= 1
        @attempts += 1
      end
    end

    def score_count
      @score += 250 if win?
      @score += @hint * 100 + @attempts * 50
    end
  end
end
