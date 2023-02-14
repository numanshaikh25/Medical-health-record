// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract MedicalHealthRecord {



    struct User{
        string name;
        string email;
        string contact_no;
        string role;
        bool active;
    }

    struct Patient{
        User user;
        string age;
        string gender;
        string medicalHistory;
        string[] medicalRecords;
    }
    struct Doctor{
        User user;
        string age;
        string gender;
        string degree;
        string speciality;
    }
    struct Hospital{
        User user;
        string addrs;
    }
    struct InsuranceCompany{
        User user;
        string addrs;
    }
    

    mapping(address=>User) users;
    mapping(address=>Patient) patients;
    mapping(address=>Doctor) doctors;
    mapping(address=>Hospital) hospitals;
    mapping(address=>InsuranceCompany) insuranceCompanies;
    // mapping(address=>mapping(address=>bool)) accessRequested;
    mapping(address=>address[]) accessRequestedUserList;
    mapping(address=>mapping(address=>bool)) accessGranted;
    mapping(address=>address[]) accessGrantedUserList;

    function createPatient(string memory _name, string memory _email,string memory _contact_no,string memory _role,string memory _age,
    string memory _gender,string memory _medicalHistory,string[] memory _medicalRecords) public {
        require(users[msg.sender].active!=true,"User already exists");
        User storage newUSer = users[msg.sender];
        newUSer.name = _name;
        newUSer.email = _email;
        newUSer.contact_no = _contact_no;
        newUSer.role = _role;
        newUSer.active = true;

        Patient storage newPatient = patients[msg.sender];
        newPatient.user = newUSer;
        newPatient.age = _age;
        newPatient.gender = _gender;
        newPatient.medicalHistory = _medicalHistory;
        newPatient.medicalRecords = _medicalRecords;
    }
    function createDoctor(string memory _name, string memory _email,string memory _contact_no,string memory _role,string memory _age,
    string memory _gender,string memory _degree,string memory _speciality) public {
        require(users[msg.sender].active!=true,"User already exists");
        User storage newUSer = users[msg.sender];
        newUSer.name = _name;
        newUSer.email = _email;
        newUSer.contact_no = _contact_no;
        newUSer.role = _role;
        newUSer.active = true;

        Doctor storage newDoctor = doctors[msg.sender];
        newDoctor.user = newUSer;
        newDoctor.age = _age;
        newDoctor.gender = _gender;
        newDoctor.degree = _degree;
        newDoctor.speciality = _speciality;
    }
    function createHospital(string memory _name, string memory _email,string memory _contact_no,string memory _role,string memory _addrs) public {
        require(users[msg.sender].active!=true,"User already exists");
        User storage newUSer = users[msg.sender];
        newUSer.name = _name;
        newUSer.email = _email;
        newUSer.contact_no = _contact_no;
        newUSer.role = _role;
        newUSer.active = true;

        Hospital storage newHospital = hospitals[msg.sender];
        newHospital.user = newUSer;
        newHospital.addrs = _addrs;
    }
    function createInsuranceCompany(string memory _name, string memory _email,string memory _contact_no,string memory _role,string memory _addrs) public {
        require(users[msg.sender].active!=true,"User already exists");
        User storage newUSer = users[msg.sender];
        newUSer.name = _name;
        newUSer.email = _email;
        newUSer.contact_no = _contact_no;
        newUSer.role = _role;
        newUSer.active = true;

        InsuranceCompany storage newInsuranceCompany = insuranceCompanies[msg.sender];
        newInsuranceCompany.user = newUSer;
        newInsuranceCompany.addrs = _addrs;
    }
    function login() public view returns(User memory){
        require(users[msg.sender].active == true,"User not found");
        return users[msg.sender];
    }

    function getPatient() public view returns(Patient memory){
        require(users[msg.sender].active == true,"User not found");
        require(patients[msg.sender].user.active == true,"Patient not found");
        return patients[msg.sender];
    }

    function getDoctor() public view returns(Doctor memory){
        require(users[msg.sender].active == true,"User not found");
        require(doctors[msg.sender].user.active == true,"Doctor not found");
        return doctors[msg.sender];
    }

    function getHospital() public view returns(Hospital memory){
        require(users[msg.sender].active == true,"User not found");
        require(hospitals[msg.sender].user.active == true,"Hospital not found");
        return hospitals[msg.sender];
    }

    function getInsuranceCompany() public view returns(InsuranceCompany memory){
        require(users[msg.sender].active == true,"User not found");
        require(insuranceCompanies[msg.sender].user.active == true,"Insurance Company not found");
        return insuranceCompanies[msg.sender];
    }

    function requestAccess(address patient) public{
        require(users[msg.sender].active==true, "User not valid");
        require(patients[msg.sender].user.active!=true,"You are a patient and cannot request for records");
        require(patients[patient].user.active == true,"Patient not found");
        // accessRequested[msg.sender][patient] = true;
        accessRequestedUserList[patient].push(msg.sender);
        accessGranted[patient][msg.sender] = false;
    }

    function grantAcess(address receiver) public{
        require(users[msg.sender].active==true, "User not valid");
        require(users[receiver].active==true,"Receiver not valid");
        require(patients[msg.sender].user.active==true,"You are not a patient");
        accessGranted[msg.sender][receiver] = true;
        accessGrantedUserList[msg.sender].push(receiver);
        for(uint i=0;i<accessRequestedUserList[msg.sender].length;i++){
            if(accessRequestedUserList[msg.sender][i]==receiver){
                accessRequestedUserList[msg.sender][i] = accessRequestedUserList[msg.sender][accessRequestedUserList[msg.sender].length-1];
                accessRequestedUserList[msg.sender].pop();
            }
        }
    }
    
    function viewRecord(address patient) public view returns(Patient memory){
        require(users[msg.sender].active==true, "User not valid");
        require(patients[patient].user.active == true,"Patient not found");
        require(accessGranted[patient][msg.sender]==true, "You do not have access");
        return patients[patient];
    }

    function revokeAccess(address receiver) public{
        require(users[msg.sender].active==true, "User not valid");
        require(users[receiver].active==true,"Receiver not valid");
        require(patients[msg.sender].user.active==true,"You are not a patient");
        accessGranted[msg.sender][receiver] = false;
        for(uint i=0;i<accessGrantedUserList[msg.sender].length;i++){
            if(accessGrantedUserList[msg.sender][i]==receiver){
                accessGrantedUserList[msg.sender][i] = accessGrantedUserList[msg.sender][accessGrantedUserList[msg.sender].length-1];
                accessGrantedUserList[msg.sender].pop();
            }
        }
    }

    function getaccessGrantedList() public view returns(address[] memory){
        require(users[msg.sender].active==true, "User not valid");
        require(patients[msg.sender].user.active==true,"You are not a patient");
        return accessGrantedUserList[msg.sender];
    }

    function getaccessRequestedList() public view returns(address[] memory){
        require(users[msg.sender].active==true, "User not valid");
        require(patients[msg.sender].user.active==true,"You are not a patient");
        return accessRequestedUserList[msg.sender];
    }

}