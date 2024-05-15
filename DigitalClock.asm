/*The purpose of the program is to create a digital clock using the PIC16F877 microcontroller. The program includes several key functionalities:

Initialization: The microcontroller is set up to configure various ports and registers.
Timer0 Configuration: Timer0 is set up to generate periodic interrupts.
LCD Initialization and Control: Functions are defined to initialize the LCD, send commands to it, and display data on it.
Keypad Scanning: The program scans a keypad to receive input from the user.
Clock Display: The current time is displayed on the LCD in the "HH:MM:SS" format.
Clock Update: The clock updates every second, incrementing the seconds, minutes, and hours appropriately.
User Input for Time Setting: The user can set the time using the keypad, and the program verifies and updates the display accordingly.
*/

LIST  P=PIC16F877
include P16f877.inc
__CONFIG _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_OFF & _HS_OSC & _WRT_ENABLE_ON & _LVP_OFF & _DEBUG_OFF & _CPD_OFF

;Mohammad enaby 213989577

org		0x00
reset goto start

      org 0x10

start: bcf STATUS,RP0 
       bcf STATUS,RP1     	;Bank 0

        clrf	PORTD
		clrf	PORTE
       

		clrf	INTCON 
		

		bsf		STATUS, RP0		;Bank 1
		movlw	0x06
		movwf	ADCON1

		clrf	TRISE		;porte output 
		clrf	TRISD		;portd output
        clrf    TRISC
        movlw   0x0F
        movwf   TRISB
         movlw	d'00'					
		movwf	TMR0				
    
        movlw	0xC7			
		movwf	OPTION_REG
        bcf		OPTION_REG,0x7	;Enable PortB Pull-Up
		bcf		STATUS, RP0			; Bank0 <------
;-------------------------------------------------
;===========tmr0 
        clrf 0x39
        call init
        goto PrintClock
;---------------------------------------------------------------------------------------
wait1:	btfss	INTCON, T0IF		; Checking the flag (Timer0)
		goto    wait1

		incf	PORTD
		movlw	d'00'			
		movwf	TMR0				
		bcf		INTCON, T0IF
		return
;===============================================================================
lulForTNR0: 
       call  wait1
       incf 0x39,f
       movlw 0x4C
       subwf 0x39,Z
       btfss STATUS,Z
       goto lulForTNR0
       clrf 0x39
       return
;===============================================================================
PrintClock:;Displays the current time on the LCD in the format "HH:MM:SS".
            movlw 0x84          
            movwf 0x20
            call lcdc
           
            movlw 0x30
            movwf 0x20
            call lcdd
            call del_41

            movlw 0x30
            movwf 0x20
            call lcdd
            call del_41

            movlw ':'
            movwf 0x20
            call lcdd
            call del_41

            movlw 0x30
            movwf 0x20
            call lcdd
            call del_41

            movlw 0x30
            movwf 0x20
            call lcdd
            call del_41

            movlw ':'
            movwf 0x20
            call lcdd
            call del_41

            movlw 0x30
          movwf 0x20
          call lcdd
          call del_41

           movlw 0x30
           movwf 0x20
           call lcdd
           call del_41

           ;-----------
           movlw 0xC4          
            movwf 0x20
            call lcdc
            call mdel

            movlw 0x48
            movwf 0x20
            call lcdd
            call del_41

            movlw 0x48
            movwf 0x20
            call lcdd
            call del_41

            movlw ':'
            movwf 0x20
            call lcdd
            call del_41

            movlw 0x4D
            movwf 0x20
            call lcdd
            call del_41

            movlw 0x4D
            movwf 0x20
            call lcdd
            call del_41

            movlw ':'
            movwf 0x20
            call lcdd
            call del_41

            movlw 0x53
          movwf 0x20
          call lcdd
          call del_41

           movlw 0x53
           movwf 0x20
           call lcdd
           call del_41
           ;-----------

          movlw 0x84
          movwf 0x20
          call lcdc
          
          goto ScanClock
          
