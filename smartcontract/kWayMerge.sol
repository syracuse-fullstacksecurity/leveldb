pragma solidity ^0.4.16;

contract HelloWorldContract
{
    /////////////////////////////////////////////////////////////////////////////
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
                // uint maximum
                root.element = 1000000000;
            }
            
            replaceMin(hp, root);
        }
        
        return output;
    }
    
    uint[][] input = [[uint(2), uint(6), uint(12), uint(34)], [uint(1), uint(9), uint(20), uint(1000)], [uint(23), uint(34), uint(90), uint(2000)]];
    
    function merge(uint k, uint arrayLen) public returns(uint[])
    {
        uint[][] memory copyToMem = input;
        uint[] memory output = new uint[](k*arrayLen);
        output = mergeKArrays(copyToMem, k, arrayLen);
        return output;
    }
    
}