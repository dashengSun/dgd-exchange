require 'rspec/core'
require 'rspec/core/rake_task'
require 'roodi_task'
task :default => [:roodi, :spec, 'npm:test']

RSpec::Core::RakeTask.new do |task|
  task.pattern = FileList['spec/**/*_spec.rb']
end

desc "Update dependencies"
task :update do
  sh "tagfish update Dockerfile"
  sh "bundle update"
end

task :rerun do
  sh "shotgun -o 0.0.0.0 -p 5000"
end

namespace :npm do
  task :test do
    sh "npm test"
  end

  task :compile do
    sh "npm run compile-js"
  end

  task :watch do
    sh "npm run watch-js"
  end
end

multitask :watch => ['npm:watch', 'rerun']

