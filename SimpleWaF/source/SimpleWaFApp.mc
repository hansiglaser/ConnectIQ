/**
 * Extremely simple watchface
 *
 * Just as an exercize.
 *
 * (c) 2017 by Johann Glaser
 */

using Toybox.Application as App;

class SimpleWaF extends App.AppBase {

  function initialize() {
    AppBase.initialize();
  }

  function onStart(state) {
  }

  function onStop(state) {
  }

  function getInitialView() {
    return [new SimpleWaFView()];
  }

}

// vi:syntax=javascript filetype=javascript
