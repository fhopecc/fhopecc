require 'test_helper'

class MonthTagSummariesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:month_tag_summaries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create month_tag_summary" do
    assert_difference('MonthTagSummary.count') do
      post :create, :month_tag_summary => { }
    end

    assert_redirected_to month_tag_summary_path(assigns(:month_tag_summary))
  end

  test "should show month_tag_summary" do
    get :show, :id => month_tag_summaries(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => month_tag_summaries(:one).id
    assert_response :success
  end

  test "should update month_tag_summary" do
    put :update, :id => month_tag_summaries(:one).id, :month_tag_summary => { }
    assert_redirected_to month_tag_summary_path(assigns(:month_tag_summary))
  end

  test "should destroy month_tag_summary" do
    assert_difference('MonthTagSummary.count', -1) do
      delete :destroy, :id => month_tag_summaries(:one).id
    end

    assert_redirected_to month_tag_summaries_path
  end
end
