require 'specter/version'
require 'specter/cli'
require 'specter/server'

module Specter

  ##
  # Raised when an incoming request is malformed in some way.
  class RequestError < StandardError; end
end # Specter
