/*this program is an assembly code to control an LCD display and scan a keypad matrix using a PIC16F877 microcontroller.
Specifically, it aims to initialize the LCD, scan the keypad for input, display the pressed key on the LCD,
and handle specific keypresses by displaying corresponding characters on the LCD.
*/

LIST  P=PIC16F877
include P16f877.inc
__CONFIG _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_OFF & _HS_OSC & _WRT_ENABLE_ON & _LVP_OFF & _DEBUG_OFF & _CPD_OFF

; LCD
;
    org 0x00
reset goto start

    org 0x10
start bcf STATUS, RP0
      bcf STATUS, RP1   ; Bank 0
      clrf PORTD
      clrf PORTE

      bsf STATUS, RP0   ; Bank 1
      movlw 0x06
      movwf ADCON1
      clrf TRISE         ; porte output 
      clrf TRISD         ; portd output

      bcf STATUS, RP0   ; Bank 0
      ;=====
      bcf STATUS, RP0
      bcf STATUS, RP1   ; Bank0
      clrf PORTD
      bsf STATUS, RP0   ; Bank1
      bcf INTCON, GIE   ; No interrupt
      movlw 0x0F
      movwf TRISB
      bcf OPTION_REG, 0x7 ; Enable PortB Pull-Up
      clrf TRISD
      bcf STATUS, RP0   ; Bank0
      clrf  0x54
      call enter
      call init

;----------------------------*------------------------------
    movlw 0x80          ; PLACE for the data on the LCD
    movwf 0x20
    call lcdc
    call mdel
    call printInsert
;============ print insert:
  printInsert:  movlw 0x49
    movwf 0x20
    call lcdd
    call del_41

    movlw 0x6E
    movwf 0x20
    call lcdd
    call del_41

    movlw 0x73
    movwf 0x20
    call lcdd
    call del_41

    movlw 0x65
    movwf 0x20
    call lcdd
    call del_41

    movlw 0x72
    movwf 0x20
    call lcdd
    call del_41

    movlw 0x74
    movwf 0x20
    call lcdd
    call del_41

   

    movlw 0xC0          ; PLACE for the data on the LCD
    movwf 0x20
    call lcdc
    call mdel

    goto main           ; CHAR (the data )

;============ print insert:
    

;----------------------------------------------------------

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

;----------------------------------------------------------

del_41 movlw 0xff
        movwf 0x23
lulaa6 movlw 0xff
        movwf 0x22
lulaa7 decfsz 0x22, 1
        goto lulaa7
        decfsz 0x23, 1
        goto lulaa6 
        return

del_01 movlw 0x20
        movwf 0x22
lulaa8 decfsz 0x22, 1
        goto lulaa8
        return

sdel movlw 0x19         ; movlw = 1 cycle
     movwf 0x23         ; movwf = 1 cycle
lulaa2 movlw 0xfa
        movwf 0x22
lulaa1 decfsz 0x22, 1  ; decfsz = 12 cycles
        goto lulaa1     ; goto = 2 cycles
        decfsz 0x23, 1
        goto lulaa2 
        return

mdel movlw 0x0a
     movwf 0x24
lulaa5 movlw 0x19
        movwf 0x23
lulaa4 movlw 0xfa
        movwf 0x22
lulaa3 decfsz 0x22, 1
        goto lulaa3
        decfsz 0x23, 1
        goto lulaa4 
        decfsz 0x24, 1
        goto lulaa5
        return

;-----------------------------------
enter: movlw 0x70
      movwf FSR
      return

next: movf 0x65,W
movwf INDF
      incf FSR,F
      return

;------------infinity loop-----
inf:  clrf 0x50
      bsf  0x50,0
      goto inf
;------------infinity loop-----
printClosed movlw 0x80          ; PLACE for the data on the LCD
            movwf 0x20
            call lcdc
            call mdel

            
            movlw 0x43
            movwf 0x20
            call lcdd
            call del_41

            movlw 0x6C
            movwf 0x20
            call lcdd
            call del_41

            movlw 0x6F
            movwf 0x20
            call lcdd
            call del_41

            movlw 0x73
            movwf 0x20
            call lcdd
            call del_41

            movlw 0x65
            movwf 0x20
            call lcdd
            call del_41

            movlw 0x64
            movwf 0x20
            call lcdd
            call del_41

            movlw 0x3A
          movwf 0x20
          call lcdd
          call del_41
 
          movlw 0x28
          movwf 0x20
          call lcdd
          call del_41
            goto inf
       
           
            return 

