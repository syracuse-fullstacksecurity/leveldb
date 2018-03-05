pragma solidity ^0.4.17;

contract TierStrucContract
{
    uint[] tiers; 
    
    //////////////////////////////////////////////////////////////////////
    // description: write the computed hash value to TierStrucContract
    // input: a hash
    // output: bool value indicates write result
    function write(uint elem) public returns (bool)
    {
        // TODO: input check here
        tiers.push(elem);
        return true;
    }
    
    //////////////////////////////////////////////////////////////////////
    // description: read hash value on specific position of TierStrucContract
    // input: position(tierNum, elemNum)
    // output: hash value
    function read(uint elemNum) public view returns(uint[])
    {
        assert(elemNum <= tiers.length);
        uint[] memory output =  new uint[](elemNum);
        for(uint i=0; i < elemNum; i++)
        {
            output[i] = tiers[i];
        }
        return output;
    }

		function remove() public
		{
				delete tiers;
		}
}
