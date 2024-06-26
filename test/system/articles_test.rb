require "application_system_test_case"

class ArticlesTest < ApplicationSystemTestCase
  setup do
    @article = articles(:one)
  end
  
  test "visiting the index" do
    visit articles_url
    assert_selector "h1", text: "Articles"
  end

  test "should create article" do
    visit articles_url
    visit_with_auth( "New Article")
    fill_in "Title", with: "TestTitle"
    fill_in "Body", with: "This is a test"
    click_on "Create Article"
    assert_text "TestTitle"
  end

  test "should update Article" do
    visit article_url(@article)
    visit_with_auth( "Edit")
    fill_in "Title", with: "Updated Title"
    fill_in "Body", with: "Updated Body"
    click_on "Update Article"
    assert_text "Updated Title"
  end

  test "should destroy Article" do
    url_with_auth( article_url(@article))
    #accept_confirm do
    #click_on "Destroy"
    #end
    visit_with_auth("Destroy")
    assert_text "Articles"
  end
end
