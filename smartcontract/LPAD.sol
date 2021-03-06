pragma solidity ^0.4.16;

contract LPAD
{
    struct Tiers
    {
        uint[][][] tiers;
        mapping(uint => uint) pTier;
        uint curSize;
        uint maxSize;
    }
    
    // state variables: storage
    Tiers tiers;
    mapping(uint=>string) store;
    
    event MergeLog(string key); 
    
    // constructor
    function LPAD() public
    {
        initialize(3, 3);
    }
    
    //////////////////////////////////////////////////////////////////////////////
    // set the tier struct (L, K)
    function initialize(uint tireNum, uint elemNum) internal returns(uint)
    {
        // check the input
        assert(elemNum > 1);
        // initialize tier struct  
        tiers.tiers.length = tireNum;
        tiers.tiers[0].length = elemNum;
        uint sum = 0; 
        for(uint i=0; i<tiers.tiers.length; i++)
        {
            tiers.pTier[i] = 0;
            sum += elemNum;
            elemNum = elemNum*tiers.tiers[0].length;
        }
        // count the max size of this tier struct
        tiers.maxSize = sum;
        tiers.curSize = 0;
        return 0;
    }
    
    ///////////////////////////////////////////////////////////////////////////////////
    // internal methods
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
    
    function merge(uint tierNum, uint k, uint arrayLen) internal returns(uint[])
    {
        uint[] memory output = new uint[](k*arrayLen);
        // test here
        output = mergeKArrays(tiers.tiers[tierNum], k, arrayLen);
        return output;
    }
    
    function stringToUint(string _amount) internal pure returns (uint result) {
        bytes memory b = bytes(_amount);
        uint i;
        uint counterBeforeDot;
        uint counterAfterDot;
        result = 0;
        uint totNum = b.length;
        totNum--;
        bool hasDot = false;

        for (i = 0; i < b.length; i++) {
            uint c = uint(b[i]);

            if (c >= 48 && c <= 57) {
                result = result * 10 + (c - 48);
                counterBeforeDot ++;
                totNum--;
            }

            if(c == 46){
                hasDot = true;
                break;
            }
        }

        if(hasDot) {
            for (uint j = counterBeforeDot + 1; j < 18; j++) {
                uint m = uint(b[j]);

                if (m >= 48 && m <= 57) {
                    result = result * 10 + (m - 48);
                    counterAfterDot ++;
                    totNum--;
                }

                if(totNum == 0){
                    break;
                }
            }
        }
        if(counterAfterDot < 18){
            uint addNum = 18 - counterAfterDot;
            uint multuply = 10 ** addNum;
            return result = result * multuply;
        }

        return result;
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    // -------------------<exposed interface>-------------------------------
    // description: set an element to the tier structure
    function set(string key, string value) public
    {
        uint L = tiers.tiers.length;
        uint k = tiers.tiers[0].length;
        uint curTier = 0;
    
        uint elem = stringToUint(key);
        store[elem] = value;
        // if current tier is not full, curTier = 0
        if(tiers.pTier[curTier] < k)
        {
            tiers.tiers[curTier][tiers.pTier[0]].push(elem);
            tiers.curSize += 1;
            tiers.pTier[curTier] += 1;
        }
        else    // if current tier is full
        {
            if(tiers.curSize >= tiers.maxSize)
            {
                return;
            }
            
            // merge current tier
            uint mergeRstLen = k * tiers.tiers[curTier][0].length;
            uint[] memory mergeRst = new uint[](mergeRstLen);
            mergeRst = merge(curTier, k, tiers.tiers[curTier][0].length);
            
            // update pointers
            curTier += 1;
            
            while(curTier < L)
            {
                // current tier is not full
                if(tiers.pTier[curTier] < k)
                {
                    tiers.tiers[curTier].push(mergeRst);
                    tiers.pTier[curTier] += 1;
                    delete mergeRst;
                    break;
                }
                else // is full
                {
                    uint[] memory oldRst = new uint[](mergeRst.length);
                    oldRst = mergeRst;
                    
                    mergeRstLen = k*tiers.tiers[curTier][0].length;
                    mergeRst = new uint[](mergeRstLen);
                    mergeRst = merge(curTier, k, tiers.tiers[curTier][0].length);
                    
                    curTier += 1;
                    // exceed max tier size ========= test here or check Maxlength
                    if(curTier >= tiers.tiers.length)
                    {
                        delete oldRst;
                        delete mergeRst;
                        // return code HERE
                        return;
                    }
                    
                    // =========== test here
                    delete tiers.tiers[curTier-1];
                    tiers.pTier[curTier-1] = 0;
                    //tiers.tiers[curTier-1].length = k;
                    tiers.tiers[curTier-1].push(oldRst);
                    tiers.pTier[curTier-1] += 1;
                }    
            }
            
            delete tiers.tiers[0];
            tiers.pTier[0] = 0;
            tiers.tiers[0].length = k;
            tiers.tiers[0][tiers.pTier[0]].push(elem);
            tiers.curSize += 1;
            tiers.pTier[0] += 1;
            return;
        }
    }


    /////////////////////////////////////////////////////////////////////////////////
    // description: read an element from the tier structure
    // input: key
    // output: return string
    function get(string key) public view returns(string)
    {
        uint L = tiers.tiers.length;
        uint k = tiers.tiers[0].length;
        uint elemSize = k;
        uint elem = stringToUint(key);
        // scan tier0
        for(uint z = 0; z < tiers.pTier[0]; z++)
        {
            if(tiers.tiers[0][z][0] == elem)
            {
                return store[tiers.tiers[0][z][0]];
            }
        }
        
        // scan rest tiers until end
        for(uint i = 1; i < L; i++)
        {
            for(uint j = 0; j < tiers.pTier[i]; j++)
            {
                if(tiers.tiers[i][j][0]<=elem && tiers.tiers[i][j][elemSize-1] >= elem)
                {
                    // binary search
                    uint l = 0;
                    uint r = elemSize;
                    while(l < r)
                    {
                        uint mid = l + (r - l)/2;
                        if(tiers.tiers[i][j][mid] == elem)
                        {
                            return store[tiers.tiers[i][j][mid]];
                        }
                        
                        if(tiers.tiers[i][j][mid] < elem)
                        {
                            l = mid + 1;
                        }
                        else
                        {
                            r = mid - 1;
                        }
                    }
                }
            }
                        elemSize = elemSize*k;
        }
        
        // not found
        return store[elem];
    }
    
    //function check(uint p1, uint p2, uint p3) public view returns(string)
    //{
    //    return store[tiers.tiers[p1][p2][p3]];
    //}
}