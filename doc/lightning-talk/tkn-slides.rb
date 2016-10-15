BOLD = "\e[1m"
OFF = "\e[0m"
RED = "\e[31m"
GREEN = "\e[32m"
YELLOW = "\e[33m"
BLUE = "\e[34m"
PINK = "\e[35m"
LIGHT_BLUE = "\e[36m"

# encoding: utf-8
block <<-EOS
  ┌──────────────────────────────┐
  │  #{BOLD}#{RED}❧ Conferencia Rails 2016 ☙#{OFF}  │
  ├──────────────────────────────┤
  │                              │
  │   #{BOLD}tck-lambdas#{OFF}                │
  │                              │
  │             meets            │
  │                              │
  │                 #{BOLD}serverless#{OFF}   │
  │                              │
  ├──────────────────────────────┤
  │     by nando #{BLUE}@colgado_es#{OFF}     │
  └──────────────────────────────┘
   #{GREEN}#{BOLD}© The Cocktail Experience 2016#{OFF}
EOS

block <<-EOS
  Thanks...
   - Organizer+stuff <3<3<3
   - Speakers <3<3
   - #{BOLD}You <3#{OFF}
EOS

center <<-EOS
  I don't want to be
  the "Leeroy Jenkins"
  of the Serverless
  #{BOLD}amazing#{OFF} community
EOS

center <<-EOS
  Dedicated...

  #{BOLD}to Jim Weirich#{OFF}
  (rake creator)

  passed away in 2014
EOS

block <<-EOS
~ mkdir conferenciarails
~ cd conferenciarails
~ #{BOLD}sls create#{OFF} --template aws-nodejs
EOS

block <<-EOS
~ tck-lambdas #{BOLD}use chistacojs#{OFF}
~ tck-lambdas #{BOLD}use contact_form#{OFF}
~ vim #{BOLD}serverless.yml#{OFF}
EOS

block <<-EOS
~ emacs #{BOLD}handler.js#{OFF}
EOS

block <<-EOS
~ #{BOLD}serverless deploy#{OFF}
~ curl http://...amazonaws.com/dev/chistacojs
~ #{BOLD}sls logs#{OFF} -f chistacojs
EOS

block <<-EOS
HTTP POST Address:
~ nano lambdas/#{BOLD}chistacojs/source/conf.js#{OFF}

EMAIL Subject/From:
~ $EDITOR lambdas/#{BOLD}contact_form/source/conf.js#{OFF}
EOS

block <<-EOS
~ #{BOLD}serverless deploy#{OFF}
~ curl http://...amazonaws.com/dev/chistacojs
~ #{BOLD}sls logs#{OFF} -f chistacojs
EOS

section "#{BOLD}THANKS!!#{OFF}" do
end
# Copyright 2016 The Cocktail Experience, S.L.
