require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['tests/**/*_test.rb']
  t.verbose = false
  $VERBOSE = nil  # Suppress Ruby warnings
end

task default: :test