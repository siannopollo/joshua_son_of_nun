require 'rubygems'
require 'spec'

require 'init'

module Kernel
  require 'cgi'
  
  def rputs(*args)
    puts *["<pre>", args.collect {|a| CGI.escapeHTML(a.inspect)}, "</pre>"]
  end
end

def Space(string)
  coordinates, orientation = string.split(' ')
  row, column = coordinates.scan(/(\w)(\d{1,2})/).first
  JoshuaSonOfNun::Space.new(row, column, orientation)
end
