#!/bin/sh
set -e

RESOURCES_TO_COPY=${PODS_ROOT}/resources-to-copy-${TARGETNAME}.txt
> "$RESOURCES_TO_COPY"

install_resource()
{
  case $1 in
    *.storyboard)
      echo "ibtool --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.xib)
        echo "ibtool --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.framework)
      echo "mkdir -p ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      mkdir -p "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      echo "rsync -av ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      rsync -av "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodel)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1"`.mom\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodel`.mom"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd"
      ;;
    *.xcassets)
      ;;
    /*)
      echo "$1"
      echo "$1" >> "$RESOURCES_TO_COPY"
      ;;
    *)
      echo "${PODS_ROOT}/$1"
      echo "${PODS_ROOT}/$1" >> "$RESOURCES_TO_COPY"
      ;;
  esac
}
install_resource "MDSpreadView/Images/MDSpreadViewCell.png"
install_resource "MDSpreadView/Images/MDSpreadViewCell@2x.png"
install_resource "MDSpreadView/Images/MDSpreadViewCellSelected.png"
install_resource "MDSpreadView/Images/MDSpreadViewCellSelected@2x.png"
install_resource "MDSpreadView/Images/MDSpreadViewColumnHeaderLeft.png"
install_resource "MDSpreadView/Images/MDSpreadViewColumnHeaderLeft@2x.png"
install_resource "MDSpreadView/Images/MDSpreadViewColumnHeaderLeftSelected.png"
install_resource "MDSpreadView/Images/MDSpreadViewColumnHeaderLeftSelected@2x.png"
install_resource "MDSpreadView/Images/MDSpreadViewColumnHeaderRight.png"
install_resource "MDSpreadView/Images/MDSpreadViewColumnHeaderRight@2x.png"
install_resource "MDSpreadView/Images/MDSpreadViewColumnHeaderRightSelected.png"
install_resource "MDSpreadView/Images/MDSpreadViewColumnHeaderRightSelected@2x.png"
install_resource "MDSpreadView/Images/MDSpreadViewCornerBottomLeft.png"
install_resource "MDSpreadView/Images/MDSpreadViewCornerBottomLeft@2x.png"
install_resource "MDSpreadView/Images/MDSpreadViewCornerBottomLeftSelected.png"
install_resource "MDSpreadView/Images/MDSpreadViewCornerBottomLeftSelected@2x.png"
install_resource "MDSpreadView/Images/MDSpreadViewCornerBottomRight.png"
install_resource "MDSpreadView/Images/MDSpreadViewCornerBottomRight@2x.png"
install_resource "MDSpreadView/Images/MDSpreadViewCornerBottomRightSelected.png"
install_resource "MDSpreadView/Images/MDSpreadViewCornerBottomRightSelected@2x.png"
install_resource "MDSpreadView/Images/MDSpreadViewCornerTopLeft.png"
install_resource "MDSpreadView/Images/MDSpreadViewCornerTopLeft@2x.png"
install_resource "MDSpreadView/Images/MDSpreadViewCornerTopLeftSelected.png"
install_resource "MDSpreadView/Images/MDSpreadViewCornerTopLeftSelected@2x.png"
install_resource "MDSpreadView/Images/MDSpreadViewCornerTopRight.png"
install_resource "MDSpreadView/Images/MDSpreadViewCornerTopRight@2x.png"
install_resource "MDSpreadView/Images/MDSpreadViewCornerTopRightSelected.png"
install_resource "MDSpreadView/Images/MDSpreadViewCornerTopRightSelected@2x.png"
install_resource "MDSpreadView/Images/MDSpreadViewRowHeaderBottom.png"
install_resource "MDSpreadView/Images/MDSpreadViewRowHeaderBottom@2x.png"
install_resource "MDSpreadView/Images/MDSpreadViewRowHeaderBottomSelected.png"
install_resource "MDSpreadView/Images/MDSpreadViewRowHeaderBottomSelected@2x.png"
install_resource "MDSpreadView/Images/MDSpreadViewRowHeaderTop.png"
install_resource "MDSpreadView/Images/MDSpreadViewRowHeaderTop@2x.png"
install_resource "MDSpreadView/Images/MDSpreadViewRowHeaderTopSelected.png"
install_resource "MDSpreadView/Images/MDSpreadViewRowHeaderTopSelected@2x.png"

rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
if [[ "${ACTION}" == "install" ]]; then
  rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
rm -f "$RESOURCES_TO_COPY"

if [[ -n "${WRAPPER_EXTENSION}" ]] && [ `xcrun --find actool` ] && [ `find . -name '*.xcassets' | wc -l` -ne 0 ]
then
  case "${TARGETED_DEVICE_FAMILY}" in 
    1,2)
      TARGET_DEVICE_ARGS="--target-device ipad --target-device iphone"
      ;;
    1)
      TARGET_DEVICE_ARGS="--target-device iphone"
      ;;
    2)
      TARGET_DEVICE_ARGS="--target-device ipad"
      ;;
    *)
      TARGET_DEVICE_ARGS="--target-device mac"
      ;;  
  esac 
  find "${PWD}" -name "*.xcassets" -print0 | xargs -0 actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${IPHONEOS_DEPLOYMENT_TARGET}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
