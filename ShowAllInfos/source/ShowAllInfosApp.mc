/**
 * Collect and display all available information
 *
 * Use the Up/Down buttons to switch between the pages.
 *
 * (c) 2017 by Johann Glaser
 */

using Toybox.Application as App;

class ShowAllInfos extends App.AppBase {

  function initialize() {
    AppBase.initialize();
  }

  function onStart(state) {
  }

  function onStop(state) {
  }

  function getInitialView() {
    return [new MainView(), new MainDelegate()];
  }

}

// vi:syntax=javascript filetype=javascript
