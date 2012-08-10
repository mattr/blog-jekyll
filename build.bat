call lessc -x .\assets\src\less\site.less > .\assets\css\site.css
call uglifyjs -o .\assets\js\site.min.js .\assets\src\js\site.js
call jekyll