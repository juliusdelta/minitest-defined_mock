# frozen_string_literal: true

require "test_helper"

class DependencyTestClass
  def method_with_ordered_args(a, b)
    a + b
  end

  def method_with_keyword_args(arg_1:, arg_2:)
    [arg_1, arg_2]
  end

  def method_with_keyword_ordered_args(arg_1, arg_2:)
    [arg_1, arg_2]
  end

  def method_with_wrong_keyword_args(arg_1:, arg_2:)
  end

  def method_for_wrong_arity(arg_1)
    [arg_1]
  end

  def method_with_no_args
    []
  end
end

class DependencyCaller
  def call_method_with_ordered_args(obj)
    obj.method_with_ordered_args(1, 2)
  end

  def call_method_with_keyword_args(obj)
    obj.method_with_keyword_args(arg_1: 1, arg_2: 2)
  end

  def call_method_with_keyword_ordered_args(obj)
    obj.method_with_keyword_ordered_args(1, arg_2: 2)
  end

  def call_method_with_wrong_keyword_args(obj)
    obj.method_with_wrong_keyword_args(wrong_arg_1: 1, wrong_arg_2: 2)
  end

  def call_method_for_wrong_arity(obj)
    obj.method_for_wrong_arity
  end

  def call_method_with_no_args(obj)
    obj.method_with_no_args
  end
end

class TestInstanceMock < Minitest::Test
  def setup
    @caller = DependencyCaller.new
  end

  def test_basic_dependency_usage_passes
    mock = Minitest::DefinedMock.new(DependencyTestClass)
    mock.expect(:method_with_ordered_args, 3, [1, 2])

    @caller.call_method_with_ordered_args(mock)

    assert_mock mock
  end

  def test_raises_error_with_wrong_number_of_ordered_args
    mock = Minitest::DefinedMock.new(DependencyTestClass)
    mock.expect(:method_for_wrong_arity, nil, [])
    @caller.call_method_for_wrong_arity(mock)

    assert_raises(Minitest::DefinedMock::ExpectationError) do
      assert_mock mock
    end
  end

  def test_raises_error_with_wrong_keyword_args
    mock = Minitest::DefinedMock.new(DependencyTestClass)
    mock.expect(:method_with_wrong_keyword_args, nil, [], wrong_arg_1: 1, wrong_arg_2: 2)
    @caller.call_method_with_wrong_keyword_args(mock)

    assert_raises(Minitest::DefinedMock::ExpectationError) do
      assert_mock mock
    end
  end

  def test_key_word_arguments
    mock = Minitest::DefinedMock.new(DependencyTestClass)
    mock.expect(:method_with_keyword_args, nil, [], arg_1: 1, arg_2: 2)
    @caller.call_method_with_keyword_args(mock)

    assert_mock mock
  end

  def test_key_word_and_ordered_args
    mock = Minitest::DefinedMock.new(DependencyTestClass)
    mock.expect(:method_with_keyword_ordered_args, nil, [1], arg_2: 2)

    @caller.call_method_with_keyword_ordered_args(mock)

    assert_mock mock
  end

  def test_no_args
    mock = Minitest::DefinedMock.new(DependencyTestClass)
    mock.expect(:method_with_no_args, nil, [])

    @caller.call_method_with_no_args(mock)

    assert_mock mock
  end
end
