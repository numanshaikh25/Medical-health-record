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
       bytes32 email;
       uint64 contact_no;
       bytes32 role;
   }


   struct Patient{
       User user;
       uint8 age;
       bytes32 gender;
       uint64 aadharNumber;
       string medicalHistory;
       Files[] medicalRecords;
   }
   struct Doctor{
       User user;
       uint8 age;
       bytes32 gender;
       uint64 aadharNumber;
       bytes32 degree;
       bytes32 speciality;
   }
   struct Hospital{
       User user;
       string addrs;
       uint64 gstNumber;
   }
   struct InsuranceCompany{
       User user;
       string addrs;
       uint64 gstNumber;
   }
   struct Files{
      bytes32 name;
      string hash;
      string description;
      bytes32 date;
    
   }
   struct AccessArray {
       address patientAddress;
       User userDetails;
   }


   struct PatientAccessArray {
       address patientAddress;
       Patient userDetails;
   }


   mapping(address=>User) users;
   mapping(address=>Patient) patients;
   mapping(address=>Doctor) doctors;
   mapping(address=>Hospital) hospitals;
   mapping(address=>InsuranceCompany) insuranceCompanies;
   mapping(address=>address[]) accessRequestedUserList;
   mapping(address=>mapping(address=>bool)) accessGranted;
   mapping(address=>address[]) accessGrantedUserList;
   mapping(address => address[]) PatientAccessList;


   function createPatient(string memory _name,bytes32 _email,uint64 _contact_no,bytes32 _role,uint8 _age,
   bytes32 _gender,uint64 _aadharNumber,string memory _medicalHistory) public {
      require(bytes(users[msg.sender].name).length == 0, "User already exists");
       User storage newUSer = users[msg.sender];
       newUSer.name = _name;
       newUSer.email = _email;
       newUSer.contact_no = _contact_no;
       newUSer.role = _role;


       Patient storage newPatient = patients[msg.sender];
       newPatient.user = newUSer;
       newPatient.age = _age;
       newPatient.gender = _gender;
       newPatient.aadharNumber = _aadharNumber;
       newPatient.medicalHistory = _medicalHistory;


   }
   function createDoctor(string memory _name,bytes32 _email,uint64 _contact_no,bytes32 _role,uint8 _age,
   bytes32 _gender, uint64 _aadharNumber,bytes32 _degree,bytes32 _speciality) public {
       require(bytes(users[msg.sender].name).length == 0, "User already exists");
       User storage newUSer = users[msg.sender];
       newUSer.name = _name;
       newUSer.email = _email;
       newUSer.contact_no = _contact_no;
       newUSer.role = _role;


       Doctor storage newDoctor = doctors[msg.sender];
       newDoctor.user = newUSer;
       newDoctor.age = _age;
       newDoctor.gender = _gender;
       newDoctor.aadharNumber = _aadharNumber;
       newDoctor.degree = _degree;
       newDoctor.speciality = _speciality;
   }
   function createHospital(string memory _name,bytes32 _email,uint64 _contact_no,bytes32 _role,string memory _addrs, uint64 _gstNumber) public {
       require(bytes(users[msg.sender].name).length == 0, "User already exists");
       User storage newUSer = users[msg.sender];
       newUSer.name = _name;
       newUSer.email = _email;
       newUSer.contact_no = _contact_no;
       newUSer.role = _role;


       Hospital storage newHospital = hospitals[msg.sender];
       newHospital.user = newUSer;
       newHospital.addrs = _addrs;
       newHospital.gstNumber = _gstNumber;
   }
   function createInsuranceCompany(string memory _name,bytes32 _email,uint64 _contact_no,bytes32 _role,string memory _addrs,uint64 _gstNumber) public {
       require(bytes(users[msg.sender].name).length == 0, "User already exists");
       User storage newUSer = users[msg.sender];
       newUSer.name = _name;
       newUSer.email = _email;
       newUSer.contact_no = _contact_no;
       newUSer.role = _role;


       InsuranceCompany storage newInsuranceCompany = insuranceCompanies[msg.sender];
       newInsuranceCompany.user = newUSer;
       newInsuranceCompany.addrs = _addrs;
       newInsuranceCompany.gstNumber = _gstNumber;
   }
   function login() public view returns(User memory){
       require(bytes(users[msg.sender].name).length != 0,"User not found");
       return users[msg.sender];
   }


   function getPatient() public view returns(Patient memory){
       require(bytes(patients[msg.sender].user.name).length!=0,"Patient not found");
       return patients[msg.sender];
   }


   function getDoctor() public view returns(Doctor memory){
       require(bytes(doctors[msg.sender].user.name).length!=0,"Doctor not found");
       return doctors[msg.sender];
   }


   function getHospital() public view returns(Hospital memory){
       require(bytes(hospitals[msg.sender].user.name).length!=0,"Hospital not found");
       return hospitals[msg.sender];
   }


   function getInsuranceCompany() public view returns(InsuranceCompany memory){
       require(bytes(insuranceCompanies[msg.sender].user.name).length!=0,"Insurance Company not found");
       return insuranceCompanies[msg.sender];
   }


   function requestAccess(address patient) public{
       require(bytes(users[msg.sender].name).length != 0,"User not found");
       require(bytes(patients[patient].user.name).length!=0,"Patient not found");
       // accessRequested[msg.sender][patient] = true;
       accessRequestedUserList[patient].push(msg.sender);
       accessGranted[patient][msg.sender] = false;
   }


   function grantAcess(address receiver) public{
       require(bytes(patients[msg.sender].user.name).length!=0,"You are not a patient");
       accessGranted[msg.sender][receiver] = true;
       accessGrantedUserList[msg.sender].push(receiver);
       PatientAccessList[receiver].push(msg.sender);
       for(uint i=0;i<accessRequestedUserList[msg.sender].length;i++){
           if(accessRequestedUserList[msg.sender][i]==receiver){
               accessRequestedUserList[msg.sender][i] = accessRequestedUserList[msg.sender][accessRequestedUserList[msg.sender].length-1];
               accessRequestedUserList[msg.sender].pop();
           }
       }
   }

