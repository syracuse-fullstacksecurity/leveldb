pragma solidity ^0.4.16;

/** @title Merge Demo. */
contract MergeContract {
	function merge(uint[] l1, uint[] l2) public view returns (uint[])
	{
		uint i = 0;
		uint j = 0;
		uint k = 0;
		uint mergeLen = l1.length + l2.length;
		uint[] rst;
		while(i < l1.length && j < l2.length)
		{
			if(l1[i] <= l2[j])
			{
				rst[k] = l1[i];
				i++;
			}
			else
			{
				rst[k] = l2[j];
				j++;
			}
			k++;
		}

		while(i < l1.length)
		{
			rst[k] = l1[i];
			i++;
			k++;
		}
		
		while(j < l2.length)
		{
			rst[k] = l2[j];
			j++;
			k++;
		}

		return rst;
	}

}
