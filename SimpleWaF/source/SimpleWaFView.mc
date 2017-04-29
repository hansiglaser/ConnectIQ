/**
 * Extremely simple watchface
 *
 * Just as an exercize.
 *
 * (c) 2017 by Johann Glaser
 */

using Toybox.Graphics as Graphics;
using Toybox.Lang as Lang;
using Toybox.Math as Math;
using Toybox.System as System;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Gregorian;
using Toybox.WatchUi as Ui;

class SimpleWaFView extends Ui.WatchFace {

  var inSleepMode;

  function initialize() {
    WatchFace.initialize();
  }

  function onLayout(dc) {
  }

  // Draw the screen content
  function onUpdate(dc) {
    var width;
    var height;

    width  = dc.getWidth();
    height = dc.getHeight();

    var time = System.getClockTime();   // returns a ClockTime object with dst, hour, min, sec, timeZoneOffset
    var now  = Time.now();              // returns a Moment object, which contains the Unix epoch 
    var info = Gregorian.info(now, Time.FORMAT_LONG);  // returns an Info object with day, day_of_week, hour, min, month, sec, year

    var timeStr = info.hour.format("%02d") + ":" + info.min.format("%02d") + ":" + info.sec.format("%02d");
    var dateStr = Lang.format("$1$, $2$. $3$. $4$", [info.day_of_week, info.day, info.month, info.year]);

    // Clear the screen
    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
    dc.fillRectangle(0, 0, width, height);

    // Draw date and time
    dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
    dc.drawText(width / 2, 20, Graphics.FONT_NUMBER_HOT, timeStr, Graphics.TEXT_JUSTIFY_CENTER);
    dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
    dc.drawText(width / 2, 90, Graphics.FONT_MEDIUM,     dateStr, Graphics.TEXT_JUSTIFY_CENTER);

    // Draw the second
    if (inSleepMode) {
      // TODO
    }
  }

  function onEnterSleep() {
    inSleepMode = true;
    Ui.requestUpdate();
  }

  function onExitSleep() {
    inSleepMode = false;
  }
}

// vi:syntax=javascript filetype=javascript
