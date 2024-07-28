// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity =0.7.6;
pragma abicoder v2;

import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";

contract SwapTokens {
    address constant SWAPROUTER02 = 0x3bFA4769FB09eefC5a80d6E87c3B9C650f7Ae48E;
    ISwapRouter public immutable swapRouter;
    address public constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address public constant WETH9 = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    uint24 public constant poolFee = 3000;

    constructor() {
        swapRouter = ISwapRouter(SWAPROUTER02);
    }

    // Use this for test

    /**  @notice swapTokenForToken swaps a fixed amount of tokenA for the maximum amount of tokenB.
        @dev The calling address must approve this contract to spend its token for this function to succeed. As the amount of input token is variable,
        the calling address will need to approve for a slightly higher amount, anticipating some variance.
        @param amountIn The exact amount of tokenB to receive from the swap.
        @return amountOut The amount of tokenB received. */
    function swapTokenForToken(
        uint256 amountIn,
        address tokenA,
        address tokenB
    ) external returns (uint256 amountOut) {
        // Transfer the specified amount of tokenA to this contract.
        TransferHelper.safeTransferFrom(
            tokenA,
            msg.sender,
            address(this),
            amountIn
        );
        // Approve the router to spend tokenA.
        TransferHelper.safeApprove(tokenA, address(swapRouter), amountIn);
        // This is used to set slippage limits, maybe we will try it later!
        uint256 minOut = 0;
        uint160 priceLimit = 0;
        // Create the params which is a struct from SwapRouter that will be used to passed into the swap for execution
        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
            .ExactInputSingleParams({
                tokenIn: tokenA,
                tokenOut: tokenB,
                fee: poolFee,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: minOut,
                sqrtPriceLimitX96: priceLimit
            });
        // The call to `exactInputSingle` executes the swap.
        amountOut = swapRouter.exactInputSingle(params);
    }

    /// @notice swapExactOutputSingle swaps a minimum possible amount of tokenA for a fixed amount of tokenB.
    /// @dev The calling address must approve this contract to spend its token for this function to succeed. As the amount of input token is variable,
    /// the calling address will need to approve for a slightly higher amount, anticipating some variance.
    /// @param amountOut The exact amount of tokenB to receive from the swap.
    /// @param amountInMaximum The amount of tokenA we are willing to spend to receive the specified amount of tokenB.
    /// @return amountIn The amount of tokenA actually spent in the swap.
    function swapExactOutputSingle(
        uint256 amountOut,
        uint256 amountInMaximum,
        address tokenA,
        address tokenB
    ) external returns (uint256 amountIn) {
        // Transfer the specified amount of tokenA to this contract.
        TransferHelper.safeTransferFrom(
            tokenA,
            msg.sender,
            address(this),
            amountInMaximum
        );

        // Approve the router to spend the specified `amountInMaximum` of tokenA.
        TransferHelper.safeApprove(
            tokenA,
            address(swapRouter),
            amountInMaximum
        );

        ISwapRouter.ExactOutputSingleParams memory params = ISwapRouter
            .ExactOutputSingleParams({
                tokenIn: tokenA,
                tokenOut: tokenB,
                fee: poolFee,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountOut: amountOut,
                amountInMaximum: amountInMaximum,
                sqrtPriceLimitX96: 0
            });

        // Executes the swap returning the amountIn needed to spend to receive the desired amountOut.
        amountIn = swapRouter.exactOutputSingle(params);

        // For exact output swaps, the amountInMaximum may not have all been spent.
        // If the actual amount spent (amountIn) is less than the specified maximum amount, we must refund the msg.sender and approve the swapRouter to spend 0.
        if (amountIn < amountInMaximum) {
            TransferHelper.safeApprove(tokenA, address(swapRouter), 0);
            TransferHelper.safeTransfer(
                tokenA,
                msg.sender,
                amountInMaximum - amountIn
            );
        }
    }
}
