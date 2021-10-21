// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

// import "https://github.com/Uniswap/uniswap-v2-periphery/blob/master/contracts/interfaces/IUniswapV2Router02.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "./IERC20.sol";

contract UniswapTest {
    address internal constant UNISWAP_ROUTER_ADDRESS =
        0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

    IUniswapV2Router02 public uniswapRouter;
    IERC20 public pundiToken;
    IERC20 public cocosTokenERC20;
    address private pundiXToken = 0x0FD10b9899882a6f2fcb5c371E17e70FdEe00C38;
    address private cocosToken = 0x0C6f5F7D555E7518f6841a79436BD2b1Eef03381;

    constructor() public {
        uniswapRouter = IUniswapV2Router02(UNISWAP_ROUTER_ADDRESS);
        pundiToken = IERC20(pundiXToken);
        cocosTokenERC20 = IERC20(cocosToken);
    }

    function swapPundixToWeth(uint256 amountIn) public {
        address[] memory path = getPathForERCTokens(
            pundiXToken,
            uniswapRouter.WETH()
        );
        pundiToken.transfer(msg.sender, amountIn);
        uint256[] memory returnedAmount = getAmount(path, amountIn);
        uniswapRouter.swapExactTokensForETH(
            returnedAmount[0],
            returnedAmount[1],
            path,
            address(this),
            block.timestamp + 12000
        );
    }

    function swapCocosToPundix(uint amountIn) public {
        address[] memory path = getPathForERCTokens(
            cocosToken,
            pundiXToken
        );
         uint[] memory returnedAmount = getAmount(path,amountIn);
         cocosTokenERC20.approve(UNISWAP_ROUTER_ADDRESS,amountIn);
         uniswapRouter.swapExactTokensForTokens(returnedAmount[0],returnedAmount[1],path, address(this) , block.timestamp + 12000);
     }

    function getAmount(address[] memory path, uint256 amountInEth)
        internal
        view
        returns (uint256[] memory)
    {
        uint256[] memory returnedAmount = uniswapRouter.getAmountsOut(
            amountInEth,
            path
        );
        return returnedAmount;
    }

    function getEstimatedETHforDAI(uint256 pundiAmount)
        public
        view
        returns (uint256[] memory)
    {
        return
            uniswapRouter.getAmountsIn(
                pundiAmount,
                getPathForERCTokens(uniswapRouter.WETH(), pundiXToken)
            );
    }

    function getPathForERCTokens(address token1, address token2)
        public
        pure
        returns (address[] memory)
    {
        address[] memory path = new address[](2);
        path[0] = token1;
        path[1] = token2;
        return path;
    }

    // important to receive ETH
    receive() external payable {}
}
