require "bundler"

Bundler.setup
Bundler::GemHelper.install_tasks

require "rake"
require "yaml"

require "rdoc/task"
require "rspec/core/rake_task"

desc "Run all examples"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = %w[--color]
  t.verbose = false
end

task :clobber do
  rm_rf 'pkg'
  rm_rf 'tmp'
  rm_rf 'coverage'
end

namespace :rcov do
  task :cleanup do
    rm_rf 'coverage.data'
    rm_rf 'coverage'
  end

  RSpec::Core::RakeTask.new :spec do |t|
    t.rcov = true
  end
end

task :rcov => ["rcov:cleanup", "rcov:spec"]

task(:release).clear_prerequisites.clear_actions

task :default => [:spec]

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "RPush gem"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
