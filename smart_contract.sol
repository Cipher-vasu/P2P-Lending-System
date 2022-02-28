// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

contract Lending {

    struct Proposal {
        uint id;
        address payable receiver;
        uint amount;
        uint duration;
        uint finalAmt;
        string mortage;
        bool isAccepted;
    }

    struct Loan {
        uint id;
        uint proposalId;
        address payable loaner;
        address payable receiver;
        uint amount;
        uint duration;
        uint finalAmt;
        bool isPayed;
    }

    uint totalProposals = 0;
    uint totalLoans = 0;
    Proposal[] public proposals;
    Loan[] public loans;
    mapping(address => bool) private hasPendingLoans;

    function createProposal(uint _amount, uint _finalAmt, uint _duration, string memory mortage) public {
        require(hasPendingLoans[msg.sender] == false, "Cannot make multiple loan requests");
        hasPendingLoans[msg.sender] = true;
        address payable _wallet = payable(msg.sender);
        proposals.push(Proposal(totalProposals, _wallet, _amount, _duration, _finalAmt, mortage, false));
        totalProposals += 1;
    }

    function acceptProposal(uint proposalId) public {
        proposals[proposalId].isAccepted = true;

        loans.push(Loan(
            totalLoans,
            proposalId,
            payable(msg.sender),
            proposals[proposalId].receiver,
            proposals[proposalId].amount,
            proposals[proposalId].duration,
            proposals[proposalId].finalAmt,
            false
        ));

        totalLoans += 1;
    }

    function transferFunds(address payable receiver) payable external {
        uint256 amount = msg.value;
        receiver.transfer(amount);
    }

    function repayLoan(address payable receiver, uint loanId) payable external {
        uint256 amount = msg.value;
        receiver.transfer(amount);
        loans[loanId].isPayed = true;
        hasPendingLoans[msg.sender] = false;
    }
}
