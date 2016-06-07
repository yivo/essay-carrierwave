# frozen_string_literal: true
# encoding: utf-8
Gem::Specification.new do |s|
  s.name            = 'essay-carrierwave'
  s.version         = '1.0.0'
  s.authors         = ['Yaroslav Konoplov']
  s.email           = ['yaroslav@inbox.com']
  s.summary         = 'essay-carrierwave'
  s.description     = 'essay-carrierwave'
  s.homepage        = 'http://github.com/yivo/essay-carrierwave'
  s.license         = 'MIT'

  s.executables     = `git ls-files -z -- bin/*`.split("\x0").map{ |f| File.basename(f) }
  s.files           = `git ls-files -z`.split("\x0")
  s.test_files      = `git ls-files -z -- {test,spec,features}/*`.split("\x0")
  s.require_paths   = ['lib']

  # TODO Add essay dependency
end
