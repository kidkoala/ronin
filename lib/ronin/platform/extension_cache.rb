#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#

require 'ronin/platform/extension'
require 'ronin/platform/exceptions/extension_not_found'

module Ronin
  module Platform
    class ExtensionCache < Hash

      #
      # Creates a new empty ExtensionCache object.
      #
      # @yield [cache]
      #   If a block is given, it will be passed the newly created
      #   extension cache.
      #
      # @yieldparam [ExtensionCache] cache
      #   The newly created extension cache.
      #
      def initialize
        super() do |hash,key|
          name = key.to_s

          hash[name] = load_extension(name)
        end

        at_exit do
          each_extension { |ext| ext.teardown! }
        end

        yield self if block_given?
      end

      #
      # @return [Array]
      #   The sorted names of the extensions within the cache.
      #
      def names
        keys.sort
      end

      alias extensions values
      alias each_extension each_value

      #
      # Selects the extensions within the cache that satisfies the given
      # block.
      #
      # @yield [ext]
      #   The block will be passed each extension, and the extension will
      #   be selected based on the return value of the block.
      #
      # @yieldparam [Extension] ext
      #   An extension from the cache.
      #
      # @return [Array]
      #   The selected extensions.
      #
      def with(&block)
        values.select(&block)
      end

      #
      # Searches within the cache for the extension with the specified name.
      #
      # @return [Boolean]
      #   Specifies whether the cache contains the extension with the
      #   specified name.
      #
      def has?(name)
        has_key?(name.to_s)
      end

      #
      # Loads the extension with the specified name.
      #
      # @param [String, Symbol] name
      #   The name of the extension to load.
      #
      # @raise [ExtensionNotFound]
      #   The extension with the specified name could not be found in
      #   the extension cache.
      #
      def load_extension(name)
        name = name.to_s

        unless Platform.overlays.has_extension?(name)
          raise(ExtensionNotFound,"extension #{name.dump} does not eixst",caller)
        end

        return Extension.new(name) do |ext|
          include(self.name)
          setup!
        end
      end

      #
      # Reloads one or all extensions within the extension cache.
      #
      # @param [String, Symbol] name
      #   The specific extension to reload.
      #
      # @return [true]
      #   Specifies the reload was successful.
      #
      def reload!(name=nil)
        reloader = lambda { |ext_name|
          self[ext_name].teardown! if has?(ext_name)

          self[ext_name] = load_extension(ext_name)
        }

        if name
          reloader.call(name)
        else
          each_key(&reloader)
        end

        return true
      end

    end
  end
end
