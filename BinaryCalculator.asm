LIST  P=PIC16F877
include P16f877.inc
__CONFIG _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_OFF & _HS_OSC & _WRT_ENABLE_ON & _LVP_OFF & _DEBUG_OFF & _CPD_OFF
;mohammad enaby 
org 0x00
reset goto start

       org 0x10
start: bcf STATUS, RP0
      bcf STATUS, RP1   ; Bank 0
      clrf PORTD
      clrf PORTE

      bsf STATUS, RP0   ; Bank 1
      movlw 0x06
      movwf ADCON1
      clrf TRISE         ; porte output 
      clrf TRISD         ; portd output
      ;=====    
      bcf INTCON, GIE   ; No interrupt
      movlw 0x0F
      movwf TRISB
      bcf OPTION_REG, 0x7 ; Enable PortB Pull-Up
      clrf TRISD

      bcf STATUS, RP0   ; Bank0
      clrf PORTD
      clrf 0x30
      clrf 0x40
      clrf 0x50
      call init
      clrf 0x60
      clrf 0x70
      clrf 0x95
goto check
;===================================================
check: incf 0x95
       movlw 0x04
       subwf 0x95 ,W
       btfsc STATUS,Z
       goto TOE
       
       call wkb
       
       movwf 0x75
       movlw 0x0a
       subwf 0x75,W
       btfsc STATUS,Z
       goto  enterA
       
       movlw 0x0b
       subwf 0x75,W
       btfsc STATUS,Z
       goto enterB

       movlw 0x0c
       subwf 0x75,W
       btfss STATUS,Z
       goto printERROR
       goto enterC
       
;===================================================
enterA: movlw 0x80
       movwf 0x20
       call lcdc
       call mdel

       movf 0x75,W
       addlw 0x37
       movwf 0x20
       call lcdd
       call mdel

       call wkb
       movwf 0x31
       addlw 0x30
       movwf 0x20
       call lcdd 
       btfsc 0x31,0
       call add1A
       call mdel
 
       call wkb 
       movwf 0x32
       addlw 0x30
       movwf 0x20
       call lcdd
       btfsc 0x32,0
       call add2A
       call mdel

       call wkb 
       movwf 0x33
       addlw 0x30
       movwf 0x20
       call lcdd 
       btfsc 0x33,0
       call add3A
       call mdel
 
       call BeginToClearFirstLine
       goto check
;===================================================
add1A: movlw 0x04
      addwf 0x30
      return
add2A: movlw 0x02
      addwf 0x30
      return
add3A: movlw 0x01
      addwf 0x30 
      return
;===================================================
enterB: movlw 0x80
       movwf 0x20
       call lcdc
       call mdel

       movf 0x75,W
       addlw 0x37
       movwf 0x20
       call lcdd
       call mdel

       call wkb
       movwf 0x41
       addlw 0x30
       movwf 0x20
       call lcdd 
       btfsc 0x41,0
       call add1B
       call mdel
 
       call wkb 
       movwf 0x42
       addlw 0x30
       movwf 0x20
       call lcdd
       btfsc 0x42,0
       call add2B
       call mdel

       call wkb 
       movwf 0x43
       addlw 0x30
       movwf 0x20
       call lcdd 
       btfsc 0x43,0
       call add3B 
       call mdel;----
      
       call BeginToClearFirstLine
       goto check
       
;===================================================
add1B: movlw 0x04
      addwf 0x40
      return
add2B: movlw 0x02
      addwf 0x40
      return
add3B: movlw 0x01
      addwf 0x40
       return
;===================================================
enterC:movlw 0x80
       movwf 0x20
       call lcdc
       call mdel

       movf 0x75,W
       addlw 0x37
       movwf 0x20
       call lcdd
       call mdel

       call wkb
       movwf 0x51
       addlw 0x30
       movwf 0x20
       call lcdd 
       btfsc 0x51,0
       call add1C
       call mdel
 
       call wkb 
       movwf 0x52
       addlw 0x30
       movwf 0x20
       call lcdd
       btfsc 0x52,0
       call add2C
       call mdel

       call wkb 
       movwf 0x53
       addlw 0x30
       movwf 0x20
       call lcdd
       btfsc 0x53,0
       call add3C 
       call mdel

       call BeginToClearFirstLine
       goto check
      
;===================================================
add1C: movlw 0x04
      addwf 0x50
      return
add2C: movlw 0x02
      addwf 0x50
       return
add3C: movlw 0x01
      addwf 0x50
       return
