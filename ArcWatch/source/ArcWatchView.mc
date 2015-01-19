using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time as Time;

class ArcWatchView extends Ui.WatchFace {

    //! Constants
    const BAR_THICKNESS = 6;
    const ARC_MAX_ITERS = 300;

    //! Class vars
    var fast_updates = true;
    var device_settings;

    //! Load your resources here
    function onLayout(dc) {
        device_settings = Sys.getDeviceSettings();
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
        // Days of month lookup - February is close enough.
        var days_per_month = [ 0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ];
        var font_ofst = BAR_THICKNESS - dc.getFontHeight(Gfx.FONT_TINY) + 4;

        // Set background color
        dc.clear();
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());

        var x = dc.getWidth() / 2;
        var y = dc.getHeight() / 2;

        // Get date information
        var dateInfo = Time.Gregorian.info( Time.now(), Time.FORMAT_SHORT );
        drawArc(dc, x, y, 25, (dateInfo.month / 12f) * 2 * Math.PI, Gfx.COLOR_PURPLE);
        drawArc(dc, x, y, 40, (1f * dateInfo.day / days_per_month[dateInfo.month]) * 2 * Math.PI, Gfx.COLOR_DK_BLUE);
        drawArc(dc, x, y, 55, (1f * dateInfo.day_of_week / 7f) * 2 * Math.PI, Gfx.COLOR_DK_GREEN);

        // Draw the hour
        drawArc(dc, x, y, 70, (dateInfo.hour / 24f) * 2 * Math.PI, Gfx.COLOR_YELLOW);
        drawArc(dc, x, y, 85, (dateInfo.min / 60f) * 2 * Math.PI, Gfx.COLOR_ORANGE);

        // If we can, draw the seconds
        if( fast_updates ) {
            drawArc(dc, x, y, 100, (dateInfo.sec / 60f) * 2 * Math.PI, Gfx.COLOR_RED);
        }

        // Draw the strings. These coordinates should match the arcs above
        var dateStrings = Time.Gregorian.info( Time.now(), Time.FORMAT_MEDIUM );

        // TODO: There may be a better way to get the hour string than figuring it out ourselves
        var hourToDisplay = dateStrings.hour;
        if( !device_settings.is24Hour ) {
            hourToDisplay %= 12;
        }

        if( hourToDisplay == 0 && !device_settings.is24Hour ) {
            hourToDisplay = 12;
        }

        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(x, y - 25 + font_ofst, Gfx.FONT_TINY, dateStrings.month, Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(x, y - 40 + font_ofst, Gfx.FONT_TINY, Lang.format("$1$", [dateStrings.day]), Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(x, y - 55 + font_ofst, Gfx.FONT_TINY, dateStrings.day_of_week, Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(x, y - 70 + font_ofst, Gfx.FONT_TINY, Lang.format("$1$", [hourToDisplay]), Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(x, y - 85 + font_ofst, Gfx.FONT_TINY, Lang.format("$1$", [dateStrings.min.format("%02d")]), Gfx.TEXT_JUSTIFY_LEFT);

        if( fast_updates ) {
            dc.drawText(x, y - 100 + font_ofst, Gfx.FONT_TINY, Lang.format("$1$", [dateStrings.sec]), Gfx.TEXT_JUSTIFY_LEFT);
        }
    }

    //! Fast (but kind of bad-looking) arc drawing.
    //! From http://stackoverflow.com/questions/8887686/arc-subdivision-algorithm/8889666#8889666
    //! TODO: Once we have drawArc, use that instead.
    function drawArc(dc, cent_x, cent_y, radius, theta, color) {
        dc.setColor( color, Gfx.COLOR_WHITE);

        var iters = ARC_MAX_ITERS * ( theta / ( 2 * Math.PI ) );
        var dx = 0;
        var dy = -radius;
        var ctheta = Math.cos(theta/(iters - 1));
        var stheta = Math.sin(theta/(iters - 1));

        dc.fillCircle(cent_x + dx, cent_y + dy, BAR_THICKNESS);

        for(var i=1; i < iters; ++i) {
            var dxtemp = ctheta * dx - stheta * dy;
            dy = stheta * dx + ctheta * dy;
            dx = dxtemp;
            dc.fillCircle(cent_x + dx, cent_y + dy, BAR_THICKNESS);
        }
    }

    //! Right now we don't get another onUpdate when we go to sleep
    //! but for now, we can call requestUpdate ourselves
    function onEnterSleep( ) {
        fast_updates = false;
        Ui.requestUpdate();
    }

    function onExitSleep( ) {
        fast_updates = true;
    }

}