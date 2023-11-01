            ;last edited - 26/09/2021
;-------------------------------------------------------------------------------	    
            ;EE322 
            ;G10 - Smart switch for a Room
	    ;E/17/370 - Wanninayake R.B.S.W.M.L.R.B.
	    ;E/17/374 - Weerasekara K.A.
	    ;E/17/413 - Yapa M.A.W.S.
 ;------------------------------------------------------------------------------   
	    
 
            PROCESSOR    16f84a
            #INCLUDE     <p16f84a.inc>
            
	     ;associating memory loactions for the delay subroutine
	    STEPS        EQU    0x0C 
	    STEPS1       EQU    0x0D
            STEPS2       EQU    0x0E
            STEPS3       EQU    0x0F
            STEPS4       EQU    0x1C
	    STEPS5       EQU    0x1D
       
	    
            ORG          0x00
            GOTO         MAIN
	    
;------------------------------------------------------------
;	    RA0 pin  -  output to the relay                 -
;	    RB1 pin  -  PIR sensor input		    -
;	    RB2 pin  -  LDR sensor input		    -
;	    RB3 pin  -  Automatic control switch	    -
;	    RB4 pin  -  Timer Switch			    -
;------------------------------------------------------------	    
	   
    MAIN:
            BSF          STATUS,5
	    MOVLW        b'11111111' 
	    MOVWF        TRISB     ; making PORTB input
	    CLRF         TRISA     ; making PORTA output
	    
    LOOP: 	    
	    BCF          STATUS,5
	    BTFSC        PORTB,3      ; checking the status of the automatic control switch
	    GOTO         AUTOMATIC    ; going into the automatic contol loop    
	    CALL         MANUAL       ; going to manual control avoiding main loop
	    GOTO         LOOP
	    
    AUTOMATIC:
            BCF          STATUS,5
            BTFSC        PORTB,2     ; checking LDR sensor input
	    GOTO         SWITCHOFF   ; goto switch off state if there is daylight
	    GOTO         HPRESENCE   ; go forward in the loop to check PIR sensor input
	    
    MANUAL:
            BCF          STATUS,5  
	    MOVLW        b'00000001'  
	    MOVWF        PORTA     ; sending 'HIGH' to relay
	    RETURN
	    
	    
    SWITCHOFF:
            BCF          STATUS,5
	    CLRF         PORTA    ; making RA0 pin 'LOW'
	    GOTO         LOOP
	    
    HPRESENCE:
            BCF          STATUS,5
            BTFSC        PORTB,1  ; cheking PIR sensor input to measure human presence
	    GOTO         SWITCHON  
	    GOTO         SWITCHOFF   
	    
    SWITCHON:
            BCF          STATUS,5
	    MOVLW        b'00000001'
	    MOVWF        PORTA    ; making RA0 pin 'HIGH'
	    BTFSC        PORTB,4  ; checking whether timer is on or off
	    GOTO         DELAY    ; wait on the siwtch_on state for defined time
	    GOTO         LOOP     
	    

    DELAY:   
    
            BCF          STATUS,5
            MOVLW        0xFF  
	    MOVWF        STEPS
	    MOVLW        0xFF
	    MOVWF        STEPS1
	    MOVLW        0xFF
	    MOVWF        STEPS2
	    MOVLW        0xFF
	    MOVWF        STEPS3
	    MOVLW        0xFF
	    MOVWF        STEPS4
	    MOVLW        0XFF
	    MOVLW        STEPS5
	    
    DELAY_LOOP:
            DECFSZ       STEPS,1
	    GOTO         DELAY_LOOP
	    DECFSZ       STEPS1,1
	    GOTO         DELAY_LOOP
	    DECFSZ       STEPS2,1
	    GOTO         DELAY_LOOP
	    DECFSZ       STEPS3,1
	    GOTO         DELAY_LOOP
	    DECFSZ       STEPS4,1
	    GOTO         DELAY_LOOP
	    DECFSZ       STEPS5,1
	    GOTO         DELAY_LOOP
	    
	    CLRF         PORTA       ; switch off after the delay
	    
    LOOP2:   ; this loop will not allow program to go into main loop until,
							 ;daylight comes or
							 ;user switch OFF automatic ctrl
    
	    BTFSC        PORTB,3    ; checking automatic control switch
            BTFSC        PORTB,2    ; checking LDR sensor input
	    GOTO         LOOP
	    GOTO         LOOP2
	    
	    
END
	    
    
            
            
	    
	    
	    
	    



