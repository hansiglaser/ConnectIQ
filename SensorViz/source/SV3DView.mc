/**
 * 3D viewer for 3D sensor data
 */

using Toybox.WatchUi as Ui;
using Toybox.Graphics;
using Toybox.Math;
using Toybox.System;
using Matrix;
using Graphics3D;

class SV3DView extends SVBaseView {

  var mG3D;

  function initialize(title, querySensorCB, time) {
    SVBaseView.initialize(title, querySensorCB, time);
    mG3D = new Graphics3D.Graphics3D();

    var m;

    // Create view matrix

    // look from top down along the Z axis, +1.0 is behind the camera,
    // -1.0 is in front, so that x goes to the right, and y goes to the top
    //m = Graphics3D.getLookAt([0.0, 0.0, 5.0], [0.0, 0.0, 0.0], [0.0, 1.0, 0.0]);

    // look from bottom up
    //m = Graphics3D.getLookAt([0.0, 0.0, -5.0], [0.0, 0.0, 0.0], [0.0, 1.0, 0.0]);

    // look from right along the X axis, i.e., +1.0 is behind the camera, -1.0 in
    // front of it, so that y goes to the right, and z goes to the top
    //m = Graphics3D.getLookAt([5.0, 0.0, 0.0], [0.0, 0.0, 0.0], [0.0, 0.0, 1.0]);
    
    // look from front along Y axis, i.e., -1.0 is behind the camera, +1.0 is in
    // front of it, so that x goes to the right, and z goes to the top
    //m = Graphics3D.getLookAt([0.0, -5.0, 0.0], [0.0, 0.0, 0.0], [0.0, 0.0, 1.0]);

    // look from diagonally above
    //m = Graphics3D.getLookAt([2.0, 2.5, 1.5], [0.0, 0.0, 0.0], [0.0, 0.0, 1.0]);
    m = Graphics3D.getLookAt([5.0, 4.0, 3.0], [0.0, 0.0, 0.0], [0.0, 0.0, 1.0]);

    mG3D.setModelMatrix(m);

    // Create projection matrix

    m = Matrix.getEye(4);
    // move the origin to the center of the screen
    var cx = System.getDeviceSettings().screenWidth*0.5;
    var cy = System.getDeviceSettings().screenHeight*0.5;
    m = Matrix.mul4x4(m, Graphics3D.getTranslate(cx, cy+25, 0.0)); // a bit below the center
    // scale so that approx. -2.0 .. +2.0 is equivalent to the screen height,
    // reverse y coordinates because the screen counts from top to bottom
    m = Matrix.mul4x4(m, Graphics3D.getScale(cy*0.5, -cy*0.5, 1.0));
    // perspective projection
    m = Matrix.mul4x4(m, Graphics3D.getPerspective(Math.toRadians(20.0), 1.0, 1.0, 1000.0));

    mG3D.setProjectionMatrix(m);

    mG3D.updateMatrix();
  }

