# frozen_string_literal: true

require_relative "defined_mock/instance_mock"
require_relative "defined_mock/version"

module Minitest
  module DefinedMock
    class ExpectationError < StandardError; end

    def self.new(klass)
      ::Minitest::DefinedMock::InstanceMock.new(klass)
    end
  end
end
