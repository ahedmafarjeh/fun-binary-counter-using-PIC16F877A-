;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Fourth Project -
; fun binary counter using PIC16F877A	
;

;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
   	PROCESSOR 16F877A
	__CONFIG 0x3731


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	cblock 0x25
count	
delay1	
delay2
bt
bt_count
bt2
bt2_count
d1
d2
d3
	endc

; regester LABEL EQUATES	;;;;;;;;;;;;;;;;;;;;;;;;;;;

PORTB	EQU		06 
PORTD	EQU     08	
TRISD	EQU		88
TRISB	EQU		86
STATUS  EQU     83
OPTION_REG  EQU     81
INTCON EQU 8B

; PROGRAM BEGINS    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ORG	000		; Start of program memory
	GOTO	start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ISR
	ORG 004
	BCF INTCON,7
	BSF PORTD,1
	BCF INTCON,1
	BSF INTCON,7
RETFIE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                      
; Port & display setup(int port D as output)	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;bt2_count res 1
start
	BANKSEL	TRISD		; Select bank 1
	MOVLW	B'00000000'	
	MOVWF	TRISD

	
    BANKSEL TRISB
	MOVLW	B'11111111'	
	MOVWF	TRISB
	bsf OPTION_REG,6
	bcf INTCON,1
	BSF INTCON,4
	BSF INTCON,7
	BANKSEL PORTB
 	movlw d'0'
	movwf bt ; puch button 1
	movlw d'0'
	movwf bt2 ; push button 2
	

int
	movlw 0x00 ; W=0
	movwf PORTD ; PORTD = 0 --> ALL LEDS ARE OFF
	movlw d'32'
    movwf count ; FOR COUNTER
	
Lp
	call delay_check ; check if push button 2 (delay button) is pressed and put delay 
	btfsc PORTB,0 ; check if push button 1 (to increment counter by specific number) is preseed or not 
   	goto display ;if not pressed dispaly number using leds --> normal count
   	goto btn1_count ;  if pressed --> then check the number of button 1 pressed count 
	
	
;	goto Lp


display
	call delay ; delay 1 sec if button 2 not pressed
	movlw 5 
	subwf bt,0
	btfss STATUS,2; if button 1 presed for the fifth time 
	goto four ;if not , go to four label to check if is pressed to the fourth time, and so on ,,,, 
	goto zero
four
	movlw 4
	subwf bt,0
	btfss STATUS,2
	goto three 	
	movlw 5
	addwf PORTD,1
	decf count
	decf count
	decf count
	decf count
	DECFSZ	count,F
	goto Lp
	goto int

three
	movlw 3
	subwf bt,0
	btfss STATUS,2
	goto two 	
	movlw 4
	addwf PORTD,1
	decf count
	decf count
	decf count
	DECFSZ	count,F
	goto Lp
	goto int

two
	movlw 2
	subwf bt,0
	btfss STATUS,2
	goto one 	
	movlw 3
	addwf PORTD,1
	decf count
	decf count
	DECFSZ	count,F
	goto Lp
	goto int

one
	movlw 1
	subwf bt,0
	btfss STATUS,2
	goto zero    
	
    movlw 2
	addwf PORTD,1 ; increament counter by 2 --> 0,2,4,6,....30
	;bcf STATUS,2
	;incf PORTD,f
	decf count
	DECFSZ	count,F
	goto Lp
	goto int
	
zero
	movlw 1
	addwf PORTD,1 ; increment counter by 1 --> 0,1,2,3,4,5......31
	;incf PORTD,f
	DECFSZ	count,F
	goto Lp
	goto int
 
	
	;goto int

	goto Lp
; here we check if button 1 is pressed and inc bt_count if increment
btn1_count
	incf bt_count ; increment bt_count by 1 
	movlw 5
	subwf bt_count,0
	btfss STATUS,2 ; check if is pressed for fifth time
	goto Tfour
	movlw 0
	movwf bt_count
	movlw 5
	movwf bt
	goto display
Tfour
	movlw 4
	subwf bt_count,0
	btfss STATUS,2
	goto Tthree
	movlw 4
	movwf bt
	goto display

Tthree
	movlw 3
	subwf bt_count,0
	btfss STATUS,2
	goto Ttwo
	movlw 3
	movwf bt
	goto display
Ttwo
	movlw 2
	subwf bt_count,0
	btfss STATUS,2
	goto Tone
	movlw 2
	movwf bt
	goto display
Tone
    movlw 1
	movwf bt
	goto display
; function that generate delay (1 sec , 2 sec ,3 sec,4 sec,5 sec) 
delay
	movlw 5 
	subwf bt2,0
	btfss STATUS,2 ;check if button 2 pressed to the fifth time the generate 1 second delay
	goto d_5sec ;else chck if is pressed to the fourh time to generate 5 second delay and so on ...
	goto d_1sec

d_5sec
	movlw 4
	subwf bt2,0
	btfss STATUS,2
	goto d_4sec
	movlw d'20'
	movwf d3
	goto loop3
	d_4sec
	movlw 3
	subwf bt2,0
	btfss STATUS,2
	goto d_3sec
	movlw d'16'
	movwf d3
	goto loop3

d_3sec
	movlw 2
	subwf bt2,0
	btfss STATUS,2
	goto d_2sec
	movlw d'12'
	movwf d3
	goto loop3
	d_2sec
	movlw 1
	subwf bt2,0
	btfss STATUS,2
	goto d_1sec
	movlw d'8'
	movwf d3
	goto loop3
	d_1sec
	movlw d'4'
	movwf d3
	loop3
	movlw d'200'
	movwf d2
	loop2
	movlw d'250'
	movwf d1
	loop
	nop
	nop
	decfsz d1,f
	goto loop 
	decfsz d2,f
	goto loop2
	decfsz d3,f
	goto loop3
return
; check delay button if pressed
delay_check
	btfsc PORTB,1 ; check if button 2 is pressed --> to genereate specific delay
	goto last ; keep the privous delay
	incf bt2_count ; if pressed increment bt2_count by one
	movlw 5 
	subwf bt2_count,0
	btfss STATUS,2 ; check if bt2_count equal 5
	goto fours ; else check if it is equal 4
	movlw 0
	movwf bt2_count ;; make bt2_count zero
	movlw 5
	movwf bt2
	goto last
	fours
	movlw 4
	subwf bt2_count,0
	btfss STATUS,2
	goto threes
	movlw 4
	movwf bt2
	goto last
	threes
	movlw 3
	subwf bt2_count,0
	btfss STATUS,2
	goto twos
	movlw 3
	movwf bt2
	goto last
	twos
	movlw 2
	subwf bt2_count,0
	btfss STATUS,2
	goto ones
	movlw 2
	movwf bt2
	goto last
	ones
	movlw 1
	subwf bt2_count,0
	btfss STATUS,2
	goto last
	movlw 1
	movwf bt2
	last
return
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;

	END