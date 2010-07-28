require 'rake'
require 'rake/rdoctask'
require 'spec/rake/spectask'

desc 'Default: Run all specs.'
task :default => :spec

desc "Run all specs"
Spec::Rake::SpecTask.new() do |t|
  t.spec_opts = ['--options', "\"spec/support/spec.opts\""]
  t.spec_files = FileList['spec/**/*_spec.rb']
end

desc 'Generate documentation for the cucumber_spinner gem.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'mail_magnet'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "cucumber_spinner"
    gemspec.version = '0.1.2'
    gemspec.summary = "Progress bar formatter for cucumber, shows failing scenarios immediately."
    gemspec.email = "tobias.kraze@makandra.de"
    gemspec.homepage = "http://github.com/makandra/cucumber_spinner"
    gemspec.description = "Formatter for cucumber like the RSpecSpinner for RSpec. Shows a progress bar on the command line and prints failing scenarios immediately."
    gemspec.authors = ["Tobias Kraze"]
    gemspec.add_dependency('rtui', '>=0.2.2')
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler"
end

