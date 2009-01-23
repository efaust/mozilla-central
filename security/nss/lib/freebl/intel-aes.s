/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Initial Developer of the Original Code is Red Hat, Inc, 2008.
 *
 * Contributor(s):
 *	Ulrich Drepper <drepper@redhat.com>
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** */

	.text

#define IV_OFFSET 16
#define EXPANDED_KEY_OFFSET 48


/* in %rdi : the key
   in %rsi : buffer for expanded key
*/
	.type intel_aes_encrypt_init_128,@function
	.globl intel_aes_encrypt_init_128
	.align	16
intel_aes_encrypt_init_128:
	movups	(%rdi), %xmm1
	movups	%xmm1, (%rsi)
	leaq	16(%rsi), %rsi
	xorl	%eax, %eax

	.byte 0x66,0x0f,0x3a,0xdf,0xd1,0x01	/* aeskeygenassist $0x01, %xmm1, %xmm2 */
	call key_expansion128
	.byte 0x66,0x0f,0x3a,0xdf,0xd1,0x02	/* aeskeygenassist $0x02, %xmm1, %xmm2 */
	call key_expansion128
	.byte 0x66,0x0f,0x3a,0xdf,0xd1,0x04	/* aeskeygenassist $0x04, %xmm1, %xmm2 */
	call key_expansion128
	.byte 0x66,0x0f,0x3a,0xdf,0xd1,0x08	/* aeskeygenassist $0x08, %xmm1, %xmm2 */
	call key_expansion128
	.byte 0x66,0x0f,0x3a,0xdf,0xd1,0x10	/* aeskeygenassist $0x10, %xmm1, %xmm2 */
	call key_expansion128
	.byte 0x66,0x0f,0x3a,0xdf,0xd1,0x20	/* aeskeygenassist $0x20, %xmm1, %xmm2 */
	call key_expansion128
	.byte 0x66,0x0f,0x3a,0xdf,0xd1,0x40	/* aeskeygenassist $0x40, %xmm1, %xmm2 */
	call key_expansion128
	.byte 0x66,0x0f,0x3a,0xdf,0xd1,0x80	/* aeskeygenassist $0x80, %xmm1, %xmm2 */
	call key_expansion128
	.byte 0x66,0x0f,0x3a,0xdf,0xd1,0x1b	/* aeskeygenassist $0x1b, %xmm1, %xmm2 */
	call key_expansion128
	.byte 0x66,0x0f,0x3a,0xdf,0xd1,0x36	/* aeskeygenassist $0x36, %xmm1, %xmm2 */
	call key_expansion128

	ret
	.size intel_aes_encrypt_init_128, .-intel_aes_encrypt_init_128


/* in %rdi : the key
   in %rsi : buffer for expanded key
*/
	.type intel_aes_decrypt_init_128,@function
	.globl intel_aes_decrypt_init_128
	.align	16
intel_aes_decrypt_init_128:
	movups	(%rdi), %xmm1
	movups	%xmm1, (%rsi)
	leaq	16(%rsi), %rsi
	xorl	%eax, %eax

	.byte 0x66,0x0f,0x3a,0xdf,0xd1,0x01	/* aeskeygenassist $0x01, %xmm1, %xmm2 */
	call key_expansion128
	.byte 0x66,0x0f,0x38,0xdb,0xd1	/* aesimc	%xmm1, %xmm2 */
	movups	%xmm2, -16(%rsi)
	.byte 0x66,0x0f,0x3a,0xdf,0xd1,0x02	/* aeskeygenassist $0x02, %xmm1, %xmm2 */
	call key_expansion128
	.byte 0x66,0x0f,0x38,0xdb,0xd1	/* aesimc	%xmm1, %xmm2 */
	movups	%xmm2, -16(%rsi)
	.byte 0x66,0x0f,0x3a,0xdf,0xd1,0x04	/* aeskeygenassist $0x04, %xmm1, %xmm2 */
	call key_expansion128
	.byte 0x66,0x0f,0x38,0xdb,0xd1	/* aesimc	%xmm1, %xmm2 */
	movups	%xmm2, -16(%rsi)
	.byte 0x66,0x0f,0x3a,0xdf,0xd1,0x08	/* aeskeygenassist $0x08, %xmm1, %xmm2 */
	call key_expansion128
	.byte 0x66,0x0f,0x38,0xdb,0xd1	/* aesimc	%xmm1, %xmm2 */
	movups	%xmm2, -16(%rsi)
	.byte 0x66,0x0f,0x3a,0xdf,0xd1,0x10	/* aeskeygenassist $0x10, %xmm1, %xmm2 */
	call key_expansion128
	.byte 0x66,0x0f,0x38,0xdb,0xd1	/* aesimc	%xmm1, %xmm2 */
	movups	%xmm2, -16(%rsi)
	.byte 0x66,0x0f,0x3a,0xdf,0xd1,0x20	/* aeskeygenassist $0x20, %xmm1, %xmm2 */
	call key_expansion128
	.byte 0x66,0x0f,0x38,0xdb,0xd1	/* aesimc	%xmm1, %xmm2 */
	movups	%xmm2, -16(%rsi)
	.byte 0x66,0x0f,0x3a,0xdf,0xd1,0x40	/* aeskeygenassist $0x40, %xmm1, %xmm2 */
	call key_expansion128
	.byte 0x66,0x0f,0x38,0xdb,0xd1	/* aesimc	%xmm1, %xmm2 */
	movups	%xmm2, -16(%rsi)
	.byte 0x66,0x0f,0x3a,0xdf,0xd1,0x80	/* aeskeygenassist $0x80, %xmm1, %xmm2 */
	call key_expansion128
	.byte 0x66,0x0f,0x38,0xdb,0xd1	/* aesimc	%xmm1, %xmm2 */
	movups	%xmm2, -16(%rsi)
	.byte 0x66,0x0f,0x3a,0xdf,0xd1,0x1b	/* aeskeygenassist $0x1b, %xmm1, %xmm2 */
	call key_expansion128
	.byte 0x66,0x0f,0x38,0xdb,0xd1	/* aesimc	%xmm1, %xmm2 */
	movups	%xmm2, -16(%rsi)
	.byte 0x66,0x0f,0x3a,0xdf,0xd1,0x36	/* aeskeygenassist $0x36, %xmm1, %xmm2 */
	call key_expansion128

	ret
	.size intel_aes_decrypt_init_128, .-intel_aes_decrypt_init_128


	.type key_expansion128,@function
	.align	16
key_expansion128:
	movd	%eax, %xmm3
	pshufd	$0xff, %xmm2, %xmm2
	shufps	$0x10, %xmm1, %xmm3
	pxor	%xmm3, %xmm1
	shufps	$0x8c, %xmm1, %xmm3
	pxor	%xmm2, %xmm1
	pxor	%xmm3, %xmm1
	movdqu	%xmm1, (%rsi)
	addq	$16, %rsi
	ret
	.size key_expansion128, .-key_expansion128


/* in %rdi : cx - context
   in %rsi : output - pointer to output buffer
   in %rdx : outputLen - pointer to variable for length of output
             (filled by caller)
   in %rcx : maxOutputLen - length of output buffer
   in %r8  : input - pointer to input buffer
   in %r9  : inputLen - length of input buffer
   on stack: blocksize - AES blocksize (always 16, unused)
*/
	.type intel_aes_encrypt_ecb_128,@function
	.globl intel_aes_encrypt_ecb_128
	.align	16
intel_aes_encrypt_ecb_128:
//	leaq	EXPANDED_KEY_OFFSET(%rdi), %rdi
	leaq	48(%rdi), %rdi

	movdqu	(%rdi), %xmm2
	movdqu	160(%rdi), %xmm12
	xor	%eax, %eax
//	cmpq	$8*16, %r9
	cmpq	$128, %r9
	jb	1f
//	leaq	-8*16(%r9), %r11
	leaq	-128(%r9), %r11
2:	movdqu	(%r8, %rax), %xmm3
	movdqu	16(%r8, %rax), %xmm4
	movdqu	32(%r8, %rax), %xmm5
	movdqu	48(%r8, %rax), %xmm6
	movdqu	64(%r8, %rax), %xmm7
	movdqu	80(%r8, %rax), %xmm8
	movdqu	96(%r8, %rax), %xmm9
	movdqu	112(%r8, %rax), %xmm10
	pxor	%xmm2, %xmm3
	pxor	%xmm2, %xmm4
	pxor	%xmm2, %xmm5
	pxor	%xmm2, %xmm6
	pxor	%xmm2, %xmm7
	pxor	%xmm2, %xmm8
	pxor	%xmm2, %xmm9
	pxor	%xmm2, %xmm10
	movq	$16, %r10
3:	movdqu	(%rdi, %r10), %xmm1
	.byte 0x66,0x0f,0x38,0xdc,0xd9	/* aesenc	%xmm1, %xmm3 */
	.byte 0x66,0x0f,0x38,0xdc,0xe1	/* aesenc	%xmm1, %xmm4 */
	.byte 0x66,0x0f,0x38,0xdc,0xe9	/* aesenc	%xmm1, %xmm5 */
	.byte 0x66,0x0f,0x38,0xdc,0xf1	/* aesenc	%xmm1, %xmm6 */
	.byte 0x66,0x0f,0x38,0xdc,0xf9	/* aesenc	%xmm1, %xmm7 */
	.byte 0x66,0x44,0x0f,0x38,0xdc,0xc1	/* aesenc	%xmm1, %xmm8 */
	.byte 0x66,0x44,0x0f,0x38,0xdc,0xc9	/* aesenc	%xmm1, %xmm9 */
	.byte 0x66,0x44,0x0f,0x38,0xdc,0xd1	/* aesenc	%xmm1, %xmm10 */
	addq	$16, %r10
	cmpq	$160, %r10
	jne	3b
	.byte 0x66,0x41,0x0f,0x38,0xdd,0xdc /* aesenclast %xmm12, %xmm3 */
	.byte 0x66,0x41,0x0f,0x38,0xdd,0xe4 /* aesenclast %xmm12, %xmm4 */
	.byte 0x66,0x41,0x0f,0x38,0xdd,0xec /* aesenclast %xmm12, %xmm5 */
	.byte 0x66,0x41,0x0f,0x38,0xdd,0xf4 /* aesenclast %xmm12, %xmm6 */
	.byte 0x66,0x41,0x0f,0x38,0xdd,0xfc /* aesenclast %xmm12, %xmm7 */
	.byte 0x66,0x45,0x0f,0x38,0xdd,0xc4 /* aesenclast %xmm12, %xmm8 */
	.byte 0x66,0x45,0x0f,0x38,0xdd,0xcc /* aesenclast %xmm12, %xmm9 */
	.byte 0x66,0x45,0x0f,0x38,0xdd,0xd4 /* aesenclast %xmm12, %xmm10 */
	movdqu	%xmm3, (%rsi, %rax)
	movdqu	%xmm4, 16(%rsi, %rax)
	movdqu	%xmm5, 32(%rsi, %rax)
	movdqu	%xmm6, 48(%rsi, %rax)
	movdqu	%xmm7, 64(%rsi, %rax)
	movdqu	%xmm8, 80(%rsi, %rax)
	movdqu	%xmm9, 96(%rsi, %rax)
	movdqu	%xmm10, 112(%rsi, %rax)
