/**
 * Base class for SensorViz visualization views.
 */

using Toybox.WatchUi as Ui;
using Toybox.System;

/**
 * Abstract base class for sensor views
 *
 * This class provides the basic functionality to visualize sensor values.
 *  - constructor
 *  - storage for title, callback function, period
 *  - periodic timer
 */
class SVBaseView extends Ui.View {
  var mTitle;            // title of the view
  var mQuerySensorCB;    // callback to query the sensors
  var mTime;             // period of the timer in ms
  var mTimer;            // timer object
  var mData;             // sensor data returned from the last callback

  /**
   * Constructor
   *
   * @param title          title of the view/sensor
   * @param querySensorCB  callback method to query the sensor, should return
   *                       its value or null if no value is available
   * @param time           time between updates in ms
   */
  function initialize(title, querySensorCB, time) {
    View.initialize();
    mTitle         = title;
    mQuerySensorCB = querySensorCB;
    mTime          = time;
    mTimer         = null;
    mData          = null;
  }

  function onShow() {
    if (mTimer == null) {
      mTimer = new Timer.Timer();
      mTimer.start(method(:onTimer), mTime, true);
    }
  }

  function onHide() {
    mTimer.stop();
  }

  function onTimer() {
    mData = mQuerySensorCB.invoke();
    Ui.requestUpdate();
  }

}

// vi:syntax=javascript filetype=javascript