  /**
   * Draw the screen
   */
  function onUpdate(dc) {
    var width  = dc.getWidth();
    var height = dc.getHeight();
    
    // clear the screen
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
    dc.clear();

    // title
    dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
    dc.drawText(width / 2,  3, Graphics.FONT_LARGE, mTitle, Graphics.TEXT_JUSTIFY_CENTER);

    if (mData == null) {
      // no data (yet)
      dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
      dc.drawText(width / 2,  30, Graphics.FONT_TINY, "No Sensor Data Available", Graphics.TEXT_JUSTIFY_CENTER);
      return;
    }

    // sensor data is in mData
    // calculate spherical coordinates
    var spR     = Math.sqrt(mData[0]*mData[0] + mData[1]*mData[1] + mData[2]*mData[2]);
    var spTheta = Math.acos(mData[2]/spR);
    var spPhi   = Math.atan2(mData[1], mData[0]);
    var spStr   = "r="+spR.format("%.2f") + ", th="+Math.toDegrees(spTheta).format("%.1f") + "°, ph="+Math.toDegrees(spPhi).format("%.1f")+"°";
    
    // print data
    dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
    dc.drawText(width / 2,  30, Graphics.FONT_TINY, "Data: " + mData, Graphics.TEXT_JUSTIFY_CENTER);
    dc.drawText(width / 2,  50, Graphics.FONT_TINY, spStr, Graphics.TEXT_JUSTIFY_CENTER);

    // prepare 3D drawing
    mG3D.setDc(dc);

    // coordinate system (bright color is positive)
    dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
    mG3D.drawLine([0.0,0.0,0.0], [ 1.0, 0.0, 0.0]);
    dc.setColor(Graphics.COLOR_DK_RED, Graphics.COLOR_TRANSPARENT);
    mG3D.drawLine([0.0,0.0,0.0], [-1.0, 0.0, 0.0]);
    dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
    mG3D.drawLine([0.0,0.0,0.0], [ 0.0, 1.0, 0.0]);
    dc.setColor(Graphics.COLOR_DK_GREEN, Graphics.COLOR_TRANSPARENT);
    mG3D.drawLine([0.0,0.0,0.0], [ 0.0,-1.0, 0.0]);
    dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
    mG3D.drawLine([0.0,0.0,0.0], [ 0.0, 0.0, 1.0]);
    dc.setColor(Graphics.COLOR_DK_BLUE, Graphics.COLOR_TRANSPARENT);
    mG3D.drawLine([0.0,0.0,0.0], [ 0.0, 0.0,-1.0]);

    // unit cube
    dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_TRANSPARENT);
    // square at z=-1.0
    mG3D.drawPoly([[ 1.0, 1.0,-1.0], [ 1.0,-1.0,-1.0], [-1.0,-1.0,-1.0], [-1.0, 1.0,-1.0]], true);
    // square at z=+1.0
    dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
    mG3D.drawPoly([[ 1.0, 1.0, 1.0], [ 1.0,-1.0, 1.0], [-1.0,-1.0, 1.0], [-1.0, 1.0, 1.0]], true);
    // connecting vertical corners
    dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
    mG3D.drawLine([ 1.0, 1.0, 1.0], [ 1.0, 1.0,-1.0]);
    mG3D.drawLine([ 1.0,-1.0, 1.0], [ 1.0,-1.0,-1.0]);
    mG3D.drawLine([-1.0,-1.0, 1.0], [-1.0,-1.0,-1.0]);
    mG3D.drawLine([-1.0, 1.0, 1.0], [-1.0, 1.0,-1.0]);

    // connectors from data to the axes
    dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
    mG3D.drawPoly([[mData[0]*0.001, 0.0, 0.0],
                   [mData[0]*0.001, mData[1]*0.001, 0.0],
                   [0.0, mData[1]*0.001, 0.0]], false);
    mG3D.drawLine([mData[0]*0.001, mData[1]*0.001, 0.0],
                  [mData[0]*0.001, mData[1]*0.001, mData[2]*0.001]);

    // data
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    mG3D.drawLine([0,0,0], [mData[0]*0.001, mData[1]*0.001, mData[2]*0.001]);
  }

}

/**
 * Input (button presses) handler
 */
class SV3DDelegate extends Ui.BehaviorDelegate {

  var mView;

  function initialize(view) {
    BehaviorDelegate.initialize();
    mView = view;
  }

  function onNextPage() {
    mView.mG3D.mModel = Matrix.mul4x4(mView.mG3D.mModel, Graphics3D.getRotate(Math.PI*0.1, 0.0, 0.0, 1.0));
    mView.mG3D.updateMatrix();
    return true;
  }

  function onPreviousPage() {
    mView.mG3D.mModel = Matrix.mul4x4(mView.mG3D.mModel, Graphics3D.getRotate(-Math.PI*0.1, 0.0, 0.0, 1.0));
    mView.mG3D.updateMatrix();
    return true;
  }

  //function onSelect() {
  //}

  //function onBack() {
  //}

}

// vi:syntax=javascript filetype=javascript