//	addq	$8*16, %rax
	addq	$128, %rax
	cmpq	%r11, %rax
	jbe	2b
1:	cmpq	%rax, %r9
	je	5f

	movdqu	16(%rdi), %xmm3
	movdqu	32(%rdi), %xmm4
	movdqu	48(%rdi), %xmm5
	movdqu	64(%rdi), %xmm6
	movdqu	80(%rdi), %xmm7
	movdqu	96(%rdi), %xmm8
	movdqu	112(%rdi), %xmm9
	movdqu	128(%rdi), %xmm10
	movdqu	144(%rdi), %xmm11

4:	movdqu	(%r8, %rax), %xmm1
	pxor	%xmm2, %xmm1
	.byte 0x66,0x0f,0x38,0xdc,0xcb	/* aesenc	%xmm3, %xmm1 */
	.byte 0x66,0x0f,0x38,0xdc,0xcc	/* aesenc	%xmm4, %xmm1 */
	.byte 0x66,0x0f,0x38,0xdc,0xcd	/* aesenc	%xmm5, %xmm1 */
	.byte 0x66,0x0f,0x38,0xdc,0xce	/* aesenc	%xmm6, %xmm1 */
	.byte 0x66,0x0f,0x38,0xdc,0xcf	/* aesenc	%xmm7, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdc,0xc8	/* aesenc	%xmm8, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdc,0xc9	/* aesenc	%xmm9, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdc,0xca	/* aesenc	%xmm10, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdc,0xcb	/* aesenc	%xmm11, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdd,0xcc	/* aesenclast %xmm12, %xmm1 */
	movdqu	%xmm1, (%rsi, %rax)
	addq	$16, %rax
	cmpq	%rax, %r9
	jne	4b

5:	xor	%eax, %eax
	ret
	.size intel_aes_encrypt_ecb_128, .-intel_aes_encrypt_ecb_128


/* in %rdi : cx - context
   in %rsi : output - pointer to output buffer
   in %rdx : outputLen - pointer to variable for length of output
             (filled by caller)
   in %rcx : maxOutputLen - length of output buffer
   in %r8  : input - pointer to input buffer
   in %r9  : inputLen - length of input buffer
   on stack: blocksize - AES blocksize (always 16, unused)
*/
	.type intel_aes_decrypt_ecb_128,@function
	.globl intel_aes_decrypt_ecb_128
	.align	16
intel_aes_decrypt_ecb_128:
//	leaq	EXPANDED_KEY_OFFSET(%rdi), %rdi
	leaq	48(%rdi), %rdi

	movdqu	(%rdi), %xmm2
	movdqu	160(%rdi), %xmm12
	xorl	%eax, %eax
//	cmpq	$8*16, %r9
	cmpq	$128, %r9
	jb	1f
//	leaq	-8*16(%r9), %r11
	leaq	-128(%r9), %r11
2:	movdqu	(%r8, %rax), %xmm3
	movdqu	16(%r8, %rax), %xmm4
	movdqu	32(%r8, %rax), %xmm5
	movdqu	48(%r8, %rax), %xmm6
	movdqu	64(%r8, %rax), %xmm7
	movdqu	80(%r8, %rax), %xmm8
	movdqu	96(%r8, %rax), %xmm9
	movdqu	112(%r8, %rax), %xmm10
	pxor	%xmm12, %xmm3
	pxor	%xmm12, %xmm4
	pxor	%xmm12, %xmm5
	pxor	%xmm12, %xmm6
	pxor	%xmm12, %xmm7
	pxor	%xmm12, %xmm8
	pxor	%xmm12, %xmm9
	pxor	%xmm12, %xmm10
	movq	$144, %r10
3:	movdqu	(%rdi, %r10), %xmm1
	.byte 0x66,0x0f,0x38,0xde,0xd9	/* aesdec	%xmm1, %xmm3 */
	.byte 0x66,0x0f,0x38,0xde,0xe1	/* aesdec	%xmm1, %xmm4 */
	.byte 0x66,0x0f,0x38,0xde,0xe9	/* aesdec	%xmm1, %xmm5 */
	.byte 0x66,0x0f,0x38,0xde,0xf1	/* aesdec	%xmm1, %xmm6 */
	.byte 0x66,0x0f,0x38,0xde,0xf9	/* aesdec	%xmm1, %xmm7 */
	.byte 0x66,0x44,0x0f,0x38,0xde,0xc1	/* aesdec	%xmm1, %xmm8 */
	.byte 0x66,0x44,0x0f,0x38,0xde,0xc9	/* aesdec	%xmm1, %xmm8 */
	.byte 0x66,0x44,0x0f,0x38,0xde,0xd1	/* aesdec	%xmm1, %xmm8 */
	subq	$16, %r10
	jne	3b
	.byte 0x66,0x0f,0x38,0xdf,0xda	/* aesdeclast %xmm2, %xmm3 */
	.byte 0x66,0x0f,0x38,0xdf,0xe2	/* aesdeclast %xmm2, %xmm3 */
	.byte 0x66,0x0f,0x38,0xdf,0xea	/* aesdeclast %xmm2, %xmm3 */
	.byte 0x66,0x0f,0x38,0xdf,0xf2	/* aesdeclast %xmm2, %xmm3 */
	.byte 0x66,0x0f,0x38,0xdf,0xfa	/* aesdeclast %xmm2, %xmm3 */
	.byte 0x66,0x44,0x0f,0x38,0xdf,0xc2	/* aesdeclast %xmm2, %xmm8 */
	.byte 0x66,0x44,0x0f,0x38,0xdf,0xca	/* aesdeclast %xmm2, %xmm9 */
	.byte 0x66,0x44,0x0f,0x38,0xdf,0xd2	/* aesdeclast %xmm2, %xmm10 */
	movdqu	%xmm3, (%rsi, %rax)
	movdqu	%xmm4, 16(%rsi, %rax)
	movdqu	%xmm5, 32(%rsi, %rax)
	movdqu	%xmm6, 48(%rsi, %rax)
	movdqu	%xmm7, 64(%rsi, %rax)
	movdqu	%xmm8, 80(%rsi, %rax)
	movdqu	%xmm9, 96(%rsi, %rax)
	movdqu	%xmm10, 112(%rsi, %rax)
//	addq	$8*16, %rax
	addq	$128, %rax
	cmpq	%r11, %rax
	jbe	2b
1:	cmpq	%rax, %r9
	je	5f

	movdqu	16(%rdi), %xmm3
	movdqu	32(%rdi), %xmm4
	movdqu	48(%rdi), %xmm5
	movdqu	64(%rdi), %xmm6
	movdqu	80(%rdi), %xmm7
	movdqu	96(%rdi), %xmm8
	movdqu	112(%rdi), %xmm9
	movdqu	128(%rdi), %xmm10
	movdqu	144(%rdi), %xmm11

4:	movdqu	(%r8, %rax), %xmm1
	pxor	%xmm12, %xmm1
	.byte 0x66,0x41,0x0f,0x38,0xde,0xcb	/* aesdec	%xmm11, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xde,0xca	/* aesdec	%xmm10, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xde,0xc9	/* aesdec	%xmm9, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xde,0xc8	/* aesdec	%xmm8, %xmm1 */
	.byte 0x66,0x0f,0x38,0xde,0xcf	/* aesdec	%xmm7, %xmm1 */
	.byte 0x66,0x0f,0x38,0xde,0xce	/* aesdec	%xmm7, %xmm1 */
	.byte 0x66,0x0f,0x38,0xde,0xcd	/* aesdec	%xmm7, %xmm1 */
	.byte 0x66,0x0f,0x38,0xde,0xcc	/* aesdec	%xmm7, %xmm1 */
	.byte 0x66,0x0f,0x38,0xde,0xcb	/* aesdec	%xmm7, %xmm1 */
	.byte 0x66,0x0f,0x38,0xdf,0xca	/* aesdeclast %xmm2, %xmm1 */
	movdqu	%xmm1, (%rsi, %rax)
	addq	$16, %rax
	cmpq	%rax, %r9
	jne	4b

5:	xor	%eax, %eax
	ret
	.size intel_aes_decrypt_ecb_128, .-intel_aes_decrypt_ecb_128


/* in %rdi : cx - context
   in %rsi : output - pointer to output buffer
   in %rdx : outputLen - pointer to variable for length of output
             (filled by caller)
   in %rcx : maxOutputLen - length of output buffer
   in %r8  : input - pointer to input buffer
   in %r9  : inputLen - length of input buffer
   on stack: blocksize - AES blocksize (always 16, unused)
*/
	.type intel_aes_encrypt_cbc_128,@function
	.globl intel_aes_encrypt_cbc_128
	.align	16
intel_aes_encrypt_cbc_128:
	testq	%r9, %r9
	je	2f

//	leaq	IV_OFFSET(%rdi), %rdx
//	leaq	EXPANDED_KEY_OFFSET(%rdi), %rdi
	leaq	16(%rdi), %rdx
	leaq	48(%rdi), %rdi

	movdqu	(%rdx), %xmm0
	movdqu	(%rdi), %xmm2
	movdqu	16(%rdi), %xmm3
	movdqu	32(%rdi), %xmm4
	movdqu	48(%rdi), %xmm5
	movdqu	64(%rdi), %xmm6
	movdqu	80(%rdi), %xmm7
	movdqu	96(%rdi), %xmm8
	movdqu	112(%rdi), %xmm9
	movdqu	128(%rdi), %xmm10
	movdqu	144(%rdi), %xmm11
	movdqu	160(%rdi), %xmm12

	xorl	%eax, %eax
1:	movdqu	(%r8, %rax), %xmm1
	pxor	%xmm0, %xmm1
	pxor	%xmm2, %xmm1
	.byte 0x66,0x0f,0x38,0xdc,0xcb	/* aesenc	%xmm3, %xmm1 */
	.byte 0x66,0x0f,0x38,0xdc,0xcc	/* aesenc	%xmm4, %xmm1 */
	.byte 0x66,0x0f,0x38,0xdc,0xcd	/* aesenc	%xmm5, %xmm1 */
	.byte 0x66,0x0f,0x38,0xdc,0xce	/* aesenc	%xmm6, %xmm1 */
	.byte 0x66,0x0f,0x38,0xdc,0xcf	/* aesenc	%xmm7, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdc,0xc8	/* aesenc	%xmm8, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdc,0xc9	/* aesenc	%xmm9, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdc,0xca	/* aesenc	%xmma, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdc,0xcb	/* aesenc	%xmmb, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdd,0xcc	/* aesenclast %xmm12, %xmm1 */
	movdqu	%xmm1, (%rsi, %rax)
	movdqa	%xmm1, %xmm0
	addq	$16, %rax
	cmpq	%rax, %r9
	jne	1b

	movdqu	%xmm0, (%rdx)

2:	xor	%eax, %eax
	ret
	.size intel_aes_encrypt_cbc_128, .-intel_aes_encrypt_cbc_128


/* in %rdi : cx - context
   in %rsi : output - pointer to output buffer
   in %rdx : outputLen - pointer to variable for length of output
             (filled by caller)
   in %rcx : maxOutputLen - length of output buffer
   in %r8  : input - pointer to input buffer
   in %r9  : inputLen - length of input buffer
   on stack: blocksize - AES blocksize (always 16, unused)
*/
	.type intel_aes_decrypt_cbc_128,@function
	.globl intel_aes_decrypt_cbc_128
	.align	16
