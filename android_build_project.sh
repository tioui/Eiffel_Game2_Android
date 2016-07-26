#!/bin/bash

CURDIR=`pwd -P`
if [ -z "$1" ]; then
    echo "Usage: android_build_project.sh com.yourcompany.yourapp [destination_directory]"
    exit 1
fi

ANDROID=`which android`
if [ -z "$ANDROID" ];then
    echo "Could not find the android utility, install Android's SDK and add it to the path"
    exit 1
fi

APP="$1"
APPARR=(${APP//./ })
BUILDPATH="build/${APP}"
if [ -n "$2" ]; then
	BUILDPATH=$2
fi

if [ -e "${BUILDPATH}" ]; then
	echo "The destination directory must not already exist."
	exit 1
fi

# Start Building

mkdir -p $BUILDPATH

cp -r android-project/* $BUILDPATH
mkdir -p $BUILDPATH/assets
cp -rp libs $BUILDPATH
rm ${BUILDPATH}/libs/android-*

sed -i "s|org\.eiffelgame2\.app|$APP|g" $BUILDPATH/AndroidManifest.xml

# Create an inherited Activity
pushd $BUILDPATH/src
for folder in "${APPARR[@]}"
do
    mkdir -p $folder
    cd $folder
done

ACTIVITY="${folder}Activity"

# Fill in a default Activity
echo "package $APP;" >  "$ACTIVITY.java"
echo "import org.eiffelgame2.app.EiffelGame2Activity;" >> "$ACTIVITY.java"
echo "public class $ACTIVITY extends EiffelGame2Activity {}" >> "$ACTIVITY.java"

popd

sed -i "s|EiffelGame2Activity|$ACTIVITY|g" $BUILDPATH/AndroidManifest.xml
sed -i "s|EiffelGame2Activity|$APP|g" $BUILDPATH/build.xml

# Update project and build
$ANDROID update project --path $BUILDPATH --target android-12

echo "Now, you have to put your libmain.so"
echo "in the corresponding libs sub-directory."
echo "Then, create the APK with:"
echo "# cd  $BUILDPATH"
echo "# ant debug install"
exit 0
