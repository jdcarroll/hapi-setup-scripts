#!/bin/bash
###############################################################
# Function to create Web Folder Structure
##
# $1 = Directory Name
# $2 = Port Number
####
function hapiSetup {
    # Make container directory for project and move into project Directory
    ###
    mkdir $1
    cd $1

    # Make Project directories
    ###
    mkdir config routes public styles scripts

    # Create main Sass File to support Gulp
    ###
    touch styles/main.scss

    # Create main server file load template and create index.js
    ###
    touch index.js
    source ~/hapi-scripts/hapi-index.sh
    echo "/*
* Commands $1 is dependant on
*
* 1. Assuming that you ran npmStruct the folder structure should be created already
* 2. hserver
* 2. hconfig
* 3. hpublic
*
* Installation Instructions
*
* npm install --save hapi good good-squeeze good-console inert gulp gulp-sass gulp-notify gulp-nodemon gulp-uglifyjs
*
*/

'use strict';

const Hapi = require('hapi');
const config = require('./config');

const server = new Hapi.Server();
server.connection({
    port: config.server.port
})

server.register([

    config.plugins.good,
    config.plugins.inert,
    config.routes.public

], function (err) {
    if (err) {
        throw err;
    }

//Starting the Server
server.start(function (err) {
if (err) {
    throw err;
}

console.log('Server running at:', server.info.uri);
    });

});" >> index.js

    # Create gulpfile load template and create gulpfile.js
    ###
    touch gulpfile.js
    source ~/hapi-scripts/hapi-gulpFile.sh
    echo "/**
* $1 - Gulp Setup
**/
var gulp = require('gulp');
var sass = require('gulp-sass');
var notify = require('gulp-notify');
var nodemon = require('gulp-nodemon');
var uglify = require('gulp-uglifyjs');
var open = require('gulp-open');

gulp.task('styles', function(){
    return gulp.src('./styles/main.scss')
        .pipe(sass().on('error', sass.logError))
        .pipe(gulp.dest('public/css'))
        .pipe(notify({ message: 'Styles Task Complete'}))
});

gulp.task('scripts', function(){
    gulp.src(['scripts/*.js'])
        .pipe(uglify('app.js',{
            mangle: false,
            compress: false,
            output: {
                beautify: true,
            }
        }))
        .pipe(gulp.dest('public/js'))
        .pipe(notify({ message: 'Front End Scripts Task Complete'}))
})

gulp.task('watch', function(){
    gulp.watch('styles/*.scss', ['styles']);
    gulp.watch('scripts/*.js', ['scripts']);
})

gulp.task('nodemon', function(){
    nodemon({
        script: 'index.js',
        ext: 'js html',
        env: { 'NODE_ENV': 'development' }
    })
});

gulp.task('app', function(){
   var options = {
        uri: 'http://localhost:$2',
   }
    gulp.src(__filename)
    .pipe(open(options));
});

gulp.task('default', function(){
    gulp.start('watch','scripts','styles','nodemon', 'app')
})" >> gulpfile.js

    # Create config load template and create config/index.js
    ###
    touch config/index.js
    source ~/hapi-scripts/hapi-config.sh
    echo "/**
* $1 - Configuration Setup
**/
module.exports = {
    server: {
        port: $2
    }, // config.server
    plugins: {
        good: { // Establish the logging with Hapi
            register: require('good'), // require the plugin
            options: { // configure the options for the plugin
                reporters: {
                    console: [{
                        module: 'good-squeeze',
                        name: 'Squeeze',
                        args: [{
                            log: '*',
                            response: '*'
                        }]
                    }, {
                        module: 'good-console'
                    }, 'stdout']
                } // config.plugins.good.options.reporters
            } // config.plugins.good.options
        }, // config.plugins.good
        inert : {
            register: require('inert')
        }
    }, // config.plugins
    routes: {
        public:{
            register: require('../routes/public.js')
        } // config.routes.public
    } // config.routes
} // config" >> config/index.js

    # Create Public Routes File load template and create routes/public.js
    ###
    touch routes/public.js
    source ~/hapi-scripts/hapi-routes-public.sh
    echo  "/**
* $1 - Host Public Files
**/
'use strict'

exports.register = function (server, options, next) {


    server.route({
        method: 'GET',
        path: '/{param*}',
        handler: {
            directory: {
                path: 'public'
            }
        }
    });

    server.route({
        method: 'GET',
        path: '/bower/{param*}',
        handler: {
            directory: {
                path: 'bower_components'
            }
        }
    })

    return next();
};

exports.register.attributes = {
    name: 'public-files'
};" >> routes/public.js

    # Create Public directories and load index.html template
    ###
    mkdir public/js public/css public/img public/views
    touch public/index.html
    source ~/hapi-scripts/hapi-index-html.sh
    echo "<!DOCTYPE html>
<html ng-app='$1'>
<head>
    <title>$1</title>
    <!-- Load CSS Files -->
    <link rel="stylesheet" type="text/css" href="bower/bootstrap/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="bower/angular-material/angular-material.min.css">
    <link rel="stylesheet" type="text/css" href="css/main.css">
    <!-- Load Script Files -->
    <script src='"bower/angular/angular.min.js"'></script>
    <script src="bower/angular-ui-router/release/angular-ui-router.min.js"></script>
    <script src="bower/angular-animate/angular-animate.min.js"></script>
    <script src="bower/angular-aria/angular-aria.min.js"></script>
    <script src="bower/angular-material/angular-material.min.js"></script>
    <script src="js/app.js"></script>
</head>
<body>
    <div ui-view></div>
</body>
</html>" >> public/index.html

    # Load Angular dependancies and setup basic routing
    ###
    #
    # Naming Conventions are imporantant here as uglifyjs has a top down compression strategy.
    # Be sure to name your files 0#_FILENAME to insure compression works appropreately
    #
    # Dependancy file
    touch scripts/01_dependencies.js
    source ~/hapi-scripts/hapi-01_dependency.sh
    echo  "var $1 = angular.module('$1', [
        'ui.router',
        'ngMaterial'
    ])
" >> scripts/01_dependencies.js
    #
    # Router File
    touch scripts/02_router.js
    source ~/hapi-scripts/hapi-02_router.sh
    echo  "$1.config(function(\$stateProvider, \$urlRouterProvider){
    \$stateProvider
        .state('base',{
            url: '/',
            templateUrl: '/views/base.html',
            controller: 'base-controller'
        })
    \$urlRouterProvider.otherwise('/');
});" >> scripts/02_router.js
    #
    # Base Controller File
    touch scripts/03_base-controller.js
    source ~/hapi-scripts/hapi-03_base-controller.sh
    echo  "$1.controller('base-controller', function(\$scope){
    console.log('Hello from Base Controller');
})" >> scripts/03_base-controller.js
    #
    # Base View File
    touch public/views/base.html
    echo "<div class=container>
    <h1>Site - $1 </h1>
    <input type='text' ng-model='name'>{{ name }}
</div>" >> public/views/base.html

    npm init
    bower init
    npm install --save hapi good good-squeeze good-console inert
    npm install --save-dev gulp gulp-sass gulp-notify gulp-nodemon gulp-uglifyjs gulp-open
    bower install --save angular bootstrap angular-ui-router angular-animate angular-aria angular-material
    atom .
    gulp & open localhost:$2
}
###############################################################
# End of Function to create Web Folder Structure
##
