require 'test_helper'

class WrestlersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @wrestler = wrestlers(:one)
  end

  test "should get index" do
    get wrestlers_url
    assert_response :success
  end

  test "should get new" do
    get new_wrestler_url
    assert_response :success
  end

  test "should create wrestler" do
    assert_difference('Wrestler.count') do
      post wrestlers_url, params: { wrestler: { bio: @wrestler.bio, college: @wrestler.college, college_year: @wrestler.college_year, name: @wrestler.name } }
    end

    assert_redirected_to wrestler_url(Wrestler.last)
  end

  test "should show wrestler" do
    get wrestler_url(@wrestler)
    assert_response :success
  end

  test "should get edit" do
    get edit_wrestler_url(@wrestler)
    assert_response :success
  end

  test "should update wrestler" do
    patch wrestler_url(@wrestler), params: { wrestler: { bio: @wrestler.bio, college: @wrestler.college, college_year: @wrestler.college_year, name: @wrestler.name } }
    assert_redirected_to wrestler_url(@wrestler)
  end

  test "should destroy wrestler" do
    assert_difference('Wrestler.count', -1) do
      delete wrestler_url(@wrestler)
    end

    assert_redirected_to wrestlers_url
  end
end
