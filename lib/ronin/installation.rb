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

module Ronin
  #
  # The {Installation} module provides methods which help reflect on the
  # installation of Ronin on the system.
  #
  module Installation
    # The loaded gemspecs of all installed ronin libraries
    @gems = {}

    #
    # Finds the installed Ronin libraries via RubyGems.
    #
    # @return [Hash{String => Gem::Specification}]
    #   The names and gem-specs of the installed Ronin libraries.
    #
    # @since 1.0.0
    #
    def Installation.gems
      load_gemspecs! if @gems.empty?
      return @gems
    end

    #
    # The names of the additional Ronin libraries installed on the system.
    #
    # @return [Array<String>]
    #   The library names.
    #
    # @since 1.0.0
    #
    def Installation.libraries
      gems.keys
    end

    #
    # Enumerates over all files within a given directory found in any
    # of the installed Ronin libraries.
    #
    # @param [String] directory
    #   The directory path to search within.
    #
    # @yield [file]
    #   The given block will be passed each file found within the directory.
    #
    # @yieldparam [String] file
    #   The sub-path to the file found within the directory.
    #
    # @return [Enumerator]
    #   Returns an Enumerator if no block is given.
    #
    # @since 1.0.0
    #
    def Installation.each_file(pattern)
      return enum_for(:each_file,pattern) unless block_given?

      # query the installed gems
      gems.each_value do |gem|
        gem_root = gem.full_gem_path
        slice_index = gem_root.length + 1

        Dir.glob(File.join(gem_root,pattern)) do |path|
          yield path[slice_index..-1]
        end
      end

      return nil
    end

    #
    # Enumerates over every file in a directory.
    #
    # @param [String] directory
    #   The directory to search within.
    #
    # @param [String, Symbol] ext
    #   The optional file extension to search for.
    #
    # @yield [name]
    #   The given block will be passed each matching file-name.
    #
    # @yieldparam [String] name
    #   The basename of the matching path within the directory.
    #
    # @return [Enumerator]
    #   If no block is given, an Enumerator will be returned.
    #
    # @since 1.0.0
    #
    def Installation.each_file_in(directory,ext=nil)
      return enum_for(:each_file_in,directory,ext) unless block_given?

      pattern = File.join(directory,'**','*')
      pattern << ".#{ext}" if ext

      slice_index = directory.length + 1

      each_file(pattern) do |path|
        yield path[slice_index..-1]
      end
    end

    protected

    #
    # Loads the gemspecs for any installed Ronin libraries.
    #
    # @return [true]
    #   All Ronin libraries were successfully found.
    #
    # @since 1.0.0
    #
    def Installation.load_gemspecs!
      ronin_gem = Gem.loaded_specs['ronin']

      if ronin_gem
        @gems['ronin'] = ronin_gem

        ronin_gem.dependent_gems.each do |gems|
          gem = gems.first
          @gems[gem.name] = gem
        end
      else
        # if we cannot find an installed ronin gem, search the $LOAD_PATH
        # for ronin gemspecs and load those
        $LOAD_PATH.each do |lib_dir|
          root_dir = File.expand_path(File.join(lib_dir,'..'))
          gemspec_path = Dir[File.join(root_dir,'ronin*.gemspec')].first

          if gemspec_path
            gem = Gem::SourceIndex.load_specification(gemspec_path)
            @gems[gem.name] = gem
          end
        end
      end

      return true
    end
  end
end
