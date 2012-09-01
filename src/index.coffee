child_process = require 'child_process'
fs = require 'fs'
sysPath = require 'path'

module.exports = class CompassCompiler
  brunchPlugin: yes
  type: 'stylesheet'
  extension: 'scss'
  pattern: /\.s[ac]ss$/

  constructor: (@config) ->
    child_process.exec "compass --version", (error, stdout, stderr) =>
      if error
        console.error "You need to have Compass on your system"
        console.error "Execute `gem install compass`"

    fs.exists @config.paths.compass_config, (exists) =>
      unless exists
        console.error "Compass config file doesn't exist"
        console.error @config.paths.compass_config

  compile: (data, path, callback) ->
    result = ''
    error = null
    options = [
      'compile',
      '--config',
      sysPath.join process.cwd(), @config.paths.compass_config
    ]
    compass = child_process.spawn 'compass', options
    compass.on 'exit', (code) -> 
      callback error, ''
        