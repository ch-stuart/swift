module.exports = function(grunt) {

    grunt.initConfig({
        watch: {
            js: {
                files: [
                    'app/assets/javascripts/**/*.js',
                    'test/casperjs/*.js'
                ],
                tasks: ['jshint']
            },
            casper: {
                files: [
                    'app/assets/javascripts/**/*.js',
                    'test/casperjs/*.js'
                ],
                tasks: ['casper']
            }
        },
        casper: {
            functional: {
                options: {
                    test: true
                },
                src: ['test/casperjs/*.js'],
                dest: 'casper-results.xml'
            }
        },
        jshint: {
            options: {
                jshintrc: true
            },
            all: [
                'app/assets/javascripts/**/*.js',
                '!app/assets/javascripts/tinycolor.js',
                '!app/assets/javascripts/jquery.lightbox_me.js',
                '!app/assets/javascripts/jquery.fitvids.js',
                '!app/assets/javascripts/farbtastic/farbtastic.js'
            ]
        }
    });

    // Load the plugin that provides the 'uglify' task.
    grunt.loadNpmTasks('grunt-contrib-jshint');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-notify');
    grunt.loadNpmTasks('grunt-casper');

    // Default task(s).
    grunt.registerTask('default', ['jshint', 'watch']);

};
