// SPDX-License-Identifier: MIT
pragma solidity ^0.7.3;

import '@openzeppelin/contracts/tokens/ERC20/IERC20.sol';

interface IUniswap {

    function swapExactTokensForETH(
        uint amountIn, 
        uint amountOutMin, 
        address[] calldata path, 
        address to,
        uint deadline
    ) external returns(uint[] memory amounts);

    function WETH() external pure returns(address);
}

interface IERC20 {

    function transferFrom(
        address sender, 
        address recipient, 
        uint256 amount
    ) 
    external 
    returns (bool);

    function approve(
        address spender,
        uint amount
    ) external 
    returns (bool);
}

contract MySwapToETH {

  // reference to uniswap 
  IUniswap uniswap;

  mapping(address => uint) public balances;

  constructor(address _uniswap) {
    uniswap = IUniswap(_uniswap);
  }

  /// @notice swap token for ETH using Uniswap
  /// @param token, the token to exchange for ETH
  /// @param amountIn, the amount of token to exchange
  /// @param amountOutMin, the min amount of ETH to get from swap
  /// @param deadline the maximum time for validity this, 
  function swapTokensForETH(
    address token, 
    uint amountIn,
    uint amountOutMin, 
    uint deadline
  ) external 
  {
    // need to have called approve on this contract first
    IER20(token).transferFrom(msg.sender, address(this), amountIn);
    address[] memory path = new address[](2);
    path[0] = address(token);
    path[1] = uniswap.WETH(); // returns address of Wrapped Ether
    IERC20(token).approve(address(uniswap), amountIn);
    uniswap.swapExactTokensForETH(
      amountIn, 
      amountOutMin, 
      path, 
      msg.sender, 
      deadline
    );
  }

}