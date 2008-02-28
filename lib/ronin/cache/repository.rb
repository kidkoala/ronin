#
#--
# Ronin - A ruby development platform designed for information security
# and data exploration tasks.
#
# Copyright (c) 2006-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
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
#++
#

require 'ronin/cache/extension'
require 'ronin/cache/exceptions/extension_not_found'
require 'ronin/cache/repository_cache'
require 'ronin/cache/config'

require 'repertoire/repository'
require 'rexml/document'

module Ronin
  module Cache
    class Repository < Repertoire::Repository

      # Repository metadata XML file name
      METADATA_FILE = 'ronin.xml'

      # Local path to the repository
      attr_reader :path

      # Media type
      attr_reader :media

      # Source URI of the repository source
      attr_reader :uri

      # Name of the repository
      attr_reader :name

      # Authors of the repository
      attr_reader :authors

      # License that the repository contents is under
      attr_reader :license

      # Description
      attr_reader :description

      #
      # Creates a new Repository object with the specified _path_, _media_
      # and _uri_.
      #
      def initialize(path,media=:local,uri=nil,&block)
        @path = File.expand_path(path)
        @uri = uri

        super(@path,Repertoire::Media.types[media])

        load_metadata(&block)
      end

      #
      # Load the Repository Cache from the given _path_. If _path is not
      # given, it will default to <tt>Config::REPOSITORY_CACHE_PATH</tt>.
      # If a _block_ is given it will be passed the loaded Repository Cache.
      #
      #   Repository.load_cache # => Cache
      #
      #   Repository.load_cache('/custom/cache') # => Cache
      #
      def Repository.load_cache(path=Config::REPOSITORY_CACHE_PATH,&block)
        @@cache = RepositoryCache.new(path,&block)
      end

      #
      # Returns the current Repository Cache, or loads the default Cache
      # if not already loaded.
      #
      def Repository.cache
        @@cache ||= load_cache
      end

      #
      # Saves the repository cache. If a _block_ is given, it will be passed
      # the repository cache before being saved.
      #
      #   Repository.save_cache # => RepositoryCache
      #
      #   Repository.save_cahce do |cache|
      #     puts "Saving cache #{cache}"
      #   end
      #
      def Repository.save_cache(&block)
        Repository.cache.save(&block)
      end

      #
      # Returns the repository with the specified _name_ from the repository
      # cache. If no such repository exists, +nil+ is returned.
      #
      #   Repository['awesome']
      #
      def Repository.[](name)
        Repository.cache[name]
      end

      #
      # Returns +true+ if there is a repository with the specified _name_
      # in the repository cache, returns +false+ otherwise.
      #
      def Repository.exists?(name)
        Repository.cache.has_repository?(name)
      end

      #
      # Returns the repository with the specified _name_ from the repository
      # cache. If no such repository exists in the repository cache,
      # a RepositoryNotFound exception will be raised.
      #
      def Repository.get(name)
        Repository.cache.get_repository(name)
      end

      #
      # Installs the Repository specified by _options_ into the
      # <tt>Config::REPOSITORY_DIR</tt>. If a _block_ is given, it will be
      # passed the newly created Repository after it has been added to
      # the Repository cache.
      #
      # _options_ must contain the following key:
      # <tt>:uri</tt>:: The URI of the Repository.
      #
      # _options_ may contain the following key:
      # <tt>:media</tt>:: The media of the Repository.
      #
      def Repository.install(options={},&block)
        Repertoire.checkout(:media => options[:media], :uri => options[:uri], :into => Config::REPOSITORY_DIR) do |path,media,uri|
          return Repository.add(path,media,uri,&block)
        end
      end

      #
      # Adds the Repository specified by _media_, _path_ and _uri_ to the
      # Repository cache. If a _block is given, it will be passed the
      # newly created Repository after it has been added to the cache.
      #
      def Repository.add(path,media=:local,uri=nil,&block)
        Repository.new(path,media,uri).add(&block)
      end

      #
      # Updates the repository with the specified _name_. If there is no
      # repository with the specified _name_ in the repository cache
      # a RepositoryNotFound exception will be raised. If a _block_ is
      # given it will be passed the updated repository.
      #
      def Repository.update(name,&block)
        Repository.get(name).update(&block)
      end

      #
      # Removes the repository with the specified _name_. If there is no
      # repository with the specified _name_ in the repository cache
      # a RepositoryNotFound exception will be raised. If a _block_ is
      # given it will be passed the repository before removal.
      #
      def Repository.remove(name,&block)
        Repository.get(name).remove(&block)
      end

      #
      # Uninstall the repository with the specified _name_. If there is no
      # repository with the specified _name_ in the repository cache
      # a RepositoryNotFound exception will be raised. If a _block_ is
      # given it will be passed the repository before uninstalling it.
      #
      def Repository.uninstall(name,&block)
        Repository.get(name).uninstall(&block)
      end

      #
      # See Cache#each_repository.
      #
      def Repository.each(&block)
        Repository.cache.each_repository(&block)
      end

      #
      # See Cache#repositories_with?.
      #
      def Repository.with(&block)
        Repository.cache.repositories_with(&block)
      end

      #
      # Returns the repositories which contain the extension with the
      # matching _name_.
      #
      #   Repository.with_extension?('exploits') # => [...]
      #
      def Repository.with_extension(name)
        Repository.with { |repo| repo.has_extension?(name) }
      end

      #
      # Returns the names of all extensions within the repository cache.
      #
      def Repository.extensions
        Repository.cache.repositories.map { |repo| repo.extensions }.flatten.uniq
      end

      #
      # Iterates through the extension names within the repository cache,
      # passing each to the specified _block_.
      #
      #   Repository.each_extension do |name|
      #     puts name
      #   end
      #
      def Repository.each_extension(&block)
        Repository.extension.each(&block)
      end

      #
      # Returns +true+ if the cache has the extension with the matching
      # _name_, returns +false+ otherwise.
      #
      def Repository.has_extension?(name)
        Repository.each do |repo|
          return true if repo.has_extension?(name)
        end

        return false
      end

      #
      # Returns the paths of all extensions within the repository cache.
      #
      def Repository.extension_paths
        paths = []

        Repository.each { |repo| paths += repo.extension_paths }

        return paths
      end

      #
      # Iterates over the paths of all extensions with the specified
      # _name_ within the repository cache, passing each to the specified
      # _block_.
      #
      def Repository.each_extension_path(&block)
        Repository.extension_paths.each(&block)
      end

      #
      # Returns the paths of all extensions with the specified _name_
      # within the repository cache.
      #
      def Repository.paths_for_extension(name)
        Repository.with_extension(name).map { |repo| File.join(repo.path,name) }
      end

      #
      # Iterates over the paths of all extensions with the specified
      # _name_ within the repository cache, passing each to the specified
      # _block_.
      #
      def Repository.each_path_for_extension(name,&block)
        Repository.paths_for_extension(name).each(&block)
      end

      #
      # Loads all similar extensions with the specified _name_ within the
      # repository cache, into one single Extension object. If a _block_
      # is given, it will be passed the newly created Extension object.
      #
      #   Repository.extension('shellcode') # => Extension
      #
      #   Repository.extension('shellcode') do |ext|
      #     return ext.search('bindshell')
      #   end
      #
      def Repository.extension(name,&block)
        name = name.to_s

        unless Repository.has_extension?(name)
          raise(ExtensionNotFound,"extension #{name.dump} does not exist",caller)
        end

        return Extension.load_extensions(name,&block)
      end

      #
      # Adds the repository to the repository cache. If a _block is given,
      # it will be passed the newly created Repository after it has been
      # added to the cache.
      #
      def add(&block)
        Repository.cache.add(self)

        block.call(self) if block
        return self
      end

      #
      # Updates the repository and reloads it's metadata. If a _block_
      # is given it will be called after the repository has been updated.
      #
      def update(&block)
        return self if @media==:local

        Repertoire.update(:media => @media, :path => @path, :uri => @uri)
        return load_metadata(&block)
      end

      #
      # Removes the repository from the repository cache. If a _block_ is
      # given, it will be passed the repository after it has been removed.
      #
      def remove(&block)
        Repository.cache.remove(self)

        block.call(self) if block
        return self
      end

      #
      # Deletes the repository then removes it from the repository cache.
      # If a _block_ is given, it will be passed the repository after it
      # has been uninstalled.
      #
      def uninstall(&block)
        Repertoire.delete(@path) do
          return remove(&block)
        end
      end

      #
      # Returns the paths of all extensions within the repository.
      #
      def extension_paths
        directories
      end

      #
      # Passes each extension path to the specified _block_.
      #
      def each_extension_path(&block)
        extension_paths.each(&block)
      end

      #
      # Returns the names of all extensions within the repository.
      #
      def extensions
        extension_paths.map { |dir| File.basename(dir) }
      end

      #
      # Passes each extension name to the specified _block_.
      #
      def each_extension(&block)
        extensions.each(&block)
      end

      #
      # Returns +true+ if the repository contains the extension with the
      # specified _name_, returns +false+ otherwise.
      #
      def has_extension?(name)
        extensions.include?(name.to_s)
      end

      #
      # Loads an extension with the specified _name_ from the repository.
      # If a _block_ is given, it will be passed the newly created
      # extension.
      #
      #   repo.extension('awesome') # => Extension
      #
      #   repo.extension('shellcode') do |ext|
      #     ...
      #   end
      #
      def extension(name,&block)
        name = name.to_s

        unless has_extension?(name)
          raise(ExtensionNotfound,"repository #{name.dump} does not contain the extension #{name.dump}",caller)
        end

        return Extension.load_extension(File.join(@path,name),&block)
      end

      #
      # Returns the +name+ of the Repository.
      #
      def to_s
        @name.to_s
      end

      protected

      #
      # Loads the repository metadata from the METADATA_FILE within the
      # repository +path+. If a _block_ is given, it will be passed the
      # repository after the metadata has been loaded.
      #
      def load_metadata(&block)
        metadata_path = File.join(@path,METADATA_FILE)

        if File.file?(metadata_path)
          metadata = REXML::Document.new(open(metadata_path))

          #@authors = Author.from_xml(metadata,'/ronin-repository/contributors/author')

          metadata.elements.each('/ronin-repository') do |repo|
            @name = repo.elements['name'].get_text.to_s.strip
            @license = repo.elements['license'].get_text.to_s.strip
            @description = repo.elements['description'].get_text.to_s.strip
          end
        else
          @name = File.basename(@path)
          @authors = []
          @license = nil
          @description = ''
        end

        block.call(self) if block
        return self
      end

    end
  end
end
