/**
 * Menu handler and sensor measurement callbacks
 */

using Toybox.WatchUi as Ui;
using Toybox.System;
using Toybox.Math;

class SVMenuDelegate extends Ui.MenuInputDelegate {

  function initialize() {
    MenuInputDelegate.initialize();
  }

  function onMenuItem(item) {
    var view;
    if (item == :accel) {
      view = new SV3DView("Acceleration", self.method(:queryAccel), 100);
      Ui.pushView(view, new SV3DDelegate(view), Ui.SLIDE_LEFT);
    } else if (item == :mag) {
      view = new SV3DView("Magnetometer", self.method(:queryMag), 100);
      Ui.pushView(view, new SV3DDelegate(view), Ui.SLIDE_LEFT);
    }
  }

  function onBack() {
    Ui.popView(Ui.SLIDE_RIGHT);
  }

  // Sensor Measurement Callbacks ////////////////////////////////////////////

  function queryAccel() {
    var info = Sensor.getInfo();
    if (info has :accel) {
      return info.accel;
    } else {
      // sensor not available --> simulate values
      return getSimSensor3D();
    }
  }

  function queryMag() {
    var info = Sensor.getInfo();
    if (info has :mag) {
      return info.mag;
    } else {
      // sensor not available
      return null;
    }
  }

  // Sensor Simulation ///////////////////////////////////////////////////////

  // persistent storage with start value
  var SimSensor3D = [799, 322, -774];

  function getSimSensor3D() {
    // add -32..31 each time, rand() returns 0..2^31-1
    SimSensor3D[0] += (Math.rand() >> (31-6)) - (1<<5);
    SimSensor3D[1] += (Math.rand() >> (31-6)) - (1<<5);
    SimSensor3D[2] += (Math.rand() >> (31-6)) - (1<<5);
    return SimSensor3D;
  }

}

// vi:syntax=javascript filetype=javascript
