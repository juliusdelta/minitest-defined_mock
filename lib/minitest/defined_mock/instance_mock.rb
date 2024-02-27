# frozen_string_literal: true

require "minitest/mock"

module Minitest
  module DefinedMock
    class InstanceMock < Minitest::Mock
      def initialize(klass)
        @klass_name = klass.name
        @klass = klass

        super()
      end

      def expect(name, retval, args = [], **kwargs, &blk)
        @method_name = name
        @method_args = args
        @method_kwargs = kwargs

        super
      end

      def verify
        expected_method = @klass.instance_method(@method_name)
        expected_method_arity = expected_method.parameters.size

        args_size = @method_args.size
        keyword_args_size = @method_kwargs.size

        # Handle keyword args
        expected_method_parameters = expected_method.parameters
        expected_key_params = expected_method_parameters.map { |param| param[1] if param[0] == :keyreq }
        key_word_args_match = @method_kwargs.keys.all? { |k| expected_key_params.include?(k) }

        unless instance_method_exists?
          raise ExpectationError, "expected `#{@klass_name}` to define method `#{@method_name}`"
        end

        unless expected_method_arity == (args_size + keyword_args_size)
          raise ExpectationError, "#{@method_name} expects #{expected_method_arity} arguments but #{args_size} were provided"
        end

        unless key_word_args_match
          raise ExpectationError, "#{@method_name} expects keyword arguments #{expected_key_params} but #{@method_kwargs.keys} were provided"
        end

        super
      end

      private

      def instance_method_exists?
        @klass.instance_methods.include?(@method_name)
      end
    end
  end
end