intel_aes_decrypt_cbc_128:
//	leaq	IV_OFFSET(%rdi), %rdx
//	leaq	EXPANDED_KEY_OFFSET(%rdi), %rdi
	leaq	16(%rdi), %rdx
	leaq	48(%rdi), %rdi

	movdqu	(%rdx), %xmm0
	movdqu	(%rdi), %xmm2
	movdqu	160(%rdi), %xmm12
	xorl	%eax, %eax
//	cmpq	$8*16, %r9
	cmpq	$128, %r9
	jb	1f
//	leaq	-8*16(%r9), %r11
	leaq	-128(%r9), %r11
2:	movdqu	(%r8, %rax), %xmm3
	movdqu	16(%r8, %rax), %xmm4
	movdqu	32(%r8, %rax), %xmm5
	movdqu	48(%r8, %rax), %xmm6
	movdqu	64(%r8, %rax), %xmm7
	movdqu	80(%r8, %rax), %xmm8
	movdqu	96(%r8, %rax), %xmm9
	movdqu	112(%r8, %rax), %xmm10
	pxor	%xmm12, %xmm3
	pxor	%xmm12, %xmm4
	pxor	%xmm12, %xmm5
	pxor	%xmm12, %xmm6
	pxor	%xmm12, %xmm7
	pxor	%xmm12, %xmm8
	pxor	%xmm12, %xmm9
	pxor	%xmm12, %xmm10
	movq	$144, %r10
3:	movdqu	(%rdi, %r10), %xmm1
	.byte 0x66,0x0f,0x38,0xde,0xd9	/* aesdec	%xmm1, %xmm3 */
	.byte 0x66,0x0f,0x38,0xde,0xe1	/* aesdec	%xmm1, %xmm4 */
	.byte 0x66,0x0f,0x38,0xde,0xe9	/* aesdec	%xmm1, %xmm5 */
	.byte 0x66,0x0f,0x38,0xde,0xf1	/* aesdec	%xmm1, %xmm6 */
	.byte 0x66,0x0f,0x38,0xde,0xf9	/* aesdec	%xmm1, %xmm7 */
	.byte 0x66,0x44,0x0f,0x38,0xde,0xc1	/* aesdec	%xmm1, %xmm8 */
	.byte 0x66,0x44,0x0f,0x38,0xde,0xc9	/* aesdec	%xmm1, %xmm9 */
	.byte 0x66,0x44,0x0f,0x38,0xde,0xd1	/* aesdec	%xmm1, %xmm10 */
	subq	$16, %r10
	jne	3b
	.byte 0x66,0x0f,0x38,0xdf,0xda	/* aesdeclast %xmm2, %xmm3 */
	.byte 0x66,0x0f,0x38,0xdf,0xe2	/* aesdeclast %xmm2, %xmm4 */
	.byte 0x66,0x0f,0x38,0xdf,0xea	/* aesdeclast %xmm2, %xmm5 */
	.byte 0x66,0x0f,0x38,0xdf,0xf2	/* aesdeclast %xmm2, %xmm6 */
	.byte 0x66,0x0f,0x38,0xdf,0xfa	/* aesdeclast %xmm2, %xmm7 */
	.byte 0x66,0x44,0x0f,0x38,0xdf,0xc2	/* aesdeclast %xmm2, %xmm8 */
	.byte 0x66,0x44,0x0f,0x38,0xdf,0xca	/* aesdeclast %xmm2, %xmm9 */
	.byte 0x66,0x44,0x0f,0x38,0xdf,0xd2	/* aesdeclast %xmm2, %xmm10 */
	pxor	%xmm0, %xmm3
	pxor	(%r8, %rax), %xmm4
	pxor	16(%r8, %rax), %xmm5
	pxor	32(%r8, %rax), %xmm6
	pxor	48(%r8, %rax), %xmm7
	pxor	64(%r8, %rax), %xmm8
	pxor	80(%r8, %rax), %xmm9
	pxor	96(%r8, %rax), %xmm10
	movdqu	112(%r8, %rax), %xmm0
	movdqu	%xmm3, (%rsi, %rax)
	movdqu	%xmm4, 16(%rsi, %rax)
	movdqu	%xmm5, 32(%rsi, %rax)
	movdqu	%xmm6, 48(%rsi, %rax)
	movdqu	%xmm7, 64(%rsi, %rax)
	movdqu	%xmm8, 80(%rsi, %rax)
	movdqu	%xmm9, 96(%rsi, %rax)
	movdqu	%xmm10, 112(%rsi, %rax)
//	addq	$8*16, %rax
	addq	$128, %rax
	cmpq	%r11, %rax
	jbe	2b
1:	cmpq	%rax, %r9
	je	5f

	movdqu	16(%rdi), %xmm3
	movdqu	32(%rdi), %xmm4
	movdqu	48(%rdi), %xmm5
	movdqu	64(%rdi), %xmm6
	movdqu	80(%rdi), %xmm7
	movdqu	96(%rdi), %xmm8
	movdqu	112(%rdi), %xmm9
	movdqu	128(%rdi), %xmm10
	movdqu	144(%rdi), %xmm11

4:	movdqu	(%r8, %rax), %xmm1
	movdqa	%xmm1, %xmm13
	pxor	%xmm12, %xmm1
	.byte 0x66,0x41,0x0f,0x38,0xde,0xcb	/* aesdec	%xmm11, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xde,0xca	/* aesdec	%xmm10, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xde,0xc9	/* aesdec	%xmm9, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xde,0xc8	/* aesdec	%xmm8, %xmm1 */
	.byte 0x66,0x0f,0x38,0xde,0xcf	/* aesdec	%xmm7, %xmm1 */
	.byte 0x66,0x0f,0x38,0xde,0xce	/* aesdec	%xmm6, %xmm1 */
	.byte 0x66,0x0f,0x38,0xde,0xcd	/* aesdec	%xmm5, %xmm1 */
	.byte 0x66,0x0f,0x38,0xde,0xcc	/* aesdec	%xmm4, %xmm1 */
	.byte 0x66,0x0f,0x38,0xde,0xcb	/* aesdec	%xmm3, %xmm1 */
	.byte 0x66,0x0f,0x38,0xdf,0xca	/* aesdeclast %xmm2, %xmm1 */
	pxor	%xmm0, %xmm1
	movdqu	%xmm1, (%rsi, %rax)
	movdqa	%xmm13, %xmm0
	addq	$16, %rax
	cmpq	%rax, %r9
	jne	4b

5:	movdqu	%xmm0, (%rdx)

	xor	%eax, %eax
	ret
	.size intel_aes_decrypt_cbc_128, .-intel_aes_decrypt_cbc_128


/* in %rdi : the key
   in %rsi : buffer for expanded key
*/
	.type intel_aes_encrypt_init_192,@function
	.globl intel_aes_encrypt_init_192
	.align	16
intel_aes_encrypt_init_192:
	movdqu	(%rdi), %xmm1
	movq	16(%rdi), %xmm3
	movdqu	%xmm1, (%rsi)
	movq	%xmm3, 16(%rsi)
	leaq	24(%rsi), %rsi

	.byte 0x66,0x0f,0x3a,0xdf,0xd3,0x01	/* aeskeygenassist $0x01, %xmm3, %xmm2 */
	call key_expansion192
	.byte 0x66,0x0f,0x3a,0xdf,0xd3,0x02	/* aeskeygenassist $0x02, %xmm3, %xmm2 */
	call key_expansion192
	.byte 0x66,0x0f,0x3a,0xdf,0xd3,0x04	/* aeskeygenassist $0x04, %xmm3, %xmm2 */
	call key_expansion192
	.byte 0x66,0x0f,0x3a,0xdf,0xd3,0x08	/* aeskeygenassist $0x08, %xmm3, %xmm2 */
	call key_expansion192
	.byte 0x66,0x0f,0x3a,0xdf,0xd3,0x10	/* aeskeygenassist $0x10, %xmm3, %xmm2 */
	call key_expansion192
	.byte 0x66,0x0f,0x3a,0xdf,0xd3,0x20	/* aeskeygenassist $0x20, %xmm3, %xmm2 */
	call key_expansion192
	.byte 0x66,0x0f,0x3a,0xdf,0xd3,0x40	/* aeskeygenassist $0x40, %xmm3, %xmm2 */
	call key_expansion192
	.byte 0x66,0x0f,0x3a,0xdf,0xd3,0x80	/* aeskeygenassist $0x80, %xmm3, %xmm2 */
	call key_expansion192

	ret
	.size intel_aes_encrypt_init_192, .-intel_aes_encrypt_init_192


/* in %rdi : the key
   in %rsi : buffer for expanded key
*/
	.type intel_aes_decrypt_init_192,@function
	.globl intel_aes_decrypt_init_192
	.align	16
intel_aes_decrypt_init_192:
	movdqu	(%rdi), %xmm1
	movq	16(%rdi), %xmm3
	movdqu	%xmm1, (%rsi)
	movq	%xmm3, 16(%rsi)
	leaq	24(%rsi), %rsi

	.byte 0x66,0x0f,0x3a,0xdf,0xd3,0x01	/* aeskeygenassist $0x01, %xmm3, %xmm2 */
	call key_expansion192
	movups	-32(%rsi), %xmm2
	movups	-16(%rsi), %xmm4
	.byte 0x66,0x0f,0x38,0xdb,0xd2	/* aesimc	%xmm2, %xmm2 */
	.byte 0x66,0x0f,0x38,0xdb,0xe4	/* aesimc	%xmm4, %xmm4 */
	movups	%xmm2, -32(%rsi)
	movups	%xmm4, -16(%rsi)
	.byte 0x66,0x0f,0x3a,0xdf,0xd3,0x02	/* aeskeygenassist $0x02, %xmm3, %xmm2 */
	call key_expansion192
	.byte 0x66,0x0f,0x38,0xdb,0xd1	/* aesimc	%xmm1, %xmm2 */
	movups	%xmm2, -24(%rsi)
	.byte 0x66,0x0f,0x3a,0xdf,0xd3,0x04	/* aeskeygenassist $0x04, %xmm3, %xmm2 */
	call key_expansion192
	movups	-32(%rsi), %xmm2
	movups	-16(%rsi), %xmm4
	.byte 0x66,0x0f,0x38,0xdb,0xd2	/* aesimc	%xmm2, %xmm2 */
	.byte 0x66,0x0f,0x38,0xdb,0xe4	/* aesimc	%xmm4, %xmm4 */
	movups	%xmm2, -32(%rsi)
	movups	%xmm4, -16(%rsi)
	.byte 0x66,0x0f,0x3a,0xdf,0xd3,0x08	/* aeskeygenassist $0x08, %xmm3, %xmm2 */
	call key_expansion192
	.byte 0x66,0x0f,0x38,0xdb,0xd1	/* aesimc	%xmm1, %xmm2 */
	movups	%xmm2, -24(%rsi)
	.byte 0x66,0x0f,0x3a,0xdf,0xd3,0x10	/* aeskeygenassist $0x10, %xmm3, %xmm2 */
	call key_expansion192
	movups	-32(%rsi), %xmm2
	movups	-16(%rsi), %xmm4
	.byte 0x66,0x0f,0x38,0xdb,0xd2	/* aesimc	%xmm2, %xmm2 */
	.byte 0x66,0x0f,0x38,0xdb,0xe4	/* aesimc	%xmm4, %xmm4 */
	movups	%xmm2, -32(%rsi)
	movups	%xmm4, -16(%rsi)
	.byte 0x66,0x0f,0x3a,0xdf,0xd3,0x20	/* aeskeygenassist $0x20, %xmm3, %xmm2 */
	call key_expansion192
	.byte 0x66,0x0f,0x38,0xdb,0xd1	/* aesimc	%xmm1, %xmm2 */
	movups	%xmm2, -24(%rsi)
	.byte 0x66,0x0f,0x3a,0xdf,0xd3,0x40	/* aeskeygenassist $0x40, %xmm3, %xmm2 */
	call key_expansion192
	movups	-32(%rsi), %xmm2
	movups	-16(%rsi), %xmm4
	.byte 0x66,0x0f,0x38,0xdb,0xd2	/* aesimc	%xmm2, %xmm2 */
	.byte 0x66,0x0f,0x38,0xdb,0xe4	/* aesimc	%xmm4, %xmm4 */
	movups	%xmm2, -32(%rsi)
	movups	%xmm4, -16(%rsi)
	.byte 0x66,0x0f,0x3a,0xdf,0xd3,0x80	/* aeskeygenassist $0x80, %xmm3, %xmm2 */
	call key_expansion192

	ret
	.size intel_aes_decrypt_init_192, .-intel_aes_decrypt_init_192


	.type key_expansion192,@function
	.align	16
