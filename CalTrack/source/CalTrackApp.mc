using Toybox.Application as App;
using Toybox.Lang as Lang;

//! Mmm global variables
var gTodayDate, gTodayCal, gTodayGoal, gShowRemaining, gMode, gHundreds, gMenuPressed, gStartPressed;
var gValuesChanged;
hidden const MAX_DAYS_STORED = 7;

enum {
    MODE_ADDING,
    MODE_SUBTRACTING,
    MODE_GOAL
}

class CalTrackApp extends App.AppBase {

    function initialize() {
        App.AppBase.initialize();
    }

    //! Constants
    hidden const FIRST_SETTING = 21; // MAX_DAYS_STORED * 3
    hidden const MENU_PRESSED = 22;
    hidden const START_PRESSED = 23;

    function onStart( state ) {
        // Determine today's date
        var dateInfo = Time.Gregorian.info( Time.now(), Time.FORMAT_SHORT );
        var dateString = Lang.format("$1$$2$$3$", [dateInfo.year, dateInfo.month.format("%02d"), dateInfo.day.format("%02d")] );
        gTodayDate = dateString.toNumber();
        gTodayGoal = 0;
        gTodayCal  = 0;

        // Try to find today's date in storage, or grab yesterday's goal
        var latestDay = 0;
        var found = false;

        var app = App.getApp();
        for( var i=0; i < (MAX_DAYS_STORED * 3); i = i+3 ) {
            var day = app.getProperty( i );
            if( null != day && day == gTodayDate ) {
                gTodayCal = app.getProperty( i + 1 );
                gTodayGoal = app.getProperty( i + 2 );
                found = true;
                break;
            } else if( null != day && day > latestDay ) {
                latestDay = day;
                gTodayGoal = app.getProperty( i + 2 );
                found = true;
            }
        }

        if( found == false ) {
            // No days of history - first time app user
            gTodayGoal = 2000;
        }

        // Pull the setting for remaining vs consumed
        gShowRemaining = app.getProperty( FIRST_SETTING );
        if( null == gShowRemaining ) {
            gShowRemaining = true;
        }

        // Pull the setting for START and MENU pressed
        gMenuPressed = app.getProperty( MENU_PRESSED );
        gStartPressed = app.getProperty( START_PRESSED );
        if( null == gMenuPressed ) {
            gMenuPressed = false;
        }
        if( null == gStartPressed ) {
            gStartPressed = false;
        }

        // We use this to determine if we have to save on exit or not
        gValuesChanged = false;
    }

    //! onStop() is called when your application is exiting - Save everything
    function onStop( state ) {
        if( gValuesChanged ) {
            var oldestDay = 29991231;
            var oldestIndex = 0;
            var found = false;

            var app = App.getApp();
            for( var i=0; i < (MAX_DAYS_STORED * 3); i = i+3 ) {
                var day = app.getProperty( i );
                if( null != day && day == gTodayDate ) {
                    app.setProperty( i + 1, gTodayCal );
                    app.setProperty( i + 2, gTodayGoal );
                    found = true;
                    break;
                } else if( null == day ) {
                    app.setProperty( i, gTodayDate );
                    app.setProperty( i + 1, gTodayCal );
                    app.setProperty( i + 2, gTodayGoal );
                    found = true;
                    break;
                } else {
                    if( day < oldestDay ) {
                        oldestDay = day;
                        oldestIndex = i;
                    }
                }
            }

            if( !found ) {
                // Full up. Use oldest day.
                app.setProperty( oldestIndex, gTodayDate );
                app.setProperty( oldestIndex + 1, gTodayCal );
                app.setProperty( oldestIndex + 2, gTodayGoal );
            }

            // Put the setting for remaining vs consumed
            app.setProperty( FIRST_SETTING, gShowRemaining );

            // Put the settings for START and MENU pressed
            app.setProperty( MENU_PRESSED, gMenuPressed );
            app.setProperty( START_PRESSED, gStartPressed );

            app.saveProperties();
        }
    }

    //! Return the initial view of your application here
    function getInitialView() {
        return [ new CalTrackView(), new CalTrackBehaviorDelegate() ];
    }

}