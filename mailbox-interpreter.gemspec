require './lib/mailbox/interpreter/version'

Gem::Specification.new do |s|
  s.name = 'mailbox-interpreter'
  s.version = "#{Mailbox::Interpreter::VERSION}"
  s.summary = 'Mailbox Interpreter'
  s.description = 'A parser and execution space for the esoteric programming language Mailbox.'
  s.authors = ['pjht', 'lampad']
  s.email = 'nonexistent@donotbotherme.com'
  s.homepage = 'https://github.com/pjht/mailbox-interpreter'

  s.has_rdoc = false
  s.extra_rdoc_files = []
  s.files = Dir.glob("{lib,examples}/**/*")
  s.files << 'bin/mailbox'

  s.require_path = "lib"

  s.required_ruby_version = '>= 2.0.0'

  s.executables << 'mailbox'
end
