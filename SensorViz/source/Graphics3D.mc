/**
 * Generic 3D math and drawing library.
 *
 * This module holds
 *  - a number of 3D math functions generating or operating on homogeneous
 *    coordinates (i.e., 4D vectors, 4x4 matrices), and
 *  - a class for 3D drawing.
 *
 * For a very good introduction on 3D calculations and how matrices are used,
 * see http://www.opengl-tutorial.org/beginners-tutorials/tutorial-3-matrices/
 *
 * Disclaimer: The 3D drawing is very simplistic and only supports wire models.
 * The implementation is inspired by OpenGL, but only implements a tiny subset
 * of its capabilites, and at some points diverges from it. There is no Z
 * buffer, no hiding of hidden objects, no shading of surfaces, ...
 */

using Toybox.System;
using Toybox.Graphics;
using Toybox.Math;
using Matrix;

module Graphics3D {

/**
 * Create a matrix for a translation by the vector (x,y,z).
 *
 * Use e.g., with
 *   m = Matrix.mul4x4(m, getTranslate(x, y, z));
 */
function getTranslate(x, y, z) {
  // https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glTranslate.xml
  var result = Matrix.getEye(4);
  result[3+0*4] = x;
  result[3+1*4] = y;
  result[3+2*4] = z;
  return result;
}

/**
 * Create a matrix for a rotation by angle radians around the vector (x,y,z).
 * The vector must be normalized.
 */
function getRotate(angle, x, y, z) {
  // https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glRotate.xml
  var result = Matrix.getZero(4*4);
  var s = Math.sin(angle);
  var c = Math.cos(angle);
  var c1 = 1.0 - c;
  result[0+0*4] = x*x*c1+c;
  result[1+0*4] = x*y*c1-z*s;
  result[2+0*4] = x*z*c1+y*s;
  result[0+1*4] = y*x*c1+z*s;
  result[1+1*4] = y*y*c1+c;
  result[2+1*4] = y*z*c1-x*s;
  result[0+2*4] = z*x*c1-y*s;
  result[1+2*4] = z*y*c1+x*s;
  result[2+2*4] = z*z*c1+c;
  result[3+3*4] = 1.0;
  return result;
}

/**
 * Create a matrix for the scaling by the desired factors along the x, y, and z
 * axes.
 */
function getScale(x, y, z) {
  // https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glScale.xml
  var result = Matrix.getZero(4*4);
  result[0+0*4] = x;
  result[1+1*4] = y;
  result[2+2*4] = z;
  result[3+3*4] = 1.0;
  return result;
}

/**
 * Create a (viewing) matrix from an eye point to a center point.
 */
function getLookAt(eye, center, up) {
  // https://github.com/g-truc/glm/blob/master/glm/gtc/matrix_transform.inl#L510
  // http://stackoverflow.com/questions/21830340/understanding-glmlookat
  // https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluLookAt.xml
  var result = Matrix.getZero(4*4);
  var x;
  var y;
  var z;
  z = Matrix.sub(eye, center);
  z = Matrix.normalize(z);
  x = Matrix.cross(up, z);
  y = Matrix.cross(z, x);
  x = Matrix.normalize(x);
  y = Matrix.normalize(y);
  //System.println("x = " + x);
  //System.println("y = " + y);
  //System.println("z = " + z);
  result[0+0*4] = x[0];
  result[1+0*4] = x[1];
  result[2+0*4] = x[2];
  result[3+0*4] = - Matrix.dot(x, eye);
  result[0+1*4] = y[0];
  result[1+1*4] = y[1];
  result[2+1*4] = y[2];
  result[3+1*4] = - Matrix.dot(y, eye);
  result[0+2*4] = z[0];
  result[1+2*4] = z[1];
  result[2+2*4] = z[2];
  result[3+2*4] = - Matrix.dot(z, eye);
  result[0+3*4] = 0.0;
  result[1+3*4] = 0.0;
  result[2+3*4] = 0.0;
  result[3+3*4] = 1.0;
  return result;
}

/**
 * Create an orthographic (projection) matrix, which produces a parallel
 * projection.
 *
 * For example, 
 *   m = getOrtho(-1.0, 1.0, -1.0, 1.0, -1.0, 1.0);
 * returns the identity matrix.
 */
function getOrtho(left, right, bottom, top, near, far) {
  // https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glOrtho.xml
  var result = Matrix.getZero(4*4);
  result[0+0*4] = 2.0/(right-left);
  result[1+1*4] = 2.0/(top-bottom);
  result[2+2*4] = 2.0/(far-near);
  result[3+3*4] = 1.0;
  result[3+0*4] = (right+left)/(left-right);
  result[3+1*4] = (top+bottom)/(bottom-top);
  result[3+2*4] = (far+near)/(near-far);
  return result;
}

/**
 * Create a perspective (projection) matrix.
 */
function getPerspective(fov, aspect, zNear, zFar) {
  // https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluPerspective.xml
  var result = Matrix.getZero(4*4);
  var f = 1.0/Math.tan(0.5*fov);
  result[0+0*4] = f/aspect;
  result[1+1*4] = f;
  result[2+2*4] = (zFar+zNear)/(zNear-zFar);
  result[3+2*4] = (2.0*zFar*zNear)/(zNear-zFar);
  result[2+3*4] = -1.0;
  return result;
}

/**
 * 3D drawing class.
 *
 *
 * TODO:
 *  - getOrtho() is untested
 *  - using the model matrix is untested
 */
class Graphics3D {
  var mModel;           // model matrix: transforms objects
  var mView;            // view matrix: transform the camera (or actually the whole world)
  var mProjection;      // projection matrix: transform the 3D world to the 2D screen, can also include perspective
  var mMVP;             // product of the above three matrices, only this is used for drawing
  var dc;               // device context for drawing

