using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.Lang as Lang;

class MainMenuDelegate extends Ui.MenuInputDelegate {
    function onMenuItem(item) {
        if( item == :menu_item_settings ) {
            var menu = new Rez.Menus.SettingsMenu();
            menu.setTitle( Ui.loadResource( Rez.Strings.text_settings ) );
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
                    historyMenu.addItem( Lang.format("$1$-$2$-$3$\n$4$/$5$", [ dateString.substring(0,4), dateString.substring(4,6), dateString.substring(6,8), app.getProperty(latestIdx + 1), app.getProperty(latestIdx + 2) ] ) );
                    mruDate = latestDate;
                }

            }


            Ui.pushView( historyMenu, new SettingsMenuDelegate(), Ui.SLIDE_LEFT );
        } else if( item == :menu_item_subtract ) {
            gMode = MODE_SUBTRACTING;
            var menu = new Rez.Menus.HundredsMenu();
            menu.setTitle( Ui.loadResource( Rez.Strings.text_enter_hundreds ) );
            Ui.pushView( menu, new HundredsMenuDelegate(), Ui.SLIDE_LEFT );
        }
    }
}

class SettingsMenuDelegate extends Ui.MenuInputDelegate {
    function onMenuItem(item) {
        if( item == :settings_item_set_goal ) {
            gMode = MODE_GOAL;
            var menu = new Rez.Menus.HundredsMenu2();
            menu.setTitle( Ui.loadResource( Rez.Strings.text_enter_hundreds ) );
            Ui.pushView( menu, new HundredsMenuDelegate(), Ui.SLIDE_LEFT );
        } else if( item == :settings_item_remaining ) {
            var menu = new Rez.Menus.CalorieDisplayMenu();
            menu.setTitle( Ui.loadResource( Rez.Strings.text_calorie_display ) );
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
    function onMenuItem(item) {
        if( item == :cal_display_remaining ) {
            gShowRemaining = true;
        } else if( item == :cal_display_consumed ) {
            gShowRemaining = false;
        }
    }
}

class HundredsMenuDelegate extends Ui.MenuInputDelegate {
    function onMenuItem(item) {
        Ui.popView( Ui.SLIDE_DOWN );


        if( item == :hun_more ) {
            var menu = new Rez.Menus.HundredsMenu2();
            menu.setTitle( Ui.loadResource( Rez.Strings.text_enter_hundreds ) );
            Ui.pushView( menu, new HundredsMenuDelegate(), Ui.SLIDE_UP );
        } else if( item == :hun_less ) {
            var menu = new Rez.Menus.HundredsMenu();
            menu.setTitle( Ui.loadResource( Rez.Strings.text_enter_hundreds ) );
            Ui.pushView( menu, new HundredsMenuDelegate(), Ui.SLIDE_DOWN );
        } else if( item == :hun_more2 ) {
            var menu = new Rez.Menus.HundredsMenu3();
            menu.setTitle( Ui.loadResource( Rez.Strings.text_enter_hundreds ) );
            Ui.pushView( menu, new HundredsMenuDelegate(), Ui.SLIDE_UP );
        } else if( item == :hun_less2 ) {
            var menu = new Rez.Menus.HundredsMenu2();
            menu.setTitle( Ui.loadResource( Rez.Strings.text_enter_hundreds ) );
            Ui.pushView( menu, new HundredsMenuDelegate(), Ui.SLIDE_DOWN );
        } else {
            if( item == :hun_0 ) {
                gHundreds = 0;
            } else if( item == :hun_1 ) {
                gHundreds = 100;
            } else if( item == :hun_2 ) {
                gHundreds = 200;
            } else if( item == :hun_3 ) {
                gHundreds = 300;
            } else if( item == :hun_4 ) {
                gHundreds = 400;
            } else if( item == :hun_5 ) {
                gHundreds = 500;
            } else if( item == :hun_6 ) {
                gHundreds = 600;
            } else if( item == :hun_7 ) {
                gHundreds = 700;
            } else if( item == :hun_8 ) {
                gHundreds = 800;
            } else if( item == :hun_9 ) {
                gHundreds = 900;
            } else if( item == :hun_10 ) {
                gHundreds = 1000;
            } else if( item == :hun_11 ) {
                gHundreds = 1100;
            } else if( item == :hun_12 ) {
                gHundreds = 1200;
            } else if( item == :hun_13 ) {
                gHundreds = 1300;
            } else if( item == :hun_14 ) {
                gHundreds = 1400;
            } else if( item == :hun_15 ) {
                gHundreds = 1500;
            } else if( item == :hun_16 ) {
                gHundreds = 1600;
            } else if( item == :hun_17 ) {
                gHundreds = 1700;
            } else if( item == :hun_18 ) {
                gHundreds = 1800;
            } else if( item == :hun_19 ) {
                gHundreds = 1900;
            } else if( item == :hun_20 ) {
                gHundreds = 2000;
            } else if( item == :hun_21 ) {
                gHundreds = 2100;
            } else if( item == :hun_22 ) {
                gHundreds = 2200;
            } else if( item == :hun_23 ) {
                gHundreds = 2300;
            } else if( item == :hun_24 ) {
                gHundreds = 2400;
            } else if( item == :hun_25 ) {
                gHundreds = 2500;
            } else if( item == :hun_26 ) {
                gHundreds = 2600;
            } else if( item == :hun_27 ) {
                gHundreds = 2700;
            } else if( item == :hun_28 ) {
                gHundreds = 2800;
            } else if( item == :hun_29 ) {
                gHundreds = 2900;
            } else if( item == :hun_30 ) {
                gHundreds = 3000;
            } else if( item == :hun_31 ) {
                gHundreds = 3100;
            } else if( item == :hun_32 ) {
                gHundreds = 3200;
            } else if( item == :hun_33 ) {
                gHundreds = 3300;
            } else if( item == :hun_34 ) {
                gHundreds = 3400;
            } else if( item == :hun_35 ) {
                gHundreds = 3500;
            } else if( item == :hun_36 ) {
                gHundreds = 3600;
            } else if( item == :hun_37 ) {
                gHundreds = 3700;
            } else if( item == :hun_38 ) {
                gHundreds = 3800;
            } else if( item == :hun_39 ) {
                gHundreds = 3900;
            } else if( item == :hun_40 ) {
                gHundreds = 4000;
            }

            var menu = new Rez.Menus.TensMenu();
            menu.setTitle( Ui.loadResource( Rez.Strings.text_enter_tens ) );
            Ui.pushView( menu, new TensMenuDelegate(), Ui.SLIDE_IMMEDIATE );
        }
    }
}

class TensMenuDelegate extends Ui.MenuInputDelegate {
    function onMenuItem(item) {
        var totalVal = gHundreds;

        if( item == :ten_0 ) {
            totalVal += 0;
        } else if( item == :ten_1 ) {
            totalVal += 10;
        } else if( item == :ten_2 ) {
            totalVal += 20;
        } else if( item == :ten_3 ) {
            totalVal += 30;
        } else if( item == :ten_4 ) {
            totalVal += 40;
        } else if( item == :ten_5 ) {
            totalVal += 50;
        } else if( item == :ten_6 ) {
            totalVal += 60;
        } else if( item == :ten_7 ) {
            totalVal += 70;
        } else if( item == :ten_8 ) {
            totalVal += 80;
        } else if( item == :ten_9 ) {
            totalVal += 90;
        }

        if( gMode == MODE_ADDING ) {
            gTodayCal += totalVal;
        } else if( gMode == MODE_SUBTRACTING ) {
            gTodayCal -= totalVal;
        } else if( gMode == MODE_GOAL ) {
            gTodayGoal = totalVal;
        }

        return true;
    }
}