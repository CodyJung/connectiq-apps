using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;

class BloodyFaceView extends Ui.WatchFace {

    //! Class variables
    var device_settings;

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
        device_settings = Sys.getDeviceSettings();
    }

    //! Update the view
    function onUpdate(dc) {
        // Determine if the user is in 12- or 24-hour mode
        // Get and show the current time
        var clockTime = Sys.getClockTime();

        var hourToDisplay = clockTime.hour;
        if( !device_settings.is24Hour ) {
            hourToDisplay %= 12;
        }

        if( hourToDisplay == 0 && !device_settings.is24Hour ) {
            hourToDisplay = 12;
        }

        var hour = View.findDrawableById("HourLabel");
        hour.setText(hourToDisplay.toString());

        var minute = View.findDrawableById("MinuteLabel");
        minute.setText(clockTime.min.format("%02d"));

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        // Draw the ticks on top of everything else
        drawTick( dc, clockTime.hour % 12, true );
        drawTick( dc, clockTime.min, false );
    }

    function drawTick( dc, value, isHour ) {
        if( isHour ) {
            var angle = ( ( value / 12.0f ) * 2 * Math.PI ) - (Math.PI / 2);
            var x1 = 109 + 109 * Math.cos( angle );
            var y1 = 109 + 109 * Math.sin( angle );

            var x2 = 109 + 99 * Math.cos( angle );
            var y2 = 109 + 99 * Math.sin( angle );

            dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_WHITE );
            dc.setPenWidth(7);
            dc.drawLine( x1, y1, x2, y2 );
        } else {
            var angle = ( ( value / 60.0f ) * 2 * Math.PI ) - (Math.PI / 2);
            var x1 = 109 + 109 * Math.cos( angle );
            var y1 = 109 + 109 * Math.sin( angle );

            var x2 = 109 + 99 * Math.cos( angle );
            var y2 = 109 + 99 * Math.sin( angle );
            dc.setColor( Gfx.COLOR_RED, Gfx.COLOR_RED );
            dc.setPenWidth(5);
            dc.drawLine( x1, y1, x2, y2 );
        }
        dc.setPenWidth(1);
    }

    //! The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    //! Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}