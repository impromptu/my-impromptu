module.exports = (Impromptu, section) ->
  system = @module.require 'impromptu-system'
  git = @module.require 'impromptu-git'
  github = @module.require 'impromptu-github'

  git.fetch()

  section 'user',
    content: [system.user, system.shortHost]
    format: (user, host) ->
      return if user.trim() is process.env.DEFAULT_USER
      "#{user}@#{host}"
    background: 'black'
    foreground: 'white'

  section 'pwd',
    content: system.prettyPwd
    background: 'blue'
    foreground: 'white'

  section 'git:in',
    when: git.branch
    content: 'in'
    background: 'black'
    foreground: 'white'

  section 'git:branch',
    content: git.branch
    background: 'green'
    foreground: 'black'

  section 'git:ahead',
    content: git.ahead
    background: 'black'
    foreground: 'green'
    when: git.isRepo
    format: (ahead) ->
      "#{ahead}⁺" if ahead

  section 'git:behind',
    content: git.behind
    background: 'black'
    foreground: 'red'
    when: git.isRepo
    format: (behind) ->
      "#{behind}⁻" if behind

  section 'github:ci',
    content: github.ci
    format: (status) ->
      if status is 'success'
        @foreground = 'green'
        'CI ✓'
      else if status is 'pending'
        @foreground = 'yellow'
        'CI …'
      else if status is 'failure' or status is 'error'
        @foreground = 'red'
        'CI ✕'
      else
        ''
    background: 'black'
    foreground: 'white'

  section 'git:staged',
    content: git.staged
    format: (staged) ->
      "staged #{staged}" if staged
    when: git.isRepo
    foreground: 'green'

  section 'git:unstaged',
    content: git.unstaged
    format: (unstaged) ->
      "unstaged #{unstaged}" if unstaged
    when: git.isRepo
    foreground: 'blue'

  section 'end',
    content: '\n$'
    foreground: 'blue'
    options:
      newlines: true
