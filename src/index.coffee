{spawn, exec} = require 'child_process'
sysPath = require 'path'
fs = require 'fs'

module.exports = class CompassCompiler
  brunchPlugin: yes
  type: 'stylesheet'
  extension: 'scss'
  pattern: /\.s[ac]ss$/
  _bin: 'compass'

  constructor: (@config) ->
    exec "#{@_bin} --version", (error, stdout, stderr) =>
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
      @config.paths.root,
      path,
      '--force',
      '--config',
      @config.paths.compass_config
    ]

    compass = spawn @_bin, options

    onExit = (code) -> callback error, result
    if process.version.slice(0, 4) is 'v0.6'
      compass.on 'exit', onExit
    else
      compass.on 'close', onExit

  getDependencies: (data, path, callback) =>
