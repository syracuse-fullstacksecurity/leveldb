pragma solidity ^0.4.17;

contract MerkleTreeContract
{
    struct MerkleTree
    {
        uint treeDepth;
        bytes32[][] levels;
        uint[] leaves;
    }
    
    MerkleTree mt;
    
    function powOf2(uint pw) internal pure returns(uint)
    {
        uint rst = 1;
        if(pw == 0) return rst;
        
        while(pw-- > 0)
        {
            rst = rst*2;
        }
        return rst;
    }
    
    function depth(uint d) internal pure returns(uint)
    {
        // Compute tree depth
        uint pow = 1; 
        while(powOf2(pow) < d){
            pow ++;
        }
        
        return pow;
    }
    
    function computeHash(uint data) internal pure returns(bytes32)
    {
        return sha256(data);
    }
    
   
    function getNodes(bytes32[] leaves) internal pure returns(bytes32[])
    {
        uint remain = leaves.length % 2;
        bytes32[] memory rst = new bytes32[]((leaves.length-remain)/2);
        for(uint i=0; i<leaves.length-1; i=i+2)
        {
            bytes32 newhash = sha256(leaves[i]&leaves[i+1]);
            rst[i/2] = newhash;
        }
        if(remain == 1){
            rst[((leaves.length-remain)/2)] = leaves[leaves.length - 1];
        }
         return rst;
    }
    
    // generate merkle tree
    function initMerkle(uint[] data) public
    {
        // compute tree depth
        uint totalElem =  data.length;
        mt.treeDepth = depth(totalElem)+1;
        mt.levels.length =  mt.treeDepth;
        for(uint i=0; i< totalElem; i++)
        {
            mt.leaves.push(data[i]);
            bytes32 hash = computeHash(data[i]);
            mt.levels[mt.treeDepth-1].push(hash);
        }
        
        // computeHash
        for(uint j= mt.treeDepth-2; j>=0; j--)
        {
            if(mt.levels[j+1].length == 1)
            {
                break;
            }
            mt.levels[j] = getNodes(mt.levels[j+1]); 
        }
    } 
    
    function level(uint i) internal view returns(bytes32[])
    {
        return mt.levels[i];
    }
    
    // get proof path
    function getProofPath(uint index) public view returns(bytes32[])
    {
        bytes32[] memory proofPath = new bytes32[](mt.treeDepth-1);
        
        for(uint curLevel = mt.treeDepth-1; curLevel > 0; curLevel--)
        {
            bytes32[] memory curLevelNodes = level(curLevel);
            if(index % 2 == 1)
            {
                proofPath[mt.treeDepth-1-curLevel] = curLevelNodes[index-1];
            }
            else
            {
                proofPath[mt.treeDepth-1-curLevel] = curLevelNodes[index+1];
            }
            
            index = index/2;
        }
        
        return proofPath;
    }
    
    // generate date --- for test use
    function genInput(uint size) public
    {
        uint datalen = powOf2(size);
        uint[] memory input = new uint[](datalen);
        for(uint i = 1; i<= datalen; i++)
        {
            input[i-1] = i;
        }
        initMerkle(input);
    }
    
    // test getProofPath
    function multiGet() public view
    {
        for(uint i=0; i<mt.leaves.length; i++)
        {
            getProofPath(i);
        }
    }
    
}
