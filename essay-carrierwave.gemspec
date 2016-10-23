# encoding: utf-8
# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name            = 'essay-carrierwave'
  s.version         = '1.0.2'
  s.authors         = ['Yaroslav Konoplov']
  s.email           = ['eahome00@gmail.com']
  s.summary         = 'essay-carrierwave'
  s.description     = 'essay-carrierwave'
  s.homepage        = 'http://github.com/yivo/essay-carrierwave'
  s.license         = 'MIT'

  s.executables     = `git ls-files -z -- bin/*`.split("\x0").map{ |f| File.basename(f) }
  s.files           = `git ls-files -z`.split("\x0")
  s.test_files      = `git ls-files -z -- {test,spec,features}/*`.split("\x0")
  s.require_paths   = ['lib']

  s.add_dependency 'carrierwave', '>= 0', '< 1.0'
  s.add_dependency 'essay',       '~> 1.1'
end
