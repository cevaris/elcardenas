#!/bin/sh


jekyll build --source _source --destination _deploy
jekyll serve --source _deploy