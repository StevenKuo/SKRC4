# SKRC4

## 字元基本解釋

##### unicode 
2 bytes (16 bits) 

ex. 

'a' > U+0061(16) > 0000 0000 0110 0001(2) > 97(10)

'我' > U+6211(16) > 0110 0010 0001 0001(2) > 25105(10)

#### UTF-8
6 bytes (48 bits)

ex. 

'a' > 0x61 > 0000 ... 0110 0001(2) > 97(10)

'我' > 0xE68891 > 0000 ... 1111 0110 1000 1000 1001 0001(2) > XXXX(10)
    
    
#### char
1 byte (8 bits)
    
 
 
## basic RC4 Algorithm

#### first part - sbox

	for i from 0 to 255
	    S[i] := i
	endfor
	j := 0
	for( i=0 ; i<256 ; i++)
	    j := (j + S[i] + key[i mod keylength]) % 256
	    swap values of S[i] and S[j]
	endfor
	
	
#### second part - get k

	i := 0
	j := 0
	while GeneratingOutput:
	    i := (i + 1) mod 256   //a
	    j := (j + S[i]) mod 256 //b
	    swap values of S[i] and S[j]  //c
	    k := inputByte ^ S[(S[i] + S[j]) % 256]
	    output K
	endwhile
    


## Objc implement point

### Encrypt

#### first part - sbox

key[i mod keylength]

[key characterAtIndex:(index % [key length])]

unichar test = [@"我" characterAtIndex:0] > 25105

#### second part - get k

const char *utf8 = [string UTF8String];

const char *test = [@"我" UTF8String] > /xe6 | /x88 | /x91

[NSNumber numberWithUnsignedChar:utf8[index]]

[NSNumber numberWithUnsignedChar:test[0] > /xe6->230

[NSString stringWithFormat:@"%c",12345] > change to unicode string


### Decrypt

#### first part - sbox

the same

#### second part - get k

[hexDec appendBytes:boldOnBytes length:sizeof(boldOnBytes)];
append : /xe6 , /x88, /x91 > @"我"