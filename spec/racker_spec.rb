feature Racker do
  context 'action in root path' do
    before { visit '/' }
    after  { expect(page).to have_current_path('/') }

    scenario 'start game' do
  	  click_button('Start') || click_button('New game')
      expect(page).to have_content('Your guess:')
  	end

    context 'player inputs code' do
      scenario 'decreases attempts' do
        click_button('Start')
        fill_in('guess', with: '1111')
        click_button('Try!')
        expect(page).to have_content('8 attempts')
      end

      context 'player inputs "hint"' do
        before do
          click_button('Start')
          fill_in('guess', with: 'hint')
          click_button('Try!')
        end

        scenario 'decreases number of hint' do
          expect(page).to have_content('0 hint')
        end

        scenario 'not decreases number of attempts' do
          expect(page).to have_content("9 attempts")
        end

        scenario 'shows hint' do
          expect(page).to have_content('Hint: Secret code contains:')
        end
      end

      scenario 'shows game_over' do
        click_button('Start')
        10.times do
          fill_in('guess', with: '1111')
          click_button('Try!')
        end

        expect(page).to have_content('Game over!')
      end
    end
  end

  context 'render score' do
    before { visit '/score' }

    scenario 'visits "/score" path' do
      expect(page).to have_content('You score attached at the end of the list')
      expect(page).to have_current_path('/score')
    end

    scenario 'starts new game from "/score" path' do
      click_button('New game')
      expect(page).to have_current_path('/')
    end
  end

  scenario 'unknown path' do
    visit '/unknown'
    expect(status_code).to be(404)
  end
end
