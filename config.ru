#!/usr/bin/env ruby

$LOAD_PATH.unshift ::File.expand_path(::File.join(::File.dirname(__FILE__),'lib'))

require 'rubygems'
require 'ronin/ui/web'

run Ronin::UI::Web.app
