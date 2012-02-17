/* extint library */
#ifndef __EXTINT_H__
#define __EXTINT_H__

/* constants */
enum extint_t { INT_TYPE_64_BITS = 2, INT_TYPE_128_BITS = 4, INT_TYPE_256_BITS = 8, INT_TYPE_512_BITS = 16, INT_TYPE_1024_BITS = 32, INT_TYPE_2048_BITS = 64, INT_TYPE_4096_BITS = 128 };

/* types */
typedef struct {
	unsigned long int part[INT_TYPE_64_BITS];
} ext_int64;
typedef struct {
	unsigned long int part[INT_TYPE_128_BITS];
} ext_int128;
typedef struct {
	unsigned long int part[INT_TYPE_256_BITS];
} ext_int256;
typedef struct {
	unsigned long int part[INT_TYPE_512_BITS];
} ext_int512;
typedef struct {
	unsigned long int part[INT_TYPE_1024_BITS];
} ext_int1024;
typedef struct {
	unsigned long int part[INT_TYPE_2048_BITS];
} ext_int2048;
typedef struct {
	unsigned long int part[INT_TYPE_4096_BITS];
} ext_int4096;

/* limits */
#define INT_TYPE_MAX_BITS INT_TYPE_4096_BITS
#define ext_int_max ext_int4096

/* functions - assignment */
void extassign(void *extint_dest, enum extint_t extint_type, unsigned long int extint_length, ...);
void extassign_zero(void *extint_dest, enum extint_t extint_type);
void extassign_neg_one(void *extint_dest, enum extint_t extint_type);

/* functions - simple arithmetic */
unsigned long int extadd (void *extint_dest, void *extint_src, enum extint_t extint_type);
unsigned long int extsub (void *extint_dest, void *extint_src, enum extint_t extint_type);
void extneg (void *extint_dest, enum extint_t extint_type);
void extinc (void *extint_dest, enum extint_t extint_type);
void extdec (void *extint_dest, void extint_t extint_type);

/* functions - complex arithmetic */
void extdiv(void *extint_quot, void *extint_resi, void *extint_src, void *extint_divisor, enum extint_t extint_type);
void extidiv(void *extint_quot, void *extint_resi, void *extint_src, void *extint_divisor, enum extint_t extint_type);
void extmul(void *extint_dest, void *extint_src, void *extint_multiplier, enum extint_t extint_type);
void extimul(void *extint_dest, void *extint_src, void *extint_multiplier, enum extint_t extint_type);

/* functions - optimised complex arithmetic */
void extmuls(void *extint_dest, void *extint_src, void *extint_multiplier, enum extint_t extint_type);
void extimuls(void *extint_dest, void *extint_src, void *extint_multiplier, enum extint_t extint_type);

/* functions - bitwise manipulation - shifts */
void extshl(void *extint_dest, void *extint_src, unsigned long int shift, enum extint_t extint_type);
void extshl_single(void *extint_value, enum extint_t extint_type);
void extshr(void *extint_dest, void *extint_src, unsigned long int shift, enum extint_t extint_type);
void extshl_single(void *extint_value, enum extint_t extint_type);

/* functions - bitwise manipulation - rotates */
void extrol(void *extint_dest, void *extint_src, unsigned long int extint_rotate, enum extint_t extint_type);
void extror(void *extint_dest, void *extint_src, unsigned long int extint_rotate, enum extint_t extint_type);

/* functions - boolean (and derived) */
void extand(void *extint_dest, void *extint_src, enum extint_t extint_type);
void extor(void *extint_dest, void *extint_src, enum extint_t extint_type);
void extxor(void *extint_dest, void *extint_src, enum extint_t extint_type);
void extnot(void *extint_dest, enum extint_t extint_type);

/* functions - binary comparison */
unsigned long int extcmp(void *extint_dest, void *extint_src, enum extint_t extint_type);
unsigned long int exticmp(void *extint_dest, void *extint_src, enum extint_t extint_type);

#endif
