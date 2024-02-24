require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  test "should get end" do
    get comments_end_url
    assert_response :success
  end
end
