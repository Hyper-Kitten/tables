require "rails_helper"

RSpec.feature "User management", :type => :feature do
  scenario "user can view users" do
    user = create_user_and_login
    user = create(:user, name: "Elvis Costello")

    visit hyper_kitten_meow.admin_users_path

    expect(page).to have_text("Elvis Costello")
  end

  scenario "user can paginate through the users" do
    create_user_and_login
    # The user created for logging in also is included here
    users = FactoryBot.create_list(:user, 10)

    visit hyper_kitten_meow.admin_users_path
    expect(page).to have_selector('.user', count: 10)
    click_on('Next')

    expect(page).to have_selector('.user', count: 1)
  end

  scenario "user can edit users " do
    create_user_and_login(name: 'Andrew')
    user = create(:user, name: 'Josh')

    visit hyper_kitten_meow.edit_admin_user_path(user)

    expect(page).to have_text("Josh")

    fill_in "Name", with: "Elvis"
    fill_in "Email", with: "test@test.com"
    click_on "Update User"

    expect(page).to have_text("Elvis")
    expect(page).to have_text("test@test.com")
  end

  scenario "user can create users " do
    user = create_user_and_login(name: 'Andrew')

    visit hyper_kitten_meow.new_admin_user_path
    fill_in "Name", with: "David Byrne"
    fill_in "Email", with: "test@test.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_on "Create User"

    expect(page).to have_text("David Byrne")
    expect(page).to have_text("test@test.com")
  end

  scenario "user can fix invalid users" do
    user = create_user_and_login
    visit hyper_kitten_meow.new_admin_user_path

    fill_in "Name", with: "Prince"
    fill_in "Email", with: "test@test.com"
    click_on "Create User"

    expect(page).to have_text("Password can't be blank")
  end
end
