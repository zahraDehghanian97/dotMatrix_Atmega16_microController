
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _cc=R5
	.DEF _y=R4
	.DEF _U=R7
	.DEF _P=R6
	.DEF _k=R8
	.DEF _k_msb=R9
	.DEF _i=R10
	.DEF _i_msb=R11
	.DEF _vl=R12
	.DEF _vl_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_FontLookup:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x3,0x3
	.DB  0xFF,0xFF,0x3,0x3,0xF8,0xFC,0x7,0x7
	.DB  0xFC,0xF8,0x0,0x38,0x44,0x82,0x1,0x8C
	.DB  0x9E,0x92,0x92,0xF2,0x60,0x0,0xFE,0xFE
	.DB  0x8,0x1C,0x36,0x62,0x82,0xC6,0x6C,0x38
	.DB  0x1C,0xE,0x6,0x0,0x8,0x8,0x8,0x0
	.DB  0xFF,0xFF,0x0,0xF8,0x24,0x22,0x24,0xF8
	.DB  0x0,0xFA,0x0,0xFC,0x8,0x6,0x0,0xFB
	.DB  0x1,0xFB,0x87,0x6B,0x6B,0xA7,0xFF,0x1
	.DB  0xFF,0xFF,0x0,0x8,0x8,0x0,0xFF,0x81
	.DB  0xAD,0xAD,0xD3,0xFF,0x81,0xFF,0xC3,0xBD
	.DB  0xAD,0xCB,0xFF,0x0,0x2,0x2,0x7E,0x2
	.DB  0x2,0x0,0x1E,0x20,0x40,0x20,0x1E,0x0
	.DB  0x8,0x8,0x8,0x0,0xF8,0xFC,0x7,0x7
	.DB  0xFC,0xF8,0x21,0x41,0x45,0x4B,0x31,0x0
	.DB  0x18,0x14,0x12,0x7F,0x10,0x0,0x27,0x45
	.DB  0x45,0x45,0x39,0x0,0x3C,0x4A,0x49,0x49
	.DB  0x30,0x0,0x1,0x71,0x9,0x5,0x3,0x0
	.DB  0x36,0x49,0x49,0x49,0x36,0x0,0x6,0x49
	.DB  0x49,0x29,0x1E,0x0,0x0,0x36,0x36,0x0
	.DB  0x0,0x0,0x0,0x56,0x36,0x0,0x0,0x0
	.DB  0x8,0x14,0x22,0x41,0x0,0x0,0x14,0x14
	.DB  0x14,0x14,0x14,0x0,0x0,0x41,0x22,0x14
	.DB  0x8,0x0,0x2,0x1,0x51,0x9,0x6,0x0
	.DB  0x32,0x49,0x59,0x51,0x3E,0x0,0x7E,0x11
	.DB  0x11,0x11,0x7E,0x0,0x7F,0x49,0x49,0x49
	.DB  0x36,0x0,0x3E,0x41,0x41,0x41,0x22,0x0
	.DB  0x7F,0x41,0x41,0x22,0x1C,0x0,0x7F,0x49
	.DB  0x49,0x49,0x41,0x0,0x7F,0x9,0x9,0x9
	.DB  0x1,0x0,0x3E,0x41,0x49,0x49,0x7A,0x0
	.DB  0x7F,0x8,0x8,0x8,0x7F,0x0,0x0,0x41
	.DB  0x7F,0x41,0x0,0x0,0x20,0x40,0x41,0x3F
	.DB  0x1,0x0,0x7F,0x8,0x14,0x22,0x41,0x0
	.DB  0x7F,0x40,0x40,0x40,0x40,0x0,0x7F,0x2
	.DB  0xC,0x2,0x7F,0x0,0x7F,0x4,0x8,0x10
	.DB  0x7F,0x0,0x3E,0x41,0x41,0x41,0x3E,0x0
	.DB  0x7F,0x9,0x9,0x9,0x6,0x0,0x3E,0x41
	.DB  0x51,0x21,0x5E,0x0,0x7F,0x9,0x19,0x29
	.DB  0x46,0x0,0x46,0x49,0x49,0x49,0x31,0x0
	.DB  0x1,0x1,0x7F,0x1,0x1,0x0,0x3F,0x40
	.DB  0x40,0x40,0x3F,0x0,0x1F,0x20,0x40,0x20
	.DB  0x1F,0x0,0x3F,0x40,0x38,0x40,0x3F,0x0
	.DB  0x63,0x14,0x8,0x14,0x63,0x0,0x7,0x8
	.DB  0x70,0x8,0x7,0x0,0x61,0x51,0x49,0x45
	.DB  0x43,0x0,0x0,0x7F,0x41,0x41,0x0,0x0
	.DB  0x55,0x2A,0x55,0x2A,0x55,0x0,0x0,0x41
	.DB  0x41,0x7F,0x0,0x0,0x7F,0x7F,0x49,0x49
	.DB  0x41,0x0,0x40,0x40,0x40,0x40,0x40,0x0
	.DB  0x0,0x1,0x2,0x4,0x0,0x0,0x20,0x54
	.DB  0x54,0x54,0x78,0x0,0x7F,0x48,0x44,0x44
	.DB  0x38,0x0,0x38,0x44,0x44,0x44,0x20,0x0
	.DB  0x38,0x44,0x44,0x48,0x7F,0x0,0x38,0x54
	.DB  0x54,0x54,0x18,0x0,0x8,0x7E,0x9,0x1
	.DB  0x2,0x0,0xC,0x52,0x52,0x52,0x3E,0x0
	.DB  0x7F,0x8,0x4,0x4,0x78,0x0,0x0,0x44
	.DB  0x7D,0x40,0x0,0x0,0x20,0x40,0x44,0x3D
	.DB  0x0,0x0,0x7F,0x10,0x28,0x44,0x0,0x0
	.DB  0x0,0x41,0x7F,0x40,0x0,0x0,0x7C,0x4
	.DB  0x18,0x4,0x78,0x0,0x7C,0x8,0x4,0x4
	.DB  0x78,0x0,0x38,0x44,0x44,0x44,0x38,0x0
	.DB  0x7C,0x14,0x14,0x14,0x8,0x0,0x8,0x14
	.DB  0x14,0x18,0x7C,0x0,0x7C,0x8,0x4,0x4
	.DB  0x8,0x0,0x48,0x54,0x54,0x54,0x20,0x0
	.DB  0x4,0x3F,0x44,0x40,0x20,0x0

