using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Math as Math;

module JungNumberPicker {

    enum {
        PG_MODE_HUNDREDS,
        PG_MODE_TENS,
        PG_MODE_ONES
    }

    //! Variables
    var page_mode;
    var value;

    class NumberPickerView extends Ui.View {

        //! Constants

        //! Variables
        var upArrowBmp;
        var dnArrowBmp;

        //! Constructor
        function initialize() {
            Ui.View.initialize();

            page_mode = PG_MODE_HUNDREDS;
            value = 1234;

            //! Set up initial value
            if( MODE_ADDING == gMode ) {
                value = 0;
            } else if( MODE_SUBTRACTING == gMode ) {
                value = 0;
            } else if( MODE_GOAL == gMode ) {
                value = gTodayGoal;
            }
        }

        //! Load your resources here
        function onLayout( dc ) {
            setLayout( Rez.Layouts.NumberPickerLayout( dc ) );

            if( MODE_ADDING == gMode ) {
                View.findDrawableById( "picker_title" ).setText( Rez.Strings.text_add_calories );
            } else if( MODE_SUBTRACTING == gMode ) {
                View.findDrawableById( "picker_title" ).setText( Rez.Strings.text_subtract_calories );
            } else if( MODE_GOAL == gMode ) {
                View.findDrawableById( "picker_title" ).setText( Rez.Strings.text_set_goal );
            }

            upArrowBmp = Ui.loadResource( Rez.Drawables.UpArrow );
            dnArrowBmp = Ui.loadResource( Rez.Drawables.DnArrow );
        }

        //! Update the view
        function onUpdate( dc ) {
            //! Clear the background
            dc.setColor( Gfx.COLOR_BLACK, Gfx.COLOR_BLACK );
            dc.clear();

            //! Update values
            View.findDrawableById( "hundreds_value" ).setText( ( value / 100 ).format( "%02d" ) );
            View.findDrawableById( "tens_value" ).setText( ( ( value % 100 ) / 10 ).toString() );
            View.findDrawableById( "ones_value" ).setText( ( value % 10 ).toString() );

            //! Draw the layout
            View.onUpdate( dc );

            //! Draw the underlines
            dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_WHITE );
            dc.setPenWidth( 2 );

            if( PG_MODE_HUNDREDS == page_mode ) {
                dc.drawBitmap( ( value < 2000 && value >= 1000 ) ? 85 : 83, 65, upArrowBmp );
                dc.drawBitmap( ( value < 2000 && value >= 1000 ) ? 85 : 83, 150, dnArrowBmp );
                dc.drawLine( ( value < 2000 && value >= 1000 ) ? 73 : 67, 140, 105, 140 );
            } else if( PG_MODE_TENS == page_mode ) {
                dc.drawBitmap( 115, 65, upArrowBmp );
                dc.drawBitmap( 115, 150, dnArrowBmp );
                dc.drawLine( 109, 140, 127, 140 );
            } else if( PG_MODE_ONES == page_mode ) {
                dc.drawBitmap( 136, 65, upArrowBmp );
                dc.drawBitmap( 136, 150, dnArrowBmp );
                dc.drawLine( 129, 140, 149, 140 );
            }
        }
    }

    class NumberPickerBehaviorDelegate extends Ui.BehaviorDelegate {
        function initialize() {
            Ui.BehaviorDelegate.initialize();
        }

        function onKey( event ) {
            if( event.getKey() == WatchUi.KEY_ENTER ) {
                //! Go to the next page mode, or finish
                if( PG_MODE_HUNDREDS == page_mode ) {
                    page_mode = PG_MODE_TENS;
                } else if( PG_MODE_TENS == page_mode ) {
                    page_mode = PG_MODE_ONES;
                } else if( PG_MODE_ONES == page_mode ) {
                    //! Save Value
                    if( MODE_ADDING == gMode ) {
                        gTodayCal += value;
                    } else if( MODE_SUBTRACTING == gMode ) {
                        gTodayCal -= value;
                    } else if( MODE_GOAL == gMode ) {
                        gTodayGoal = value;
                    }
                    Ui.popView( Ui.SLIDE_RIGHT );
                }

                Ui.requestUpdate();
                return true;
            } else if( event.getKey() == WatchUi.KEY_ESC ) {
                //! Go to the previous page mode, or exit
                if( PG_MODE_HUNDREDS == page_mode ) {
                    Ui.popView( Ui.SLIDE_RIGHT );
                    return true;
                } else if( PG_MODE_TENS == page_mode ) {
                    page_mode = PG_MODE_HUNDREDS;
                    Ui.requestUpdate();
                    return true;
                } else if( PG_MODE_ONES == page_mode ) {
                    page_mode = PG_MODE_TENS;
                    Ui.requestUpdate();
                    return true;
                }

                return false;
            } else if( event.getKey() == WatchUi.KEY_UP ) {
                //! Up - increase value
                if( PG_MODE_HUNDREDS == page_mode ) {
                    value += 100;
                } else if( PG_MODE_TENS == page_mode ) {
                    if( ( value / 10 ) % 10 == 9 ) {
                        value -= 90;
                    } else {
                        value += 10;
                    }
                } else if( PG_MODE_ONES == page_mode ) {
                    if( value % 10 == 9 ) {
                        value -= 9;
                    } else {
                        value += 1;
                    }
                }

                if( value > 4000 ) {
                    value = 4000;
                }

                Ui.requestUpdate();
                return true;
            } else if( event.getKey() == WatchUi.KEY_DOWN ) {
                //! Down - decrease value
                if( PG_MODE_HUNDREDS == page_mode ) {
                    value -= 100;
                } else if( PG_MODE_TENS == page_mode ) {
                    if( ( value / 10 ) % 10 == 0 ) {
                        value += 90;
                    } else {
                        value -= 10;
                    }
                } else if( PG_MODE_ONES == page_mode ) {
                    if( value % 10 == 0 ) {
                        value += 9;
                    } else {
                        value -= 1;
                    }
                }

                if( value < 0 ) {
                    value = 0;
                }

                Ui.requestUpdate();
                return true;
            }

            // Didn't handle this event
            return false;
        }

    }
}