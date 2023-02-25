pragma solidity ^0.8.0;

contract LinearRegression {
    
    struct Parameters {
      uint public slope;
      uint public intercept;
      uint public n;
      uint public sum_x;
      uint public sum_y;
      uint public sum_xy;
      uint public sum_xx;
    }
    
    // initializes the training data
    function fit(uint[] memory x, uint[] memory y) internal pure returns (Parameters memory) {
        require(x.length == y.length, "Input array lengths must be equal");
        require(x.length >= 2, "Input array lengths must be at least 2");
        
        n = x.length;
        
        uint sum_x = 0;
        uint sum_y = 0;
        uint sum_xy = 0;
        uint sum_xx = 0;
        
        for (uint i = 0; i < n; i++) {
            sum_x += x[i];
            sum_y += y[i];
            sum_xy += x[i] * y[i];
            sum_xx += x[i] * x[i];
        }
        
        uint slope = (n * sum_xy - sum_x * sum_y) / (n * sum_xx - sum_x * sum_x);
        uint intercept = (sum_y - slope * sum_x) / n;
        return Parameters(slope, intercept, n, sum_x, sum_y, sum_xy, sum_xx);
    }
    
    // train existing data
    function train(uint[] memory x, uint[] memory y, Parameters memory parameters) internal pure returns (Parameters memory) {
        require(x.length == y.length, "Input array lengths must be equal");
        
        uint new_n = x.length;
        
        sum_x = Parameters.sum_x
        sum_y = Parameters.sum_y
        sum_xy = Parameters.sum_xy
        sum_xx = Parameters.sum_xx
        n = Parameters.n
        
        for (uint i = 0; i < new_n; i++) {
            sum_x += x[i];
            sum_y += y[i];
            sum_xy += x[i] * y[i];
            sum_xx += x[i] * x[i];
        }
        
        n += new_n;
        slope = (n * sum_xy - sum_x * sum_y) / (n * sum_xx - sum_x * sum_x);
        intercept = (sum_y - slope * sum_x) / n;
        
      return Parameters(slope, intercept, n, sum_x, sum_y, sum_xy, sum_xx);
    }
    
    //calculates mean squared error
    function meanSquaredError(uint[] memory x, uint[] memory y, Parameters memory parameters) internal view returns (uint) {
        require(x.length == y.length, "Input array lengths must be equal");
        require(parameters.slope != 0, "Model must be trained first");
        
        uint sum_error_squared = 0;
        for (uint i = 0; i < x.length; i++) {
            uint y_pred = predict(x[i], parameters);
            uint error = y[i] - y_pred;
            sum_error_squared += error * error;
        }
        
        return sum_error_squared / x.length;
    }
    
    // calculates mean absolute error
    function meanAbsoluteError(uint[] memory x, uint[] memory y, Parameters memory parameters) internal pure returns (uint) {
      require(x.length == y.length, "Input array lengths must be equal");
      require(parameters.slope != 0, "Model must be trained first");
        
      uint absolute_error = 0;
        
      for (uint i = 0; i < x.length; i++) {
          uint y_pred = predict(x[i], parameters)
          absolute_error += abs(y[i] - y_pred);
      }
        
      return absolute_error / x.length;
    }

    
    // predicts the data
    function predict(uint x, Parameters memory parameters) internal view returns (uint) {
        return parameters.slope * x + parameters.intercept;
    }
}
