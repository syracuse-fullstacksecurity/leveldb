pragma solidity ^0.4.16;

/** @title Merge Demo. */
contract MergeContract {

    uint[] rst;

	function merge(uint[] l1, uint[] l2) public returns (uint[])
	{
		uint i = 0;
		uint j = 0;
		uint k = 0;
		
		while(i < l1.length && j < l2.length)
		{
			if(l1[i] <= l2[j])
			{
				rst.push(l1[i]);
				i++;
			}
			else
			{
				rst.push(l2[j]);
				j++;
			}
			k++;
		}

		while(i < l1.length)
		{
			rst.push(l1[i]);
			i++;
			k++;
		}
		
		while(j < l2.length)
		{
			rst.push(l2[j]);
			j++;
			k++;
		}
		return rst;
	}
	
	
	function getRst() public view returns (uint[])
	{
	    return rst;
	}

}
