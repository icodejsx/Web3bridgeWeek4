// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SchoolManagement {

    //  State variables at the top
    IERC20 public token;
    address public admin;

    //  Student Data
    struct Student {
        string name;
        uint256 amountPaid;
        bool isEnrolled;
    }

    // Staff Data
    struct Staff {
        string name;
        uint256 salary;
        bool isEmployed;
        bool isSuspended;
    }

    // adding unique address for students and staffs
    mapping(address => Student) public students;
    mapping(address => Staff) public staffs;

    // One constructor only
    constructor(address _tokenAddress) {
        admin = msg.sender;
        token = IERC20(_tokenAddress);
    }

    //  Modifier on its own, nothing inside except the guard
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can do this");
        _;
    }

    //  Enroll student
    function enrollStudent(address _student, string memory _name) public onlyAdmin {
        students[_student] = Student({
            name: _name,
            amountPaid: 0,
            isEnrolled: true
        });
    }

    // Remove student
    function removeStudent(address _student) public onlyAdmin {
        require(students[_student].isEnrolled, "Student not found");
        students[_student].isEnrolled = false;
    }

    // Student pays fees
    function payFees(uint256 _amount) public {
        require(students[msg.sender].isEnrolled, "You are not a student");
        token.transferFrom(msg.sender, address(this), _amount);
        students[msg.sender].amountPaid += _amount;
    }

    //  Hire staff
    function hireStaff(address _staff, string memory _name, uint256 _salary) public onlyAdmin {
        staffs[_staff] = Staff({
            name: _name,
            salary: _salary,
            isEmployed: true,
            isSuspended: false
        });
    }

    //  Suspend staff
    function suspendStaff(address _staff) public onlyAdmin {
        require(staffs[_staff].isEmployed, "Staff not found");
        staffs[_staff].isSuspended = true;
    }

    //  Pay staff
    function payStaff(address _staff) public onlyAdmin {
        require(staffs[_staff].isEmployed, "Staff not found");
        require(!staffs[_staff].isSuspended, "Staff is suspended");
        uint256 salary = staffs[_staff].salary;
        token.transfer(_staff, salary);
      
    }

}