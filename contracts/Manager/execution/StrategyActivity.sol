// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {OrderTypes} from "../../libraries/OrderTypes.sol";
import {TheExStrategy} from "./interface/TheExecutionStrategy.sol";

/**
 * @title StrategyStandardSaleForFixedPrice
 * @notice Strategy that executes an order at a fixed price that
 * can be taken either by a bid or an ask.
 */
contract StrategyActivity is TheExStrategy ,Ownable{
    uint256 public immutable PROTOCOL_FEE;
    address public ACTIVITY_ADDRESS;
    event UpdateActivity(address indexed collection);

    /**
     * @notice Constructor
     * @param _protocolFee protocol fee (200 --> 2%, 400 --> 4%)
     */
    constructor(uint256 _protocolFee) {
        PROTOCOL_FEE = _protocolFee;
    }

    //
    // tion canExecuteTakerAsk
    //  @Description: Check price information
    //  @param OrderTypes.TakerOrder
    //  @param OrderTypes.MakerOrder
    //  @return external
    //
    function canExecuteBuy(OrderTypes.TakerOrder calldata takerAsk, OrderTypes.MakerOrder calldata makerBid)
        external
        view
        override
        returns (
            bool,
            uint256,
            uint256
        )
    {
        // Confirm all information are matched and valid within the time period for fixed price    return (
            return (((makerBid.price == takerAsk.price) &&
                (makerBid.tokenId == takerAsk.tokenId) &&
                (makerBid.startTime <= block.timestamp) &&
                (makerBid.endTime >= block.timestamp)&&
                makerBid.collection == ACTIVITY_ADDRESS),
            makerBid.tokenId,
            makerBid.amount
        );
    }

    //
    // tion canExecuteTakerBid
    //  @Description: Check strategy
    //  @param OrderTypes.TakerOrder
    //  @param OrderTypes.MakerOrder
    //  @return external
    //
    function canExecuteSell(OrderTypes.TakerOrder calldata takerBid, OrderTypes.MakerOrder calldata makerAsk)
        external
        view
        override
        returns (
            bool,
            uint256,
            uint256
        )
    {
        //Confirm all information are matched and valid within the time period for fixed price
        return (
            ((makerAsk.price == takerBid.price) &&
                (makerAsk.tokenId == takerBid.tokenId) &&
                (makerAsk.startTime <= block.timestamp) &&
                (makerAsk.endTime >= block.timestamp)),
            makerAsk.tokenId,
            makerAsk.amount
        );
    }
    function setFreeAddress(address _freeAddress)external onlyOwner{
        ACTIVITY_ADDRESS = _freeAddress;
        emit UpdateActivity(_freeAddress);
    }

    //
    // function viewProtocolFee
    //  @Description: Return platform transaction fee
    //  @return external
    //
    function viewProtocolFee() external view override returns (uint256) {
        return PROTOCOL_FEE;
    }
}
