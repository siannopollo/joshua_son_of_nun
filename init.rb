$: << File.expand_path(File.dirname(__FILE__) + '/lib')

require 'joshua_son_of_nun/ship'
require 'joshua_son_of_nun/board'
require 'joshua_son_of_nun/space'

require 'joshua_son_of_nun/strategy/base'
require 'joshua_son_of_nun/strategy/random'
require 'joshua_son_of_nun/strategy/diagonal'
require 'joshua_son_of_nun/strategy/knight'

require 'joshua_son_of_nun/player'