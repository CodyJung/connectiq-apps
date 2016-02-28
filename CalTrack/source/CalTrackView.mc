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

        // Draw the arcs
        dc.setPenWidth( 8 );

        // Background arc
        dc.setColor( Gfx.COLOR_DK_GRAY, Gfx.COLOR_BLACK );
        dc.drawArc( CENTER_X, CENTER_Y, CENTER_X - 3, Gfx.ARC_CLOCKWISE, 240, 300 );

        // Calories arc
        gTodayCal = 100;
        var effectivePercentage = ( gTodayCal > gTodayGoal ) ? 1 : gTodayCal.toFloat() / gTodayGoal;
        effectivePercentage = ( gTodayCal < 0 ) ? 0 : effectivePercentage;

        if( effectivePercentage > 0.01 ) {
            var endAngle = ( 240 - ( effectivePercentage * 300 ) ).toLong() % 360;

            dc.setColor( ( gTodayGoal > gTodayCal ) ? Gfx.COLOR_GREEN : Gfx.COLOR_RED, Gfx.COLOR_BLACK );
            dc.drawArc( CENTER_X, CENTER_Y, CENTER_X - 3, Gfx.ARC_CLOCKWISE, 240, endAngle );
        }

        // Draw the various text
        View.findDrawableById( "app_title"  ).draw( dc );
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

}