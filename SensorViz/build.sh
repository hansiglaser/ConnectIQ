#!/bin/bash

# Target device (default: square_watch_sim) to build for
# Note: According to https://forums.garmin.com/archive/index.php/t-357819.html,
# the fr920xt has a bug which loads all images mirrored around x and y. The
# compiler pre-mirrors the images, which then show up mirrored in the simulator.
# The simulator does not show the fr920xt bug.
# Note: If you don't specify a device, the compiler will not include all
# resources in the package.
DEVICE="fr735xt"
#DEVICE="vivoactive_hr"

# developer key
DEVEL_KEY=~/.ciq/developer_key.der

# get resource identifider for the application name as defined with the "name"
# attribute of the "iq:application" tag in manifest.xml
NAME_RES=$(sed -rn '/iq:application/s/^.* name="([^"]+)" .*$/\1/p' manifest.xml)
if [ -z "$NAME_RES" ] ; then
  echo "Error: Can't determine the resource identifier for the application name."
  exit 1
fi
# if the resource identifier begins with "@String.", cut that off
NAME_RES="${NAME_RES##@Strings.}"
# get the value of that string resource
APPNAME=$(grep -hr "string *id=\"$NAME_RES\"" $(find resources/ -iname '*.xml') | sed -r "s/^.*<string[^>]+id=\"$NAME_RES\"[^>]*>([^<]+)<.*$/\1/")
if [ -z "$APPNAME" ] ; then
  echo "Error: Can't determine the application name from resource identifier $NAME_RES"
  exit 1
fi
if [ "${#APPNAME}" -gt 20 ] ; then
  echo "Error: The application name is too long:"
  echo "\"$APPNAME\""
  exit 1
fi
echo "Application name: $APPNAME"

# result/output in all upper case
OUT="${APPNAME^^}.PRG"

# MonkeyC compiler
CC=monkeyc

# declare an array for all arguments
declare -a args

# handle command line parameters
while [ $# -gt 0 ] ; do
  case "$1" in
    -d)
      # -d <device>
      DEVICE="$2"
      shift   # second shift will be done after "case"
      ;;
    *)
      # add all (unhandled) arguments given at the command line to take precedence over the defaults
      args+=("$1")
      ;;
  esac
  shift
done

# Prints the compiler version and exits
#args+=('-v')
# Show compiler warnings
args+=('-w')
# Create an application package.
#args+=('-e')
# Print debug output (to stderr, complete human-readable dump of the byte code)
#args+=('-g')
# Strip debug information (-r,--release)
#args+=('-r')
# Target device (default: square_watch_sim)
if [ -n "$DEVICE" ] ; then
  args+=('-d' "$DEVICE")
fi
# developer key
args+=('-y' "$DEVEL_KEY")
# output
args+=('-o' "$OUT")
# manifest
args+=('-m' 'manifest.xml')
# resources
for d in ./resources/ $(find . -maxdepth 1 -iname 'resources-*' -a -type d) ; do
  for i in $(find "$d" -iname '*.xml') ; do
    args+=('-z' "$i")
  done
done
# sources
for i in $(find ./source/ -iname '*.mc') ; do
  args+=("$i")
done

# compile
echo $CC "${args[@]}"
$CC "${args[@]}"
if [ $? -eq 0 ] ; then
  echo "Successfully built $OUT."
  ls -l "$OUT"
  exit 0
else
  echo "Error building $OUT."
  exit 1
fi
