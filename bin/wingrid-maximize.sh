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



# ----------------------------
# Put Window into Grid Pattern
# ----------------------------

# Position and resize the active window 
wmctrl -r :ACTIVE: -b add,maximized_horz,maximized_vert




