// SPDX-License-Identifier: MIT
pragma experimental ABIEncoderV2;
pragma solidity >=0.4.22 <0.9.0;

contract main {
  struct user {
    string name;
    friend[] friendList;
  }

  struct friend{
    address pubkey;
    string name;
  }

  struct message {
    address sender;
    uint timestamp;
    string content;
  }

  struct AllUserStruct{
    string name;
    address accountAddress;
  }

  AllUserStruct[] public getAllUsers;


  mapping(address=>user) public userList;
  mapping(bytes32=>message[]) public allMessages;


  function checkUserExists(address pubkey) public view returns(bool){
    return bytes(userList[pubkey].name).length>0;
  }

  function createAccount(string calldata name,address pubkey) external returns(string memory){
    require(checkUserExists(pubkey)==false,"User already exists");
    require(bytes(name).length>0,"Username cannot be empty");
    userList[pubkey].name = name;
    getAllUsers.push(AllUserStruct(name,pubkey));
    return userList[pubkey].name;
  }

  function getUsername(address pubkey) external view returns(string memory){
    require(checkUserExists(pubkey),"user is not registered");
    return userList[pubkey].name;
  }

  function addFriend(address friend_key,string calldata name)external {
    require(checkUserExists(msg.sender),"Create account first");
    require(checkUserExists(friend_key),"user is not registered");
    require(msg.sender!=friend_key,"User cannot add themselves");
    require(checkAlreadyFriends(msg.sender,friend_key)==false,"These users are already friends");

    _addFriend(msg.sender,friend_key,name);
    _addFriend(friend_key,msg.sender,userList[msg.sender].name);
  }

  function checkAlreadyFriends(address pubkey1,address pubkey2)internal view returns(bool){
    if(userList[pubkey1].friendList.length>userList[pubkey2].friendList.length){
      address tmp = pubkey1;
      pubkey1 = pubkey2;
      pubkey2 = tmp;
    }
    for(uint256 i=0; i<userList[pubkey1].friendList.length;i++){
      if(userList[pubkey1].friendList[i].pubkey == pubkey2)return true;
    }
    return false;
  }

  function _addFriend(address me,address friend_key,string memory name)internal {
    friend memory newFriend = friend(friend_key,name);
    userList[me].friendList.push(newFriend);
  }

  function getMyFriendList() external view returns(friend[] memory){
    return userList[msg.sender].friendList;
  }

  function _getChatCode(address pubkey1,address pubkey2) internal pure returns(bytes32){
    if(pubkey1<pubkey2){
      return keccak256(abi.encodePacked(pubkey1,pubkey2));
    }
    else return keccak256(abi.encodePacked(pubkey2,pubkey1));
  }

  function sendMessage(address friend_key,string calldata _msg)external {
    require(checkUserExists(msg.sender),"user is not registered");
    require(checkUserExists(friend_key),"user is not registered");
    require(checkAlreadyFriends(msg.sender,friend_key),"You are not friend with given user");

    bytes32 chatcode = _getChatCode(msg.sender,friend_key);
    message memory newMsg = message(msg.sender,block.timestamp, _msg);
    allMessages[chatcode].push(newMsg);
  }

  function readMessage(address friend_key) external view returns(message[] memory){
    bytes32 chatcode = _getChatCode(msg.sender,friend_key);
    return allMessages[chatcode];
  }

  function getAllAppUser() public view returns(AllUserStruct[] memory){
    return getAllUsers;
  }
}
