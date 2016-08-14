using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.Lang as Lang;
using JungNumberPicker as NumPick;

class MainMenuDelegate extends Ui.MenuInputDelegate {
    function initialize() {
        Ui.MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        if( item == :menu_item_settings ) {
            var menu = new Rez.Menus.SettingsMenu();
            Ui.pushView( menu, new SettingsMenuDelegate(), Ui.SLIDE_LEFT );
        } else if( item == :menu_item_history ) {
            var historyMenu = new Ui.Menu();
            historyMenu.setTitle( Ui.loadResource( Rez.Strings.text_history ) );

            var app = App.getApp();

            var mruDate = 29991231;
            for( var i=0; i < 7; i++ ) {
                // Find the newest entry
                var latestIdx = -1;
                var latestDate = 0;

                for( var j=0; j < (MAX_DAYS_STORED * 3); j = j+3 ) {
                    var date = app.getProperty( j );
                    if( null != date && date > latestDate && date < mruDate ) {
                        latestDate = date;
                        latestIdx = j;
                    }
                }

                if( latestIdx != -1 ) {
                    var dateString = latestDate.toString();
                    historyMenu.addItem( Lang.format("$1$-$2$-$3$\n$4$/$5$", [ dateString.substring(0,4), dateString.substring(4,6), dateString.substring(6,8), app.getProperty(latestIdx + 1), app.getProperty(latestIdx + 2) ] ), i );
                    mruDate = latestDate;
                }
            }

            if( mruDate == 29991231 ) {
                historyMenu.addItem( Rez.Strings.text_no_history, 0 );
            }

            Ui.pushView( historyMenu, new SettingsMenuDelegate(), Ui.SLIDE_LEFT );
        } else if( item == :menu_item_subtract ) {
            gMode = MODE_SUBTRACTING;
            Ui.pushView( new NumPick.NumberPickerView(), new NumPick.NumberPickerBehaviorDelegate(), Ui.SLIDE_LEFT );
        }
    }
}

class SettingsMenuDelegate extends Ui.MenuInputDelegate {
    function initialize() {
        Ui.MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        if( item == :settings_item_set_goal ) {
            gMode = MODE_GOAL;
            Ui.pushView( new NumPick.NumberPickerView(), new NumPick.NumberPickerBehaviorDelegate(), Ui.SLIDE_LEFT );
        } else if( item == :settings_item_remaining ) {
            var menu = new Rez.Menus.CalorieDisplayMenu();
            Ui.pushView( menu, new CalorieDisplayMenuDelegate(), Ui.SLIDE_LEFT );
        } else if( item == :settings_item_clear ) {
            var app = App.getApp();
            for( var i=0; i < (MAX_DAYS_STORED * 3); i++ ) {
                app.deleteProperty( i );
            }
        }
    }
}

class CalorieDisplayMenuDelegate extends Ui.MenuInputDelegate {
    function initialize() {
        Ui.MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        if( item == :cal_display_remaining ) {
            gShowRemaining = true;
        } else if( item == :cal_display_consumed ) {
            gShowRemaining = false;
        }
    }
}