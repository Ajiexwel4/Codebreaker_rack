module Codebreaker
  module Marker
    def check_win
      if win?
        'Congratulation! You win!'
      elsif @attempts.zero?
        @hint = 0
        @game_start = false
        "Game over! Secret code is #{@secret_code}."
      else
        marking
      end
    end

    def win?
      @secret_code == @player_code
    end

    private

    def marking
      @player_code = convert_to_a(@player_code)
      @attempts -= 1
      pluses + minuses
    end

    def pluses
      @player_code.zip(@secret_code.chars).map { |array| '+' if array[0] == array[1] }.compact.join
    end

    def minuses
      secret = convert_to_a(@secret_code)
      array = @player_code.map { |num| secret[secret.find_index(num)] = '-' if secret.include?(num) }
      '-' * (array.count('-') - pluses.length)
    end

    def convert_to_a(code)
      code.chars.to_a
    end
  end
end
