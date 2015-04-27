module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    coffee:
      compile:
        options:
          bare: yes
        files:
          'dist/account.js': 'account.coffee',
          'dist/main.js': 'main.coffee'

    grunt.loadNpmTasks 'grunt-contrib-coffee'

    grunt.registerTask 'copy', 'Moving the configuration', ->
      grunt.file.copy "./config.json", "./dist/config.json"

    grunt.registerTask 'trade', 'Moving the configuration', ->
      done = @async()
      trade = require "./dist/main.js"
      trade ->
        done(0)

    grunt.registerTask 'tradeLoop', 'Moving the configuration', ->
      done = @async()
      trade = require "./dist/main.js"

      trade()
      setInterval ->
        trade
      , 1000 * 30

  grunt.registerTask 'build', ['coffee', 'copy']
  grunt.registerTask 'default', ['coffee', 'copy', 'trade']
