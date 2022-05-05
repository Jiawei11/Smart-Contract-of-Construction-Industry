// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract Blocrac{
    address public gov;

    uint256 public itemsCount = 0;
    mapping(uint => Item) public itemlist;
    mapping(uint => market) public marketlist;

    constructor(){
        gov=msg.sender;
    }

    struct market {
        string _itemname;
        uint _marketunitprice;
    }

    struct Item {
        uint _id;
        string _itemname;
        uint256 _unitprice;
        uint256 _quantity;
        string _suppliername;
    }

    //Item public request;

    function add_market_info() public {
        require(msg.sender==gov,'You are not authorized to the list.');
        marketlist[1]=market('brick',50);
        marketlist[2]=market('pipe',100);
        marketlist[3]=market('wire',60);
        /*market memory brick=market('brick',50);
        market memory pipe=market('pipe',100);
        market memory wire=market('wire',60);
        marketlist.push(brick);
        marketlist.push(pipe);
        marketlist.push(wire);*/
    }

    function addItem(string memory _itemname, uint256  _unitprice, uint256  _quantity, string  memory _suppliername) public {
        require(msg.sender==gov,'You are not authorized to change the itemlist.');
        incrementCount_item();
        itemlist[itemsCount]=Item(itemsCount,_itemname,_unitprice,_quantity,_suppliername);
    }

    function pullrequest(string memory _itemname, uint256  _quantity) public view returns(string memory){

        uint256 marketunitprice;
        for(uint256 i = 0; i < 3; i++){
            if(compareString(marketlist[i+1]._itemname, _itemname)){

                marketunitprice = marketlist[i+1]._marketunitprice;
            }
        }

        for(uint256 i = 0; i < itemsCount; i++){

            if(compareString(itemlist[i+1]._itemname, _itemname)){

                if(itemlist[i+1]._quantity < _quantity){

                    return "quantity not enough, Submit for manual review";
                }else{

                    if(itemlist[i+1]._unitprice >= (marketunitprice * 80 / 100) && itemlist[i+1]._unitprice <= (marketunitprice * 120 / 100)){
                        return "pass"; //pass
                    }else{
                        return "manual review";
                    }
                }
            }
        }

        return "error";

    }

    function compareString(string memory a, string memory b) private pure returns (bool){
        if(bytes(a).length != bytes(b).length){
            return false;
        }else{
            return  keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
        }
    }

    function incrementCount_item() internal {
        itemsCount +=1;
    }

    /*function incrementCount_require() internal {
        requireCount +=1;
    }*/

}