using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.ActivityMonitor as Act;

class PipBoy30View extends Ui.WatchFace {

    //! Class vars
    var timefont;
    var background;
    var device_settings;
    var device_stats;
    var act_info;

    //! Load your resources here
    function onLayout(dc) {
        background = Ui.loadResource(Rez.Drawables.WatchBG);
        timefont = Ui.loadResource(Rez.Fonts.font_timefont);
        device_settings = Sys.getDeviceSettings();
        device_stats = Sys.getSystemStats();
        act_info = Act.getInfo();
        dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
        dc.drawBitmap(0, 0, background);
        var time = makeClockTime();

        dc.drawText( dc.getWidth()/2 + 5, 115, timefont, time, Gfx.TEXT_JUSTIFY_CENTER );

        //! Draw the step percentage on the leg
        var width = 0;
        if( act_info.steps > act_info.stepGoal ) {
            width = 18;
        } else {
            width = ( act_info.steps * 18 ) / act_info.stepGoal;
        }
        dc.fillRectangle(134, 97, width, 3);

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