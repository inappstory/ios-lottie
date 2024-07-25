#!/bin/sh

#  ci_post_xcodebuild.sh
#  IASLottie
#
#  Created by StPashik on 25.07.2024.
#

echo "Platform: $CI_PRODUCT_PLATFORM"

if [[ -n $CI_ARCHIVE_PATH ]];
then
echo "Archive path: $CI_ARCHIVE_PATH"
else
    echo "It's not archive"
fi

# Type a script or drag a script file from your workspace to insert its path.
# Set the output folder var
OUTPUTFOLDER_IOS=${CI_ARCHIVE_PATH}/${CI_PRODUCT_PLATFORM}-universal

NAME_OF_TARGET=${CI_XCODE_SCHEME}
# To make an XCFramework, we first build the framework for every type seperately
echo "XCFramework: Starting script to build an XCFramework. Output dir: ${CI_ARCHIVE_PATH}"
# Device slice.
echo "XCFramework: Archiving DEVICE type..."
xcodebuild archive -quiet -workspace ${CI_PROJECT_FILE_PATH} -scheme "${NAME_OF_TARGET}" -configuration Release -destination 'generic/platform=iOS' -archivePath "${CI_ARCHIVE_PATH}/${NAME_OF_TARGET}.framework-iphoneos.xcarchive" SKIP_INSTALL=NO SWIFT_SERIALIZE_DEBUGGING_OPTIONS=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES SWIFT_EMIT_PRIVATE_MODULE_INTERFACE=YES
echo "XCFramework: Archiving SIMULATOR type..."
# Simulator slice.
xcodebuild archive -quiet -workspace ${CI_PROJECT_FILE_PATH} -scheme "${NAME_OF_TARGET}" -configuration Release -destination 'generic/platform=iOS Simulator' -archivePath "${CI_ARCHIVE_PATH}/${NAME_OF_TARGET}.framework-iphonesimulator.xcarchive" SKIP_INSTALL=NO SWIFT_SERIALIZE_DEBUGGING_OPTIONS=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES SWIFT_EMIT_PRIVATE_MODULE_INTERFACE=YES
# Simulator-targeted archives don't generate BCSymbolMap files, so above is only needed for iphone target
echo "XCFramework: Creating XCFramework file"
# Then we group them into one XCFramework file
xcodebuild -quiet -create-xcframework -framework "${CI_ARCHIVE_PATH}/${NAME_OF_TARGET}.framework-iphoneos.xcarchive/Products/Library/Frameworks/${NAME_OF_TARGET}.framework" -debug-symbols "${CI_ARCHIVE_PATH}/${NAME_OF_TARGET}.framework-iphoneos.xcarchive/dSYMs/${NAME_OF_TARGET}.framework.dSYM" -framework "${CI_ARCHIVE_PATH}/${NAME_OF_TARGET}.framework-iphonesimulator.xcarchive/Products/Library/Frameworks/${NAME_OF_TARGET}.framework" -debug-symbols "${CI_ARCHIVE_PATH}/${NAME_OF_TARGET}.framework-iphonesimulator.xcarchive/dSYMs/${NAME_OF_TARGET}.framework.dSYM" -output "${OUTPUTFOLDER_IOS}/${NAME_OF_TARGET}.xcframework"
# For developer convenience, open the output folder

echo "<<* XCFRAMEWORK COMPLETE *>>"

echo "XCFramework: Start moving to github"

VERSION_NUMBER=$(cat $CI_PRIMARY_REPOSITORY_PATH/$NAME_OF_TARGET.xcodeproj/project.pbxproj | grep -m1 'MARKETING_VERSION' | cut -d'=' -f2 | tr -d ';' | tr -d ' ')
BUILD_NUMBER=$(cat $CI_PRIMARY_REPOSITORY_PATH/$NAME_OF_TARGET.xcodeproj/project.pbxproj | grep -m1 'CURRENT_PROJECT_VERSION' | cut -d'=' -f2 | tr -d ';' | tr -d ' ')

echo "Version: ${VERSION_NUMBER}"
echo "Build: ${BUILD_NUMBER}"

echo "XCFramework: Start ZIP"

cd $OUTPUTFOLDER_IOS
zip -r $OUTPUTFOLDER_IOS/$NAME_OF_TARGET.zip $NAME_OF_TARGET.xcframework

echo "XCFramework: End ZIP"

echo "XCFramework: Send ZIP to bot"

CHAT_ID='41266209'
BOT_TOKEN='6049226934:AAEiUG5GhBIlw8hDes3WA_NZyd9R_agM0Rg'
CAPTION="CI build ${CI_BUILD_NUMBER} for ${NAME_OF_TARGET} ${VERSION_NUMBER} (${BUILD_NUMBER})"

echo sending $OUTPUTFOLDER_IOS/$NAME_OF_TARGET.zip

curl -F chat_id=$CHAT_ID -F document=@$OUTPUTFOLDER_IOS/$NAME_OF_TARGET.zip -F caption="$CAPTION" https://api.telegram.org/bot$BOT_TOKEN/sendDocument

echo "XCFramework: Sending ZIP finished"

echo "<<* XCFRAMEWORK SENDED *>>"
