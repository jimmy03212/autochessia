// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import "forge-std/Test.sol";
import {MudTest} from "@latticexyz/world/test/MudTest.t.sol";
import {Creature, CreatureData, GameConfig, Player, ShopConfig} from "../src/codegen/index.sol";
import {GameRecord, Game, GameData} from "../src/codegen/index.sol";
import {Hero, HeroData} from "../src/codegen/index.sol";
import {Piece, PieceData} from "../src/codegen/index.sol";
import {IWorld} from "../src/codegen/world/IWorld.sol";
import {GameStatus} from "../src/codegen/common.sol";

contract ReadWriteStateTest is MudTest {
    IWorld public world;

    function setUp() public override {
        super.setUp();
        world = IWorld(worldAddress);

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // Start broadcasting transactions from the deployer account
        vm.startBroadcast(deployerPrivateKey);
    }

    function testWriteState() public {
        for (uint256 i; i < 10; ++i) {
            Piece.setHealth(world, bytes32(uint256(1)), 100);
        }
    }

    function testReadState1() public {
        for (uint256 i; i < 10; ++i) {
            uint32 health = Piece.getHealth(world, bytes32(uint256(1)));
        }
    }

    function testReadState2() public {
        Piece.getHealth(world, bytes32(uint256(1)));
        // Piece.getX(world, bytes32(uint256(1)));
        // Piece.getY(world, bytes32(uint256(1)));
    }

    function testReadState3() public {
        Piece.get(world, bytes32(uint256(1)));
    }
}
