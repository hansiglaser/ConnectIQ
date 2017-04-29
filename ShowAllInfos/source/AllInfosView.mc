/**
 * Paginating viewer (and start view)
 */

using Toybox.Graphics as Graphics;
using Toybox.Lang as Lang;
using Toybox.Math as Math;
using Toybox.System as System;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Gregorian;
using Toybox.WatchUi as Ui;
using Toybox.Activity as Activity;
using Toybox.ActivityMonitor as ActivityMonitor;
using Toybox.Position;
using Toybox.Sensor;
using Toybox.UserProfile;

// Main View /////////////////////////////////////////////////////////////////

/**
 * Start screen, only waits for the Select/Enter button
 */
class MainView extends Ui.View {

  var mAppName;
  var mIcon;

  // Constructor
  function initialize() {
    Ui.View.initialize();
    mAppName = Ui.loadResource(Rez.Strings.AppName);
    mIcon    = Ui.loadResource(Rez.Drawables.LauncherIcon);
  }

  function onUpdate(dc) {
    // Clear the screen
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
    dc.clear();

    dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
    dc.drawText(dc.getWidth()/2, 5, Graphics.FONT_LARGE, mAppName, Graphics.TEXT_JUSTIFY_CENTER);

    var x = (dc.getWidth()  - mIcon.getWidth())  / 2;
    var y = (dc.getHeight() - mIcon.getHeight()) / 2;
    dc.drawBitmap(x, y, mIcon);

    dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
    dc.drawText(dc.getWidth()/2, dc.getHeight()-30, Graphics.FONT_LARGE, "Press Select", Graphics.TEXT_JUSTIFY_CENTER);
  }

}

class MainDelegate extends Ui.BehaviorDelegate {

  // Constructor
  function initialize() {
    Ui.BehaviorDelegate.initialize();
  }

  function onSelect() {
    var view;
    view = new AllInfosView();
    Ui.pushView(view, new AllInfosViewDelegate(view), Ui.SLIDE_LEFT);
  }

}

// Info View /////////////////////////////////////////////////////////////////

/**
 * Paginating information viewer
 */
class AllInfosView extends Ui.View {

  var mAllInfos;
  var mScreenWidth;
  var mScreenHeight;
  var mGroupFont;
  var mElementFont;
  var mGroupHeight;
  var mElementHeight;
  var mElPerPage;
  var mCurrentGroup;
  var mCurrentPage;
  var mPageIndGroup;
  var mPageIndPage;

  function initialize() {
    Ui.View.initialize();
    //mAllInfos = new AllInfos(OUT_PRINT);
    mAllInfos = new AllInfos(OUT_STORE);
    mAllInfos.StoreAllInfos();
    //mAllInfos.Print();
    mScreenWidth   = System.getDeviceSettings().screenWidth;
    mScreenHeight  = System.getDeviceSettings().screenHeight;
    mGroupFont     = Graphics.FONT_SMALL;
    mElementFont   = Graphics.FONT_XTINY;
    mGroupHeight   = Graphics.getFontHeight(mGroupFont);
    mElementHeight = Graphics.getFontHeight(mElementFont);
    mElPerPage     = (mScreenHeight - 8 - mGroupHeight - 8) / mElementHeight;
    mCurrentGroup  = 0;
    mCurrentPage   = 0;
    mPageIndGroup  = new PageIndicator();
    mPageIndPage   = new PageIndicator();
    mPageIndGroup.setup(mAllInfos.InfoData.size(), Graphics.COLOR_GREEN, Graphics.COLOR_BLUE, mPageIndGroup.ALIGN_TOP_CENTER, 4, 0);
    mPageIndPage. setup(3, Graphics.COLOR_YELLOW, Graphics.COLOR_ORANGE, mPageIndPage.ALIGN_BOTTOM_CENTER, 4, 1);
  }

  function onLayout(dc) {
  }

  // Draw the screen
  function onUpdate(dc) {
    var y;

    // Clear the screen
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
    dc.clear();

    // print current group name
    y = 8;
    dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
    dc.drawText(dc.getWidth()/2, y, mGroupFont, mAllInfos.InfoData[mCurrentGroup][:title], Graphics.TEXT_JUSTIFY_CENTER);
    y += mGroupHeight; 

    // print lines of information (as many as fit or are available in this group)
    dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
    var i;
    var st;
    for (i = mCurrentPage*mElPerPage; i < (mCurrentPage+1)*mElPerPage && i < mAllInfos.InfoData[mCurrentGroup][:elements].size(); i++) {
      st = mAllInfos.ElementToString(mAllInfos.InfoData[mCurrentGroup][:elements][i]);
      dc.drawText(10, y, mElementFont, st, Graphics.TEXT_JUSTIFY_LEFT);
      y += mElementHeight;
    }

    // draw page indicators
    mPageIndGroup.draw(dc, mCurrentGroup);
    mPageIndPage.mSize = (mAllInfos.InfoData[mCurrentGroup][:elements].size()-1) / mElPerPage + 1;
    mPageIndPage. draw(dc, mCurrentPage);
  }

  function NextPage() {
    if ((mCurrentPage+1)*mElPerPage < mAllInfos.InfoData[mCurrentGroup][:elements].size()) {
      // same group, next page
      mCurrentPage++;
    } else {
      // next group
      mCurrentGroup++;
      if (mCurrentGroup >= mAllInfos.InfoData.size()) {
        // wrap around
        mCurrentGroup = 0;
      }
      // first page
      mCurrentPage = 0;
    }
    Ui.requestUpdate();
  }

  function PrevPage() {
    if (mCurrentPage > 0) {
      // same group, previous page
      mCurrentPage--;
    } else {
      if (mCurrentGroup > 0) {
        // previous group
        mCurrentGroup--;
      } else {
        // wrap around
        mCurrentGroup = mAllInfos.InfoData.size()-1;
      }
      // last page
      mCurrentPage = (mAllInfos.InfoData[mCurrentGroup][:elements].size()-1) / mElPerPage;
    }
    Ui.requestUpdate();
  }

}

class AllInfosViewDelegate extends Ui.BehaviorDelegate {

  var mView;

  function initialize(view) {
    BehaviorDelegate.initialize();
    mView = view;
  }

  function onNextPage() {
    mView.NextPage();
    return true;
  }

  function onPreviousPage() {
    mView.PrevPage();
    return true;
  }

  function onBack() {
    Ui.popView(Ui.SLIDE_RIGHT);
    return true;
  }

}

// vi:syntax=javascript filetype=javascript
