pragma solidity ^0.4.17;

contract LPADContract
{
    ///////////////////////////////////////////////////////////////////////
    // in-memory merkle tree implementation
    struct MerkleTree
    {
        uint treeDepth;
        bytes32[][] levels;
        uint[] leaves;
    }
    
    // help method to calculate power of 2
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
    
    // compute the depth of the merkle tree
    function depth(uint d) internal pure returns(uint)
    {
        // Compute tree depth
        uint pow = 1; 
        while(powOf2(pow) < d){
            pow ++;
        }
        
        return pow;
    }
    
    // compute hash value
    function computeHash(uint data) internal pure returns(bytes32)
    {
        return keccak256(data);
    }
    
    // internal method to build up level hash array
    function getNodes(bytes32[] leaves) internal pure returns(bytes32[])
    {
        uint remain = leaves.length % 2;
        bytes32[] memory rst = new bytes32[]((leaves.length+remain)/2);
        for(uint i=0; i<leaves.length-1; i=i+2)
        {
            bytes32 newhash = keccak256(leaves[i]&leaves[i+1]);
            rst[i/2] = newhash;
        }
        if(remain == 1){
            rst[((leaves.length-remain)/2)] = leaves[leaves.length - 1];
        }
         return rst;
    }
    
    // generate merkle tree
    // @param: uint[] source data to build the merkle tree
    // @return: bytes32, root hash of the merkle tree
    function buildMerkle(uint[] data) internal pure returns(bytes32)
    {
        // compute tree depth 
        MerkleTree memory mt;
        uint totalElem =  data.length;
        mt.treeDepth = depth(totalElem)+1;
        // init merkle tree
        uint remain = totalElem%2;
        mt.levels = new bytes32[][](mt.treeDepth+remain);
        mt.leaves = new uint[](totalElem);
        mt.levels[mt.treeDepth-1] = new bytes32[](totalElem+remain);
        
        // construct the bottom level, for the odd length, split the last elem
        for(uint i=0; i< totalElem; i++)
        {
            mt.leaves[i] = data[i];
            bytes32 hash = computeHash(data[i]);
            mt.levels[mt.treeDepth-1][i] = hash;
        }
        
        if(remain ==1 )
        {
            mt.levels[mt.treeDepth-1][totalElem] = computeHash(data[totalElem-1]);
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
        
        return mt.levels[0][0];
    } 
    
    ////////////////////////////////////////////////////////////////////////////////
    // LPAD definition
    struct Tiers
    {
        bytes32[][] tiers;
        uint tierNum;
        uint elemNum;
    }
    
    // storage variable
    Tiers tiers;
    
    
     ////////////////////////////////////////////////////////////////////////
    // define the merge operation
    // a min heap node
    struct MinHeapNode
    {
        uint element;       // element to be sorted
        uint i;             // index of the array from which the element is taken
        uint j;             // index of the next element to be picked from array
    }
    
    struct MinHeap
    {
        MinHeapNode[] harr;
        uint heap_size;
    }
    
    
    function swap(MinHeapNode x, MinHeapNode y) internal pure
    {
        MinHeapNode memory temp;
        temp = x;
        x = y;
        y = temp;
    }
    
    function left(uint i) internal pure returns(uint)
    {
        return 2*i + 1;
    }
    
    function right(uint i) internal pure returns(uint)
    {
        return 2*i + 2;
    }
    
    function getMin(MinHeap hp) internal pure returns(MinHeapNode)
    {
        return hp.harr[0];
    }
    
    function replaceMin(MinHeap hp, MinHeapNode x) internal
    {
        hp.harr[0] = x;
        MinHeapify(hp, 0);
    }
    
    function MinHeapify(MinHeap hp, uint i) internal
    {
        uint l = left(i);
        uint r = right(i);
        uint smallest = i;
        if(l < hp.heap_size && hp.harr[l].element < hp.harr[i].element)
        {
            smallest = l;
        }
        if(r < hp.heap_size && hp.harr[r].element < hp.harr[smallest].element)
        {
            smallest = r;
        }
        if(smallest != i)
        {
            //swap(hp.harr[i], hp.harr[smallest]);
            MinHeapNode memory temp = hp.harr[i];
            hp.harr[i] = hp.harr[smallest];
            hp.harr[smallest] = temp;
            MinHeapify(hp, smallest);
        }
    }
    
    function builtHeap(MinHeapNode[] a, uint kSize) internal returns(MinHeap)
    {
        MinHeap memory hp;
        hp.harr = a;
        hp.heap_size = kSize;
        uint i = (hp.heap_size - 1)/2;
        while(i >= 0)
        {
            MinHeapify(hp, i);
            if(i == 0) break;
            i--;
        }
        
        return hp;
    }
    
    ///////////////////////////////////////////////////////////////////////////////
    function mergeKArrays(uint[][] arr, uint k, uint arrayLen) internal returns(uint[])
    {
        uint[] memory output = new uint[](k*arrayLen);
        
        // create a min heap with k heap nodes.
        MinHeapNode[] memory harr = new MinHeapNode[](k);
        
        for(uint cnt = 0; cnt < k; cnt++)
        {
            harr[cnt].element = arr[cnt][0];    // store the first element
            harr[cnt].i = cnt;                  // index of array
            harr[cnt].j = 1;                  // index of next element to be stored from array
        }
        
        MinHeap memory hp;
        hp = builtHeap(harr, k);
        
        //get the minimum element from min heap and replace it with next element of its array
        for(uint count = 0; count < arrayLen * k; count++)
        {
            // get the minimum elem and store it in output
            MinHeapNode memory root = getMin(hp);
            output[count] = root.element;
            
            // find next element that will replace current root of heap.
            if(root.j < arrayLen)
            {
                root.element = arr[root.i][root.j];
                root.j += 1;
            }
            else
            {
                // uint maximum ------------------------------
                root.element = ~uint256(0);
            }
            
            replaceMin(hp, root);
        }
        
        return output;
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////
    // internal method to convert one-dimensional array to two-dimensional
    function genArrays(uint[] data, uint k, uint arrayLen) internal pure returns(uint[][])
    {
        uint[][] memory output = new uint[][](k);
        uint cnt = 0;
        for(uint idx=0; idx < k; idx++)
        {   
            output[idx] = new uint[](arrayLen);
            cnt = arrayLen*idx;
            for(uint i=0; i< arrayLen; i++)
            {
                output[idx][i] = data[cnt+i];
            }
        }
        return output;
    }

    function remove(uint tierNum) internal
    {
        if(tierNum == 0)
        {
            delete tiers.tiers[tierNum];
        }
        else
        {
            bytes32 tmp = tiers.tiers[tierNum][tiers.tierNum];
            delete tiers.tiers[tierNum];
            tiers.tiers[tierNum].push(tmp);
        }
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // expose interface
    // size configuration of LPAD
    function initialize(uint tierSize, uint elemSize) public 
    {
        tiers.tiers.length = tierSize;
        tiers.tierNum = tierSize;
        tiers.elemNum = elemSize;
    }

    //////////////////////////////////////////////////////////////////////
    // description: merge tier at tierNum to one array
    // @param: uint[] data, data at tierNum
    // @param: uint tierNum, tierNum 
    // @param: uint k, the length of each array at this tier
    // @param: uint arrayLen, the length of each array
    // output: bool value indicates write result
    function merge(uint[] data, uint tierNum, uint k, uint arrayLen) public returns(bool)
    {
        uint[][] memory initData = genArrays(data, k, arrayLen);
        // validation
        for(uint i = 0; i < k; i++)
        {
            if(tierNum == 0 && tiers.tiers[tierNum][i] != keccak256(data[i]))
            {
                return false;
            }
            
            if(tierNum !=0 && buildMerkle(initData[i]) != tiers.tiers[tierNum][i])
            {
                // not pass
                return false;
            }
        }
        
        // merge arrays
        uint[] memory output = new uint[](k*arrayLen);
        output = mergeKArrays(initData, k, arrayLen);  
        
        // update data, trigger transaction
        remove(tierNum);
        tiers.tiers[tierNum+1].push(buildMerkle(output));
        
        return true;
    }
    
    //////////////////////////////////////////////////////////////////////
    // description: write the computed hash value to TierStrucContract
    // input: a hash
    // output: bool value indicates write result
    function write(uint elem) public returns (bool)
    {
        // TODO: input check here
        // uint[] memory array = new uint[](1);
        // array[0] = elem;
        // tiers.tiers[0].push(keccak256(array));
        tiers.tiers[0].push(keccak256(elem));
        return true;
    }
    
    //////////////////////////////////////////////////////////////////////
    // description: read hash value on specific position of TierStrucContract
    // input: position(tierNum, elemNum)
    // output: hash value
    function read(uint tierNum, uint elemNum) public view returns(bytes32)
    {
        require(tierNum <= tiers.tierNum);
        require(elemNum <= tiers.elemNum);
        return tiers.tiers[tierNum][elemNum];
    }
    
}