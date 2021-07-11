ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require_relative "sign_in_helper"
require "rails/test_help"
require 'minitest/mock'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: 1, with: :threads)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all 今回はfixturesは使わないので削除

  # Add more helper methods to be used by all tests here...
end
