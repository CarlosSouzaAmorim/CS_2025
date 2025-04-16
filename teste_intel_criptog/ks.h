/* ks.h */
#define _GNU_SOURCE
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <assert.h>
#include <errno.h>
#include <birchutils.h>

typedef unsigned char int8;
typedef unsigned short int int16;
typedef unsigned int int32;
typedef unsigned long long int int64;
typedef unsigned _BitInt(128) int128;

typedef int32 word;    //AES int32 is a word
typedef int128 key;    //AES key
typedef word wordarray[44];

// key schedule --> create subkeys
// actual encryption and decr

//  128 kit key ---> 11 subkeys of the same length
// in 44 keys


#define $1 (int8 *)
#define $2 (int16)
#define $4 (int32)
#define $8 (int64)
#define $16 (int128)
#define $c (char *)
#define $i (int)

int main(int,char**);
