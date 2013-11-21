#!/bin/sh


jekyll build --source _source 
cd _site
jekyll serve --watch 