key_expansion192:
	pshufd	$0x55, %xmm2, %xmm2
	xor	%eax, %eax
	movd	%eax, %xmm4
	shufps	$0x10, %xmm1, %xmm4
	pxor	%xmm4, %xmm1
	shufps	$0x8c, %xmm1, %xmm4
	pxor	%xmm2, %xmm1
	pxor	%xmm4, %xmm1
	movdqu	%xmm1, (%rsi)
	addq	$16, %rsi

	pshufd	$0xff, %xmm1, %xmm4
	movd	%eax, %xmm5
	shufps	$0x00, %xmm3, %xmm5
	shufps	$0x08, %xmm3, %xmm5
	pxor	%xmm4, %xmm3
	pxor	%xmm5, %xmm3
	movq	%xmm3, (%rsi)
	addq	$8, %rsi
	ret
	.size key_expansion192, .-key_expansion192


/* in %rdi : cx - context
   in %rsi : output - pointer to output buffer
   in %rdx : outputLen - pointer to variable for length of output
             (filled by caller)
   in %rcx : maxOutputLen - length of output buffer
   in %r8  : input - pointer to input buffer
   in %r9  : inputLen - length of input buffer
   on stack: blocksize - AES blocksize (always 16, unused)
*/
	.type intel_aes_encrypt_ecb_192,@function
	.globl intel_aes_encrypt_ecb_192
	.align	16
intel_aes_encrypt_ecb_192:
//	leaq	EXPANDED_KEY_OFFSET(%rdi), %rdi
	leaq	48(%rdi), %rdi

	movdqu	(%rdi), %xmm2
	movdqu	192(%rdi), %xmm14
	xorl	%eax, %eax
//	cmpq	$8*16, %r9
	cmpq	$128, %r9
	jb	1f
//	leaq	-8*16(%r9), %r11
	leaq	-128(%r9), %r11
2:	movdqu	(%r8, %rax), %xmm3
	movdqu	16(%r8, %rax), %xmm4
	movdqu	32(%r8, %rax), %xmm5
	movdqu	48(%r8, %rax), %xmm6
	movdqu	64(%r8, %rax), %xmm7
	movdqu	80(%r8, %rax), %xmm8
	movdqu	96(%r8, %rax), %xmm9
	movdqu	112(%r8, %rax), %xmm10
	pxor	%xmm2, %xmm3
	pxor	%xmm2, %xmm4
	pxor	%xmm2, %xmm5
	pxor	%xmm2, %xmm6
	pxor	%xmm2, %xmm7
	pxor	%xmm2, %xmm8
	pxor	%xmm2, %xmm9
	pxor	%xmm2, %xmm10
	movq	$16, %r10
3:	movdqu	(%rdi, %r10), %xmm1
	.byte 0x66,0x0f,0x38,0xdc,0xd9	/* aesenc	%xmm1, %xmm3 */
	.byte 0x66,0x0f,0x38,0xdc,0xe1	/* aesenc	%xmm1, %xmm4 */
	.byte 0x66,0x0f,0x38,0xdc,0xe9	/* aesenc	%xmm1, %xmm5 */
	.byte 0x66,0x0f,0x38,0xdc,0xf1	/* aesenc	%xmm1, %xmm6 */
	.byte 0x66,0x0f,0x38,0xdc,0xf9	/* aesenc	%xmm1, %xmm7 */
	.byte 0x66,0x44,0x0f,0x38,0xdc,0xc1	/* aesenc	%xmm1, %xmm8 */
	.byte 0x66,0x44,0x0f,0x38,0xdc,0xc9	/* aesenc	%xmm1, %xmm9 */
	.byte 0x66,0x44,0x0f,0x38,0xdc,0xd1	/* aesenc	%xmm1, %xmm10 */
	addq	$16, %r10
	cmpq	$192, %r10
	jne	3b
	.byte 0x66,0x41,0x0f,0x38,0xdd,0xde	/* aesenclast %xmm14, %xmm3 */
	.byte 0x66,0x41,0x0f,0x38,0xdd,0xe6	/* aesenclast %xmm14, %xmm4 */
	.byte 0x66,0x41,0x0f,0x38,0xdd,0xee	/* aesenclast %xmm14, %xmm5 */
	.byte 0x66,0x41,0x0f,0x38,0xdd,0xf6	/* aesenclast %xmm14, %xmm7 */
	.byte 0x66,0x41,0x0f,0x38,0xdd,0xfe	/* aesenclast %xmm14, %xmm3 */
	.byte 0x66,0x45,0x0f,0x38,0xdd,0xc6	/* aesenclast %xmm14, %xmm8 */
	.byte 0x66,0x45,0x0f,0x38,0xdd,0xce	/* aesenclast %xmm14, %xmm9 */
	.byte 0x66,0x45,0x0f,0x38,0xdd,0xd6	/* aesenclast %xmm14, %xmm10 */
	movdqu	%xmm3, (%rsi, %rax)
	movdqu	%xmm4, 16(%rsi, %rax)
	movdqu	%xmm5, 32(%rsi, %rax)
	movdqu	%xmm6, 48(%rsi, %rax)
	movdqu	%xmm7, 64(%rsi, %rax)
	movdqu	%xmm8, 80(%rsi, %rax)
	movdqu	%xmm9, 96(%rsi, %rax)
	movdqu	%xmm10, 112(%rsi, %rax)
//	addq	$8*16, %rax
	addq	$128, %rax
	cmpq	%r11, %rax
	jbe	2b
1:	cmpq	%rax, %r9
	je	5f

	movdqu	16(%rdi), %xmm3
	movdqu	32(%rdi), %xmm4
	movdqu	48(%rdi), %xmm5
	movdqu	64(%rdi), %xmm6
	movdqu	80(%rdi), %xmm7
	movdqu	96(%rdi), %xmm8
	movdqu	112(%rdi), %xmm9
	movdqu	128(%rdi), %xmm10
	movdqu	144(%rdi), %xmm11
	movdqu	160(%rdi), %xmm12
	movdqu	176(%rdi), %xmm13

4:	movdqu	(%r8, %rax), %xmm1
	pxor	%xmm2, %xmm1
	.byte 0x66,0x0f,0x38,0xdc,0xcb	/* aesenc	%xmm3, %xmm1 */
	.byte 0x66,0x0f,0x38,0xdc,0xcc	/* aesenc	%xmm4, %xmm1 */
	.byte 0x66,0x0f,0x38,0xdc,0xcd	/* aesenc	%xmm5, %xmm1 */
	.byte 0x66,0x0f,0x38,0xdc,0xce	/* aesenc	%xmm6, %xmm1 */
	.byte 0x66,0x0f,0x38,0xdc,0xcf	/* aesenc	%xmm7, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdc,0xc8	/* aesenc	%xmm8, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdc,0xc9	/* aesenc	%xmm9, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdc,0xca	/* aesenc	%xmm10, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdc,0xcb	/* aesenc	%xmm11, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdc,0xcc	/* aesenc	%xmm12, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdc,0xcd	/* aesenc	%xmm13, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdd,0xce	/* aesenclast %xmm14, %xmm1 */
	movdqu	%xmm1, (%rsi, %rax)
	addq	$16, %rax
	cmpq	%rax, %r9
	jne	4b

5:	xor	%eax, %eax
	ret
	.size intel_aes_encrypt_ecb_192, .-intel_aes_encrypt_ecb_192


/* in %rdi : cx - context
   in %rsi : output - pointer to output buffer
   in %rdx : outputLen - pointer to variable for length of output
             (filled by caller)
   in %rcx : maxOutputLen - length of output buffer
   in %r8  : input - pointer to input buffer
   in %r9  : inputLen - length of input buffer
   on stack: blocksize - AES blocksize (always 16, unused)
*/
	.type intel_aes_decrypt_ecb_192,@function
	.globl intel_aes_decrypt_ecb_192
	.align	16
intel_aes_decrypt_ecb_192:
//	leaq	EXPANDED_KEY_OFFSET(%rdi), %rdi
	leaq	48(%rdi), %rdi

	movdqu	(%rdi), %xmm2
	movdqu	192(%rdi), %xmm14
	xorl	%eax, %eax
//	cmpq	$8*16, %r9
	cmpq	$128, %r9
	jb	1f
//	leaq	-8*16(%r9), %r11
	leaq	-128(%r9), %r11
2:	movdqu	(%r8, %rax), %xmm3
	movdqu	16(%r8, %rax), %xmm4
	movdqu	32(%r8, %rax), %xmm5
	movdqu	48(%r8, %rax), %xmm6
	movdqu	64(%r8, %rax), %xmm7
	movdqu	80(%r8, %rax), %xmm8
	movdqu	96(%r8, %rax), %xmm9
	movdqu	112(%r8, %rax), %xmm10
	pxor	%xmm14, %xmm3
	pxor	%xmm14, %xmm4
	pxor	%xmm14, %xmm5
	pxor	%xmm14, %xmm6
	pxor	%xmm14, %xmm7
	pxor	%xmm14, %xmm8
	pxor	%xmm14, %xmm9
	pxor	%xmm14, %xmm10
	movq	$176, %r10