  /**
   * Constructor
   */
  function initialize() {
    mModel      = Matrix.getEye(4);
    mView       = Matrix.getEye(4);
    mProjection = Matrix.getEye(4);
    mMVP        = Matrix.getEye(4);  // updateMatrix() would lead to the same result
    dc = null;
  }
  
  // Matrix and Projection Functions /////////////////////////////////////////

  /**
   * Set the model matrix
   */
  function setModelMatrix(matrix) {
    mModel = matrix;
  }

  /**
   * Set the view matrix
   */
  function setViewMatrix(matrix) {
    mView = matrix;
  }

  /**
   * Set the projection matrix
   *
   * Note: in contrast to OpenGL, this also includes the mapping of
   * (-1.0,-1.0)-(1.0,1.0) to the actual screen coordinates. 
   */
  function setProjectionMatrix(matrix) {
    mProjection = matrix;
  }

  /**
   * Calculate the product of the three matrices
   */
  function updateMatrix() {
    mMVP = Matrix.mul4x4(mProjection, Matrix.mul4x4(mView, mModel));
  }

  /**
   * Map a 3D point to the 2D screen
   */
  function map3D2D(point) {
    // https://en.wikipedia.org/wiki/3D_projection#Perspective_projection
    point.add(1.0);   // vec3 --> vec4, being a point and no direction (therefore 1.0) 
    var f = Matrix.mul4x4x1x4(mMVP, point);
    //if (f[3].abs() < 1e-6) {
    //  System.println("f = " + f);
    //  return [0, 0];
    //}
    var result = new [2];
    //System.print("f = " + f);
    result[0] = Math.round(f[0]/f[3]).toNumber();
    result[1] = Math.round(f[1]/f[3]).toNumber();
    //System.println(" --> " + result);
    return result;
  }

  // Drawing Functions ///////////////////////////////////////////////////////

  /**
   * Set the device context to a member variable for the other drawing
   * functions.
   */
  function setDc(adc) {
    dc = adc;
  }
 
  /**
   * Draw a line in 3D space
   *
   * @param from  first  coordinate as array with 3 elements [x,y,z]
   * @param to    second coordinate as array with 3 elements [x,y,z]
   */
  function drawLine(from, to) {
    from = map3D2D(from);
    to   = map3D2D(to);
    //System.println("from: " + from + ", to: " + to);
    dc.drawLine(from[0], from[1], to[0], to[1]);
  }

  /**
   * Draw a polyline in 3D space
   *
   * @param pts    points of the polyline, array of array with 3 elements
   *               [x,y,z]
   * @param close  boolean, if true the last point will be connected with the
   *               first point
   */
  function drawPoly(pts, close) {
    var p0;
    var pf;
    var pt;
    var i;
    p0 = map3D2D(pts[0]);
    pf = p0;
    for (i = 1; i < pts.size(); i++) {
      pt = map3D2D(pts[i]);
      //System.println("from: " + pf + ", to: " + pt);
      dc.drawLine(pf[0], pf[1], pt[0], pt[1]);
      pf = pt;
    }
    if (close) {
      dc.drawLine(pf[0], pf[1], p0[0], p0[1]);
    }
  }

}

}

// vi:syntax=javascript filetype=javascript
