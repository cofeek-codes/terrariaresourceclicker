#!/bin/bash

GODOT_PATH="../Godot_v4.5-stable_win64.exe"
EXPORT_PATH="../terrariaresourceclicker_exports/web"

echo " "
echo " "
echo " "

rm -rf -v $EXPORT_PATH/** &&

echo " "
echo " "
echo " "

$GODOT_PATH --headless --export-release Playgama $EXPORT_PATH/index.html &&

7z a -tzip $EXPORT_PATH/web.zip $EXPORT_PATH/**