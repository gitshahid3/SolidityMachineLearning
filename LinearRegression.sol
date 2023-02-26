pragma solidity >=0.8.13;

import { SD59x18, sd } from "@prb/math/SD59x18.sol";
import { UD60x18, ud } from "@prb/math/UD60x18.sol";

struct Parameters {
  uint n;
  int slope;
  int intercept;
  int sum_x;
  int sum_y;
  int sum_xy;
  int sum_xx;
}
    
// trains on data
function fit(int[] memory x, int[] memory y, Parameters memory parameters) pure returns (Parameters memory) {
  require(x.length == y.length, "Input array lengths must be equal");
        
  uint new_n = x.length;
        
  SD59x18 sum_x = sd(parameters.sum_x);
  SD59x18 sum_y = sd(parameters.sum_y);
  SD59x18 sum_xy = sd(parameters.sum_xy);
  SD59x18 sum_xx = sd(parameters.sum_xx);
  UD60x18 n = ud(parameters.n);
        
  for (uint i = 0; i < new_n; i++) {
    SD59x18 xi = sd(x[i]) ;
    SD59x18 yi = sd(y[i]);
    
    sum_x = sum_x.add(xi);
    sum_y = sum_y.add(yi);
    sum_xy = sum_xy.add(xi.mul(yi));
    sum_xx = sum_xx.add(xi.mul(xi));
  }
        
  n = n.add(sd(new_n));
  uint slope = (n.mul(sum_xy).sub(sum_x.mul(sum_y)).div(n.mul(sum_xx).sub(sum_x.mul(sum_x)).intoInt256();
  uint intercept = (sum_y.sub(slope.mul(sum_x))).div(n).intoInt256();
        
  return Parameters(slope, intercept, n.intoUint256(), sum_x.intoUint256(), sum_y.intoUint256(), sum_xy.intoUint256(), sum_xx.intoUint256());
}
    
//calculates mean squared error
function meanSquaredError(int[] memory x, int[] memory y, Parameters memory parameters) pure returns (uint) {
  require(x.length == y.length, "Input array lengths must be equal");
  require(parameters.slope != 0, "Model must be trained first");
        
  UD60x18 sum_error_squared = ud(0);
  for (uint i = 0; i < x.length; i++) {
    SD59x18 y_pred = sd(predict(x[i], parameters));
    SD59x18 error = sd(y[i]).sub(y_pred);
    sum_error_squared = sum_error_squared.add(error.mul(error).intoUD60x18());
  }
        
  return sum_error_squared.div(ud(x.length)).intoUint256();
}
    
// calculates mean absolute error
function meanAbsoluteError(int[] memory x, int[] memory y, Parameters memory parameters) pure returns (uint) {
  require(x.length == y.length, "Input array lengths must be equal");
  require(parameters.slope != 0, "Model must be trained first");
        
  UD60x18 absolute_error = ud(0);
        
  for (uint i = 0; i < x.length; i++) {
    SD59x18 y_pred = sd(predict(x[i], parameters));
    UD60x18 error = sd(y[i]).sub(y_pred).abs();
    absolute_error = absolute_error.add(error);
  }
        
  return absolute_error.div(x.length).intoUint256();
}

    
// predicts the data
function predict(int xi, Parameters memory parameters) pure returns (int) {
  SD59x18 slope = parameters.slope;
  SD59x18 x = xi;
  SD59x18 intercept = parameters.intercept;
  
  return slope.mul(x).add(intercept).intoInt256();
}