;====================================================
TOE:
     movf 0x50,W
     movwf 0x51
     movwf 0x52
     movwf 0x53
     movwf 0x54
     movwf 0x55
     movwf 0x56
     
     movlw 0x01
     subwf 0x51,W
     btfsc STATUS,Z
     goto SUB

     movlw 0x02
     subwf 0x52,W
     btfsc STATUS,Z
     goto MULT
     nop
     
     movlw 0x03
     subwf 0x53,W
     btfsc STATUS,Z
     goto  DIV
     nop
 
     movlw 0x04
     subwf 0x54,W
     btfsc STATUS,Z
     goto POW
     nop
 
     movlw 0x05
     subwf 0x55,W
     btfsc STATUS,Z
     goto Dig1A
 
     movlw 0x06
     subwf 0x56,W
     btfsc STATUS,Z
     goto Dig0B
     call printERROR
;====================================================
printResult: movwf 0x60

             clrf 0x63
             clrf 0x64
             clrf 0x65
             clrf 0x66


             btfsc 0x60,3
             incf 0x63,f
             btfsc 0x60,2
             incf 0x64,f
             btfsc 0x60,1
             incf 0x65,f
             btfsc 0x60,0
             incf 0x66,f

             movlw 0xC0
             movwf 0x20
             call lcdc
             call mdel
             
             movf 0x63,W
             addlw 0x30
             movwf 0x20
             call lcdd

             movf 0x64,W
             addlw 0x30
             movwf 0x20
             call lcdd
 
             movf 0x65,W
             addlw 0x30
             movwf 0x20
             call lcdd
 
             movf 0x66,W
             addlw 0x30
             movwf 0x20
             call lcdd
             SLEEP
;====================================================
printERROR:  call BeginToClearFirstLine
             movlw 0x85
             movwf 0x20
             call lcdc
 
             movlw 'E'
             movwf 0x20
             call lcdd
             
             movlw 'R'
             movwf 0x20
             call lcdd
             
             movlw 'R'
             movwf 0x20
             call lcdd
             
             movlw 'O'
             movwf 0x20
             call lcdd
             
             movlw 'R'
             movwf 0x20
             call lcdd
             SLEEP
;====================================================
SUB: movf 0x30,W
     movwf 0x35
     movf 0x40,W
     movwf 0x45

     movf 0x30,W
     subwf 0x40,W
     btfsc STATUS,C
     call printResult
     movf 0x45,W
     subwf 0x35,W
     movwf 0x69

     movlw 0xC0
     movwf 0x20
     call lcdc 
     movlw '-'
     movwf 0x20
     call lcdd
     movf 0x69,W
     call printResult2

printResult2:movwf 0x60

             clrf 0x64
             clrf 0x65
             clrf 0x66

             btfsc 0x60,2
             incf 0x64
             btfsc 0x60,1
             incf 0x65
             btfsc 0x60,0
             incf 0x66

             movf 0x64,W
             addlw 0x30
             movwf 0x20
             call lcdd
 
             movf 0x65,W
             addlw 0x30
             movwf 0x20
             call lcdd
 
             movf 0x66,W
             addlw 0x30
             movwf 0x20
             call lcdd
             SLEEP
;====================================================
ADD: movf 0x30,W
     addwf 0x60
     decf 0x40,f
     goto MULT
     
     
MULT: movlw 0x00
      subwf 0x40,W
      btfss STATUS,Z
      goto ADD
      movf 0x60,W
      call printResult
;=====================================================
DIV:  movf 0x40,W
      subwf 0x30,W
      btfss STATUS,C
      goto print
      movwf 0x30
      incf 0x60,f
      goto DIV

print: movf 0x60,W
      call printResult
;====================================================
ADD2: movf 0x31,W
     addwf 0x68
     decf 0x41,f
     goto MULT2
     
     
MULT2: movlw 0x00
      subwf 0x41,W
      btfss STATUS,Z
      goto ADD2
      movf 0x68,W
      return
;---------
POW: movf 0x40,W
    movwf 0x70 
    movf  0x30,W
    movwf 0x31
    movwf 0x41
    clrf 0x68
    goto mul

POW1: call MULT2
     movwf 0x31
     movf 0x30,W
     movwf 0x41 
     clrf 0x68
     decf 0x70,f
     goto mul
     
mul:  movlw 0x01
      subwf 0x70,W
      btfss STATUS,Z
      goto POW1
      movf 0x31,W
      call printResult
;====================================================
Dig1A: 
       movlw 0x01
       subwf 0x31,W
       btfsc STATUS,Z
       incf 0x60,F

       movlw 0x01
       subwf 0x32,W
       btfsc STATUS,Z
       incf 0x60,F
 
       movlw 0x01
       subwf 0x33,W
       btfsc STATUS,Z
       incf 0x60,F
       movf 0x60,W

       call printResult
       return
;====================================================
Dig0B: 
       movlw 0x00
       subwf 0x41,W
       btfsc STATUS,Z
       incf 0x60,F

       movlw 0x00
       subwf 0x42,W
       btfsc STATUS,Z
       incf 0x60,F
 
       movlw 0x00
       subwf 0x43,W
       btfsc STATUS,Z
       incf 0x60,F
       movf 0x60,W

       call printResult
       return
;====================================================
del_41	movlw		0xcd
		movwf		0x23
