child_process = require 'child_process'
fs = require 'fs'
sysPath = require 'path'

module.exports = class CompassCompiler
  brunchPlugin: yes
  type: 'stylesheet'
  extension: 'scss'
  pattern: /\.s[ac]ss$/

  constructor: (@config) ->
    @compassConfig = @config.plugins?.compass

  compile: (data, path, callback) -> 
    prefix = if @compassConfig.useBundler then 'bundle exec' else ''

    child_process.exec "#{prefix} compass --version", (error, stdout, stderr) =>
      if error
        console.error "You need to have Compass on your system"
        if @compassConfig.useBundler
          console.error "Add this line to your application's Gemfile:"
          console.error "gem 'compass'"
        else
          console.error "Execute `gem install compass`"

    fs.exists @config.paths.compass, (exists) =>
      unless exists
        console.error "Compass config file doesn't exist"
        console.error @config.paths.compass

    configPath = sysPath.join process.cwd(), @config.paths.compass
    child_process.exec "#{prefix} compass compile --config #{configPath}", (error, stdout, stderr) ->
      console.log "exec error: " + error  if error isnt null

    callback();
    