#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin.
#
# Ronin is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ronin.  If not, see <http://www.gnu.org/licenses/>.
#

require 'ronin/model'

module Ronin
  autoload :UserName, 'ronin/user_name'
  autoload :Password, 'ronin/password'

  #
  # Represents Credentials used to access services or websites.
  #
  class Credential

    include Model

    # Primary key of the credential
    property :id, Serial

    # Password of the credential
    belongs_to :password

    # User name of the credential
    belongs_to :user_name

    #
    # Searches for all credentials for a specific user.
    #
    # @param [String] name
    #   The name of the user.
    #
    # @return [Array<Credential>]
    #   The credentials for the user.
    #
    # @since 1.0.0
    #
    def self.for_user(name)
      all('user_name.name' => name)
    end

    #
    # Searches for all credentials with a common password.
    #
    # @param [String] password
    #   The password to search for.
    #
    # @return [Array<Credential>]
    #   The credentials with the common password.
    #
    # @since 1.0.0
    #
    def self.with_password(password)
      all('password.clear_text' => password)
    end

    #
    # The user the credential belongs to.
    #
    # @return [String]
    #   The user name.
    #
    # @since 1.0.0
    #
    def user
      self.user_name.name if self.user_name
    end

    #
    # The clear-text password of the credential.
    #
    # @return [String]
    #   The clear-text password.
    #
    # @since 1.0.0
    #
    def clear_text
      self.password.clear_text if self.password
    end

    #
    # Converts the credentials to a String.
    #
    # @return [String]
    #   The user name and the password.
    #
    # @since 1.0.0
    #
    def to_s
      "#{self.user_name}:#{self.password}"
    end

    #
    # Splits the credential to multiple variables.
    #
    # @return [Array<String>]
    #   The user and the password.
    #
    # @example
    #   user, password = cred
    #
    #   user
    #   # => "alice"
    #   password
    #   # => "secret"
    #
    # @since 1.0.0
    #
    def to_ary
      [self.user_name.name, self.password.clear_text]
    end

  end
end