//    function rejectAccess(address receiver) public{
//        require(bytes(patients[msg.sender].user.name).length!=0,"You are not a patient");
//        for(uint i=0;i<accessRequestedUserList[msg.sender].length;i++){
//            if(accessRequestedUserList[msg.sender][i]==receiver){
//                accessRequestedUserList[msg.sender][i] = accessRequestedUserList[msg.sender][accessRequestedUserList[msg.sender].length-1];
//                accessRequestedUserList[msg.sender].pop();
//            }
//        }
//    }
  
   function viewRecord(address patient) public view returns(Patient memory){
    //    require(bytes(users[msg.sender].name).length != 0,"User not found");
       require(accessGranted[patient][msg.sender]==true, "You do not have access");
       return patients[patient];
   }


   function revokeAccess(address receiver) public{
       require(bytes(users[receiver].name).length != 0,"Receiver not valid");
       require(bytes(patients[msg.sender].user.name).length!=0,"You are not a patient");
       accessGranted[msg.sender][receiver] = false;
       for(uint i=0;i<accessGrantedUserList[msg.sender].length;i++){
           if(accessGrantedUserList[msg.sender][i]==receiver){
               accessGrantedUserList[msg.sender][i] = accessGrantedUserList[msg.sender][accessGrantedUserList[msg.sender].length-1];
               accessGrantedUserList[msg.sender].pop();
               for(uint j=0; j<PatientAccessList[receiver].length; j++){
                   if(PatientAccessList[receiver][j] == msg.sender){
                       PatientAccessList[receiver][j] = PatientAccessList[receiver][PatientAccessList[receiver].length-1];
                       PatientAccessList[receiver].pop();
                       break;
                   }
               }
               break;
           }
       }
   }


   function getaccessGrantedList() public view returns(AccessArray[] memory){
       require(bytes(patients[msg.sender].user.name).length!=0,"You are not a patient");

       address[] memory grantedUsers = accessGrantedUserList[msg.sender];
       AccessArray[] memory result = new AccessArray[](grantedUsers.length);


       for (uint i = 0; i < grantedUsers.length; i++) {
           result[i] = AccessArray(grantedUsers[i], users[grantedUsers[i]]);
       }


       return result;
   }

   function getaccessRequestedList() public view returns(AccessArray[] memory){
       require(bytes(patients[msg.sender].user.name).length!=0,"You are not a patient");


       address[] memory requestedUsers = accessRequestedUserList[msg.sender];
       AccessArray[] memory result = new AccessArray[](requestedUsers.length);


       for (uint i = 0; i < requestedUsers.length; i++) {
           result[i] = AccessArray(requestedUsers[i], users[requestedUsers[i]]);
       }


       return result;
   }

   function getPatientAccessList() public view returns(PatientAccessArray[] memory){
       require(bytes(patients[msg.sender].user.name).length==0,"You are a patient and cannot request for records");
       address[] memory patientList = PatientAccessList[msg.sender];
       PatientAccessArray[] memory result = new PatientAccessArray[](patientList.length);


       for (uint i = 0; i < patientList.length; i++) {
           result[i] = PatientAccessArray(patientList[i], patients[patientList[i]]);
       }


       return result;
   }
   function addFiles(bytes32 _name,string memory _hash, string memory _description, bytes32 _date) public {
       require(bytes(patients[msg.sender].user.name).length!=0,"You are not a patient");
       Files memory newFile = Files({
           name: _name,
           hash: _hash,
           description: _description,
           date: _date
       });
       patients[msg.sender].medicalRecords.push(newFile);
   }
}



