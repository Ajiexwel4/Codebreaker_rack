module Codebreaker
  describe Game do
    context 'sets subject constants' do
      it 'contains constant with 7 attempts' do
        expect(Codebreaker::Game::ATTEMPTS).to eq(7)
      end

      it 'contains constant with 1 hint' do
        expect(Codebreaker::Game::HINT).to eq(1)
      end
    end

    context 'subject attributes #initialize' do
      it 'saves secret code' do
        expect(subject.instance_variable_get(:@secret_code)).not_to be_empty
      end

      it 'saves secret code as string' do
        expect(subject.instance_variable_get(:@secret_code).class).to be(String)
      end

      it 'saves secret code with 4 numbers from 1 to 6 in string' do
        expect(subject.instance_variable_get(:@secret_code)).to match(/^[1-6]{4}$/)
      end

      it 'saves player code as String' do
        expect(subject.instance_variable_get(:@player_code).class).to be(String)
      end

      it 'saves score and it not to be nil' do
        expect(subject.instance_variable_get(:@score)).not_to be_nil
      end

      it 'saves score as 0' do
        expect(subject.instance_variable_get(:@score)).to be(0)
      end

      it 'saves hint from constant HINT' do
        expect(subject.instance_variable_get(:@hint)).to be(Game::HINT)
      end

      it 'saves attempt from constant ATTEMPTS' do
        expect(subject.instance_variable_get(:@attempts)).to be(Game::ATTEMPTS)
      end
    end

    context '#check_guess' do
      let(:check_win)  { subject.check_guess('1234') }
      let(:check_lose) { subject.check_guess('1111') }
      let(:check_hint) { subject.check_guess('hint') }

      before do
        subject.instance_variable_set(:@secret_code, '1234')
      end

      context 'if player type "hint"' do
        before do
          allow(subject).to receive(:puts)
        end

        it 'adds 1 attempt compensation for try' do
          expect { check_hint }.to change { subject.attempts }.by(0)
        end

        it 'reduce attempts number by 1' do
          expect { check_hint }.to change { subject.hint }.by(-1)
        end
      end

      context 'if win' do
        it 'matches secret code and guess to equal' do
          check_win
          expect(@secret_code).to eq(@player_code)
        end

        it 'returns win message' do
          expect(check_win).to eq('Congratulation! You win!')
        end
      end

      context 'if lose' do
        before do
          subject.instance_variable_set(:@attempts, 0)
          check_lose
        end

        it 'sets hint to 0' do
          expect(subject.hint).to be_zero
        end

        it 'sets game_start flag to false' do
          expect(subject.game_start).to be_falsey
        end

        it 'returns game over message' do
          expect(check_lose).to eq('Game over! Secret code is 1234.')
        end
      end

      context 'cheking comparison in else branch' do
        it 'reduce attempts number by 1' do
          expect { check_lose }.to change { subject.attempts }.by(-1)
        end

        [
          ['3331', '3332', '+++' ],
          ['1113', '1112', '+++' ],
          ['1312', '1212', '+++' ],
          ['1234', '1235', '+++' ],

          ['1234', '1266', '++'  ],
          ['1122', '1325', '++'  ],
          ['1234', '6634', '++'  ],
          ['1234', '1654', '++'  ],

          ['1243', '1234', '++--'],
          ['1532', '5132', '++--'],
          ['1234', '1324', '++--'],
          ['1234', '1243', '++--'],

          ['1234', '1245', '++-' ],
          ['1234', '1524', '++-' ],
          ['1234', '5231', '++-' ],
          ['1234', '6134', '++-' ],

          ['1234', '1423', '+---'],
          ['1234', '4213', '+---'],
          ['1234', '2431', '+---'],
          ['1234', '2314', '+---'],

          ['2112', '1222', '+--' ],
          ['2345', '4542', '+--' ],
          ['3444', '4334', '+--' ],
          ['2245', '4125', '+--' ],

          ['5451', '4445', '+-'  ],
          ['1234', '5212', '+-'  ],
          ['1234', '1112', '+-'  ],
          ['1122', '1233', '+-'  ],

          ['1234', '1555', '+'   ],
          ['1234', '1111', '+'   ],
          ['4111', '4444', '+'   ],
          ['1113', '2155', '+'   ],

          ['5556', '1115', '-'   ],
          ['1234', '6653', '-'   ],
          ['1234', '5551', '-'   ],
          ['1234', '5511', '-'   ],

          ['1244', '4156', '--'  ],
          ['1221', '2332', '--'  ],
          ['3331', '1253', '--'  ],
          ['2244', '4526', '--'  ],

          ['5432', '2541', '---' ],
          ['1145', '6514', '---' ],
          ['4611', '1466', '---' ],
          ['1234', '6423', '---' ],

          ['1234', '4321', '----'],
          ['5432', '2345', '----'],
          ['1234', '2143', '----'],
          ['1221', '2112', '----'],

          ['1234', '5555', ''    ],
          ['1234', '5656', ''    ],
          ['1234', '6655', ''    ],
          ['1234', '5665', ''    ]
        ].each do |check|
          it "returns #{check[2]} if code #{check[0]} and guess #{check[1]}" do
            subject.instance_variable_set(:@secret_code, check[0])
            expect(subject.check_guess(check[1])).to eq(check[2])
          end
        end
      end
    end

    context '#score_count' do
      it 'counts scores if win' do
        subject.instance_variable_set(:@secret_code, '1234')
        subject.instance_variable_set(:@player_code, '1234')
        expect(subject.score_count).to be(700)
      end

      it 'counts scores if lose' do
        subject.instance_variable_set(:@attempts, 0)
        subject.instance_variable_set(:@hint, 0)
        expect(subject.score_count).to be(0)
      end
    end
  end
end
