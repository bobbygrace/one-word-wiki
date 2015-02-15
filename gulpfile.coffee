gulp = require 'gulp'
concat = require 'gulp-concat'
minifyCSS = require 'gulp-minify-css'
rename = require 'gulp-rename'
minifyHTML = require 'gulp-minify-html'

gulpCssSrc = [
  'src/client/styles/normalize.css'
  'src/client/styles/main.css'
]

gulp.task 'css', ->

  gulp
    .src gulpCssSrc
    .pipe concat('app.css')
    .pipe gulp.dest('./public/css')
    .pipe minifyCSS()
    .pipe rename('app.min.css')
    .pipe gulp.dest('./public/css')


gulpHtmlSrc = './src/client/html/*.html'

gulp.task 'html', ->
  options = {empty: true}

  gulp
    .src gulpHtmlSrc
    .pipe minifyHTML(options)
    .pipe gulp.dest('./public')


gulp.task 'watch', ->
  gulp.watch gulpCssSrc, ['css']
  gulp.watch gulpHtmlSrc, ['html']


gulp.task 'default', ['css', 'html', 'watch']
