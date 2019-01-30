pragma solidity ^0.4.23;
// Basic Contract
// Declares the store variables
contract EcommerceStore{
    enum ProductCondition {New,Used}
    //This will increment as we add the products and can also be queried anytime to get the number of products in our blockchain at a given point of time.
    uint public productIndex;
    mapping(address => mapping(uint => Product)) stores ; //can be used to get mapping of user to products
    mapping(uint => address) productIdInStore; // mapping from product to address
    struct Product{     // Defining our product
        uint id;
        string name;
        string category;
        string imageLink;
        string descLink;
        uint startTime;
        uint price;
        ProductCondition condition;
        address buyer;
    }
    constructor() public{
        productIndex = 0;
    }
    function addProductToStore(string _name,string _category,string _imageLink,string _descLink,uint _startTime,uint _price,uint _productConditon){
        productIndex += 1;
        Product memory product = Product(productIndex,_name, _category, _imageLink, _descLink, _startTime, _price, ProductCondition(_productConditon),0);
        stores[msg.sender][productIndex] = product;
        productIdInStore[productIndex] = msg.sender;
        
    }
    function getProduct(uint _productId) public view returns(uint,string,string,string,string,uint,uint,ProductCondition,address){
        Product memory product = stores[productIdInStore[_productId]][_productId];
        return(product.id,product.name,product.category,product.imageLink,product.descLink,product.startTime,product.price,
        product.condition,product.buyer);
    }
    
    function buy(uint _productId) payable public{
        Product memory product = stores[productIdInStore[_productId]][_productId];
        require(product.buyer == address(0));
        require(msg.value >= product.price);
        product.buyer == msg.sender;
        stores[productIdInStore[_productId]][_productId] = product;
    }
}