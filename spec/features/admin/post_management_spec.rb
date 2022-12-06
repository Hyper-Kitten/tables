require "rails_helper"

RSpec.feature "Post management", :type => :feature do
  scenario "user can view posts" do
    user = create_user_and_login
    post = create(:post, title: "My Title")

    visit hyper_kitten_meow.admin_posts_path

    expect(page).to have_text("My Title")
  end

  it "paginates posts" do
    create_user_and_login
    paginates(factory: :post, increment: 10, selector: ".post") do
      visit hyper_kitten_meow.admin_posts_path
    end
  end

  scenario "user can edit posts " do
    user = create_user_and_login(name: 'Andrew')
    user = create(:user, name: 'Josh')
    post = create(:post, title: "My Title")
    tag = create(:tag, label: 'coffee')

    visit hyper_kitten_meow.edit_admin_post_path(post)

    expect(page).to have_text("My Title")

    fill_in "Title", with: "Hello World!"
    fill_in "Summary", with: "My great summary!"
    fill_in "Slug", with: "my slug"
    check "coffee"
    select "Josh", from: "post[user_id]"
    check "Published"
    click_on "Update Post"

    expect(page).to have_text("Hello World!")
    expect(page).to have_text("My great summary!")
    expect(page).to have_text("my-slug")
    expect(page).to have_text("Josh")
    expect(page).to have_text("Josh")
    expect(page).to have_text("coffee")
    expect(page).to have_css(".published")
  end

  scenario "user can create posts", js: true do
    user = create_user_and_login(name: 'Andrew')
    user = create(:user, name: 'Josh')
    tag = create(:tag, label: 'coffee')

    visit hyper_kitten_meow.new_admin_post_path
    fill_in "Title", with: "Hello World!"
    fill_in "Summary", with: "My great summary!"
    fill_in_rich_text_area "Body", with: "Fuzzy waffle!"
    fill_in "Slug", with: "my slug"
    select "Josh", from: "post[user_id]"
    check "coffee"
    check "Published"
    click_on "Create Post"

    expect(page).to have_text("Hello World!")
    expect(page).to have_text("My great summary!")
    expect(page).to have_text("my-slug")
    expect(page).to have_css(".published")
    expect(page).to have_text("Josh")
    expect(page).to have_text("coffee")
    expect(page).to have_text("Post successfully created.")
  end

  scenario "user can fix invalid posts" do
    user = create_user_and_login
    visit hyper_kitten_meow.new_admin_post_path

    fill_in "Title", with: ""
    click_on "Create Post"

    expect(page).to have_text("Title can't be blank")
  end
end
