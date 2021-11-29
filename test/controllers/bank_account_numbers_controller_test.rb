require 'test_helper'

class BankAccountNumbersControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get bank_account_numbers_create_url
    assert_response :success
  end

end
