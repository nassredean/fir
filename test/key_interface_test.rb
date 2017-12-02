# frozen_string_literal: true
# encoding: UTF-8

module KeyInterfaceTest
  def test_implements_the_get_interface
    assert_respond_to(@key, :get)
  end
end
