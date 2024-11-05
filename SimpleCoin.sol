//`SPDX-License-Identifier: MIT` for an open-source MIT License.

pragma solidity >=0.7.0 <0.8.0;

contract SimpleCoin {
    mapping(address => uint256) private coinBalance;      // 계좌별 코인 잔액
    address[] private enrolledAccounts;                   // 등록된 계좌 목록

    event Enroll(address indexed user);                   // 계좌 등록 이벤트
    event Transfer(address indexed from, address indexed to, uint256 value); // 코인 전송 이벤트
    event EarnedCoin(address indexed user, uint256 amount); // 코인 획득 이벤트

    constructor() {
    }

    // 계좌가 등록되었는지 확인하는 함수
    function isEnrolled(address account) private view returns (bool) {
        for (uint i = 0; i < enrolledAccounts.length; i++) {
            if (enrolledAccounts[i] == account) {
                return true;
            }
        }
        return false;
    }

    // 1. 계좌를 등록하고 초기 잔액을 0으로 설정하는 enroll 함수
    function enroll() public {
        require(!isEnrolled(msg.sender), "Account already enrolled"); // 계좌가 이미 등록된 경우를 방지
        coinBalance[msg.sender] = 0; // 잔액을 0으로 초기화하여 등록
        enrolledAccounts.push(msg.sender); // 등록된 계좌 목록에 추가
        emit Enroll(msg.sender);
    }

    // 1-1. 현재까지 등록된 모든 계좌 ID를 출력하는 함수
    function getEnrolledAccounts() public view returns (address[] memory) {
        return enrolledAccounts;
    }

    // 2. 100 코인을 지급하는 함수
    function getCoin() public returns (string memory) {
        require(isEnrolled(msg.sender), "Must be enrolled to receive coins");
        uint256 rewardAmount = 100;
        
        coinBalance[msg.sender] += rewardAmount; // 코인 지급
        
        emit EarnedCoin(msg.sender, rewardAmount); // 코인 획득 이벤트 발생
        
        return "You have earned 100 coins.";
    }

    // 3. 계좌의 현재 코인 잔액을 반환하는 함수
    function getBalance() public view returns (uint256) {
        require(isEnrolled(msg.sender), "Must be enrolled to view balance");
        return coinBalance[msg.sender];
    }

    // 4. 코인을 다른 계좌로 전송하는 transfer 함수
    function transfer(address _to, uint256 _amount) public {
        require(isEnrolled(msg.sender), "Must be enrolled to transfer coins");
        require(isEnrolled(_to), "Recipient must be enrolled");
        require(coinBalance[msg.sender] >= _amount, "Insufficient balance");
        require(coinBalance[_to] + _amount >= coinBalance[_to], "Overflow error");

        coinBalance[msg.sender] -= _amount;
        coinBalance[_to] += _amount;
        emit Transfer(msg.sender, _to, _amount);
    }
}
