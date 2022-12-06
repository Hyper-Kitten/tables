require "rails_helper"

RSpec.feature "Menu management", :type => :feature do
  scenario "user can view posts" do
    user = create_user_and_login
    menu = create(:menu, name: "My Title")

    visit hyper_kitten_meow.admin_menus_path

    expect(page).to have_text("My Title")
  end

  scenario "user can create a menu" do
    user = create_user_and_login
    static_page = create(:page, title: "My Page")

    visit hyper_kitten_meow.new_admin_menu_path

    fill_in "Name", with: "Hello World!"
    select "My Page", from: "Page"
    fill_in "Title", with: "My Title"
    check "New window"
    click_button "Create Menu"

    expect(page).to have_text("Menu was successfully created.")
    expect(page).to have_text("Hello World!")
    menu = HyperKittenMeow::Menu.last
    menu_item = menu.menu_items.first
    expect(menu_item.title).to eq("My Title")
    expect(menu_item.page).to eq(static_page)
    expect(menu_item.new_window).to eq(true)
    expect(menu_item.position).to eq(1)
  end

  scenario "user can edit menus" do
    user = create_user_and_login(name: 'Andrew')
    menu = create(:menu, name: "My Menu")
    static_page = create(:page, title: "My Page")

    visit hyper_kitten_meow.edit_admin_menu_path(menu)

    expect(page).to have_text("My Menu")

    fill_in "Name", with: "Hello World!"
    select "My Page", from: "Page"
    fill_in "Title", with: "My Title"
    click_on "Update Menu"

    expect(page).to have_text("Menu was successfully updated.")
    expect(page).to have_text("Hello World!")
    menu.reload
    menu_item = menu.menu_items.first
    expect(menu_item.title).to eq("My Title")
    expect(menu_item.page).to eq(static_page)
    expect(menu_item.position).to eq(1)
  end

  scenario "user can edit menus and add menu items", js: true do
    user = create_user_and_login(name: 'Andrew')
    menu = create(:menu, name: "My Menu")
    static_page1 = create(:page, title: "My Page 1")
    static_page2 = create(:page, title: "My Page 2")

    visit hyper_kitten_meow.edit_admin_menu_path(menu)

    expect(page).to have_text("My Menu")

    click_on "Add Menu Item"
    expect(page).to have_selector(".menu-item", count: 2)
    menu_items = all(".menu-item")
    within menu_items.first do
      select "My Page 1", from: "Page"
      fill_in "Title", with: "First Item"
    end
    within menu_items.last do
      select "My Page 2", from: "Page"
      fill_in "Title", with: "Second Item"
    end
    click_on "Update Menu"

    expect(page).to have_text("My Menu")
    menu.reload
    expect(menu.menu_items.size).to eq(2)
    menu_item = menu.menu_items.first
    expect(menu_item.title).to eq("First Item")
    expect(menu_item.page).to eq(static_page1)
    expect(menu_item.position).to eq(1)
    menu_item2 = menu.menu_items.last
    expect(menu_item2.title).to eq("Second Item")
    expect(menu_item2.page).to eq(static_page2)
    expect(menu_item2.position).to eq(2)
  end

  scenario "user can edit menus and remove menu items", js: true do
    user = create_user_and_login(name: 'Andrew')
    menu = create(:menu, name: "My Menu")
    static_page1 = create(:page, title: "My Page 1")
    static_page2 = create(:page, title: "My Page 2")
    create(:menu_item, menu: menu, page: static_page1, title: "First Item", position: 1)
    create(:menu_item, menu: menu, page: static_page2, title: "Second Item", position: 2)

    visit hyper_kitten_meow.edit_admin_menu_path(menu)

    expect(page).to have_text("My Menu")
    expect(page).to have_selector(".menu-item", count: 2)
    menu_items = all(".menu-item")
    within menu_items.first do
      click_on "Remove"
    end
    click_on "Update Menu"

    expect(page).to have_text("My Menu")
    menu.reload
    expect(menu.menu_items.size).to eq(1)
    menu_item = menu.menu_items.first
    expect(menu_item.title).to eq("Second Item")
    expect(menu_item.page).to eq(static_page2)
    expect(menu_item.position).to eq(1)
  end

  scenario "user can delete a menu" do
    user = create_user_and_login(name: 'Andrew')
    menu = create(:menu, name: "My Menu")
    static_page1 = create(:page, title: "My Page 1")
    static_page2 = create(:page, title: "My Page 2")
    create(:menu_item, menu: menu, page: static_page1, title: "First Item", position: 1)
    create(:menu_item, menu: menu, page: static_page2, title: "Second Item", position: 2)

    visit hyper_kitten_meow.admin_menus_path

    click_on "Delete"

    expect(page).to have_text("Menu was successfully deleted.")
    expect(page).to_not have_text("My Menu")
  end
end

