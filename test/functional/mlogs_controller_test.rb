require 'test_helper'

class MlogsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:mlogs)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_mlog
    assert_difference('Mlog.count') do
      post :create, :mlog => { }
    end

    assert_redirected_to mlog_path(assigns(:mlog))
  end

  def test_should_show_mlog
    get :show, :id => mlogs(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => mlogs(:one).id
    assert_response :success
  end

  def test_should_update_mlog
    put :update, :id => mlogs(:one).id, :mlog => { }
    assert_redirected_to mlog_path(assigns(:mlog))
  end

  def test_should_destroy_mlog
    assert_difference('Mlog.count', -1) do
      delete :destroy, :id => mlogs(:one).id
    end

    assert_redirected_to mlogs_path
  end
end
