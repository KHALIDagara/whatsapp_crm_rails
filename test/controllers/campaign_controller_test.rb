require "test_helper"

class CampaignControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get campaign_new_url
    assert_response :success
  end

  test "should get create" do
    get campaign_create_url
    assert_response :success
  end

  test "should get show" do
    get campaign_show_url
    assert_response :success
  end
end
