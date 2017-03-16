require 'test_helper'

class AssemblyControllerControllerTest < ActionDispatch::IntegrationTest
  test "should get deletetag" do
    get assembly_controller_deletetag_url
    assert_response :success
  end

  test "should get edittag" do
    get assembly_controller_edittag_url
    assert_response :success
  end

  test "should get deletewallet" do
    get assembly_controller_deletewallet_url
    assert_response :success
  end

  test "should get editwallet" do
    get assembly_controller_editwallet_url
    assert_response :success
  end

end
