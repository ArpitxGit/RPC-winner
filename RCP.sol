// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


contract Game {
    bytes32 constant ROCK = "ROCK";
    bytes32 constant PAPER = "PAPER";
    bytes32 constant SCISSORS = "SCISSORS";

    mapping(address => bytes32) public choices;

    function play(bytes32 choice) external {
        //We cannot check whether choice is valid or not 

        require(choices[msg.sender] == bytes32(0)); // make sure player hasnt played before
        choices[msg.sender] = choice;
    }

    function evaluate(
        address alice,
        bytes32 aliceChoice,
        bytes32 aliceRandomness, //Randomness added which prevents the other user from correctly guessing the move of the other player
        address bob,
        bytes32 bobChoice,
        bytes32 bobRandomness // Randomness added which prevents the other user from correctly guessing the move of the other player
    ) external view returns (address) {
        // making sure the commitment of the choices hold - Player now reveals what their choice was and randomness can be made public at this point
        require(
            keccak256(abi.encodePacked(aliceChoice, aliceRandomness)) ==
                choices[alice]
        );

        // checking that bob isn't trying to change their move and their choice was correct
        require(
            keccak256(abi.encodePacked(bobChoice, bobRandomness)) ==
                choices[bob]
        );

        // same as before, its a draw if both users picked the same choice and same randomness, this is possible if their randomness was empty!
        if (aliceChoice == bobChoice) {
            return address(0);
        }

        if (aliceChoice == ROCK && bobChoice == PAPER) {
            return bob;
        } else if (bobChoice == ROCK && aliceChoice == PAPER) {
            return alice;
        } else if (aliceChoice == SCISSORS && bobChoice == PAPER) {
            return alice;
        } else if (bobChoice == SCISSORS && aliceChoice == PAPER) {
            return bob;
        } else if (aliceChoice == ROCK && bobChoice == SCISSORS) {
            return alice;
        } else if (bobChoice == ROCK && aliceChoice == SCISSORS) {
            return bob;
        }
        return address (0);
    }
}
