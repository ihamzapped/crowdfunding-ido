// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

struct Token {
    address addr;
    uint decimals;
}

interface IIDO {
    event Claimed(address indexed investor, uint amount);
    event Invested(address indexed investor, uint amount, uint claims);

    /**
     * @notice Invest in the IDO and claim tokens once the sale is over
     * @dev Callable only when the sale is active and not halted
     * @dev The invested ETH will be sent to the IDO contract deposit address
     * @dev The investor will receive claimAmount of IDO tokens proportional to the invested amount
     * @dev Claim tokens will be locked in this contract till the claimStart time
     * @dev The s_idoToken owner must have sufficient balance and allowance for this contract for invest to proceed
     * @dev Emits Invested event on successful investment
     */
    function invest() external payable;

    /**
     * @notice Claim IDO tokens proportional to the invested amount
     * @dev Callable only after the claim start time and not halted
     * @dev The IDO tokens will be transferred from the IDO contract to the investor
     * @dev Emits Claimed event on successful claim
     */
    function claim() external;

    /**
     * @notice Burn excess IDO tokens after the sale ends
     * @dev Callable only after the sale end time
     * @dev The IDO tokens will be transferred from the IDO contract to the zero address
     */
    function burn() external;

    /**
     * @notice Update the IDO contract deposit address
     * @dev Callable only by the contract owner
     * @param _addr The new deposit address
     */
    function setDeposit(address payable _addr) external;

    /**
     * @notice Halt the IDO contract
     * @dev Callable only by the contract owner
     */
    function halt() external;

    /**
     * @notice Resume the IDO contract
     * @dev Callable only by the contract owner
     */
    function resume() external;

    /**
     * @notice Check if the IDO contract is halted
     * @return True if the IDO contract is halted, otherwise false
     */
    function s_halted() external view returns (bool);

    /**
     * @notice Get the amount of ETH raised in the IDO so far
     * @return The amount of ETH raised
     */
    function s_raised() external view returns (uint);

    /**
     * @notice Get the IDO token contract address and decimals
     * @return The IDO token contract address and decimals
     */
    function s_idoToken() external view returns (address, uint);

    /**
     * @notice Get the IDO contract deposit address
     * @return The IDO contract deposit address
     */
    function s_deposit() external view returns (address payable);

    /**
     * @notice Get the amount of pending claims of an investor
     * @param _addr The investor address
     * @return The amount of pending claims of an investor
     */
    function s_claims(address _addr) external view returns (uint);
}
