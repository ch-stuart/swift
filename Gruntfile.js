module.exports = function(grunt) {

    grunt.initConfig({
        watch: {
            js: {
                files: ["app/assets/javascripts/**/*.js"],
                tasks: ["jshint"]
            }
        },
        jshint: {
            options: {
                jshintrc: true
            },
            all: [
                "app/assets/javascripts/**/*.js",
                "!app/assets/javascripts/tinycolor.js",
                "!app/assets/javascripts/jquery.lightbox_me.js",
                "!app/assets/javascripts/jquery.fitvids.js",
                "!app/assets/javascripts/farbtastic/farbtastic.js"
            ]
        }
    });

    // Load the plugin that provides the "uglify" task.
    grunt.loadNpmTasks("grunt-contrib-jshint");
    grunt.loadNpmTasks("grunt-contrib-watch");
    grunt.loadNpmTasks("grunt-notify");

    // Default task(s).
    grunt.registerTask("default", ["jshint", "watch"]);

};
