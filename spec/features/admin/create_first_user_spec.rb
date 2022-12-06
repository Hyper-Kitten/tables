require "rails_helper"

RSpec.feature "Creating the first user", :type => :feature do
  context "when there are no users" do
    scenario "trying to login redirects to the first user form" do
      visit hyper_kitten_meow.admin_login_path

      expect(page).to have_current_path(hyper_kitten_meow.new_admin_first_user_path)
    end

    scenario "visitor can create first user" do
      visit hyper_kitten_meow.new_admin_first_user_path

      fill_in "Name", with: "David Byrne"
      fill_in "Email", with: "test@test.com"
      fill_in "Password", with: "password"
      fill_in "Password confirmation", with: "password"
      click_on "Create User"

      expect(page).to have_current_path(hyper_kitten_meow.admin_login_path)
      expect(page).to have_text("User successfully created. Please log in.")
    end
  end

  context "when there are users" do
    scenario "trying to create a first user redirects to the login page" do
      create(:user)

      visit hyper_kitten_meow.new_admin_first_user_path

      expect(page).to have_current_path(hyper_kitten_meow.admin_login_path)
    end
  end
end
