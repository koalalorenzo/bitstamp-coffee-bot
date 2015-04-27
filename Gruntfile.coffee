module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    coffee:
      compile:
        options:
          bare: yes
        files:
          'build/account.js': 'account.coffee',
          'build/main.js': 'main.coffee'

    grunt.loadNpmTasks 'grunt-contrib-coffee'

    grunt.registerTask 'clean', 'Clean everything', ->
      grunt.file.delete "./build/"
      grunt.log.ok "Build file removed"

    grunt.registerTask 'copy', 'Moving the configuration', ->
      grunt.file.copy "./config.json", "./build/config.json"
      grunt.log.ok "Copying configuration"

    grunt.registerTask 'trade', 'Make buy or sell orders', ->
      done = @async()
      trade = require "./build/main.js"
      trade ->
        done(0)

    grunt.registerTask 'tradeLoop', 'infiniteloop of trade task', ->
      done = @async()
      trade = require "./build/main.js"

      grunt.log.ok "Trade loop started"
      setInterval ->
        trade()
      , 1000 * 15
      trade()

  grunt.registerTask 'build', ['clean', 'coffee', 'copy']
  grunt.registerTask 'default', ['clean', 'coffee', 'copy', 'trade']
