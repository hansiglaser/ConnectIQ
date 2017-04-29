/**
 * Dummy start view, because AppBase.getInitialView() must return a real View
 * object, no Menu object.
 *
 * Taken from https://forums.garmin.com/showthread.php?361137-Starting-an-app-in-a-menu
 */

using Toybox.WatchUi as Ui;
using Toybox.System;

class SVStartView extends Ui.View {
  hidden var firstShow;

  function initialize() {
    View.initialize();
    firstShow = true;
  }

  function onShow() {
    // if this is the first call to `onShow', then we want the menu to immediately appear
    if (firstShow) {
      Ui.pushView(new Rez.Menus.MainMenu(), new SVMenuDelegate(), Ui.SLIDE_IMMEDIATE);
      firstShow = false;
    } else {
      // otherwise, we are returning to this view, most likely because the menu was exited,
      // either by pressing back, or by selecting an item that caused the menu to be popped,
      // so we want to pop ourselves
      Ui.popView(Ui.SLIDE_IMMEDIATE);
    }
  }
}

/**
 * Dummy delegate, necessary for the Back button to work.
 */
class SVStartDelegate extends Ui.BehaviorDelegate {
  function initialize() {
    BehaviorDelegate.initialize();
  }
}

// vi:syntax=javascript filetype=javascript