;---------------------------------------------------------------------------------------
ScanClock:;Scans a keypad matrix to get the input for setting the time.
           call wkb
           movwf 0x70
           addlw 0x30; scan hours -0
           movwf 0x20
           call  lcdd
           call  mdel
         
           call wkb
           movwf 0x71
           addlw 0x30
           movwf 0x20;scan hours 0-
           call  lcdd
           call  mdel

           movlw 0x87
          movwf 0x20
          call lcdc
          call mdel

           call wkb
           movwf 0x60
           addlw 0x30
           movwf 0x20
           call  lcdd
           call  mdel

           call wkb
           movwf 0x61
           addlw 0x30
           movwf 0x20
           call  lcdd
           call  mdel

           movlw 0x8A
          movwf 0x20
          call lcdc
          call mdel

           call wkb
           movwf 0x50
           addlw 0x30
           movwf 0x20
           call  lcdd
           call  mdel

           call wkb
           movwf 0x51
           addlw 0x30
           movwf 0x20
           call  lcdd
           call  mdel
           goto  check
           
;-------------------------------------------------------------------------
    check: movlw 0x06
           subwf 0x50,W
           btfsc STATUS,Z
           goto PrintClock
           movlw 0x06
           subwf 0x50,W 
           btfsc STATUS,C
           goto PrintClock

           movlw 0x06
           subwf 0x60,W
           btfsc STATUS,Z
           goto PrintClock
           movlw 0x06
           subwf 0x60,W 
           btfsc STATUS,C
           goto PrintClock

           movlw 0x02
           subwf 0x70,W
           btfsc STATUS,Z
           goto  CheckOnesOfHours
           movlw 0x02
           subwf 0x70,W 
           btfsc STATUS,C
           goto PrintClock
           goto incfSec1

 CheckOnesOfHours:
           movlw 0x04
           subwf 0x71,W
           btfsc STATUS,Z
           goto  PrintClock
           movlw 0x04
           subwf 0x71,W
           btfss STATUS,C
           goto  incfSec1
           goto PrintClock
           
           
           
;-------------------------------------------------------------------------

incfSec1: ;increment ones in minutes, if ones is not 0A show it in 0x88, if yes go to incMin2
          
          incf 0x51
          movlw 0x8B
          movwf 0x20
          call  lcdc 
          call lulForTNR0
 
          movlw 0x0A
          subwf 0x51,Z
          btfsc STATUS,Z
          goto incfSec2

          movf 0x51,W
          addlw 0x30
          movwf 0x20
          call  lcdd
         ; call tm
          goto incfSec1
;===
  incfSec2:;show 0 in 0x88 , increment tens in Min and show it in 0x87, if tens equals to 6 , which mean Min=60, goto incHours1, and show 00
          clrf 0x51
          incf 0x50
          movlw 0x8A
          movwf 0x20
          call  lcdc 

          movf 0x50,W
          addlw 0x30
          movwf 0x20
          call lcdd

          movlw 0x30
          movwf 0x20
          call lcdd
          
  
          movlw 0x06
          subwf 0x50,Z
          btfss STATUS,Z
          goto incfSec1

          clrf 0x50 
          clrf 0x51
          movlw 0x8A
          movwf 0x20
          call  lcdc 
    
          movlw 0x30
          movwf 0x20
          call lcdd
 
          movlw 0x30
          movwf 0x20
          call lcdd

          goto incMin1

;---------------------------------------------------------------------------------------
  incMin1: ;increment ones in minutes, if ones is not 0A show it in 0x88, if yes go to incMin2
          incf 0x61
          movlw 0x88
          movwf 0x20
          call  lcdc 
          

          movlw 0x0A
          subwf 0x61,Z
          btfsc STATUS,Z
          goto incMin2
          movf 0x61,W
          addlw 0x30
          movwf 0x20
          call lcdd
         
          goto incfSec1
