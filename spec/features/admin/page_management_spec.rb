require "rails_helper"

RSpec.feature "Page management", :type => :feature do
  scenario "user can view pages" do
    user = create_user_and_login
    static_page = create(:page, title: "My Title")

    visit hyper_kitten_meow.admin_pages_path

    expect(page).to have_text("My Title")
  end

  it "paginates pages" do
    create_user_and_login
    paginates(factory: :page, increment: 10, selector: '.page') do
      visit hyper_kitten_meow.admin_pages_path
    end
  end

  scenario "user can paginate through the pages" do
    create_user_and_login
    pages = FactoryBot.create_list(:page, 11)

    visit hyper_kitten_meow.admin_pages_path
    expect(page).to have_selector('.page', count: 10)
    click_on('Next')

    expect(page).to have_selector('.page', count: 1)
  end

  scenario "user can edit pages", js: true do
    user = create_user_and_login
    static_page = create(:page, title: "My Title")

    visit hyper_kitten_meow.edit_admin_page_path(static_page)

    expect(page).to have_text("My Title")

    fill_in "Title", with: "Hello World!"
    fill_in "Slug", with: "my slug"
    fill_in_rich_text_area "Body", with: "Fuzzy waffle!"
    check "Published"
    click_on "Update Page"

    expect(current_path).to eq(hyper_kitten_meow.admin_pages_path)
    expect(page).to have_text("Hello World!")
    expect(page).to have_text("my-slug")
  end

  scenario "user can create pages", js: true do
    user = create_user_and_login

    visit hyper_kitten_meow.new_admin_page_path
    fill_in "Title", with: "Hello World!"
    fill_in_rich_text_area "Body", with: "Fuzzy waffle!"
    check "Published"
    click_on "Create Page"

    expect(current_path).to eq(hyper_kitten_meow.admin_pages_path)
    expect(page).to have_text("Hello World!")
    expect(page).to have_text("Page successfully created.")
  end

  scenario "user can fix invalid pages", js: true do
    user = create_user_and_login
    visit hyper_kitten_meow.new_admin_page_path

    fill_in "Title", with: ""
    click_on "Create Page"

    expect(page).to have_text("Title can't be blank")
  end
end
