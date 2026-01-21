require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = false
  $VERBOSE = nil  # Suppress Ruby warnings
end

task default: :test