using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;

class SectorWatchView extends Ui.WatchFace {

    //! Constants
    // Yeah, I'm kind of scumming this. I precalculated these because I didn't want to
    // deal with doing a whole lot of sines/cosines every minute/second.
    const min_array = [ [109,   0], [120,   1], [132,   2], [143,   5], [153,   9],
                         [164,  15], [173,  21], [182,  28], [190,  36], [197,  45],
                         [203,  55], [209,  65], [213,  75], [216,  86], [217,  98],
                         [218, 109], [217, 120], [216, 132], [213, 143], [209, 153],
                         [203, 164], [197, 173], [190, 182], [182, 190], [173, 197],
                         [164, 203], [153, 209], [143, 213], [132, 216], [120, 217],
                         [109, 218], [ 98, 217], [ 86, 216], [ 75, 213], [ 65, 209],
                         [ 55, 203], [ 45, 197], [ 36, 190], [ 28, 182], [ 21, 173],
                         [ 15, 164], [  9, 153], [  5, 143], [  2, 132], [  1, 120],
                         [  0, 109], [  1,  98], [  2,  86], [  5,  75], [  9,  65],
                         [ 15,  55], [ 21,  45], [ 28,  36], [ 36,  28], [ 45,  21],
                         [ 55,  15], [ 65,   9], [ 75,   5], [ 86,   2], [ 98,   1] ];

    const hour_array = [ [109,  19], [132,  22], [154,  31], [172,  45],
                         [186,  64], [196,  86], [199, 109], [196, 132],
                         [187, 153], [172, 173], [154, 187], [132, 196],
                         [109, 199], [ 86, 196], [ 64, 187], [ 46, 173],
                         [ 32, 154], [ 22, 132], [ 19, 109], [ 22,  86],
                         [ 32,  64], [ 46,  45], [ 64,  31], [ 86,  22] ];

    //! Class vars
    var fast_updates = true;

    //! Load your resources here
    function onLayout(dc) {
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
        // Set background color
        dc.clear();
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());

        // Get the current time
        var dateInfo = Time.Gregorian.info( Time.now(), Time.FORMAT_SHORT );

        // Draw the minute ticks
        // We're drawing a polygon from the top middle of the screen,
        // to the center, to the appropriate minute coord, to the right, up,
        // then back to the top middle.
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        if( dateInfo.min <= 30 ) {
            dc.fillPolygon([min_array[0], [109, 109], min_array[dateInfo.min], [218, min_array[dateInfo.min][1]], [218, 0]]);
        } else {
            // Right half
            dc.fillPolygon([min_array[0], [109, 109], min_array[30], [218, min_array[30][1]], [218, 0]]);
            // Left half
            dc.fillPolygon([min_array[30], [109, 109], min_array[dateInfo.min], [0, min_array[dateInfo.min][1]], [0, 218]]);
        }

        // Draw the current second in red
        if( fast_updates ) {
            dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_RED);
            var out_x = ( min_array[dateInfo.sec][0] + min_array[( dateInfo.sec + 1 ) % 60][0] ) / 2;
            var out_y = ( min_array[dateInfo.sec][1] + min_array[( dateInfo.sec + 1 ) % 60][1] ) / 2;
            dc.fillPolygon([min_array[dateInfo.sec], [out_x, out_y], min_array[( dateInfo.sec + 1 ) % 60], [109, 109]]);
        }

        // Draw the segments
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        for( var i=0; i<30; i++ ) {
            dc.drawLine(min_array[i][0], min_array[i][1], min_array[i+30][0], min_array[i+30][1]);
        }

        // Clear central area for hour ticks
        dc.fillCircle( 109, 109, 90 );

        // Draw hour ticks in dark gray. Here we're drawing the
        // ticks individually.
        dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
        for( var i=0; i < dateInfo.hour; i++ ) {
            dc.fillPolygon([ hour_array[i], [109, 109], hour_array[i + 1 % 24] ]);
        }

        // Segment the hour ticks
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        for( var i=0; i<12; i++ ) {
            dc.drawLine(hour_array[i][0], hour_array[i][1], hour_array[i+12][0], hour_array[i+12][1]);
        }

        // Clear the very center
        dc.fillCircle( 109, 109, 60 );

        // Draw the current time in black
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        var timeString = Lang.format("$1$:$2$", [dateInfo.hour, dateInfo.min.format("%02d")]);
        var timeYOfst = dc.getFontHeight(Gfx.FONT_NUMBER_HOT);
        dc.drawText( 109, 109 - (timeYOfst / 2), Gfx.FONT_NUMBER_HOT, timeString, Gfx.TEXT_JUSTIFY_CENTER);
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