3:	movdqu	(%rdi, %r10), %xmm1
	.byte 0x66,0x0f,0x38,0xde,0xd9	/* aesdec	%xmm1, %xmm3 */
	.byte 0x66,0x0f,0x38,0xde,0xe1	/* aesdec	%xmm1, %xmm4 */
	.byte 0x66,0x0f,0x38,0xde,0xe9	/* aesdec	%xmm1, %xmm5 */
	.byte 0x66,0x0f,0x38,0xde,0xf1	/* aesdec	%xmm1, %xmm6 */
	.byte 0x66,0x0f,0x38,0xde,0xf9	/* aesdec	%xmm1, %xmm7 */
	.byte 0x66,0x44,0x0f,0x38,0xde,0xc1	/* aesdec	%xmm1, %xmm8 */
	.byte 0x66,0x44,0x0f,0x38,0xde,0xc9	/* aesdec	%xmm1, %xmm9 */
	.byte 0x66,0x44,0x0f,0x38,0xde,0xd1	/* aesdec	%xmm1, %xmm10 */
	subq	$16, %r10
	jne	3b
	.byte 0x66,0x0f,0x38,0xdf,0xda	/* aesdeclast %xmm2, %xmm3 */
	.byte 0x66,0x0f,0x38,0xdf,0xe2	/* aesdeclast %xmm2, %xmm4 */
	.byte 0x66,0x0f,0x38,0xdf,0xea	/* aesdeclast %xmm2, %xmm5 */
	.byte 0x66,0x0f,0x38,0xdf,0xf2	/* aesdeclast %xmm2, %xmm6 */
	.byte 0x66,0x0f,0x38,0xdf,0xfa	/* aesdeclast %xmm2, %xmm7 */
	.byte 0x66,0x44,0x0f,0x38,0xdf,0xc2	/* aesdeclast %xmm2, %xmm8 */
	.byte 0x66,0x44,0x0f,0x38,0xdf,0xca	/* aesdeclast %xmm2, %xmm9 */
	.byte 0x66,0x44,0x0f,0x38,0xdf,0xd2	/* aesdeclast %xmm2, %xmm10 */
	movdqu	%xmm3, (%rsi, %rax)
	movdqu	%xmm4, 16(%rsi, %rax)
	movdqu	%xmm5, 32(%rsi, %rax)
	movdqu	%xmm6, 48(%rsi, %rax)
	movdqu	%xmm7, 64(%rsi, %rax)
	movdqu	%xmm8, 80(%rsi, %rax)
	movdqu	%xmm9, 96(%rsi, %rax)
	movdqu	%xmm10, 112(%rsi, %rax)
//	addq	$8*16, %rax
	addq	$128, %rax
	cmpq	%r11, %rax
	jbe	2b
1:	cmpq	%rax, %r9
	je	5f

	movdqu	16(%rdi), %xmm3
	movdqu	32(%rdi), %xmm4
	movdqu	48(%rdi), %xmm5
	movdqu	64(%rdi), %xmm6
	movdqu	80(%rdi), %xmm7
	movdqu	96(%rdi), %xmm8
	movdqu	112(%rdi), %xmm9
	movdqu	128(%rdi), %xmm10
	movdqu	144(%rdi), %xmm11
	movdqu	160(%rdi), %xmm12
	movdqu	176(%rdi), %xmm13

4:	movdqu	(%r8, %rax), %xmm1
	pxor	%xmm14, %xmm1
	.byte 0x66,0x41,0x0f,0x38,0xde,0xcd	/* aesdec	%xmm13, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xde,0xcc	/* aesdec	%xmm12, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xde,0xcb	/* aesdec	%xmm11, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xde,0xca	/* aesdec	%xmm10, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xde,0xc9	/* aesdec	%xmm9, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xde,0xc8	/* aesdec	%xmm8, %xmm1 */
	.byte 0x66,0x0f,0x38,0xde,0xcf	/* aesdec	%xmm7, %xmm1 */
	.byte 0x66,0x0f,0x38,0xde,0xce	/* aesdec	%xmm6, %xmm1 */
	.byte 0x66,0x0f,0x38,0xde,0xcd	/* aesdec	%xmm5, %xmm1 */
	.byte 0x66,0x0f,0x38,0xde,0xcc	/* aesdec	%xmm4, %xmm1 */
	.byte 0x66,0x0f,0x38,0xde,0xcb	/* aesdec	%xmm3, %xmm1 */
	.byte 0x66,0x0f,0x38,0xdf,0xca	/* aesdeclast %xmm2, %xmm1 */
	movdqu	%xmm1, (%rsi, %rax)
	addq	$16, %rax
	cmpq	%rax, %r9
	jne	4b

5:	xor	%eax, %eax
	ret
	.size intel_aes_decrypt_ecb_192, .-intel_aes_decrypt_ecb_192


/* in %rdi : cx - context
   in %rsi : output - pointer to output buffer
   in %rdx : outputLen - pointer to variable for length of output
             (filled by caller)
   in %rcx : maxOutputLen - length of output buffer
   in %r8  : input - pointer to input buffer
   in %r9  : inputLen - length of input buffer
   on stack: blocksize - AES blocksize (always 16, unused)
*/
	.type intel_aes_encrypt_cbc_192,@function
	.globl intel_aes_encrypt_cbc_192
	.align	16
intel_aes_encrypt_cbc_192:
	testq	%r9, %r9
	je	2f

//	leaq	IV_OFFSET(%rdi), %rdx
//	leaq	EXPANDED_KEY_OFFSET(%rdi), %rdi
	leaq	16(%rdi), %rdx
	leaq	48(%rdi), %rdi

	movdqu	(%rdx), %xmm0
	movdqu	(%rdi), %xmm2
	movdqu	16(%rdi), %xmm3
	movdqu	32(%rdi), %xmm4
	movdqu	48(%rdi), %xmm5
	movdqu	64(%rdi), %xmm6
	movdqu	80(%rdi), %xmm7
	movdqu	96(%rdi), %xmm8
	movdqu	112(%rdi), %xmm9
	movdqu	128(%rdi), %xmm10
	movdqu	144(%rdi), %xmm11
	movdqu	160(%rdi), %xmm12
	movdqu	176(%rdi), %xmm13
	movdqu	192(%rdi), %xmm14

	xorl	%eax, %eax
1:	movdqu	(%r8, %rax), %xmm1
	pxor	%xmm0, %xmm1
	pxor	%xmm2, %xmm1
	.byte 0x66,0x0f,0x38,0xdc,0xcb	/* aesenc	%xmm3, %xmm1 */
	.byte 0x66,0x0f,0x38,0xdc,0xcc	/* aesenc	%xmm4, %xmm1 */
	.byte 0x66,0x0f,0x38,0xdc,0xcd	/* aesenc	%xmm5, %xmm1 */
	.byte 0x66,0x0f,0x38,0xdc,0xce	/* aesenc	%xmm6, %xmm1 */
	.byte 0x66,0x0f,0x38,0xdc,0xcf	/* aesenc	%xmm7, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdc,0xc8	/* aesenc	%xmm8, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdc,0xc9	/* aesenc	%xmm9, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdc,0xca	/* aesenc	%xmm10, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdc,0xcb	/* aesenc	%xmm11, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdc,0xcc	/* aesenc	%xmm12, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdc,0xcd	/* aesenc	%xmm13, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdd,0xce	/* aesenclast %xmm14, %xmm1 */
	movdqu	%xmm1, (%rsi, %rax)
	movdqa	%xmm1, %xmm0
	addq	$16, %rax
	cmpq	%rax, %r9
	jne	1b

	movdqu	%xmm0, (%rdx)

2:	xor	%eax, %eax
	ret
	.size intel_aes_encrypt_cbc_192, .-intel_aes_encrypt_cbc_192


/* in %rdi : cx - context
   in %rsi : output - pointer to output buffer
   in %rdx : outputLen - pointer to variable for length of output
             (filled by caller)
   in %rcx : maxOutputLen - length of output buffer
   in %r8  : input - pointer to input buffer
   in %r9  : inputLen - length of input buffer
   on stack: blocksize - AES blocksize (always 16, unused)
*/
	.type intel_aes_decrypt_cbc_192,@function
	.globl intel_aes_decrypt_cbc_192
	.align	16
intel_aes_decrypt_cbc_192:
//	leaq	IV_OFFSET(%rdi), %rdx
//	leaq	EXPANDED_KEY_OFFSET(%rdi), %rdi
	leaq	16(%rdi), %rdx
	leaq	48(%rdi), %rdi

	movdqu	(%rdx), %xmm0
	movdqu	(%rdi), %xmm2
	movdqu	192(%rdi), %xmm14
	xorl	%eax, %eax
//	cmpq	$8*16, %r9
	cmpq	$128, %r9
	jb	1f
//	leaq	-8*16(%r9), %r11
	leaq	-128(%r9), %r11
2:	movdqu	(%r8, %rax), %xmm3
	movdqu	16(%r8, %rax), %xmm4
	movdqu	32(%r8, %rax), %xmm5
	movdqu	48(%r8, %rax), %xmm6
	movdqu	64(%r8, %rax), %xmm7
	movdqu	80(%r8, %rax), %xmm8
	movdqu	96(%r8, %rax), %xmm9
	movdqu	112(%r8, %rax), %xmm10
	pxor	%xmm14, %xmm3
	pxor	%xmm14, %xmm4
	pxor	%xmm14, %xmm5
	pxor	%xmm14, %xmm6
	pxor	%xmm14, %xmm7
	pxor	%xmm14, %xmm8
	pxor	%xmm14, %xmm9
	pxor	%xmm14, %xmm10
	movq	$176, %r10
3:	movdqu	(%rdi, %r10), %xmm1
	.byte 0x66,0x0f,0x38,0xde,0xd9	/* aesdec	%xmm1, %xmm3 */
	.byte 0x66,0x0f,0x38,0xde,0xe1	/* aesdec	%xmm1, %xmm4 */
	.byte 0x66,0x0f,0x38,0xde,0xe9	/* aesdec	%xmm1, %xmm5 */
	.byte 0x66,0x0f,0x38,0xde,0xf1	/* aesdec	%xmm1, %xmm6 */
	.byte 0x66,0x0f,0x38,0xde,0xf9	/* aesdec	%xmm1, %xmm7 */
	.byte 0x66,0x44,0x0f,0x38,0xde,0xc1	/* aesdec	%xmm1, %xmm8 */
	.byte 0x66,0x44,0x0f,0x38,0xde,0xc9	/* aesdec	%xmm1, %xmm9 */
	.byte 0x66,0x44,0x0f,0x38,0xde,0xd1	/* aesdec	%xmm1, %xmm10 */
	subq	$16, %r10
	jne	3b
	.byte 0x66,0x0f,0x38,0xdf,0xda	/* aesdeclast %xmm2, %xmm3 */
	.byte 0x66,0x0f,0x38,0xdf,0xe2	/* aesdeclast %xmm2, %xmm4 */
	.byte 0x66,0x0f,0x38,0xdf,0xea	/* aesdeclast %xmm2, %xmm5 */
	.byte 0x66,0x0f,0x38,0xdf,0xf2	/* aesdeclast %xmm2, %xmm6 */
	.byte 0x66,0x0f,0x38,0xdf,0xfa	/* aesdeclast %xmm2, %xmm7 */
	.byte 0x66,0x44,0x0f,0x38,0xdf,0xc2	/* aesdeclast %xmm2, %xmm8 */
	.byte 0x66,0x44,0x0f,0x38,0xdf,0xca	/* aesdeclast %xmm2, %xmm9 */
	.byte 0x66,0x44,0x0f,0x38,0xdf,0xd2	/* aesdeclast %xmm2, %xmm10 */
	pxor	%xmm0, %xmm3
	pxor	(%r8, %rax), %xmm4
	pxor	16(%r8, %rax), %xmm5
	pxor	32(%r8, %rax), %xmm6
	pxor	48(%r8, %rax), %xmm7
	pxor	64(%r8, %rax), %xmm8
	pxor	80(%r8, %rax), %xmm9
	pxor	96(%r8, %rax), %xmm10
	movdqu	112(%r8, %rax), %xmm0
	movdqu	%xmm3, (%rsi, %rax)
	movdqu	%xmm4, 16(%rsi, %rax)
	movdqu	%xmm5, 32(%rsi, %rax)
	movdqu	%xmm6, 48(%rsi, %rax)
	movdqu	%xmm7, 64(%rsi, %rax)
	movdqu	%xmm8, 80(%rsi, %rax)
	movdqu	%xmm9, 96(%rsi, %rax)
	movdqu	%xmm10, 112(%rsi, %rax)
