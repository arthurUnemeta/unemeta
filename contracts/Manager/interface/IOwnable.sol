// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IOwnable {
    function transferOwnership(address newOwner) external;

    function owner() external view returns (address);

    function admin() external view returns (address);
}
