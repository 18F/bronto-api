guard :rspec do
  # App files
  watch(%r{^app/*/(.+)\.rb$})            { 'spec' }

  # Lib files
  watch(%r{^lib/(.+)\.rb$})              { |m| 'spec/lib/#{m[1]}_spec.rb' }

  # Test files
  watch(%r{^spec/.+_spec\.rb$})          { 'spec' }
  watch('spec/spec_helper.rb')           { 'spec' }
  watch(%r{^spec/support/(.+)\.rb$})     { 'spec' }
end