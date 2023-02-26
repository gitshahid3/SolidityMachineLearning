pragma solidity >=0.8.13;

import { UD60x18, ud } from "@prb/math/UD60x18.sol";

struct Parameters {
  uint public slope;
  uint public intercept;
  uint public n;
  uint public sum_x;
  uint public sum_y;
  uint public sum_xy;
  uint public sum_xx;
}
    
// trains on data
function fit(uint[] memory x, uint[] memory y, Parameters memory parameters) pure returns (Parameters memory) {
  require(x.length == y.length, "Input array lengths must be equal");
        
  uint new_n = x.length;
        
  UD60x18 sum_x = ud(parameters.sum_x);
  UD60x18 sum_y = ud(parameters.sum_y);
  UD60x18 sum_xy = ud(parameters.sum_xy);
  UD60x18 sum_xx = ud(parameters.sum_xx);
  UD60x18 n = ud(parameters.n);
        
  for (uint i = 0; i < new_n; i++) {
    UD60x18 xi = ud(x[i]) ;
    UD60x18 yi = ud(y[i]);
    
    sum_x = sum_x.add(xi);
    sum_y = sum_y.add(yi);
    sum_xy = sum_xy.add(xi.mul(yi));
    sum_xx = sum_xx.add(xi.mul(xi));
  }
        
  n = n.add(ud(new_n));
  uint slope = (n.mul(sum_xy).sub(sum_x.mul(sum_y)).div(n.mul(sum_xx).sub(sum_x.mul(sum_x)).intoUint256();
  uint intercept = (sum_y.sub(slope.mul(sum_x))).div(n).intoUint256();
        
  return Parameters(slope, intercept, n.intoUint256(), sum_x.intoUint256(), sum_y.intoUint256(), sum_xy.intoUint256(), sum_xx.intoUint256());
}
    
//calculates mean squared error
function meanSquaredError(uint[] memory x, uint[] memory y, Parameters memory parameters) pure returns (uint) {
  require(x.length == y.length, "Input array lengths must be equal");
  require(parameters.slope != 0, "Model must be trained first");
        
  UD60x18 sum_error_squared = ud(0);
  for (uint i = 0; i < x.length; i++) {
    UD60x18 y_pred = ud(predict(x[i], parameters));
    UD60x18 error = ud(y[i]).sub(y_pred);
    sum_error_squared = sum_error_squared.add(error.mul(error));
  }
        
  return sum_error_squared.div(ud(x.length)).intoUint256();
}
    
// calculates mean absolute error
function meanAbsoluteError(uint[] memory x, uint[] memory y, Parameters memory parameters) pure returns (uint) {
  require(x.length == y.length, "Input array lengths must be equal");
  require(parameters.slope != 0, "Model must be trained first");
        
  UD60x18 absolute_error = ud(0);
        
  for (uint i = 0; i < x.length; i++) {
    UD60x18 y_pred = ud(predict(x[i], parameters));
    absolute_error = absolute_error.add(abs(ud(y[i]).sub(y_pred)));
  }
        
  return absolute_error.div(x.length).intoUint256();
}

    
// predicts the data
function predict(uint xi, Parameters memory parameters) pure returns (uint) {
  UD60x18 slope = parameters.slope;
  UD60x18 x = xi;
  UD60x18 intercept = parameters.intercept;
  
  return slope.mul(x).add(intercept).intoUint256();
}
