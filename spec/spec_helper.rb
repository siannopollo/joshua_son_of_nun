require 'rubygems'
require 'spec'

require 'init'

module Kernel
  require 'cgi'
  
  def rputs(*args)
    puts *["<pre>", args.collect {|a| CGI.escapeHTML(a.inspect)}, "</pre>"]
  end
end