;----------------------------
printOpened: movlw 0x80          ; PLACE for the data on the LCD
            movwf 0x20
            call lcdc
            call mdel

          movlw 0x4F
          movwf 0x20
          call lcdd
          call del_41

          movlw 0x70
          movwf 0x20
          call lcdd
          call del_41

          movlw 0x65
          movwf 0x20
          call lcdd
          call del_41

          movlw 0x6E
          movwf 0x20
          call lcdd
          call del_41

          movlw 0x65
          movwf 0x20
          call lcdd
          call del_41

          movlw 0x64
          movwf 0x20
          call lcdd
          call del_41

          movlw 0x3A
          movwf 0x20
          call lcdd
          call del_41
 
          movlw 0x29
          movwf 0x20
          call lcdd
          call del_41
          goto inf

       
          return

;----------------------------
check0 movlw 0x31
       subwf 0x70, W
       btfss STATUS, Z
       call printClosed
       goto check1

check1 movlw 0x32
       subwf 0x71, W
       btfss STATUS, Z
       call printClosed
       goto check2

check2 movlw 0x33
       subwf 0x72, W
       btfss STATUS, Z
       call printClosed
       goto check3

check3 movlw 0x34
       subwf 0x73, W
       btfss STATUS, Z
       call printClosed
       call printOpened
;-----------------------------------------------&&&&&&77&&7&777&&^
     
main: call wkb
     incf  0x54
     addlw 0x30
     movwf 0x65
     call next
     call del_41 
     movf 0x65,W
     movwf 0x20
     call lcdd
     movlw 0x04
     subwf 0x54, W
     btfsc STATUS, Z
     goto check0
     call del_41
     call mdel
     call del_41
     goto main
;-------------------------------------------------

wkb bcf PORTB, 0x4      ; scan Row 1
    bsf PORTB, 0x5
    bsf PORTB, 0x6
    bsf PORTB, 0x7
    btfss PORTB, 0x0
    goto kb01
    btfss PORTB, 0x1
    goto kb02
    btfss PORTB, 0x2
    goto kb03
    btfss PORTB, 0x3
    goto kb0a

    bsf PORTB, 0x4
    bcf PORTB, 0x5       ; scan Row 2
    btfss PORTB, 0x0
    goto kb04
    btfss PORTB, 0x1
    goto kb05
    btfss PORTB, 0x2
    goto kb06
    btfss PORTB, 0x3
    goto kb0b

    bsf PORTB, 0x5
    bcf PORTB, 0x6       ; scan Row 3
    btfss PORTB, 0x0
    goto kb07
    btfss PORTB, 0x1
    goto kb08
    btfss PORTB, 0x2
    goto kb09
    btfss PORTB, 0x3
    goto kb0c

    bsf PORTB, 0x6
    bcf PORTB, 0x7       ; scan Row 4
    btfss PORTB, 0x0
    goto kb0e
    btfss PORTB, 0x1
    goto kb00
    btfss PORTB, 0x2
    goto kb0f
    btfss PORTB, 0x3
    goto kb0d

    goto wkb

kb00 movlw 0x00
     goto disp
kb01 movlw 0x01
     goto disp
kb02 movlw 0x02
     goto disp
kb03 movlw 0x03
     goto disp
kb04 movlw 0x04
     goto disp
kb05 movlw 0x05
     goto disp
kb06 movlw 0x06
     goto disp
kb07 movlw 0x07
     goto disp
kb08 movlw 0x08
     goto disp
kb09 movlw 0x09
     goto disp
kb0a movlw 0x0A
     goto disp
kb0b movlw 0x0B
     goto disp
kb0c movlw 0x0C
     goto disp
kb0d movlw 0x0D
     goto disp
kb0e movlw 0x0E
     goto disp
kb0f movlw 0x0F
     goto disp

disp: return

end
