using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Math as Math;

class CalTrackView extends Ui.View {

    //! Constants
    hidden const BAR_THICKNESS = 10;
    hidden const ARC_MAX_ITERS = 300;
    hidden const CENTER_X = 109;
    hidden const CENTER_Y = 109;

    var menu_pressed;
    var start_pressed;

    //! Constructor
    function initialize() {
    }

    //! Load your resources here
    function onLayout( dc ) {
        setLayout( Rez.Layouts.MainLayout( dc ) );

        View.findDrawableById( "goal_title" ).setText( Rez.Strings.text_goal );
    }

    //! Update the view
    function onUpdate( dc ) {

        if( gShowRemaining == true ) {
            View.findDrawableById( "current_label" ).setText( Rez.Strings.text_remaining );
        } else {
            View.findDrawableById( "current_label" ).setText( Rez.Strings.text_consumed );
        }

        // Clear the background
        dc.setColor( Gfx.COLOR_BLACK, Gfx.COLOR_BLACK );
        dc.clear();

        // Draw the calories arc
        // 3.84 rad = 220 degrees
        var effectivePercentage = ( gTodayCal > gTodayGoal ) ? 1 : gTodayCal.toFloat() / gTodayGoal;
        effectivePercentage = ( gTodayCal < 0 ) ? 0 : effectivePercentage;
        if( effectivePercentage > 0.01 ) {
            drawArc( dc, CENTER_X, CENTER_Y, CENTER_X - 5, effectivePercentage * 3.84, ( gTodayGoal > gTodayCal ) ? Gfx.COLOR_GREEN : Gfx.COLOR_RED );
        }

        // Draw the border for the arc
        dc.setPenWidth( 2 );
        dc.setColor( Gfx.COLOR_DK_GRAY, Gfx.COLOR_DK_GRAY );
        dc.drawLine( CENTER_X, CENTER_Y, CENTER_X - 100, CENTER_Y + 45 );
        dc.drawLine( CENTER_X, CENTER_Y, CENTER_X + 100, CENTER_Y + 45 );
        dc.fillCircle( CENTER_X, CENTER_Y, 98 );

        // Clear the inside of the arc
        dc.setColor( Gfx.COLOR_BLACK, Gfx.COLOR_BLACK );
        dc.fillPolygon( [ [CENTER_X, CENTER_Y], [CENTER_X + 101, CENTER_Y + 46], [CENTER_X + 101, 218], [CENTER_X - 101, 218], [CENTER_X - 101, CENTER_Y + 46] ] );
        dc.fillCircle( CENTER_X, CENTER_Y, 96 );

        // Draw the various text
        View.findDrawableById( "goal_title" ).draw( dc );

        View.findDrawableById( "goal_value" ).setText( gTodayGoal.toString() );
        View.findDrawableById( "goal_value" ).draw( dc );

        if( gShowRemaining == true ) {
            View.findDrawableById( "current_value" ).setText( (gTodayGoal - gTodayCal).toString() );
        } else {
            View.findDrawableById( "current_value" ).setText( gTodayCal.toString() );
        }

        View.findDrawableById( "current_value" ).draw( dc );

        View.findDrawableById( "current_label" ).draw( dc );

        // On first run, show the help banner
        if( !gMenuPressed ) {
            dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_WHITE );
            dc.fillRectangle( 0, 0, 218, 72 );
            dc.setColor( Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT );
            View.findDrawableById( "one_time_tip" ).setText( Rez.Strings.menu_for_more );
            View.findDrawableById( "one_time_tip" ).draw( dc );
            }
        else if( !gStartPressed ) {
            dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_WHITE );
            dc.fillRectangle( 0, 0, 218, 72 );
            dc.setColor( Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT );
            View.findDrawableById( "one_time_tip" ).setText( Rez.Strings.start_for_more );
            View.findDrawableById( "one_time_tip" ).draw( dc );
            }

    }

    //! Fast (but kind of bad-looking) arc drawing.
    //! From http://stackoverflow.com/questions/8887686/arc-subdivision-algorithm/8889666#8889666
    //! TODO: Once we have drawArc, use that instead.
    function drawArc( dc, cent_x, cent_y, radius, theta, color ) {
        dc.setColor( color, Gfx.COLOR_WHITE );

        var iters = ARC_MAX_ITERS * ( theta / ( 2 * Math.PI ) );
        var dx = -100;
        var dy = 37;
        var ctheta = Math.cos( theta / ( iters - 1 ) );
        var stheta = Math.sin( theta / ( iters - 1 ) );

        dc.fillCircle( cent_x + dx, cent_y + dy, BAR_THICKNESS );

        for( var i=1; i < iters; ++i ) {
            var dxtemp = ctheta * dx - stheta * dy;
            dy = stheta * dx + ctheta * dy;
            dx = dxtemp;
            dc.fillCircle( cent_x + dx, cent_y + dy, BAR_THICKNESS );
        }
    }

}