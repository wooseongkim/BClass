//`SPDX-License-Identifier: MIT` for an open-source MIT License.

pragma solidity >=0.7.0 <0.8.0;

contract EtherTransfer {
    address public owner;

    // 계약 생성자. 계약을 배포하는 계정이 소유자가 되며, 생성자가 payable이므로 이더를 받을 수 있다.
    constructor() payable {
        owner = msg.sender;
    }

    // 이더 입금 함수
    function deposit() public payable {}

    // 특정 계좌로 이더 전송 함수
    function transferEther(address payable _to, uint _amount) public {
        require(msg.sender == owner, "Only owner can transfer ether");
        require(address(this).balance >= _amount, "Insufficient balance in contract");
        _to.transfer(_amount);
    }

    // 남아 있는 입금된 이더 확인 함수
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
