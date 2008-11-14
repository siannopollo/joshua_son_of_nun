require 'init'

OLD_STRATEGIES = JoshuaSonOfNun::Strategy.strategies.dup
JoshuaSonOfNun::Strategy.module_eval do
  class << self
    attr_accessor :strategies
  end
end
JoshuaSonOfNun::Strategy.strategies = OLD_STRATEGIES

def Space(string)
  coordinates, orientation = string.split(' ')
  row, column = coordinates.scan(/(\w)(\d{1,2})/).first
  JoshuaSonOfNun::Space.new(row, column, orientation)
end

class GameSimulator
  attr_reader :current_player, :game_over, :opponent,
              :player_one_strategy, :player_two_strategy,
              :player_one, :player_two, :players, :results,
              :ship_placement, :ships
  
  alias_method :game_over?, :game_over
  
  def initialize(player_one_strategy, player_two_strategy)
    @player_one_strategy, @player_two_strategy = player_one_strategy, player_two_strategy
    @player_one = JoshuaSonOfNun::Player.new
    @player_two = JoshuaSonOfNun::Player.new
    tag_players!
    
    @results = {@player_one.name => [], @player_two.name => []}
  end
  
  def determine_damage(target)
    hit, sunk = nil
    ship_placement[opponent.name].each do |ship, spaces|
      space = spaces.delete(target)
      if space
        hit = true
        sunk = spaces.empty?
        break
      end
    end
    @game_over = ship_placement[opponent.name].values.flatten.empty?
    [hit, sunk]
  end
  
  def fire_on_opponent
    target = current_player.next_target
    ship_hit, ship_sunk = determine_damage(target)
    
    current_player.target_result(target.to_s, ship_hit, ship_sunk)
    opponent.enemy_targeting(target.to_s)
  end
  
  def force_strategy(strategy)
    JoshuaSonOfNun::Strategy.strategies = [strategy]
  end
  
  def gather_ship_placement
    players.each do |player|
      placement = {}
      ships.each do |ship|
        placement[ship] = Space(player.send("#{ship}_placement")).spaces_for_placement(player.send(ship).length)
      end
      
      ship_placement[player.name] = placement
    end
  end
  
  def reset
    @players = [@player_one, @player_two]
    
    force_strategy(player_one_strategy) unless player_one_strategy.nil?
    @player_one.new_game(@player_two.name)
    force_strategy(player_two_strategy) unless player_two_strategy.nil?
    @player_two.new_game(@player_one.name)
    
    @ship_placement = {}
    @ships = [:battleship, :carrier, :destroyer, :patrolship, :submarine]
    gather_ship_placement
    
    @game_over = false
  end
  
  def run!
    reset
    
    until game_over?
      switch_turns
      fire_on_opponent
    end
    
    @results[@current_player.name] << strategy_name(@current_player)
  end
  
  def strategy_name(player)
    player.strategy.class.name.split("::").last
  end
  
  def summarized_results
    results.collect do |player, winning_strategies|
      output = "#{player}:"
      output << " #{winning_strategies.size} wins"
      strategy_count = OLD_STRATEGIES.collect do |strategy|
        count = winning_strategies.select {|s| s == strategy}.size
        "#{strategy} => #{count}"
      end
      output << " (#{strategy_count * ', '})"
    end.reverse * "\n"
  end
  
  def switch_turns
    @current_player = @players.shift
    @players << @current_player
    @opponent = @players.first
  end
  
  def tag_players!
    class << player_one
      def name; 'player_one'; end
    end
    class << player_two
      def name; 'player_two'; end
    end
  end
end

simulator = GameSimulator.new(ARGV.shift, ARGV.shift)
21.times {simulator.run!}
puts '', simulator.summarized_results, ''