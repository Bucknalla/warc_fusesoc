#include <iostream>
#include <hls_stream.h>
#include <ap_axi_sdata.h>

using namespace std;

typedef ap_axis <32,1,1,1> AXI_T;
typedef hls::stream<AXI_T> STREAM_T;

void vec_add(STREAM_T &A, STREAM_T &B, STREAM_T &C, int LEN){
#pragma HLS INTERFACE s_axilite port=LEN bundle=ctrl
#pragma HLS INTERFACE axis port=A
#pragma HLS INTERFACE axis port=B
#pragma HLS INTERFACE axis port=C
#pragma HLS INTERFACE s_axilite port=return bundle=ctrl

    AXI_T tmpA, tmpB, tmpC;

    for(int i=0; i<LEN; i++){

        A >> tmpA;
        B >> tmpB;
        tmpC.data = tmpA.data + tmpB.data;
		
        if(i == LEN-1){
			tmpC.last = 1;	
		}else{
			tmpC.last = 0;
		}
		tmpC.strb = 0x7;	
		tmpC.keep = 0x7;	
		C << tmpC;
    }

}