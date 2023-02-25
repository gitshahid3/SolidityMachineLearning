## Solidity Machine Learning Library

AI on blockchains, this repository is not for production and is just for experiment, i created it to broaden my portfolio

This library currently has only 1 algorithm which is linear regression

This library doesnt stores arrays of data but 7 single variables

### Linear Regression

#### Importing 
To get started with it lets import it

```solidity
pragma solidity ^0.8.0;

import "./SolidityMachineLearning/LinearRegression.sol";

contract LinearRegressionTest {
  
  function test() public {

  }
}
```

#### Training and predicting

```solidity

//creating a storage to store our parameters 
LinearRegression.Parameters public parameters;

function test() public pure returns (uint) {

  // initializes and trains
  uint[] x = [1, 2, 3, 4, 5];
  uint[] y = [15, 30, 45, 60, 75];
  //pass x, y along with empty parameters struct
  parameters = LinearRegression.fit(x, y, parameters);

  // train more using old data
  uint[] new_x = [6, 7, 8];
  uint[] new_y = [90, 105, 120];
  // trains on old data "parameters";
  parameters = LinearRegression.fit(x, y, parameters);

  // predicting with x = 10, and the parameters to predict on
  uint x = 10;
  return LinearRegression.predict(x, parameters) ;
  // outputs 150

}
```


#### Properties of LinearRegression.Parameters struct

```solidity
struct Parameters {
      uint public slope; // slope of data
      uint public intercept; // intercept of data
      uint public n; // total number of data
      uint public sum_x; //used for calculating slope and intercept
      uint public sum_y; //used for calculating slope and intercept
      uint public sum_xy; //used for calculating slope
      uint public sum_xx; //used for calculating slope
 }
```

#### Using error calculators

Currently only two error calculators are present Mean Squared Error and Mean Absolute Error

```solidity
function test_error() public pure returns (uint, uint) {
  // x is array of data, y is the array of correct outputs
  uint[] x = [20, 30]
  uint[] y = [300, 450]

  // using our old Parameters stored in the parameters variable
  uint MSE = LinearRegression.meanSquaredError(x, y, parameters) 
  uint MAE = LinearRegression.meanAbsoluteError(x, y, parameters)
  
  return (MSE, MAE) 
}
```
