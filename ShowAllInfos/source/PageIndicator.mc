//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//
// Improvements by Johann Glaser

using Toybox.System;
using Toybox.Graphics as Gfx;

class PageIndicator {

    var ALIGN_BOTTOM_RIGHT  = 0;
    var ALIGN_BOTTOM_CENTER = 1;
    var ALIGN_BOTTOM_LEFT   = 2;
    var ALIGN_TOP_RIGHT     = 3;
    var ALIGN_TOP_CENTER    = 4;
    var ALIGN_TOP_LEFT      = 5;

    var mSize, mSelectedColor, mNotSelectedColor, mAlignment, mRadius, mMargin;

    function setup(size, selectedColor, notSelectedColor, alignment, radius, margin) {
        mSize = size;
        mSelectedColor = selectedColor;
        mNotSelectedColor = notSelectedColor;
        mAlignment = alignment;
        mRadius = radius;
        mMargin = margin;
    }

    function draw(dc, selectedIndex) {
        var width = mSize * 2*mRadius;
        var x = 0;
        var y = 0;

        if (mAlignment == ALIGN_BOTTOM_RIGHT) {
            x = dc.getWidth() - width - mMargin;
            y = dc.getHeight() - mRadius - mMargin;

        } else if (mAlignment == ALIGN_BOTTOM_CENTER) {
            x = (dc.getWidth() - width) / 2;
            y = dc.getHeight() - mRadius - mMargin;

        } else if (mAlignment == ALIGN_BOTTOM_LEFT) {
            x = 0 + mMargin;
            y = dc.getHeight() - mRadius - mMargin;

        } else if (mAlignment == ALIGN_TOP_RIGHT) {
            x = dc.getWidth() - width - mMargin;
            y = 0 + mMargin + mRadius;

        } else if (mAlignment == ALIGN_TOP_CENTER) {
            x = (dc.getWidth() - width) / 2;
            y = 0 + mMargin + mRadius;

        } else if (mAlignment == ALIGN_TOP_LEFT) {
            x = 0 + mMargin;
            y = 0 + mMargin + mRadius;
        } else {
            x = 0;
            y = 0;
        }

        for (var i=0; i<mSize; i+=1) {
            if (i == selectedIndex) {
                dc.setColor(mSelectedColor, Gfx.COLOR_TRANSPARENT);
            } else {
                dc.setColor(mNotSelectedColor, Gfx.COLOR_TRANSPARENT);
            }

            var tempX = (x + (i * 2*mRadius)) + mRadius;
            dc.fillCircle(tempX, y, mRadius-1);
        }
    }

}