_0x4:
	.DB  0x4D,0x61,0x6E,0x6F,0x6A,0x20,0x52,0x2E
	.DB  0x20,0x54,0x68,0x61,0x6B,0x75,0x72,0x20
	.DB  0x20
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 7/4/2018
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;#include <pgmspace.h>
;#include <interrupt.h>
;	flags -> R17

	.CSEG
;#include <io.h>
;
;
;// Declare your global variables here
;
;void delay();
;void DisplayChar(char f);
;void Scanner();
;void SIGNAL();
;
;char Vline[30];
;char cc,y,U,P;
; int k;
; char String[] = "Manoj R. Thakur  ";

	.DSEG
;
; int i,vl;
; char S,Z,g,K,w;
; char M;
;/*--------------------------------------------------------------------------------------------------
;                                     Character generator
;
;             This table defines the standard ASCII characters in a 3x5 dot format.
;--------------------------------------------------------------------------------------------------*/
;const char FontLookup [][6] =
;{
;    { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },  // sp
;
;    { 0x03, 0x03, 0xff, 0xff, 0x03, 0x03 },   // T
;    { 0xf8, 0xfc, 0x07, 0x07, 0xfc, 0xf8 },   // A
;    { 0x00, 0x38, 0x44, 0x82, 0x01, 0x8c },   // (
;    { 0x9e, 0x92, 0x92, 0xf2, 0x60, 0x00 },   // S
;    { 0xfe, 0xfe, 0x08, 0x1c, 0x36, 0x62 },   // K
;    { 0x82, 0xc6, 0x6c, 0x38, 0x1c, 0x0e },   // Y
;    { 0x06, 0x00, 0x08, 0x08, 0x08, 0x00 },   // Y
;
;    { 0xFF, 0xFF, 0x00, 0xf8, 0x24, 0x22 },   // A
;    { 0x24, 0xf8, 0x00, 0xfa, 0x00, 0xfc },   // i
;    { 0x08, 0x06, 0x00, 0xfb, 0x01, 0xfb },   // r
;    { 0x87, 0x6b, 0x6b, 0xa7, 0xff, 0x01 },   // T
;    { 0xff, 0xff, 0x00, 0x08, 0x08, 0x00 },   // e
;
;    { 0xff, 0x81, 0xad, 0xad, 0xd3, 0xff },   // B
;    { 0x81, 0xff, 0xc3, 0xbd, 0xad, 0xcb },   // I
;    { 0xff, 0x00, 0x02, 0x02, 0x7e, 0x02 },   // G
;    { 0x02, 0x00, 0x1e, 0x20, 0x40, 0x20 },   // T
;    { 0x1e, 0x00, 0x08, 0x08, 0x08, 0x00 },   // V
;
;    { 0xf8, 0xfc, 0x07, 0x07, 0xfc, 0xf8 },   // 2
;    { 0x21, 0x41, 0x45, 0x4B, 0x31, 0x00 },   // 3
;    { 0x18, 0x14, 0x12, 0x7F, 0x10, 0x00 },   // 4
;    { 0x27, 0x45, 0x45, 0x45, 0x39, 0x00 },   // 5
;    { 0x3C, 0x4A, 0x49, 0x49, 0x30, 0x00 },   // 6
;    { 0x01, 0x71, 0x09, 0x05, 0x03, 0x00 },   // 7
;    { 0x36, 0x49, 0x49, 0x49, 0x36, 0x00 },   // 8
;    { 0x06, 0x49, 0x49, 0x29, 0x1E, 0x00 },   // 9
;    { 0x00, 0x36, 0x36, 0x00, 0x00, 0x00 },   // :
;    { 0x00, 0x56, 0x36, 0x00, 0x00, 0x00 },   // ;
;    { 0x08, 0x14, 0x22, 0x41, 0x00, 0x00 },   // <
;    { 0x14, 0x14, 0x14, 0x14, 0x14, 0x00 },   // =
;    { 0x00, 0x41, 0x22, 0x14, 0x08, 0x00 },   // >
;    { 0x02, 0x01, 0x51, 0x09, 0x06, 0x00 },   // ?
;    { 0x32, 0x49, 0x59, 0x51, 0x3E, 0x00 },   // @
;    { 0x7E, 0x11, 0x11, 0x11, 0x7E, 0x00 },   // A
;    { 0x7F, 0x49, 0x49, 0x49, 0x36, 0x00 },   // B
;    { 0x3E, 0x41, 0x41, 0x41, 0x22, 0x00 },   // C
;    { 0x7F, 0x41, 0x41, 0x22, 0x1C, 0x00 },   // D
;    { 0x7F, 0x49, 0x49, 0x49, 0x41, 0x00 },   // E
;    { 0x7F, 0x09, 0x09, 0x09, 0x01, 0x00 },   // F
;    { 0x3E, 0x41, 0x49, 0x49, 0x7A, 0x00 },   // G
;    { 0x7F, 0x08, 0x08, 0x08, 0x7F, 0x00 },   // H
;    { 0x00, 0x41, 0x7F, 0x41, 0x00, 0x00 },   // I
;    { 0x20, 0x40, 0x41, 0x3F, 0x01, 0x00 },   // J
;    { 0x7F, 0x08, 0x14, 0x22, 0x41, 0x00 },   // K
;    { 0x7F, 0x40, 0x40, 0x40, 0x40, 0x00 },   // L
;    { 0x7F, 0x02, 0x0C, 0x02, 0x7F, 0x00 },   // M
;    { 0x7F, 0x04, 0x08, 0x10, 0x7F, 0x00 },   // N
;    { 0x3E, 0x41, 0x41, 0x41, 0x3E, 0x00 },   // O
;    { 0x7F, 0x09, 0x09, 0x09, 0x06, 0x00 },   // P
;    { 0x3E, 0x41, 0x51, 0x21, 0x5E, 0x00 },   // Q
;    { 0x7F, 0x09, 0x19, 0x29, 0x46, 0x00 },   // R
;    { 0x46, 0x49, 0x49, 0x49, 0x31, 0x00 },   // S
;    { 0x01, 0x01, 0x7F, 0x01, 0x01, 0x00 },   // T
;    { 0x3F, 0x40, 0x40, 0x40, 0x3F, 0x00 },   // U
;    { 0x1F, 0x20, 0x40, 0x20, 0x1F, 0x00 },   // V
;    { 0x3F, 0x40, 0x38, 0x40, 0x3F, 0x00 },   // W
;    { 0x63, 0x14, 0x08, 0x14, 0x63, 0x00 },   // X
;    { 0x07, 0x08, 0x70, 0x08, 0x07, 0x00 },   // Y
;    { 0x61, 0x51, 0x49, 0x45, 0x43, 0x00 },   // Z
;    { 0x00, 0x7F, 0x41, 0x41, 0x00, 0x00 },   // [
;    { 0x55, 0x2A, 0x55, 0x2A, 0x55, 0x00 },   // 55
;    { 0x00, 0x41, 0x41, 0x7F, 0x00, 0x00 },   // ]
;    { 0x7F, 0x7F, 0x49, 0x49, 0x41, 0x00 },   // E//{ 0x04, 0x02, 0x01, 0x02, 0x04, 0x00 },   // ^
;    { 0x40, 0x40, 0x40, 0x40, 0x40, 0x00 },   // _
;    { 0x00, 0x01, 0x02, 0x04, 0x00, 0x00 },    // '
; { 0x20, 0x54, 0x54, 0x54, 0x78, 0x00 },   // a
;    { 0x7F, 0x48, 0x44, 0x44, 0x38, 0x00 },   // b
;    { 0x38, 0x44, 0x44, 0x44, 0x20, 0x00 },   // c
;    { 0x38, 0x44, 0x44, 0x48, 0x7F, 0x00 },   // d
;    { 0x38, 0x54, 0x54, 0x54, 0x18, 0x00 },   // e
;    { 0x08, 0x7E, 0x09, 0x01, 0x02, 0x00 },   // f
;    { 0x0C, 0x52, 0x52, 0x52, 0x3E, 0x00 },   // g
;    { 0x7F, 0x08, 0x04, 0x04, 0x78, 0x00 },   // h
;    { 0x00, 0x44, 0x7D, 0x40, 0x00, 0x00 },   // i
;    { 0x20, 0x40, 0x44, 0x3D, 0x00, 0x00 },   // j
;    { 0x7F, 0x10, 0x28, 0x44, 0x00, 0x00 },   // k
;    { 0x00, 0x41, 0x7F, 0x40, 0x00, 0x00 },   // l
;    { 0x7C, 0x04, 0x18, 0x04, 0x78, 0x00 },   // m
;    { 0x7C, 0x08, 0x04, 0x04, 0x78, 0x00 },   // n
;    { 0x38, 0x44, 0x44, 0x44, 0x38, 0x00 },   // o
;    { 0x7C, 0x14, 0x14, 0x14, 0x08, 0x00 },   // p
;    { 0x08, 0x14, 0x14, 0x18, 0x7C, 0x00 },   // q
;    { 0x7C, 0x08, 0x04, 0x04, 0x08, 0x00 },   // r
;    { 0x48, 0x54, 0x54, 0x54, 0x20, 0x00 },   // s
;    { 0x04, 0x3F, 0x44, 0x40, 0x20, 0x00 }   // t
;/*
;    { 0x3C, 0x40, 0x40, 0x20, 0x7C, 0x00 },   // u
;    { 0x1C, 0x20, 0x40, 0x20, 0x1C, 0x00 },   // v
;    { 0x3C, 0x40, 0x30, 0x40, 0x3C, 0x00 },   // w
;    { 0x44, 0x28, 0x10, 0x28, 0x44, 0x00 },   // x
;    { 0x0C, 0x50, 0x50, 0x50, 0x3C, 0x00 },   // y
;    { 0x44, 0x64, 0x54, 0x4C, 0x44, 0x00 }    // z
; */
;};
;
;void main()
; 0000 009B {

	.CSEG
_main:
; .FSTART _main
; 0000 009C  cc=0;
	CLR  R5
; 0000 009D  y=0;
	CLR  R4
; 0000 009E  DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 009F  DDRB=0xFF;
	OUT  0x17,R30
; 0000 00A0 
; 0000 00A1  //Initialize scanner
; 0000 00A2  TCNT0=0xF1;
	LDI  R30,LOW(241)
	OUT  0x32,R30
; 0000 00A3  TCCR0=0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 00A4  TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 00A5  SREG=0x80;
	LDI  R30,LOW(128)
	OUT  0x3F,R30
; 0000 00A6 
; 0000 00A7  PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00A8  PORTD=0xff;
	LDI  R30,LOW(255)
	OUT  0x12,R30
; 0000 00A9 
; 0000 00AA  while(1){
_0x5:
; 0000 00AB     int i = 0;
; 0000 00AC     for( i =0; i<6; i++){
	SBIW R28,2
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
;	i -> Y+0
	STD  Y+0,R30
	STD  Y+0+1,R30
_0x9:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,6
	BRGE _0xA
; 0000 00AD 
; 0000 00AE         PORTB = ~FontLookup[5][i];
	__POINTW1FN _FontLookup,30
	LD   R26,Y
	LDD  R27,Y+1
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	COM  R30
	OUT  0x18,R30
; 0000 00AF         delay();
	RCALL _delay
; 0000 00B0     }
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	RJMP _0x9
_0xA:
; 0000 00B1  }
	ADIW R28,2
	RJMP _0x5
; 0000 00B2 
; 0000 00B3 }
_0xB:
	RJMP _0xB
