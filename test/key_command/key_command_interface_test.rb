# frozen_string_literal: true
# encoding: UTF-8

module KeyCommandInterfaceTest
  def test_implements_the_executable_interface
    assert_respond_to(@command, :execute)
  end

  def test_implements_the_handleable_interface
    assert_respond_to(@command.class, :handles?)
  end

  def test_implements_the_state_interface
    assert_respond_to(@command, :state)
  end

  def test_implements_the_character_interface
    assert_respond_to(@command, :character)
  end
end

module KeyCommandSubclassTest
  def test_responds_to_execute_hook
    assert_respond_to(@command, :execute_hook)
  end

  def test_responds_to_character_code
    assert_respond_to(@command.class, :character_regex)
  end
end
