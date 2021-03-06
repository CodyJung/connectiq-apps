using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.ActivityMonitor as Act;

class PipBoy30View extends Ui.WatchFace {

    //! Class vars
    var timefont;
    var background_bmp;
    var bad_foot_bmp;
    var bad_face_bmp;
    var device_settings;

    //! Load your resources here
    function onLayout(dc) {
        // Load bitmaps
        background_bmp = Ui.loadResource(Rez.Drawables.WatchBG);
        bad_foot_bmp = Ui.loadResource(Rez.Drawables.BadFoot);
        bad_face_bmp = Ui.loadResource(Rez.Drawables.BadFace);

        // Load time font
        timefont = Ui.loadResource(Rez.Fonts.font_timefont);

        // Grab watch settings
        device_settings = Sys.getDeviceSettings();
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    //! Update the view
    //! Lots of magic numbers here. This face is
    //! only really made for FR920, Vivoactive, and Epix
    //! which are all 205x148
    function onUpdate(dc) {
        // initialize
        var time = makeClockTime();
        var device_stats = Sys.getSystemStats();
        var act_info = Act.getInfo();

        // Set the draw color
        dc.clear();
        dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);

        // Draw the background
        // This is offset incorrectly in FR920.
        // That's a known issue (K2554).
        dc.drawBitmap(0, 0, background_bmp);

        if( act_info.moveBarLevel == Act.MOVE_BAR_LEVEL_MIN ) {
            dc.fillRectangle(62, 97, 18, 4);
        } else {
            dc.drawBitmap(62, 86, bad_foot_bmp);
            dc.drawBitmap(101, 36, bad_face_bmp);

            if( act_info.moveBarLevel == Act.MOVE_BAR_LEVEL_MIN + 1 ) {
                dc.fillRectangle(62, 97, 9, 4);
            } else {
                dc.fillRectangle(62, 97, ( 9 * (Act.MOVE_BAR_LEVEL_MAX - act_info.moveBarLevel) ) / Act.MOVE_BAR_LEVEL_MAX, 4);
            }
        }

        // Write the current clock time
        dc.drawText( dc.getWidth()/2 + 5, 115, timefont, time, Gfx.TEXT_JUSTIFY_CENTER );

        //! Draw the step percentage on the leg
        var width = 0;
        if( act_info.steps > act_info.stepGoal ) {
            width = 18;
        } else {
            width = ( act_info.steps * 18 ) / act_info.stepGoal;
        }
        dc.fillRectangle(134, 97, width, 4);

        //! Draw the battery percentage on the chest
        dc.fillRectangle(101, 64, ( device_stats.battery * 16 ) / 100, 4);

    }

    //! Get the time from the clock and format it for
    //! the watch face (from the C64Face example)
    hidden function makeClockTime()
    {
        var clockTime = Sys.getClockTime();
        var hour, min, result;

        if( device_settings.is24Hour )
            {
            hour = clockTime.hour;
            }
        else
            {
            hour = clockTime.hour % 12;
            hour = (hour == 0) ? 12 : hour;
            }

        min = clockTime.min;

        // You so money and you don't even know it
        return Lang.format("$1$:$2$",[hour, min.format("%02d")]);
    }

}