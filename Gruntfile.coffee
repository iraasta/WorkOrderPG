exec = (require "child_process").exec
spawn = (require "child_process").spawn

module.exports = (grunt)->
  grunt.initConfig({
    pkg: grunt.file.readJSON 'package.json'
    sass: {
      dist: {
        files: [{
          expand: true,
          cwd: 'www/src/view/sass/',
          src: ['*.scss'],
          dest: 'www/css',
          ext: '.css'
        }]
      }
    },
    haml: {
      dist: {
        files: [{
          expand: true,
          cwd: 'www/src/view/haml/',
          src: ['*.haml'],
          dest: 'www',
          ext: '.html'
        }]
      }
    }
    watch:
      scripts:{
        files: ['www/src/**/*'],
        tasks: ['browserify', 'sass'],
        options:
          livereload: true
      }

    connect:
      options:
        hostname: 'localhost'
        livereload: 35729
        port: 3000
      server:
        options:
          base: 'www'
          open: true
  });

  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-phonegap');
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks('grunt-contrib-sass');
  grunt.loadNpmTasks('grunt-contrib-haml');

  grunt.registerTask "default", ['browserify', 'sass', 'run:android']
  grunt.registerTask 'server', ->
    grunt.task.run 'connect:server'
    grunt.task.run 'watch:all'

  grunt.task.registerTask "browserify", "Default task", ->
    done = this.async();
    exec("browserify -t coffeeify www/src/index.coffee > www/js/bundle.js", (err, stderr, stdout) ->
      grunt.log.write "stderr:: #{stderr}" if stderr?
      grunt.log.write "stdout:: #{stdout}" if stdout?
      done();
    )
  grunt.task.registerTask "run", "Default task", (target)->
    done = this.async();
    exec("cordova run #{target}", (err, stderr, stdout) ->
      grunt.log.write "stderr:: #{stderr}"
      grunt.log.write "stdout:: #{stdout}"
      done();
    )