lulaa6	movlw		0x20
		movwf		0x22
lulaa7	decfsz		0x22,1
		goto		lulaa7
		decfsz		0x23,1
		goto 		lulaa6 
		return


del_01	movlw		0x20
		movwf		0x22
lulaa8	decfsz		0x22,1
		goto		lulaa8
		return


sdel	movlw		0x19		; movlw = 1 cycle
		movwf		0x23		; movwf	= 1 cycle
lulaa2	movlw		0xfa
		movwf		0x22
lulaa1	decfsz		0x22,1		; decfsz= 12 cycle
		goto		lulaa1		; goto	= 2 cycles
		decfsz		0x23,1
		goto 		lulaa2 
		return


mdel	movlw		0x2a
		movwf		0x24
lulaa5	movlw		0x19
		movwf		0x23
lulaa4	movlw		0xfa
		movwf		0x22
lulaa3	decfsz		0x22,1
		goto		lulaa3
		decfsz		0x23,1
		goto 		lulaa4 
		decfsz		0x24,1
		goto		lulaa5
		return
;===================================================
wait goto wait

;
;subroutine to initialize LCD
;
init movlw 0x30
     movwf 0x20
     call lcdc
     call del_41

     movlw 0x30
     movwf 0x20
     call lcdc
     call del_01

     movlw 0x30
     movwf 0x20
     call lcdc
     call mdel

     movlw 0x01         ; display clear
     movwf 0x20
     call lcdc
     call mdel

     movlw 0x06         ; ID=1,S=0 increment,no shift 000001 ID S
     movwf 0x20
     call lcdc
     call mdel

     movlw 0x0c         ; D=1,C=B=0 set display, no cursor, no blinking
     movwf 0x20
     call lcdc
     call mdel

     movlw 0x38         ; dl=1 ( 8 bits interface,n=12 lines,f=05x8 dots)
     movwf 0x20
     call lcdc
     call mdel
     return

;
;subroutine to write command to LCD
;

lcdc movlw 0x00        ; E=0,RS=0 
     movwf PORTE
     movf 0x20, w
     movwf PORTD
     movlw 0x01        ; E=1,RS=0
     movwf PORTE
     call sdel
     movlw 0x00        ; E=0,RS=0
     movwf PORTE
     return

;
;subroutine to write data to LCD
;

lcdd movlw 0x02        ; E=0, RS=1
     movwf PORTE
     movf 0x20, w
     movwf PORTD
     movlw 0x03        ; E=1, rs=1  
     movwf PORTE
     call sdel
     movlw 0x02        ; E=0, rs=1  
     movwf PORTE
     return
;===================================================
BeginToClearFirstLine: call mdel
Movlw 0x80
Movwf 0x20
Movwf 0x59
Call lcdc
call ClearNextBit1
return
ClearNextBit1: incf 0x59
Movlw 0x90
Subwf 0x59, W
Btfsc STATUS, Z
Return
movlw 0x20
movwf 0x20
Call lcdd
Goto ClearNextBit1

BeginToClearSecLine:   ;call mdel
Movlw 0xC0
Movwf 0x20
Movwf 0x58
Call lcdc
call ClearNextBit2
return

ClearNextBit2: incf 0x58
Movlw 0xD0
Subwf 0x58, W
Btfsc STATUS, Z
Return
movlw 0x20
movwf 0x20
Call lcdd
goto ClearNextBit2
;===================================================
wkb:    bcf             PORTB,0x4     ;Line 0 of Matrix is enabled
        bsf             PORTB,0x5
        bsf             PORTB,0x6
        bsf             PORTB,0x7
;-----------------------------------------------------------------------
        btfss           PORTB,0x0     ;Scan for 1,A
        goto            kb01
        btfss           PORTB,0x3
        goto            kb0a
;-----------------------------------------------------------------------
        bsf             PORTB,0x4	;Line 1 of Matrix is enabled
        bcf             PORTB,0x5
;-----------------------------------------------------------------------
        btfss           PORTB,0x3     ;Scan for B
        goto            kb0b
;-----------------------------------------------------------------------	
        bsf             PORTB,0x5	;Line 2 of Matrix is enabled
        bcf             PORTB,0x6
;-----------------------------------------------------------------------
        btfss           PORTB,0x3      ;Scan for C
        goto            kb0c
;-----------------------------------------------------------------------
        bsf             PORTB,0x6	;Line 3 of Matrix is enabled
        bcf             PORTB,0x7
;----------------------------------------------------------------------
        btfss           PORTB,0x1       ;Scan FOR 0
        goto            kb00
;----------------------------------------------------------------------
        goto            wkb

kb00:   movlw           0x00
        goto            disp	
kb01:   movlw           0x01
        goto            disp		
kb0a:   movlw           0x0a
        goto            disp	
kb0b:   movlw           0x0b
        goto            disp	
kb0c:   movlw           0x0c
        goto            disp		


disp:   return

	end