//	addq	$8*16, %rax
	addq	$128, %rax
	cmpq	%r11, %rax
	jbe	2b
1:	cmpq	%rax, %r9
	je	5f

	movdqu	16(%rdi), %xmm3
	movdqu	32(%rdi), %xmm4
	movdqu	48(%rdi), %xmm5
	movdqu	64(%rdi), %xmm6
	movdqu	80(%rdi), %xmm7
	movdqu	96(%rdi), %xmm8
	movdqu	112(%rdi), %xmm9
	movdqu	128(%rdi), %xmm10
	movdqu	144(%rdi), %xmm11
	movdqu	160(%rdi), %xmm12
	movdqu	176(%rdi), %xmm13

4:	movdqu	(%r8, %rax), %xmm1
	movdqa	%xmm1, %xmm15
	pxor	%xmm14, %xmm1
	.byte 0x66,0x41,0x0f,0x38,0xde,0xcd	/* aesdec	%xmm13, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xde,0xcc	/* aesdec	%xmm12, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xde,0xcb	/* aesdec	%xmm11, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xde,0xca	/* aesdec	%xmm10, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xde,0xc9	/* aesdec	%xmm9, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xde,0xc8	/* aesdec	%xmm8, %xmm1 */
	.byte 0x66,0x0f,0x38,0xde,0xcf	/* aesdec	%xmm7, %xmm1 */
	.byte 0x66,0x0f,0x38,0xde,0xce	/* aesdec	%xmm6, %xmm1 */
	.byte 0x66,0x0f,0x38,0xde,0xcd	/* aesdec	%xmm5, %xmm1 */
	.byte 0x66,0x0f,0x38,0xde,0xcc	/* aesdec	%xmm4, %xmm1 */
	.byte 0x66,0x0f,0x38,0xde,0xcb	/* aesdec	%xmm3, %xmm1 */
	.byte 0x66,0x0f,0x38,0xdf,0xca	/* aesdeclast %xmm2, %xmm1 */
	pxor	%xmm0, %xmm1
	movdqu	%xmm1, (%rsi, %rax)
	movdqa	%xmm15, %xmm0
	addq	$16, %rax
	cmpq	%rax, %r9
	jne	4b

5:	movdqu	%xmm0, (%rdx)

	xor	%eax, %eax
	ret
	.size intel_aes_decrypt_cbc_192, .-intel_aes_decrypt_cbc_192


/* in %rdi : the key
   in %rsi : buffer for expanded key
*/
	.type intel_aes_encrypt_init_256,@function
	.globl intel_aes_encrypt_init_256
	.align	16
intel_aes_encrypt_init_256:
	movdqu	(%rdi), %xmm1
	movdqu	16(%rdi), %xmm3
	movdqu	%xmm1, (%rsi)
	movdqu	%xmm3, 16(%rsi)
	leaq	32(%rsi), %rsi
	xor	%eax, %eax

	.byte 0x66,0x0f,0x3a,0xdf,0xd3,0x01	/* aeskeygenassist $0x01, %xmm3, %xmm2 */
	call key_expansion256
	.byte 0x66,0x0f,0x3a,0xdf,0xd3,0x02	/* aeskeygenassist $0x02, %xmm3, %xmm2 */
	call key_expansion256
	.byte 0x66,0x0f,0x3a,0xdf,0xd3,0x04	/* aeskeygenassist $0x04, %xmm3, %xmm2 */
	call key_expansion256
	.byte 0x66,0x0f,0x3a,0xdf,0xd3,0x08	/* aeskeygenassist $0x08, %xmm3, %xmm2 */
	call key_expansion256
	.byte 0x66,0x0f,0x3a,0xdf,0xd3,0x10	/* aeskeygenassist $0x10, %xmm3, %xmm2 */
	call key_expansion256
	.byte 0x66,0x0f,0x3a,0xdf,0xd3,0x20	/* aeskeygenassist $0x20, %xmm3, %xmm2 */
	call key_expansion256
	.byte 0x66,0x0f,0x3a,0xdf,0xd3,0x40	/* aeskeygenassist $0x40, %xmm3, %xmm2 */
	call key_expansion256

	ret
	.size intel_aes_encrypt_init_256, .-intel_aes_encrypt_init_256


/* in %rdi : the key
   in %rsi : buffer for expanded key
*/
	.type intel_aes_decrypt_init_256,@function
	.globl intel_aes_decrypt_init_256
	.align	16
intel_aes_decrypt_init_256:
	movdqu	(%rdi), %xmm1
	movdqu	16(%rdi), %xmm3
	movdqu	%xmm1, (%rsi)
	.byte 0x66,0x0f,0x38,0xdb,0xe3	/* aesimc	%xmm3, %xmm4 */
	movdqu	%xmm4, 16(%rsi)
	leaq	32(%rsi), %rsi
	xor	%eax, %eax

	.byte 0x66,0x0f,0x3a,0xdf,0xd3,0x01	/* aeskeygenassist $0x01, %xmm3, %xmm2 */
	call key_expansion256
	.byte 0x66,0x0f,0x38,0xdb,0xe1	/* aesimc	%xmm1, %xmm4 */
	.byte 0x66,0x0f,0x38,0xdb,0xeb	/* aesimc	%xmm3, %xmm5 */
	movdqu	%xmm4, -32(%rsi)
	movdqu	%xmm5, -16(%rsi)
	.byte 0x66,0x0f,0x3a,0xdf,0xd3,0x02	/* aeskeygenassist $0x02, %xmm3, %xmm2 */
	call key_expansion256
	.byte 0x66,0x0f,0x38,0xdb,0xe1	/* aesimc	%xmm1, %xmm4 */
	.byte 0x66,0x0f,0x38,0xdb,0xeb	/* aesimc	%xmm3, %xmm5 */
	movdqu	%xmm4, -32(%rsi)
	movdqu	%xmm5, -16(%rsi)
	.byte 0x66,0x0f,0x3a,0xdf,0xd3,0x04	/* aeskeygenassist $0x04, %xmm3, %xmm2 */
	call key_expansion256
	.byte 0x66,0x0f,0x38,0xdb,0xe1	/* aesimc	%xmm1, %xmm4 */
	.byte 0x66,0x0f,0x38,0xdb,0xeb	/* aesimc	%xmm3, %xmm5 */
	movdqu	%xmm4, -32(%rsi)
	movdqu	%xmm5, -16(%rsi)
	.byte 0x66,0x0f,0x3a,0xdf,0xd3,0x08	/* aeskeygenassist $0x08, %xmm3, %xmm2 */
	call key_expansion256
	.byte 0x66,0x0f,0x38,0xdb,0xe1	/* aesimc	%xmm1, %xmm4 */
	.byte 0x66,0x0f,0x38,0xdb,0xeb	/* aesimc	%xmm3, %xmm5 */
	movdqu	%xmm4, -32(%rsi)
	movdqu	%xmm5, -16(%rsi)
	.byte 0x66,0x0f,0x3a,0xdf,0xd3,0x10	/* aeskeygenassist $0x10, %xmm3, %xmm2 */
	call key_expansion256
	.byte 0x66,0x0f,0x38,0xdb,0xe1	/* aesimc	%xmm1, %xmm4 */
	.byte 0x66,0x0f,0x38,0xdb,0xeb	/* aesimc	%xmm3, %xmm5 */
	movdqu	%xmm4, -32(%rsi)
	movdqu	%xmm5, -16(%rsi)
	.byte 0x66,0x0f,0x3a,0xdf,0xd3,0x20	/* aeskeygenassist $0x20, %xmm3, %xmm2 */
	call key_expansion256
	.byte 0x66,0x0f,0x38,0xdb,0xe1	/* aesimc	%xmm1, %xmm4 */
	.byte 0x66,0x0f,0x38,0xdb,0xeb	/* aesimc	%xmm3, %xmm5 */
	movdqu	%xmm4, -32(%rsi)
	movdqu	%xmm5, -16(%rsi)
	.byte 0x66,0x0f,0x3a,0xdf,0xd3,0x40	/* aeskeygenassist $0x40, %xmm3, %xmm2 */
	call key_expansion256

	ret
	.size intel_aes_decrypt_init_256, .-intel_aes_decrypt_init_256


	.type key_expansion256,@function
	.align	16
key_expansion256:
	movd	%eax, %xmm6
	pshufd	$0xff, %xmm2, %xmm2
	shufps	$0x10, %xmm1, %xmm6
	pxor	%xmm6, %xmm1
	shufps	$0x8c, %xmm1, %xmm6
	pxor	%xmm2, %xmm1
	pxor	%xmm6, %xmm1
	movdqu	%xmm1, (%rsi)
	addq	$16, %rsi
	.byte 0x66,0x0f,0x3a,0xdf,0xe1,0x00	/* aeskeygenassist $0, %xmm1, %xmm4 */

	pshufd	$0xaa, %xmm4, %xmm4
	shufps	$0x10, %xmm3, %xmm6
	pxor	%xmm6, %xmm3
	shufps	$0x8c, %xmm3, %xmm6
	pxor	%xmm4, %xmm3
	pxor	%xmm6, %xmm3
	movdqu	%xmm3, (%rsi)
	addq	$16, %rsi
	ret
	.size key_expansion256, .-key_expansion256


/* in %rdi : cx - context
   in %rsi : output - pointer to output buffer
   in %rdx : outputLen - pointer to variable for length of output
             (filled by caller)
   in %rcx : maxOutputLen - length of output buffer
   in %r8  : input - pointer to input buffer
   in %r9  : inputLen - length of input buffer
   on stack: blocksize - AES blocksize (always 16, unused)
*/
	.type intel_aes_encrypt_ecb_256,@function
	.globl intel_aes_encrypt_ecb_256
	.align	16
intel_aes_encrypt_ecb_256:
//	leaq	EXPANDED_KEY_OFFSET(%rdi), %rdi
	leaq	48(%rdi), %rdi

	movdqu	(%rdi), %xmm2
	movdqu	224(%rdi), %xmm15
	xorl	%eax, %eax
//	cmpq	$8*16, %r9
	cmpq	$128, %r9
	jb	1f
//	leaq	-8*16(%r9), %r11
	leaq	-128(%r9), %r11
2:	movdqu	(%r8, %rax), %xmm3
	movdqu	16(%r8, %rax), %xmm4
	movdqu	32(%r8, %rax), %xmm5
	movdqu	48(%r8, %rax), %xmm6
	movdqu	64(%r8, %rax), %xmm7
	movdqu	80(%r8, %rax), %xmm8
	movdqu	96(%r8, %rax), %xmm9
	movdqu	112(%r8, %rax), %xmm10
	pxor	%xmm2, %xmm3
	pxor	%xmm2, %xmm4
	pxor	%xmm2, %xmm5
	pxor	%xmm2, %xmm6
	pxor	%xmm2, %xmm7
	pxor	%xmm2, %xmm8
	pxor	%xmm2, %xmm9
	pxor	%xmm2, %xmm10
	movq	$16, %r10
