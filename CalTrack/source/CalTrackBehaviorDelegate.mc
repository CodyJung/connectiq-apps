using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Math as Math;
using JungNumberPicker as NumPick;

class CalTrackBehaviorDelegate extends Ui.BehaviorDelegate {
    function onKey( event ) {
        if( event.getKey() == WatchUi.KEY_ENTER ) {
            gMode = MODE_ADDING;
            Ui.pushView( new NumPick.NumberPickerView(), new NumPick.NumberPickerBehaviorDelegate(), Ui.SLIDE_LEFT );

            // The user knows how to press the menu button
            if( gMenuPressed && !gStartPressed ) {
                gStartPressed = true;
            }

            return true;
        }
        else if( event.getKey() == WatchUi.KEY_MENU ) {
            var menu = new Rez.Menus.MainMenu();
            menu.setTitle( Ui.loadResource( Rez.Strings.text_menu ) );
            Ui.pushView( menu, new MainMenuDelegate(), Ui.SLIDE_LEFT );

            // The user knows how to press the menu button
            if( !gMenuPressed ) {
                gMenuPressed = true;
            }

            return true;
        }

        // Didn't handle this event
        return false;
    }

}