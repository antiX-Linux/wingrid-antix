#!/bin/sh


PROGNAME=${0##*/}
PROGVERSION="1.1"



# --------------------
# Help and Information
# --------------------

# When requested show information about script
if [ "$1" = '-h' ] || [ "$1" = '--help' ]; then
cat << end-of-messageblock

$PROGNAME version $PROGVERSION
Places the active window into a predetermined position and size on screen.

Usage: 
   $PROGNAME

Options:
   -h, --help     Show this output

Summary:
   The screen is notionally divided into 4 rectangles in a 2x2 grid.
   Each window may occupy any 1, any 2 adjacent, or all 4 rectangles.

   Launching is normally done using the keyboard via a combined key press.
   The combination of keys are assigned by the system window manager and can 
   be reassigned if desired.  

   Optional configuration items are available in
   /home/USERNAME/.config/wingrid/wingrid.conf

   Requires:
      awk, wmctrl, xdpyinfo, yad

   See also:
      wingrid-bottom.sh
      wingrid-bottomleft.sh
      wingrid-bottomright.sh
      wingrid-left.sh
      wingrid-right.sh
      wingrid-top.sh
      wingrid-topleft.sh
      wingrid-topright.sh
      wingrid-maximize.sh
      wingrid-close.sh

end-of-messageblock
   exit 0
fi



# --------------------------
# User Configurable Settings
# --------------------------

# Location of the user configurable settings file
CONFIGFILE="$HOME/.config/wingrid/wingrid.conf"

# Obtain the user specifiable configuration
if [ -f $CONFIGFILE ]; then
   . $CONFIGFILE

   else

   # Display an error message and exit
   ERRMSG=" $CONFIGFILE \n Was not found \n\n Exiting..."
   YADBOX="--title="Wingrid" --image="error" --button="OK:1""
   [ "$DISPLAY" != "" ] && yad $YADBOX --text="$ERRMSG"
   exit 1
fi

# Guard against missing individual settings 
[ "$WINHEIGHT_LESS" = "" ] && WINHEIGHT_LESS=0
[ "$WINHEIGHT_MORE" = "" ] && WINHEIGHT_MORE=0
[ "$GAPTOP" = "" ] && GAPTOP=0
[ "$GAPLEFT" = "" ] && GAPLEFT=0



# --------------------
# Construct Parameters
# --------------------

# Capture screen resolution value
SCREENRES=$(xdpyinfo | awk '/dimensions:/ { sub("x", " "); print $2" "$3 }')

# Extract screen resolution into height and width components
SCREENWIDTH=${SCREENRES% *}
SCREENHEIGHT=${SCREENRES#* }

# Calculate 50% of the screen width and height values
SCREENHALFWIDTH=$(($SCREENWIDTH/2))
SCREENHALFHEIGHT=$(($SCREENHEIGHT/2))

# Reference used by window manager when positioning the window (always zero)
GRAVITY=0

# Distance from screen top edge to top edge of bottom window
OFFSETTOP=$(($SCREENHALFHEIGHT-$WINHEIGHT_MORE))

# Distance from screen left edge to left edge of right window
OFFSETLEFT=$SCREENHALFWIDTH

# Dimensions of window
WINHEIGHT=$(($SCREENHALFHEIGHT-$WINHEIGHT_LESS))
WINWIDTH=$SCREENHALFWIDTH



# ----------------------------
# Put Window into Grid Pattern
# ----------------------------

# Ensure the active window is not in maximized mode nor in fullscreen mode
wmctrl -r :ACTIVE: -b remove,maximized_horz,maximized_vert
wmctrl -r :ACTIVE: -b remove,fullscreen

# Position and resize the active window 
wmctrl -r :ACTIVE: -e $GRAVITY,$OFFSETLEFT,$OFFSETTOP,$WINWIDTH,$WINHEIGHT