;===
  incMin2:;show 0 in 0x88 , increment tens in Min and show it in 0x87, if tens equals to 6 , which mean Min=60, goto incHours1, and show 00
          clrf 0x61
          incf 0x60
          movlw 0x87
          movwf 0x20
          call  lcdc 
          

          movf 0x60,W
          addlw 0x30
          movwf 0x20
          call lcdd

          movlw 0x30
          movwf 0x20
          call lcdd
  
          movlw 0x06
          subwf 0x60,Z
          btfss STATUS,Z
          goto incfSec1
          clrf 0x60 
          clrf 0x61
          movlw 0x87
          movwf 0x20
          call  lcdc 
    
          movlw 0x30
          movwf 0x20
          call lcdd
 
          movlw 0x30
          movwf 0x20
          call lcdd

          goto incHours1
;---------------------------------------------------------------------------------------
 incHours1: ;increment ones in Hours, if ones is not 0A show it in 0x85, if yes go to incHours2
         incf 0x71
          movlw 0x85
          movwf 0x20
          call  lcdc 
          
          goto CheckOnes2
         inc: movlw 0x0A
          subwf 0x71,Z
          btfsc STATUS,Z
          goto incHours2
          movf 0x71,W
          addlw 0x30
          movwf 0x20
          call lcdd
          
          goto incfSec1
;===
CheckOnes2: movlw 0x02
            subwf 0x70,W
            btfss STATUS,Z
            goto inc 
            movlw 0x04
          subwf 0x71,Z
          btfsc STATUS,Z
          goto PrintClock1
          movf 0x71,W
          addlw 0x30
          movwf 0x20
          call lcdd
          
          goto incfSec1
;===
incHours2: ;show 0 in 0x85, increment tens , if tens equal to 2 and ones equal to 3 , 
           incf 0x70
          movlw 0x85
          movwf 0x20
          call  lcdc 
          
          clrf  0x71
          movlw 0x30
          movwf 0x20
          call lcdd  
         
          movlw 0x84
          movwf 0x20
          call  lcdc 
          
          movf 0x70,W
          addlw 0x30
          movwf 0x20
          call lcdd
          
          goto incfSec1
;---------------------------------------------------------------------------------------
;======================================================
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

mdel movlw 0x05
     movwf 0x24
lulaa5 movlw 0xff
        movwf 0x23
lulaa4 movlw 0xff
        movwf 0x22
lulaa3 decfsz 0x22, 1
        goto lulaa3
        decfsz 0x23, 1
        goto lulaa4 
        decfsz 0x24, 1
        goto lulaa5
        return

;======================================================

;======================================================

;======================================================
PrintClock1:;Displays the current time on the LCD in the format "HH:MM:SS".
            movlw 0x84          
            movwf 0x20
            call lcdc
            

            movlw 0x30
            movwf 0x20
            call lcdd
            

            movlw 0x30
            movwf 0x20
            call lcdd
            c

            movlw ':'
            movwf 0x20
            call lcdd
            

            movlw 0x30
            movwf 0x20
            call lcdd
            

            movlw 0x30
            movwf 0x20
            call lcdd
           

            movlw ':'
            movwf 0x20
            call lcdd
            

            movlw 0x30
          movwf 0x20
          call lcdd
          

           movlw 0x30
           movwf 0x20
           call lcdd
           

           ;-----------
           movlw 0xC4          
            movwf 0x20
            call lcdc
            

            movlw 0x48
            movwf 0x20
            call lcdd
            

            movlw 0x48
            movwf 0x20
            call lcdd
            

            movlw ':'
            movwf 0x20
            call lcdd
            

            movlw 0x4D
            movwf 0x20
            call lcdd
            

            movlw 0x4D
            movwf 0x20
            call lcdd
            

            movlw ':'
            movwf 0x20
            call lcdd
            
            movlw 0x53
          movwf 0x20
          call lcdd
          

           movlw 0x53
           movwf 0x20
           call lcdd
           
           ;-----------

          movlw 0x84
          movwf 0x20
          call lcdc
          
            goto incfSec1
;=====================================================

;
;subroutine to initialize LCD
;
wait goto wait
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
;=================================================

;-------------------------------------------------

wkb: bcf PORTB, 0x4      ; scan Row 1
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
           
           

 
