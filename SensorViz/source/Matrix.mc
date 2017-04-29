/**
 * Vector and matrix math routines.
 *
 * All vectors and matrices are stored in arrays with n*m elements, enumerating
 * first in x (column), then in y (row), e.g., the array
 *   a = [0, 1, 2, 3, 4, 5, 6, 7, 8];
 * represents the 3x3 matrix
 *     / 0 1 2 \
 *     | 3 4 5 |
 *     \ 6 7 8 /
 *
 * The functions don't check the inputs (for performance reasons), e.g., for
 * proper array sizes. The caller has to ensure that.
 *
 * The functions are not specially optimized.
 */

using Toybox.Math;

module Matrix {

  /**
   * Creates and returns a len=x*y matrix with 0.0.
   */
  function getZero(len) {
    var result = new [len];
    var i;
    for (i = 0; i < len; i++) {
      result[i] = 0.0;
    }
    return result;
  }

  /**
   * Creates and returns an xy*xy identity matrix.
   */
  function getEye(xy) {
    var result = getZero(xy*xy);
    var i;
    for (i = 0; i < xy*xy; i+=(xy+1)) {
      result[i] = 1.0;
    }
    return result;
  }

  /**
   * Adds two vectors or matrices and returns the result.
   */
  function add(a, b) {
    var result = new [a.size()];   // don't overwrite a or b, because Arrays are passed by referece
    var i;
    for (i = 0; i < a.size(); i++) {
      result[i] = a[i] + b[i];
    }
    return result;
  }

  /**
   * Subtracts two vectors or matrices and returns the result.
   */
  function sub(a, b) {
    var result = new [a.size()];   // don't overwrite a or b, because Arrays are passed by referece
    var i;
    for (i = 0; i < a.size(); i++) {
      result[i] = a[i] - b[i];
    }
    return result;
  }

  /**
   * Calculates the dot product of two vectors of identical length.
   */
  function dot(a, b) {
    var result = 0.0;
    var i;
    for (i = 0; i < a.size(); i++) {
      result += a[i] * b[i];
    }
    return result;
  }

  /**
   * Calculates the cross product of two 3x1 vectors.
   */
  function cross(a, b) {
    var result = new [3];
    result[0] = a[1]*b[2] - b[1]*a[2];
    result[1] = a[2]*b[0] - b[2]*a[0];
    result[2] = a[0]*b[1] - b[0]*a[1];
    return result;
  }

  /**
   * Calculates the length/norm of a vector of arbitrary length.
   */
  function length(a) {
    var result = 0.0;
    var i;
    for (i = 0; i < a.size(); i++) {
      result += a[i]*a[i];
    }
    return Math.sqrt(result);
  }

  /**
   * Create a vector with the same direction but with a length of 1.0.
   */
  function normalize(a) {
    var result = new [a.size()];   // don't overwrite a or b, because Arrays are passed by referece
    var len = length(a);
    if (len == 0.0) {
      return NaN;
    }
    var m = 1.0/len;   // small optimization: device once, multiply multiple times
    var i;
    for (i = 0; i < a.size(); i++) {
      result[i] = a[i] * m;
    }
    return result;
  }

  /**
   * Matrix multiplication of two 4x4 matrices
   */
  function mul4x4(a, b) {
    var result = new [4*4];
    var sum;
    var x,y,i;
    for (x = 0; x < 4; x++) {
      for (y = 0; y < 4; y++) {
        sum = 0.0;
        for (i = 0; i < 4; i++) {
          sum += a[y*4+i] * b[i*4+x];
        }
        result[y*4+x] = sum;
      }
    }
    //System.println("mul4x4: " + a);
    //System.println("mul4x4: " + b);
    //System.println("mul4x4: " + result);
    return result;
  }

  /**
   * Matrix multiplication of a 4x4 matrix with a 1x4 vector, resulting in a
   * 1x4 vector.
   */
  function mul4x4x1x4(a, b) {
    var result = new [1*4];
    var sum;
    var y,i;
    for (y = 0; y < 4; y++) {
      sum = 0.0;
      for (i = 0; i < 4; i++) {
        sum += a[y*4+i] * b[i];
      }
      result[y] = sum;
    }
    //System.println("mul4x4x1x4: a = " + a);
    //System.println("mul4x4x1x4: b = " + b);
    //System.println("mul4x4x1x4: r = " + result);
    return result;
  }

}

// vi:syntax=javascript filetype=javascript
