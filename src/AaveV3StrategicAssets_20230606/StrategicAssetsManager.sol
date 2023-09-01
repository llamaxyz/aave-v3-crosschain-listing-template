// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {IERC20} from 'solidity-utils/contracts/oz-common/interfaces/IERC20.sol';
import {Initializable} from 'solidity-utils/contracts/transparent-proxy/Initializable.sol';
import {SafeERC20} from 'solidity-utils/contracts/oz-common/SafeERC20.sol';
import {AaveGovernanceV2} from 'aave-address-book/AaveGovernanceV2.sol';
import {AaveV3Ethereum} from 'aave-address-book/AaveV3Ethereum.sol';

import {LSDLiquidityGaugeManager} from './LSDLiquidityGaugeManager.sol';
import {VeTokenManager} from './VeTokenManager.sol';

contract StrategicAssetsManager is Initializable, LSDLiquidityGaugeManager, VeTokenManager {
  using SafeERC20 for IERC20;

  event WithdrawalERC20(address indexed _token, uint256 _amount);

  function initialize() external initializer {
    _transferOwnership(AaveGovernanceV2.SHORT_EXECUTOR);
    _updateGuardian(_msgSender());
    spaceId = 'balancer.eth';
    gaugeController = 0xC128468b7Ce63eA702C1f104D55A2566b13D3ABD;
    lockDuration = 365 days;
  }

  function withdrawERC20(address token, uint256 amount) external onlyOwner {
    IERC20(token).safeTransfer(address(AaveV3Ethereum.COLLECTOR), amount);
    emit WithdrawalERC20(token, amount);
  }
}
