require "application_system_test_case"

class AccountActivitiesTest < ApplicationSystemTestCase
  setup do
    @account_activity = account_activities(:one)
  end

  test "visiting the index" do
    visit account_activities_url
    assert_selector "h1", text: "Account Activities"
  end

  test "creating a Account activity" do
    visit account_activities_url
    click_on "New Account Activity"

    fill_in "Account", with: @account_activity.account_id
    fill_in "Amount", with: @account_activity.amount
    fill_in "Order", with: @account_activity.order_id
    click_on "Create Account activity"

    assert_text "Account activity was successfully created"
    click_on "Back"
  end

  test "updating a Account activity" do
    visit account_activities_url
    click_on "Edit", match: :first

    fill_in "Account", with: @account_activity.account_id
    fill_in "Amount", with: @account_activity.amount
    fill_in "Order", with: @account_activity.order_id
    click_on "Update Account activity"

    assert_text "Account activity was successfully updated"
    click_on "Back"
  end

  test "destroying a Account activity" do
    visit account_activities_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Account activity was successfully destroyed"
  end
end
