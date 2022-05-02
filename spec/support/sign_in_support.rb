module SignInSupport
  def sign_in(user)
    year = Date.today.year
    month = Date.today.month
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    find('input[name="commit"]').click
    expect(current_path).to eq(year_month_spends_path(year, month))
  end
end