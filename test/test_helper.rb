ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "helpers/auth_helper"
class ActionDispatch::IntegrationTest
  include AuthHelper
end
module BasicAuthHelper
  def visit_with_auth(link_text)
    link = find_link(link_text)[:href]
    uri = URI.parse(link)
    uri.user = "dhh"
    uri.password = "secret"
    visit uri.to_s
  end
  def url_with_auth(url)
    uri = URI.parse(url)
    uri.user = "dhh"
    uri.password = "secret"
    uri.to_s
    visit uri.to_s
  end
  def authorize_user
    headers = { Authorization: ActionController::HttpAuthentication::Basic.encode_credentials("dhh", "secret") }
    return headers
  end
end
module ActiveSupport
  class TestCase
    include BasicAuthHelper
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors, with: :threads)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
