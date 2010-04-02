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

require 'thread'

module Ronin
  module UI
    class AsyncConsole

      # The result message class
      Message = Struct.new(:line, :type, :value)

      #
      # Creates a new Asynchronous Console, within the given context.
      #
      # @param [Module] context
      #   The context to evaluate code within.
      #
      def initialize(context=Ronin)
        @context = context
        @line = 0

        @input = Queue.new
        @output = Queue.new

        Thread.new(@context) do |context|
          sandbox = Object.new
          sandbox.extend context

          scope = sandbox.send :binding

          loop do
            line, code = @input.pop

            begin
              result = if code.kind_of?(Proc)
                         sandbox.instance_eval(&code)
                       else
                         eval(code,scope)
                       end

              mesg = Message.new(line, :result, result)
            rescue Exception => e
              mesg = Message.new(line, :exception, e)
            end

            @output.push mesg
          end
        end
      end

      #
      # Enqueues Ruby code or a block to be evaluated.
      #
      # @param [String] code
      #   The Ruby code to evaluate.
      #
      # @yield []
      #   If a block is given, it will be evaluated.
      #
      # @return [Integer]
      #   The line number assigned to the pushed code.
      #
      def push(code=nil,&block)
        @input.push [@line += 1, (code || block)]
        return @line
      end

      #
      # Determines whether the output queue is empty.
      #
      # @return [Boolean]
      #   The state of the output queue.
      #
      def empty?
        @output.empy?
      end

      #
      # Dequeues a result.
      #
      # @return [Message]
      #   The result message.
      #
      def pull
        @output.pop unless @output.empty?
      end

      #
      # Enumerates over the results in the output queue.
      #
      # @yield [message]
      #   The given block will be passed each result.
      #
      # @yieldparam [Message] message
      #   A result message returned from a previous evaluation.
      #
      def each(&block)
        until @output.empty?
          block.call(@output.pop)
        end

        return self
      end

    end
  end
end
