/**
 * SensorViz -- Visualize sensor data (in 3D)
 *
 * This app displays the accelerometer and magnetometer measurements as
 * interactive 3D graph. You can go around the coordinate system using the Up
 * and Down buttons.
 *
 * (c) 2017 by Johann Glaser
 *
 * TODO
 *  - enable/disable display of spherical coordinates
 *  - draw arcs for spherical coordinates: one in xy-plane from 0° to phi (also
 *    draw projection in xy plane additional to axis connectors), one from the
 *    +z axis downward for theta
 *  - pause measurements
 *  - zoom in/out
 *  - increase/decrease camera z position
 *  - move (rotate, scale) the coordinate system with a fixed arrow
 * 
 */

using Toybox.Application as App;
using Toybox.System;

class SensorViz extends App.AppBase {

  function initialize() {
    AppBase.initialize();
  }

  function onStart(state) {
  }

  function onStop(state) {
  }

  function getInitialView() {
    return [new SVStartView(), new SVStartDelegate()];
  }

}

// vi:syntax=javascript filetype=javascript
