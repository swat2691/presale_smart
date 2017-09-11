pragma solidity ^0.4.13;


/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address public owner;


    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    function Ownable() {
        owner = msg.sender;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert();
        }
        _;
    }


    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) onlyOwner {
        if (newOwner != address(0)) {
            owner = newOwner;
        }
    }

}

/**
 * @title Authorizable
 * @dev Allows to authorize access to certain function calls
 *
 * ABI
 * [{"constant":true,"inputs":[{"name":"authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"inputs":[],"payable":false,"type":"constructor"}]
 */
contract Authorizable {

    address[] authorizers;
    mapping(address => uint) authorizerIndex;

    /**
     * @dev Throws if called by any account tat is not authorized.
     */
    modifier onlyAuthorized {
        require(isAuthorized(msg.sender));
        _;
    }

    /**
     * @dev Contructor that authorizes the msg.sender.
     */
    function Authorizable() {
        authorizers.length = 2;
        authorizers[1] = msg.sender;
        authorizerIndex[msg.sender] = 1;
    }

    /**
     * @dev Function to get a specific authorizer
     * @param authorizerIndex index of the authorizer to be retrieved.
     * @return The address of the authorizer.
     */
    function getAuthorizer(uint authorizerIndex) external constant returns(address) {
        return address(authorizers[authorizerIndex + 1]);
    }

    /**
     * @dev Function to check if an address is authorized
     * @param _addr the address to check if it is authorized.
     * @return boolean flag if address is authorized.
     */
    function isAuthorized(address _addr) constant returns(bool) {
        return authorizerIndex[_addr] > 0;
    }

    /**
     * @dev Function to add a new authorizer
     * @param _addr the address to add as a new authorizer.
     */
    function addAuthorized(address _addr) external onlyAuthorized {
        authorizerIndex[_addr] = authorizers.length;
        authorizers.length++;
        authorizers[authorizers.length - 1] = _addr;
    }
}

/**
 * Math operations with safety checks
 */
library SafeMath {
    function mul(uint a, uint b) internal returns (uint) {
        uint c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function div(uint a, uint b) internal returns (uint) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint a, uint b) internal returns (uint) {
        assert(b <= a);
        return a - b;
    }

    function add(uint a, uint b) internal returns (uint) {
        uint c = a + b;
        assert(c >= a);
        return c;
    }

    function max64(uint64 a, uint64 b) internal constant returns (uint64) {
        return a >= b ? a : b;
    }

    function min64(uint64 a, uint64 b) internal constant returns (uint64) {
        return a < b ? a : b;
    }

    function max256(uint256 a, uint256 b) internal constant returns (uint256) {
        return a >= b ? a : b;
    }

    function min256(uint256 a, uint256 b) internal constant returns (uint256) {
        return a < b ? a : b;
    }

    function assert(bool assertion) internal {
        if (!assertion) {
            revert();
        }
    }
}

/**
 * Class providing availability to transfer presale coins.
**/
contract InvestorsInfo {
    function balanceOf(address investor) constant returns (uint balance);
    function getInvestors() constant returns (address[]);
}

/**
 * @title MainSale
 * @dev The main PAY token sale contract
 *
 * ABI
 * [{"constant":false,"inputs":[{"name":"_multisigVault","type":"address"}],"name":"setMultisigVault","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"exchangeRate","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"altDeposits","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"},{"name":"tokens","type":"uint256"}],"name":"authorizedCreateTokens","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_exchangeRate","type":"address"}],"name":"setExchangeRate","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_token","type":"address"}],"name":"retrieveTokens","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"totalAltDeposits","type":"uint256"}],"name":"setAltDeposit","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"start","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"}],"name":"createTokens","outputs":[],"payable":true,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"multisigVault","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_hardcap","type":"uint256"}],"name":"setHardCap","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_start","type":"uint256"}],"name":"setStart","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"token","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"payable":true,"type":"fallback"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"ether_amount","type":"uint256"},{"indexed":false,"name":"pay_amount","type":"uint256"},{"indexed":false,"name":"exchangerate","type":"uint256"}],"name":"TokenSold","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"pay_amount","type":"uint256"}],"name":"AuthorizedCreate","type":"event"},{"anonymous":false,"inputs":[],"name":"MainSaleClosed","type":"event"}]
 */
