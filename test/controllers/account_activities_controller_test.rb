require 'test_helper'

class AccountActivitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account_activity = account_activities(:one)
  end

  test "should get index" do
    get account_activities_url
    assert_response :success
  end

  test "should get new" do
    get new_account_activity_url
    assert_response :success
  end

  test "should create account_activity" do
    assert_difference('AccountActivity.count') do
      post account_activities_url, params: { account_activity: { account_id: @account_activity.account_id, amount: @account_activity.amount, order_id: @account_activity.order_id } }
    end

    assert_redirected_to account_activity_url(AccountActivity.last)
  end

  test "should show account_activity" do
    get account_activity_url(@account_activity)
    assert_response :success
  end

  test "should get edit" do
    get edit_account_activity_url(@account_activity)
    assert_response :success
  end

  test "should update account_activity" do
    patch account_activity_url(@account_activity), params: { account_activity: { account_id: @account_activity.account_id, amount: @account_activity.amount, order_id: @account_activity.order_id } }
    assert_redirected_to account_activity_url(@account_activity)
  end

  test "should destroy account_activity" do
    assert_difference('AccountActivity.count', -1) do
      delete account_activity_url(@account_activity)
    end

    assert_redirected_to account_activities_url
  end
end
