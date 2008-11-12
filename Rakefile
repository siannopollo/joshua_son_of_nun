require 'rake'
require 'rake/gempackagetask'
require 'spec/rake/spectask'
require 'battleship_tournament/submit'

desc "Run all specs"
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_files = FileList['spec/**/*.rb']
  t.spec_opts = ['--options', 'spec/spec.opts']
  t.rcov = false
end
task :default => :spec

PKG_NAME = "joshua_son_of_nun"
PKG_VERSION   = "1.0"

spec = Gem::Specification.new do |s|
  s.name = PKG_NAME
  s.version = PKG_VERSION
  s.files = FileList['**/*'].to_a
  s.require_path = 'lib'
  s.test_files = Dir.glob('spec/*_spec.rb')
  s.bindir = 'bin'
  s.executables = []
  s.summary = "Battleship Player:joshua_son_of_nun"
  s.rubyforge_project = "sparring"
  s.homepage = "http://sparring.rubyforge.org/"

  ###########################################
  ##
  ## You are encouraged to modify the following
  ## spec attributes.
  ##
  ###########################################
  s.description = "A battleship player"
  s.author = "Steve Iannopollo"
  s.email = "steve@iannopollo.com"
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = false
  pkg.need_tar = false
end

desc "Submit your player"
task :submit do
  submitter = BattleshipTournament::Submit.new(PKG_NAME)
  submitter.submit
end

desc 'Locally build the gem'
task :make_gem do
  `cd #{File.expand_path(File.dirname(__FILE__))} && rm -f pkg/joshua_son_of_nun-1.0.gem && rake gem && sudo gem uninstall joshua_son_of_nun && sudo gem install pkg/joshua_son_of_nun-1.0.gem`
end