contract InvestyPresale is Ownable, Authorizable, InvestorsInfo {
    using SafeMath for uint;
    // Presale Investy Coin definition START
    event TokensCreated(address indexed to, uint value);
    event PresaleFinished();
    event PresaleStarted(address _token);

    string public name = "Investy Coin";
    string public symbol = "IVC";
    uint public totalSupply = 0;
    mapping(address => uint) balances;
    address[] investors;

    struct index {
    uint val;
    bool isValue;
    }
    mapping(address => index) investorsIndex;

    bool public presaleActive = true;
    modifier isPresaleActive() {
        if(!presaleActive) revert();
        _;
    }

    /**
       * @dev Allows authorized acces to create tokens. This is used for Bitcoin and ERC20 deposits
       * @param recipient the recipient to receive tokens.
       * @param tokens number of tokens to be created.
       */
    function mint(address recipient, uint tokens) internal isPresaleActive returns (bool) {
        totalSupply = totalSupply.add(tokens);
        balances[recipient] = balances[recipient].add(tokens);

        if(!investorsIndex[recipient].isValue) {
            investorsIndex[recipient].isValue=true;
            investorsIndex[recipient].val=investors.length;
            investors.length++;
            investors[investors.length - 1] = recipient;
        }

        TokensCreated(recipient, tokens);
        return true;
    }

    /**
     * @dev Function to stop minting new tokens.
     * @return True if the operation was successful.
     */
    function finishPresale() public onlyOwner returns (bool) {
        presaleActive = false;
        PresaleFinished();
        return true;
    }

    /**
    * @dev Gets the balance of the specified address.
    * @param _owner The address to query the the balance of.
    * @return An uint representing the amount owned by the passed address.
    */
    function balanceOf(address _owner) constant returns (uint balance) {
        return balances[_owner];
    }
    // Presale Investy Coin definition END

    event TokenSold(address recipient, uint ether_amount, uint pay_amount, uint exchangerate);

    uint constant MILLI_USD_TO_IVC_RATE = 34;//presale fixed IVC coin cost
    uint einsteinToUsdRate = 283950;

    /**
            constructor
        */
    function InvestyPresale() {
        PresaleStarted(this);
    }

    /**
     * @dev Function to get all authorized all registered investors.
     * @return address[].
     */
    function getInvestors() constant onlyAuthorized returns (address[]) {
        return investors;
    }

    /**
     * @dev Allows anyone to create tokens by depositing ether.
     * @param recipient the recipient to receive tokens.
     */
    function createTokens(address recipient) public isPresaleActive payable {
        uint ivc = (einsteinToUsdRate.mul(msg.value).div(MILLI_USD_TO_IVC_RATE));// 18 signs after comma
        mint(recipient, ivc);
        TokenSold(recipient, msg.value, ivc, einsteinToUsdRate / 1000);
    }

    /**
       * @dev Allows authorized acces to create tokens. This is used for Bitcoin and ERC20 deposits
       * @param recipient the recipient to receive tokens.
       * @param tokens number of tokens*10^-18 to be created.
       */
    function createTokens(address recipient, uint tokens) public onlyAuthorized returns (bool){
        bool result = mint(recipient, tokens);

        return result;
    }

    /**
     * @dev Allows the owner to set the exchangerate contract.
     * @param _einsteinToUsdRate the exchangerate address
     */
    function setExchangeRate(uint _einsteinToUsdRate) public onlyAuthorized {
        einsteinToUsdRate = _einsteinToUsdRate;
    }

    /**
     * @dev Fallback function which receives ether and created the appropriate number of tokens for the
     * msg.sender.
     */
    function() external payable {
        createTokens(msg.sender);
    }
}