3:	movdqu	(%rdi, %r10), %xmm1
	.byte 0x66,0x0f,0x38,0xdc,0xd9	/* aesenc	%xmm1, %xmm3 */
	.byte 0x66,0x0f,0x38,0xdc,0xe1	/* aesenc	%xmm1, %xmm4 */
	.byte 0x66,0x0f,0x38,0xdc,0xe9	/* aesenc	%xmm1, %xmm5 */
	.byte 0x66,0x0f,0x38,0xdc,0xf1	/* aesenc	%xmm1, %xmm6 */
	.byte 0x66,0x0f,0x38,0xdc,0xf9	/* aesenc	%xmm1, %xmm7 */
	.byte 0x66,0x44,0x0f,0x38,0xdc,0xc1	/* aesenc	%xmm1, %xmm8 */
	.byte 0x66,0x44,0x0f,0x38,0xdc,0xc9	/* aesenc	%xmm1, %xmm9 */
	.byte 0x66,0x44,0x0f,0x38,0xdc,0xd1	/* aesenc	%xmm1, %xmm10 */
	addq	$16, %r10
	cmpq	$224, %r10
	jne	3b
	.byte 0x66,0x41,0x0f,0x38,0xdd,0xdf	/* aesenclast %xmm15, %xmm3 */
	.byte 0x66,0x41,0x0f,0x38,0xdd,0xe7	/* aesenclast %xmm15, %xmm4 */
	.byte 0x66,0x41,0x0f,0x38,0xdd,0xef	/* aesenclast %xmm15, %xmm5 */
	.byte 0x66,0x41,0x0f,0x38,0xdd,0xf7	/* aesenclast %xmm15, %xmm6 */
	.byte 0x66,0x41,0x0f,0x38,0xdd,0xff	/* aesenclast %xmm15, %xmm7 */
	.byte 0x66,0x45,0x0f,0x38,0xdd,0xc7	/* aesenclast %xmm15, %xmm8 */
	.byte 0x66,0x45,0x0f,0x38,0xdd,0xcf	/* aesenclast %xmm15, %xmm9 */
	.byte 0x66,0x45,0x0f,0x38,0xdd,0xd7	/* aesenclast %xmm15, %xmm10 */
	movdqu	%xmm3, (%rsi, %rax)
	movdqu	%xmm4, 16(%rsi, %rax)
	movdqu	%xmm5, 32(%rsi, %rax)
	movdqu	%xmm6, 48(%rsi, %rax)
	movdqu	%xmm7, 64(%rsi, %rax)
	movdqu	%xmm8, 80(%rsi, %rax)
	movdqu	%xmm9, 96(%rsi, %rax)
	movdqu	%xmm10, 112(%rsi, %rax)
//	addq	$8*16, %rax
	addq	$128, %rax
	cmpq	%r11, %rax
	jbe	2b
1:	cmpq	%rax, %r9
	je	5f

	movdqu	16(%rdi), %xmm2
	movdqu	32(%rdi), %xmm3
	movdqu	48(%rdi), %xmm4
	movdqu	64(%rdi), %xmm5
	movdqu	80(%rdi), %xmm6
	movdqu	96(%rdi), %xmm7
	movdqu	112(%rdi), %xmm8
	movdqu	128(%rdi), %xmm9
	movdqu	144(%rdi), %xmm10
	movdqu	160(%rdi), %xmm11
	movdqu	176(%rdi), %xmm12
	movdqu	192(%rdi), %xmm13
	movdqu	208(%rdi), %xmm14

4:	movdqu	(%r8, %rax), %xmm1
	pxor	(%rdi), %xmm1
	.byte 0x66,0x0f,0x38,0xdc,0xca	/* aesenc	%xmm2, %xmm1 */
	.byte 0x66,0x0f,0x38,0xdc,0xcb	/* aesenc	%xmm3, %xmm1 */
	.byte 0x66,0x0f,0x38,0xdc,0xcc	/* aesenc	%xmm4, %xmm1 */
	.byte 0x66,0x0f,0x38,0xdc,0xcd	/* aesenc	%xmm5, %xmm1 */
	.byte 0x66,0x0f,0x38,0xdc,0xce	/* aesenc	%xmm6, %xmm1 */
	.byte 0x66,0x0f,0x38,0xdc,0xcf	/* aesenc	%xmm7, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdc,0xc8	/* aesenc	%xmm8, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdc,0xc9	/* aesenc	%xmm9, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdc,0xca	/* aesenc	%xmm10, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdc,0xcb	/* aesenc	%xmm11, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdc,0xcc	/* aesenc	%xmm12, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdc,0xcd	/* aesenc	%xmm13, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdc,0xce	/* aesenc	%xmm14, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdd,0xcf	/* aesenclast %xmm15, %xmm1 */
	movdqu	%xmm1, (%rsi, %rax)
	addq	$16, %rax
	cmpq	%rax, %r9
	jne	4b

5:	xor	%eax, %eax
	ret
	.size intel_aes_encrypt_ecb_256, .-intel_aes_encrypt_ecb_256


/* in %rdi : cx - context
   in %rsi : output - pointer to output buffer
   in %rdx : outputLen - pointer to variable for length of output
             (filled by caller)
   in %rcx : maxOutputLen - length of output buffer
   in %r8  : input - pointer to input buffer
   in %r9  : inputLen - length of input buffer
   on stack: blocksize - AES blocksize (always 16, unused)
*/
	.type intel_aes_decrypt_ecb_256,@function
	.globl intel_aes_decrypt_ecb_256
	.align	16
intel_aes_decrypt_ecb_256:
//	leaq	EXPANDED_KEY_OFFSET(%rdi), %rdi
	leaq	48(%rdi), %rdi

	movdqu	(%rdi), %xmm2
	movdqu	224(%rdi), %xmm15
	xorl	%eax, %eax
//	cmpq	$8*16, %r9
	cmpq	$128, %r9
	jb	1f
//	leaq	-8*16(%r9), %r11
	leaq	-128(%r9), %r11
2:	movdqu	(%r8, %rax), %xmm3
	movdqu	16(%r8, %rax), %xmm4
	movdqu	32(%r8, %rax), %xmm5
	movdqu	48(%r8, %rax), %xmm6
	movdqu	64(%r8, %rax), %xmm7
	movdqu	80(%r8, %rax), %xmm8
	movdqu	96(%r8, %rax), %xmm9
	movdqu	112(%r8, %rax), %xmm10
	pxor	%xmm15, %xmm3
	pxor	%xmm15, %xmm4
	pxor	%xmm15, %xmm5
	pxor	%xmm15, %xmm6
	pxor	%xmm15, %xmm7
	pxor	%xmm15, %xmm8
	pxor	%xmm15, %xmm9
	pxor	%xmm15, %xmm10
	movq	$208, %r10
3:	movdqu	(%rdi, %r10), %xmm1
	.byte 0x66,0x0f,0x38,0xde,0xd9	/* aesdec	%xmm1, %xmm3 */
	.byte 0x66,0x0f,0x38,0xde,0xe1	/* aesdec	%xmm1, %xmm4 */
	.byte 0x66,0x0f,0x38,0xde,0xe9	/* aesdec	%xmm1, %xmm5 */
	.byte 0x66,0x0f,0x38,0xde,0xf1	/* aesdec	%xmm1, %xmm6 */
	.byte 0x66,0x0f,0x38,0xde,0xf9	/* aesdec	%xmm1, %xmm7 */
	.byte 0x66,0x44,0x0f,0x38,0xde,0xc1	/* aesdec	%xmm1, %xmm8 */
	.byte 0x66,0x44,0x0f,0x38,0xde,0xc9	/* aesdec	%xmm1, %xmm9 */
	.byte 0x66,0x44,0x0f,0x38,0xde,0xd1	/* aesdec	%xmm1, %xmm10 */
	subq	$16, %r10
	jne	3b
	.byte 0x66,0x0f,0x38,0xdf,0xda	/* aesdeclast %xmm2, %xmm3 */
	.byte 0x66,0x0f,0x38,0xdf,0xe2	/* aesdeclast %xmm2, %xmm4 */
	.byte 0x66,0x0f,0x38,0xdf,0xea	/* aesdeclast %xmm2, %xmm5 */
	.byte 0x66,0x0f,0x38,0xdf,0xf2	/* aesdeclast %xmm2, %xmm6 */
	.byte 0x66,0x0f,0x38,0xdf,0xfa	/* aesdeclast %xmm2, %xmm7 */
	.byte 0x66,0x44,0x0f,0x38,0xdf,0xc2	/* aesdeclast %xmm2, %xmm8 */
	.byte 0x66,0x44,0x0f,0x38,0xdf,0xca	/* aesdeclast %xmm2, %xmm9 */
	.byte 0x66,0x44,0x0f,0x38,0xdf,0xd2	/* aesdeclast %xmm2, %xmm10 */
	movdqu	%xmm3, (%rsi, %rax)
	movdqu	%xmm4, 16(%rsi, %rax)
	movdqu	%xmm5, 32(%rsi, %rax)
	movdqu	%xmm6, 48(%rsi, %rax)
	movdqu	%xmm7, 64(%rsi, %rax)
	movdqu	%xmm8, 80(%rsi, %rax)
	movdqu	%xmm9, 96(%rsi, %rax)
	movdqu	%xmm10, 112(%rsi, %rax)
//	addq	$8*16, %rax
	addq	$128, %rax
	cmpq	%r11, %rax
	jbe	2b
1:	cmpq	%rax, %r9
	je	5f

	movdqu	16(%rdi), %xmm2
	movdqu	32(%rdi), %xmm3
	movdqu	48(%rdi), %xmm4
	movdqu	64(%rdi), %xmm5
	movdqu	80(%rdi), %xmm6
	movdqu	96(%rdi), %xmm7
	movdqu	112(%rdi), %xmm8
	movdqu	128(%rdi), %xmm9
	movdqu	144(%rdi), %xmm10
	movdqu	160(%rdi), %xmm11
	movdqu	176(%rdi), %xmm12
	movdqu	192(%rdi), %xmm13
	movdqu	208(%rdi), %xmm14

4:	movdqu	(%r8, %rax), %xmm1
	pxor	%xmm15, %xmm1
	.byte 0x66,0x41,0x0f,0x38,0xde,0xce	/* aesdec	%xmm14, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xde,0xcd	/* aesdec	%xmm13, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xde,0xcc	/* aesdec	%xmm12, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xde,0xcb	/* aesdec	%xmm11, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xde,0xca	/* aesdec	%xmm10, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xde,0xc9	/* aesdec	%xmm9, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xde,0xc8	/* aesdec	%xmm8, %xmm1 */
	.byte 0x66,0x0f,0x38,0xde,0xcf	/* aesdec	%xmm7, %xmm1 */
	.byte 0x66,0x0f,0x38,0xde,0xce	/* aesdec	%xmm6, %xmm1 */
	.byte 0x66,0x0f,0x38,0xde,0xcd	/* aesdec	%xmm5, %xmm1 */
	.byte 0x66,0x0f,0x38,0xde,0xcc	/* aesdec	%xmm4, %xmm1 */
	.byte 0x66,0x0f,0x38,0xde,0xcb	/* aesdec	%xmm3, %xmm1 */
	.byte 0x66,0x0f,0x38,0xde,0xca	/* aesdec	%xmm2, %xmm1 */
	.byte 0x66,0x0f,0x38,0xdf,0x0f	/* aesdeclast (%rdi), %xmm1 */
	movdqu	%xmm1, (%rsi, %rax)
	addq	$16, %rax
	cmpq	%rax, %r9
	jne	4b

