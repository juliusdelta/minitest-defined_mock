# frozen_string_literal: true

class TestDefinedMock < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Minitest::DefinedMock::VERSION
  end
end
