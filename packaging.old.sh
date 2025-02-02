#!/bin/bash
#set -x # debug

rm -R ./dist
mkdir ./dist

MANIFEST_FILE_NAME="manifest.json"
MANIFEST_FILE_NAME_V2="manifestv2.json"
CSS_FILE_NAME="global.css"
MAIN_JS_FILE_NAME="main.js"
CONTENT_JS_FILE_NAME="ogkush.js"
BG_JS_FILE_NAME="background.js"
VERSION_JS_FILE_NAME="util/version.js"
VERSION="${1:-`date +%-m.%-d.%-H.%-M`}"

npx cleancss -o dist/$CSS_FILE_NAME $CSS_FILE_NAME 
echo "$CSS_FILE_NAME minified"


npx terser $MAIN_JS_FILE_NAME -o ./dist/$MAIN_JS_FILE_NAME
echo "$MAIN_JS_FILE_NAME minified"
npx terser $CONTENT_JS_FILE_NAME -o ./dist/$CONTENT_JS_FILE_NAME
echo "$CONTENT_JS_FILE_NAME minified"
npx terser $BG_JS_FILE_NAME -o ./dist/$BG_JS_FILE_NAME
echo "$BG_JS_FILE_NAME  minified"


echo "Minification complete!"

cp -r res/ dist/res
cp -r util/ dist/util
cp -r libs/ dist/libs
cp  $MANIFEST_FILE_NAME ./dist/$MANIFEST_FILE_NAME

cd ./dist
sed -i "s/0\.0\.0/$VERSION/g" "$MANIFEST_FILE_NAME"
sed -i "s/__VERSION__/$VERSION/g" "$CONTENT_JS_FILE_NAME"
sed -i "s/__VERSION__/$VERSION/g" "$VERSION_JS_FILE_NAME"

zip -qr -X "ogi-chrome.zip" * 
echo "Packing zip for chrome complete!"
sed -i '31d' $MANIFEST_FILE_NAME

zip -qr -X "ogi-edge.zip" * -x "ogi-chrome.zip"
echo "Packing zip for edge complete!"


rm $MAIN_JS_FILE_NAME $CONTENT_JS_FILE_NAME $BG_JS_FILE_NAME $CSS_FILE_NAME
cp ../$MAIN_JS_FILE_NAME ./$MAIN_JS_FILE_NAME
cp ../$CONTENT_JS_FILE_NAME ./$CONTENT_JS_FILE_NAME
cp ../$BG_JS_FILE_NAME ./$BG_JS_FILE_NAME
cp ../$CSS_FILE_NAME ./$CSS_FILE_NAME
cp ../$MANIFEST_FILE_NAME_V2 ./$MANIFEST_FILE_NAME
cp ../readme.md .

sed -i "s/0\.0\.0/$VERSION/g" "$MANIFEST_FILE_NAME"
sed -i "s/__VERSION__/$VERSION/g" "$CONTENT_JS_FILE_NAME"
sed -i "s/__VERSION__/$VERSION/g" "$VERSION_JS_FILE_NAME"

# Modifing chrome-extension:// to moz-extension://
sed -i "s/chrome/moz/g" "$CSS_FILE_NAME"
zip -qrm -X "ogi-firefox.zip" * -x "ogi-chrome.zip" "ogi-edge.zip"
echo "Packing zip for firefox complete!"