5:	xor	%eax, %eax
	ret
	.size intel_aes_decrypt_ecb_256, .-intel_aes_decrypt_ecb_256


/* in %rdi : cx - context
   in %rsi : output - pointer to output buffer
   in %rdx : outputLen - pointer to variable for length of output
             (filled by caller)
   in %rcx : maxOutputLen - length of output buffer
   in %r8  : input - pointer to input buffer
   in %r9  : inputLen - length of input buffer
   on stack: blocksize - AES blocksize (always 16, unused)
*/
	.type intel_aes_encrypt_cbc_256,@function
	.globl intel_aes_encrypt_cbc_256
	.align	16
intel_aes_encrypt_cbc_256:
	testq	%r9, %r9
	je	2f

//	leaq	IV_OFFSET(%rdi), %rdx
//	leaq	EXPANDED_KEY_OFFSET(%rdi), %rdi
	leaq	16(%rdi), %rdx
	leaq	48(%rdi), %rdi

	movdqu	(%rdx), %xmm0
	movdqu	16(%rdi), %xmm2
	movdqu	32(%rdi), %xmm3
	movdqu	48(%rdi), %xmm4
	movdqu	64(%rdi), %xmm5
	movdqu	80(%rdi), %xmm6
	movdqu	96(%rdi), %xmm7
	movdqu	112(%rdi), %xmm8
	movdqu	128(%rdi), %xmm9
	movdqu	144(%rdi), %xmm10
	movdqu	160(%rdi), %xmm11
	movdqu	176(%rdi), %xmm12
	movdqu	192(%rdi), %xmm13
	movdqu	208(%rdi), %xmm14
	movdqu	224(%rdi), %xmm15

	xorl	%eax, %eax
1:	movdqu	(%r8, %rax), %xmm1
	pxor	%xmm0, %xmm1
	pxor	(%rdi), %xmm1
	.byte 0x66,0x0f,0x38,0xdc,0xca	/* aesenc	%xmm2, %xmm1 */
	.byte 0x66,0x0f,0x38,0xdc,0xcb	/* aesenc	%xmm3, %xmm1 */
	.byte 0x66,0x0f,0x38,0xdc,0xcc	/* aesenc	%xmm4, %xmm1 */
	.byte 0x66,0x0f,0x38,0xdc,0xcd	/* aesenc	%xmm5, %xmm1 */
	.byte 0x66,0x0f,0x38,0xdc,0xce	/* aesenc	%xmm6, %xmm1 */
	.byte 0x66,0x0f,0x38,0xdc,0xcf	/* aesenc	%xmm7, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdc,0xc8	/* aesenc	%xmm8, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdc,0xc9	/* aesenc	%xmm9, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdc,0xca	/* aesenc	%xmm10, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdc,0xcb	/* aesenc	%xmm11, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdc,0xcc	/* aesenc	%xmm12, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdc,0xcd	/* aesenc	%xmm13, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdc,0xce	/* aesenc	%xmm14, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xdd,0xcf	/* aesenclast %xmm15, %xmm1 */
	movdqu	%xmm1, (%rsi, %rax)
	movdqa	%xmm1, %xmm0
	addq	$16, %rax
	cmpq	%rax, %r9
	jne	1b

	movdqu	%xmm0, (%rdx)

2:	xor	%eax, %eax
	ret
	.size intel_aes_encrypt_cbc_256, .-intel_aes_encrypt_cbc_256


/* in %rdi : cx - context
   in %rsi : output - pointer to output buffer
   in %rdx : outputLen - pointer to variable for length of output
             (filled by caller)
   in %rcx : maxOutputLen - length of output buffer
   in %r8  : input - pointer to input buffer
   in %r9  : inputLen - length of input buffer
   on stack: blocksize - AES blocksize (always 16, unused)
*/
	.type intel_aes_decrypt_cbc_256,@function
	.globl intel_aes_decrypt_cbc_256
	.align	16
intel_aes_decrypt_cbc_256:
//	leaq	IV_OFFSET(%rdi), %rdx
//	leaq	EXPANDED_KEY_OFFSET(%rdi), %rdi
	leaq	16(%rdi), %rdx
	leaq	48(%rdi), %rdi

	movdqu	(%rdx), %xmm0
	movdqu	(%rdi), %xmm2
	movdqu	224(%rdi), %xmm15
	xorl	%eax, %eax
//	cmpq	$8*16, %r9
	cmpq	$128, %r9
	jb	1f
//	leaq	-8*16(%r9), %r11
	leaq	-128(%r9), %r11
2:	movdqu  (%r8, %rax), %xmm3
	movdqu	16(%r8, %rax), %xmm4
	movdqu	32(%r8, %rax), %xmm5
	movdqu	48(%r8, %rax), %xmm6
	movdqu	64(%r8, %rax), %xmm7
	movdqu	80(%r8, %rax), %xmm8
	movdqu	96(%r8, %rax), %xmm9
	movdqu	112(%r8, %rax), %xmm10
	pxor	%xmm15, %xmm3
	pxor	%xmm15, %xmm4
	pxor	%xmm15, %xmm5
	pxor	%xmm15, %xmm6
	pxor	%xmm15, %xmm7
	pxor	%xmm15, %xmm8
	pxor	%xmm15, %xmm9
	pxor	%xmm15, %xmm10
	movq	$208, %r10
3:	movdqu	(%rdi, %r10), %xmm1
	.byte 0x66,0x0f,0x38,0xde,0xd9	/* aesdec	%xmm1, %xmm3 */
	.byte 0x66,0x0f,0x38,0xde,0xe1	/* aesdec	%xmm1, %xmm4 */
	.byte 0x66,0x0f,0x38,0xde,0xe9	/* aesdec	%xmm1, %xmm5 */
	.byte 0x66,0x0f,0x38,0xde,0xf1	/* aesdec	%xmm1, %xmm6 */
	.byte 0x66,0x0f,0x38,0xde,0xf9	/* aesdec	%xmm1, %xmm7 */
	.byte 0x66,0x44,0x0f,0x38,0xde,0xc1	/* aesdec	%xmm1, %xmm8 */
	.byte 0x66,0x44,0x0f,0x38,0xde,0xc9	/* aesdec	%xmm1, %xmm9 */
	.byte 0x66,0x44,0x0f,0x38,0xde,0xd1	/* aesdec	%xmm1, %xmm10 */
	subq	$16, %r10
	jne	3b
	.byte 0x66,0x0f,0x38,0xdf,0xda	/* aesdeclast %xmm2, %xmm3 */
	.byte 0x66,0x0f,0x38,0xdf,0xe2	/* aesdeclast %xmm2, %xmm4 */
	.byte 0x66,0x0f,0x38,0xdf,0xea	/* aesdeclast %xmm2, %xmm5 */
	.byte 0x66,0x0f,0x38,0xdf,0xf2	/* aesdeclast %xmm2, %xmm6 */
	.byte 0x66,0x0f,0x38,0xdf,0xfa	/* aesdeclast %xmm2, %xmm7 */
	.byte 0x66,0x44,0x0f,0x38,0xdf,0xc2	/* aesdeclast %xmm2, %xmm8 */
	.byte 0x66,0x44,0x0f,0x38,0xdf,0xca	/* aesdeclast %xmm2, %xmm9 */
	.byte 0x66,0x44,0x0f,0x38,0xdf,0xd2	/* aesdeclast %xmm2, %xmm10 */
	pxor	%xmm0, %xmm3
	pxor	(%r8, %rax), %xmm4
	pxor	16(%r8, %rax), %xmm5
	pxor	32(%r8, %rax), %xmm6
	pxor	48(%r8, %rax), %xmm7
	pxor	64(%r8, %rax), %xmm8
	pxor	80(%r8, %rax), %xmm9
	pxor	96(%r8, %rax), %xmm10
	movdqu	112(%r8, %rax), %xmm0
	movdqu	%xmm3, (%rsi, %rax)
	movdqu	%xmm4, 16(%rsi, %rax)
	movdqu	%xmm5, 32(%rsi, %rax)
	movdqu	%xmm6, 48(%rsi, %rax)
	movdqu	%xmm7, 64(%rsi, %rax)
	movdqu	%xmm8, 80(%rsi, %rax)
	movdqu	%xmm9, 96(%rsi, %rax)
	movdqu	%xmm10, 112(%rsi, %rax)
//	addq	$8*16, %rax
	addq	$128, %rax
	cmpq	%r11, %rax
	jbe	2b
1:	cmpq	%rax, %r9
	je	5f

	movdqu	16(%rdi), %xmm2
	movdqu	32(%rdi), %xmm3
	movdqu	48(%rdi), %xmm4
	movdqu	64(%rdi), %xmm5
	movdqu	80(%rdi), %xmm6
	movdqu	96(%rdi), %xmm7
	movdqu	112(%rdi), %xmm8
	movdqu	128(%rdi), %xmm9
	movdqu	144(%rdi), %xmm10
	movdqu	160(%rdi), %xmm11
	movdqu	176(%rdi), %xmm12
	movdqu	192(%rdi), %xmm13
	movdqu	208(%rdi), %xmm14

4:	movdqu	(%r8, %rax), %xmm1
	pxor	%xmm15, %xmm1
	.byte 0x66,0x41,0x0f,0x38,0xde,0xce	/* aesdec	%xmm14, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xde,0xcd	/* aesdec	%xmm13, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xde,0xcc	/* aesdec	%xmm12, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xde,0xcb	/* aesdec	%xmm11, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xde,0xca	/* aesdec	%xmm10, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xde,0xc9	/* aesdec	%xmm9, %xmm1 */
	.byte 0x66,0x41,0x0f,0x38,0xde,0xc8	/* aesdec	%xmm8, %xmm1 */
	.byte 0x66,0x0f,0x38,0xde,0xcf	/* aesdec	%xmm7, %xmm1 */
	.byte 0x66,0x0f,0x38,0xde,0xce	/* aesdec	%xmm6, %xmm1 */
	.byte 0x66,0x0f,0x38,0xde,0xcd	/* aesdec	%xmm5, %xmm1 */
	.byte 0x66,0x0f,0x38,0xde,0xcc	/* aesdec	%xmm4, %xmm1 */
	.byte 0x66,0x0f,0x38,0xde,0xcb	/* aesdec	%xmm3, %xmm1 */
	.byte 0x66,0x0f,0x38,0xde,0xca	/* aesdec	%xmm2, %xmm1 */
	.byte 0x66,0x0f,0x38,0xdf,0x0f	/* aesdeclast (%rdi), %xmm1 */
	pxor	%xmm0, %xmm1
	movdqu	%xmm1, (%rsi, %rax)
	movdqu	(%r8, %rax), %xmm0
	addq	$16, %rax
	cmpq	%rax, %r9
	jne	4b

5:	movdqu	%xmm0, (%rdx)

	xor	%eax, %eax
	ret
	.size intel_aes_decrypt_cbc_256, .-intel_aes_decrypt_cbc_256
