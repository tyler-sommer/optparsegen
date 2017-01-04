Gem::Specification.new do |spec|
  spec.name         = 'optparsegen'
  spec.version      = '0.1.1'
  spec.summary      = 'Generate ruby optparse code from usage text.'
  spec.author       = 'Tyler Sommer'
  spec.files        = Dir['lib/**/*.rb'] + ['bin/optparsegen']
  spec.test_files   = Dir['test/**/*.rb']
  spec.license      = 'MIT'
  spec.executables  = ['optparsegen']
end