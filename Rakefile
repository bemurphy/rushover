#!/usr/bin/env rake
require "bundler/gem_tasks"

require "rake/testtask"
Rake::TestTask.new(:test) do |t|
  t.test_files = FileList["test/*_test.rb"]
  t.ruby_opts << '-Itest -Ilib'
end
task :default => :test