; .FEND
;
;
;void delay()
; 0000 00B7 {
_delay:
; .FSTART _delay
; 0000 00B8  int k;
; 0000 00B9  for(k=1;k<16000;k++)
	ST   -Y,R17
	ST   -Y,R16
;	k -> R16,R17
	__GETWRN 16,17,1
_0xD:
	__CPWRN 16,17,16000
	BRGE _0xE
; 0000 00BA  {
; 0000 00BB  }
	__ADDWRN 16,17,1
	RJMP _0xD
_0xE:
; 0000 00BC }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;void SIGNAL()
; 0000 00BF {
; 0000 00C0  cc=cc++;
; 0000 00C1  Scanner();
; 0000 00C2  TCNT0=0xFE;
; 0000 00C3 }
;
;void Scanner()
; 0000 00C6 {
; 0000 00C7 switch(cc)
; 0000 00C8 {
; 0000 00C9 case 1:
; 0000 00CA   PORTD=0xFF;
; 0000 00CB   PORTB=0x80;
; 0000 00CC   PORTD=~Vline[0];
; 0000 00CD   break;
; 0000 00CE case 2:
; 0000 00CF   PORTD=0xFF;
; 0000 00D0   PORTB=0x40;
; 0000 00D1   PORTD=~Vline[1];
; 0000 00D2   break;
; 0000 00D3 case 3:
; 0000 00D4   PORTD=0xFF;
; 0000 00D5   PORTB=0x20;
; 0000 00D6   PORTD=~Vline[2];
; 0000 00D7   break;
; 0000 00D8 case 4:
; 0000 00D9   PORTD=0xFF;
; 0000 00DA   PORTB=0x10;
; 0000 00DB   PORTD=~Vline[3];
; 0000 00DC   break;
; 0000 00DD case 5:
; 0000 00DE   PORTD=0xFF;
; 0000 00DF   PORTB=0x08;
; 0000 00E0   PORTD=~Vline[4];
; 0000 00E1   break;
; 0000 00E2 case 6:
; 0000 00E3   PORTD=0xFF;
; 0000 00E4   PORTB=0x04;
; 0000 00E5   PORTD=~Vline[5];
; 0000 00E6   break;
; 0000 00E7 case 7:
; 0000 00E8   PORTD=0xFF;
; 0000 00E9   PORTB=0x02;
; 0000 00EA   PORTD=~Vline[6];
; 0000 00EB   break;
; 0000 00EC case 8:
; 0000 00ED   PORTD=0xFF;
; 0000 00EE   PORTB=0x01;
; 0000 00EF   PORTD=~Vline[7];
; 0000 00F0   cc=0;
; 0000 00F1 }
; 0000 00F2 }
;
;/*********************************************************************************/
;/*         Display Char                           */
;/*********************************************************************************/
;void DisplayChar(char f)
; 0000 00F8 {
; 0000 00F9 char g;
; 0000 00FA f=f-0x20;
;	f -> Y+1
;	g -> R17
; 0000 00FB  for(g=4;g>=0;g--)
; 0000 00FC  {
; 0000 00FD   Vline[y]=pgm_read_byte(&FontLookup[f][g]);
; 0000 00FE   y=y++;
; 0000 00FF  }
; 0000 0100   Vline[y]=0x00;
; 0000 0101   y=0;//y++;
; 0000 0102 }
;
;void Delay()
; 0000 0105 {
; 0000 0106  int t;
; 0000 0107   for(t=0;t<4000;t++);
;	t -> R16,R17
; 0000 0108 }
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG

	.CSEG

	.DSEG
_Vline:
	.BYTE 0x1E
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG

	.CSEG
;END OF CODE MARKER
__END_OF_CODE:
