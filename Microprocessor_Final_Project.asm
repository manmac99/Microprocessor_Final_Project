; Jinwoo-Baseball.asm
;
; Welcome to Wagner Baseball Version 9-3!!
; Written by Professor David Wagner
; 
; Improved by:
; 	Student Members:
; 		(Jinwoo Park)
;
; A project for the 8051 Microcontroller

;=================================================================
;=================================================================
;                       DEFINED VALUES
;=================================================================
;=================================================================


;*********************************************************************
; Variables
; Addresses in 8051 Memory of the Variables used by this program
;********************************************************************


; ================== LCD Variables ==================

MOTOR_ADDR	EQU	0FFEFH
MOTOR_COMMAND	EQU 20H
LCD-Instr-Mem         EQU     30H    ; The instruction to be sent to the LCD
LCD-Data-Mem          EQU     31H    ; The data to be sent to the LCD

LCD-Cursor-Row        EQU     32H    ; The row number where a character will be displayed on the LCD
LCD-Cursor-Col        EQU     33H    ; The column number where a character will be displayed on the LCD

Char-Loc-Offset       EQU     34H    ; The offset location of the character in memory
Char-value            EQU     35H    ; The ASCII code of the character to display

Message-Lo-Byte       EQU     36H    ; The low byte of the message for DPTR
Message-Hi-Byte       EQU     37H    ; The high byte of the message for DPTR
Font-Lo-Byte          EQU     38H    ; Low Byte of the font for DPTR
Font-Hi-Byte          EQU     39H    ; High Byte of the font for DPTR

Font-Row-Num          EQU     3AH    ; Font Row Number
CGRAM-Address         EQU     3BH    ; CGRAM Address of Character in LCD

Message-Length        EQU     3CH    ; The size of the message in memory

; ================== Key Pad Variables ==================

Key-Col-Num           EQU     40H    ; The column number of the key pressed
Key-Row-Num           EQU     41H    ; The row number of the key pressed
Key-Num               EQU     42H    ; The number of the key pressed

Key-Col-Pattern       EQU     43H    ; The pattern of all columns to scan
Key-Row-Pattern       EQU     44H    ; The pattern of all rows which were scannned

; ================== Game Data Variables ==================

Score-Player1         EQU     45H    ; The score of Player 1
Score-Player2         EQU     46H    ; The score of Player 2

Ball-Count            EQU     47H    ; The number of Balls
Strike-Count          EQU     48H    ; The number of Strikes
Out-Count             EQU     49H    ; The number of Outs

Player-At-Bat         EQU     4AH    ; The number of the player at bat (1 or 2)

Inning-Number         EQU     4BH    ; The Inning Number

Base1-Occupied        EQU     4CH    ; 1 if First Base is Occupied, O if not
Base2-Occupied        EQU     4DH    ; 1 if Second Base is Occupied, O if not
Base3-Occupied        EQU     4EH    ; 1 if Third Base is Occupied, O if not

; =================== Key Press Results ===================

ValidKeyPress         EQU     50H    ; Was the key press valid?
PitchersAction         EQU     51H    ; Which pitchers throw was pressed
BattersSwing          EQU     52H    ; Which batters swing was pressed

; ================== Dot Matrix Variables ==================

Dot-Current-Row       EQU     59H    ; Which Dot Matrix Row is currently Displayed
Dot-Current-Bits      EQU     5AH    ; Bit Pattern with bit in currently Displayed Row

Ball-Dot-Row          EQU     5BH    ; The Row of the baseball on the dot matrix 
Ball-Row-Bits         EQU     5CH    ; The Bit Pattern of the baseball row

Dot-Saved-Row         EQU     5DH    ; The Row Number in the Dot Matrix which will be saved

Dot-Red-Saved         EQU     5EH    ; The saved Bit Pattern from the red dot matrix row
Dot-Green-Saved       EQU     5FH    ; The saved Bit Pattern from the green dot matrix row

Dot-Red-Matrix        EQU     60H    ; The Red Dot Matrix data is stored 50H-57H
Dot-Green-Matrix      EQU     68H    ; The Green Dot Matrix data is stored 58H-5FH

;*********************************************************************
; Hangul Code Variables
; Addresses in 8051 Data Memory where the Character Codes for each 
; Hangul can be found
;********************************************************************

Char-Code-YA          EQU     70H
Char-Code-GU          EQU     71H

Char-Code-WA          EQU     72H
Char-Code-GEU         EQU     73H
Char-Code-NEO         EQU     74H

Char-Code-WI             EQU     75H
Char-Code-DAE            EQU     76H
Char-Code-EUN            EQU     77H

Char-Code-BLANK          EQU     78H

; ======================================
; Memory addresses of note variables
; ======================================

; The length of time to keep the buzzer on or off
ONTIME                   EQU 79H
OFFTIME                  EQU 7AH
DELAYLENGTH              EQU 7BH

; The two byte counter of time remaining to play this note
NOTECOUNTERHI            EQU 7CH
NOTECOUNTERLO            EQU 7DH

; The total number of notes to play, and the current note being played

SONGMAXPOS               EQU 7EH
SONGCURRENTPOS           EQU 7FH

; ======================================
;  Additional (New) Variables
;  Please use 53H through 58H for additional variables
; ======================================

;*****************************************************************
; Constants
;*****************************************************************

; ==================== Note Constants ==================

; The Length of each note
NOTELENGTH EQU 30H

; The Length of time to keep the buzzer on
ONTIMELENGTH EQU 0AH

; =================== Key Pad Constants ===================

NoNumberPressed EQU 50H ; The Key-Number if no number is pressed
BallKeyPress EQU 00H ; The Key-Number if Ball is pressed
StrikeKeyPress EQU 01H ; The Key-Number if Strike is pressed
OutKeyPress EQU 02H ; The Key-Number if Out is pressed

CurveKeyPress EQU 00H ; The Key-Number if Curve Ball is thrown
StraitKeyPress EQU 01H ; The Key-Number if Straight Ball is thrown
CurveLKeyPress EQU 02H ; The Key-Number if Curve Left is thrown
CurveRKeyPress EQU 03H ; The Key-Number if Curve Right is thrown
SwingKeyPress EQU 04H ; The Key-Number if Batter swings
NoSwingKeyPress EQU 05H ; The Key-Number if Batter does not swing
SwingHigh EQU 06H
SwingLow EQU 07H

; ================== Dot Matrix Constants ==================

DotOnDelay1 EQU 010H ; The wait time while the Dot Matrix is On
DotOnDelay2 EQU 010H ; The wait time while the Dot Matrix is On

BallOnDelay1 EQU 060H ; The wait time while the Ball is Displayed
BallOnDelay2 EQU 060H ; The wait time while the Ball is Displayed

InitPitchRow EQU 4 ; The initial row of the baseball on the field
InitPitchBits EQU 00010000B ; The initial bit pattern on the field 
InitBallRow EQU 2 ; The initial row of a ball on Home Plate
InitBallBits EQU 00000001B ; The initial bit pattern on Home Plate
InitStrikeRow EQU 0 ; The initial row of a strike on Home Plate
InitStrikeBits EQU 00000001B ; The initial bit pattern on Home Plate
BallLastRow EQU 8 ; The final Row of the ball after throwing it

Base1Row EQU 2 ; The row number of first base
Base1Bits EQU 01000000B  ; The bit pattern of first base
Base2Row EQU 2 ; The row number of first base
Base2Bits EQU 00000100B  ; The bit pattern of second base
Base3Row EQU 6 ; The row number of first base
Base3Bits EQU 00000100B  ; The bit pattern of third base

; ========================= LCD Constants ========================= 

Line1-Address           EQU     00H  ; Address in LCD DDRAM memory where Line 1 begins
Line2-Address           EQU     40H  ; Address in LCD DDRAM memory where Line 2 begins
Font-Row-Max            EQU     08H  ; The Number of Rows in a Character Font

;*****************************************************************
; Device Registers
;*****************************************************************

; ============== Memory Locations of LCD Registers ==============

LCD-Write-Instr        EQU     0FFE0H     ; The register in the LCD which receives instructions
LCD-Write-Data         EQU     0FFE1H     ; The register in the LCD which receives data

LCD-Read-Instr         EQU     0FFE2H     ; The register in the LCD which sends instructions
LCD-Read-Data          EQU     0FFE3H     ; The register in the LCD which sends data


; ===== Memory Locations of the Dot Matrix Rows and Columns =====

DotMatrix-Green        EQU     0FFC5H     ; Which columns are colored green
DotMatrix-Red          EQU     0FFC6H     ; Which columns are colored red
DotMatrix-Row          EQU     0FFC7H     ; Which rows are turned on

; ========= Memory Locations of KeyPad Rows and Columns =========

Keypad-Data-Out        EQU     0FFF0H    ; Write which columns to consider
Keypad-Data-In         EQU     0FFF1H     ; Read the rows 

; ====== Memory Locations of LED 7-Segment Array Registers ======

LED-7-Segment1         EQU     0FFC3H    ; The first and second LED Numbers
LED-7-Segment2         EQU     0FFC2H    ; The third and fourth LED Numbers
LED-7-Segment3         EQU     0FFC1H    ; The fifth and sixth LED Numbers

; ========== Memory Location of Seven Segment Display ==========

Seven-Segment EQU 0FFC0H    ; The location of the 7-segment display

; ========= Memory Address of Buzzer =========

BUZZER EQU 0FFEFH

;*****************************************************************
; LCD Instructions
; Instruction Codes for each of the LCD Commands
;*****************************************************************

Clear-LCD              EQU     01H   ; Clear the LCD Screen entirely
Cursor-Home-LCD        EQU     02H   ; Move the Cursor to the Home position

; Does the cursor address increase or decrease after printing a character?
; and does the screen shift?
Cur-Dec-LCD            EQU     04H   ; Move the Cursor Address Left after writing
Cur-DecShift_LCD       EQU     05H   ; Move the Cursor Address Left and Shift the Screen after writing
Cur-Inc-LCD            EQU     06H   ; Move the Cursor Address Right after writing
Cur-IncShift_LCD       EQU     07H   ; Move the Cursor Address Right and Shift the Screen after writing

; Turn on or off the Display, the Cursor, and the Blinking Cursor
DCB-Off-LCD            EQU     08H    ;Display(OFF) ,Cursor(OFF) ,Blink(OFF)
Blink-On-LCD           EQU     09H    ;Display(OFF) ,Cursor(OFF) ,Blink(ON)
Cursor-On-LCD          EQU     0AH    ;Display(OFF) ,Cursor(ON) ,Blink(OFF)
CurBlink-On-LCD        EQU     0BH    ;Display(OFF) ,Cursor(ON) ,Blink(ON)
Display-On-LCD         EQU     0CH    ;Display(ON) ,Cursor(OFF) ,Blink(OFF)
DispBlink-On-LCD       EQU     0DH    ;Display(ON) ,Cursor(OFF) ,Blink(ON)
DispCur-On-LCD         EQU     0EH    ;Display(ON) ,Cursor(ON) ,Blink(OFF)
DCB-On-LCD             EQU     0FH    ;Display(ON) ,Cursor(ON) ,Blink(ON)

;Set the number of Rows and the Font Size
OneRow_5X7-LCD         EQU     30H    ;8-Bit 1 Row 5*7  , 1/16 duty
OneRow_5X10-LCD        EQU     34H    ;8-Bit 1 Row 5*10 , 1/16 duty
TwoRows-5X7-LCD        EQU     38H    ;8-Bit 2 Row 5*7  , 1/16 duty
TwoRows-5X10-LCD       EQU     3CH    ;8-Bit 2 Row 5*10 , 1/16 duty

;Set the CG RAM Address
Start-CGRAM-LCD        EQU     40H    ;0 100 0000 : CG-RAM Address Setting

;Set the DD RAM Address, which moves the cursor to that address
Move-Cursor-LCD        EQU     80H    ;1 000 0000 : Data Entry Start Address



;=================================================================
;=================================================================
;               MAIN PROGRAM EXECUTION LOOP
;=================================================================
;=================================================================

;*****************************************************************
; Main Loop
;*****************************************************************

	ORG 8000H
MAIN:
	CALL InitProgram
	CALL ShowMsgPlayYagu
	CALL ShowMsgWvsW
	CALL PlayGameSong
	CALL WaitForKeyPress
	CALL WaitForKeyRel
MainLoop:
	CALL PitcherThrows
	CALL BatterSwings
	CALL ResolvePitch
	CALL PressAnyKey
	JMP MainLoop

;*****************************************************************
; Players Press a Key
;*****************************************************************

PressAnyKey:
	CALL ShowMsgPressKey
	CALL WaitForKeyPress
	CALL WaitForKeyRel
	RET

PitcherThrows:
	CALL ShowMsgCurveOrS
	CALL WaitForKeyPress
	CALL PitcherAction
	CALL WaitForKeyRel
	MOV A, ValidKeyPress
	CJNE A, #1, PitcherThrows
	MOV A, PitchersAction
	CJNE A, #StraitKeyPress, PitcherThrows2
	RET

PitcherThrows2:
	CALL ShowMsgCurveLR
	CALL WaitForKeyPress
	CALL PitcherAction2
	CALL WaitForKeyRel
	MOV A, ValidKeyPress
	CJNE A, #1, PitcherThrows2
	RET

BatterSwings:
	CALL ShowMsgSwingOrN
	CALL WaitForKeyPress
	CALL BatterAction
	CALL WaitForKeyRel
	MOV A, ValidKeyPress
	CJNE A, #1, BatterSwings
	MOV A, BattersSwing
	CJNE A, #NoSwingKeyPress, BatterSwings2
	RET

BatterSwings2:
	CALL ShowMsgSwingHrL
	CALL WaitForKeyPress
	CALL BatterAction2
	CALL WaitForKeyRel
	MOV A, ValidKeyPress
	CJNE A, #1, BatterSwings2
	RET

;*****************************************************************
; This function waits until a key is pressed
;*****************************************************************

WaitForKeyPress:
	CALL DisplayDotMatrix
	CALL ScanKeyboard
	CALL GetKeyNum
	MOV A, Key-Num
	CJNE A, #NoNumberPressed, KeyPressFound
	JMP WaitForKeyPress
KeyPressFound:
	RET

;*****************************************************************
; This function waits until all keys are released
;*****************************************************************

WaitForKeyRel:
	CALL DisplayDotMatrix
	CALL ScanKeyboard
	CALL GetKeyNum
	MOV A, Key-Num
	CJNE A, #NoNumberPressed, WaitForKeyRel
	RET

;=================================================================
;=================================================================
;               INITIALIZATION PROCEDURES 
;=================================================================
;=================================================================

;*****************************************************************
; Initialize the program
;*****************************************************************

InitProgram:
	CALL InitVariables
	CALL InitDisplays
	RET

;*****************************************************************
; Initialize the variables
;*****************************************************************

InitVariables:
	MOV A, #0
	MOV Score-Player1, A
	MOV Score-Player2, A
	MOV Ball-Count, A
	MOV Strike-Count, A
	MOV Out-Count, A
	MOV Base1-Occupied, A
	MOV Base2-Occupied, A
	MOV Base3-Occupied, A
	MOV A, #1
	MOV Player-At-Bat, A
	MOV Inning-Number, A
	RET

;*****************************************************************
; Initialize the displays
;*****************************************************************

InitDisplays:
	CALL InitDotMatrix
	CALL InitLCD
	CALL DisplayAll
	RET

;*****************************************************************
; Initialize the Dot Matrix
;*****************************************************************

InitDotMatrix:
	MOV Dot-Current-Row, #0
	MOV Dot-Current-Bits, #00000001b
	RET

;*****************************************************************
; Initialize the LCD Display
;*****************************************************************

InitLCD:
	MOV LCD-Instr-Mem, #TwoRows-5X7-LCD
	CALL WriteInstToLCD
	MOV LCD-Instr-Mem, #DispCur-On-LCD
	CALL WriteInstToLCD
	MOV LCD-Instr-Mem, #Clear-LCD
	CALL WriteInstToLCD
	MOV LCD-Instr-Mem, #Cur-Inc-LCD
	CALL WriteInstToLCD
	RET

;=================================================================
;=================================================================
;                       KEY PRESS ACTION
;=================================================================
;=================================================================



;*****************************************************************
; Perform the Actions for a Key Press by the Pitcher
;*****************************************************************

PitcherAction:
	MOV PitchersAction, #NoNumberPressed
	MOV ValidKeyPress, #0
	MOV A, Key-Num
CheckCurve: CJNE A, #CurveKeyPress, CheckStraight
	JMP ValidPitch
CheckStraight: CJNE A, #StraitKeyPress, FinishPitcher
	JMP ValidPitch

; ================== Second Key for Left or Right ==================

PitcherAction2:
	MOV PitchersAction, #NoNumberPressed
	MOV ValidKeyPress, #0
	MOV A, Key-Num
CheckCurveLeft: CJNE A, #CurveLKeyPress, CheckCurveRight
	JMP ValidPitch
CheckCurveRight: CJNE A, #CurveRKeyPress, FinishPitcher
	JMP ValidPitch

ValidPitch:
	MOV PitchersAction, A
	MOV ValidKeyPress, #1
FinishPitcher:
	RET

;*****************************************************************
; Perform the Actions for a Key Press by the Batter
;*****************************************************************


BatterAction:
	MOV BattersSwing, #NoNumberPressed
	MOV ValidKeyPress, #0
	MOV A, Key-Num
CheckSwing: 
        ;CJNE A, #SwingKeyPress, BatterAction2
		CJNE A, #SwingKeyPress, CheckNoSwing
	JMP ValidSwing
CheckNoSwing: 
        CJNE A, #NoSwingKeyPress, FinishBatter
	JMP ValidSwing
BatterAction2:
	MOV BattersSwing, #NoNumberPressed
	MOV ValidKeyPress, #0
	MOV A, Key-Num
CheckSwingHigh: 
        CJNE A, #SwingHigh, CheckSwingLow
	JMP ValidSwing
CheckSwingLow: 
        CJNE A, #SwingLow, CheckSwingFive
	JMP ValidSwing
CheckSwingFive: 
        CJNE A, #NoSwingKeyPress, FinishBatter
	JMP ValidSwing

; Nono:
; 	MOV BattersSwing, #4
; 	MOV ValidKeyPress, #1
; 	JMP FinishBatter

ValidSwing:
	MOV BattersSwing, A
	MOV ValidKeyPress, #1
FinishBatter:
	RET

;*****************************************************************
; Determine the Result of the Pitch and Swing Combination
;*****************************************************************

ResolvePitch:
	MOV A, PitchersAction
	CJNE A, #StraitKeyPress, ResolveCurve

; ================== Resolve a Straight Pitch ==================

ResolveStraight: 
	MOV A, BattersSwing
StraightNoSwing:
        CJNE A, #SwingHigh, StraightNSwing
	;CALL BuntAction ;이거 수정함
	CALL FOutAction
	RET

StraightNSwing:
        CJNE A, #NoSwingKeyPress, StraightSwing
	;CALL BuntAction ;이거 수정함
	CALL BallAction
	RET

StraightSwing: 
        CJNE A, #SwingLow, FinishResolve
	CALL BuntAction
	RET

; ================== Resolve a Curve Pitch ==================

ResolveCurve: 
	CJNE A, #CurveLKeyPress, ResolveCurveR


ResolveCurveL: 
	MOV A, BattersSwing
CurveLNoSwing:
        ;CJNE A, #NoSwingKeyPress, CurveLSwing
		CJNE A, #SwingHigh, CurveLNSwing ;홈런
		
	CALL HomeRunAction
	RET
CurveLNSwing:
        CJNE A, #NoSwingKeyPress, CurveLSwing
		;CJNE A, #SwingHigh, CurveLSwing ;홈런
		
	CALL StrikeAction
	RET

CurveLSwing: 
        CJNE A, #SwingLow, FinishResolve
	CALL DoubleAction ;2루타
	RET


ResolveCurveR: 
	MOV A, BattersSwing
CurveRNoSwing:
        CJNE A, #SwingHigh, CurveRNSwing
	CALL BCAction
	RET
CurveRNSwing:
        CJNE A, #NoSwingKeyPress, CurveRSwing
	CALL DeadAction
	RET

CurveRSwing: 
        CJNE A, #SwingLow, FinishResolve
	CALL TripleAction
	RET

FinishResolve:
	RET

;*****************************************************************
; Perform the Actions for a Ball
;*****************************************************************

BallAction:
	CALL ThrowBall
	CALL ShowMsgBall
	CALL IncBallCount
	RET

BuntAction:
	CALL ThrowBall
	CALL ShowMsgBunt
	CALL IncBallCount
	RET

BCAction:
	CALL ThrowStrike
	CALL ShowMsgBC
	CALL IncBallCount
	RET

;*****************************************************************
; Perform the Actions for a Strike
;*****************************************************************

StrikeAction:
	CALL ThrowStrike
	CALL ShowMsgStrike
	CALL IncStrikeCount
	RET

;*****************************************************************
; Perform the Actions for an Out
;*****************************************************************

OutAction:
	CALL ThrowStrike
	CALL ShowMsgOut
	CALL IncOutCount
	RET

FOutAction:
	CALL ThrowStrike
	CALL ShowMsgFOut
	CALL IncOutCount
	RET

;*****************************************************************
; Perform the Actions for a Single
;*****************************************************************

SingleAction:
	CALL ThrowStrike
	CALL ShowMsgSingle
	CALL AdvanceAllBases
	MOV Base1-Occupied, #1
	CALL CopyBasesToDotM
	RET

DoubleAction:
	CALL ThrowStrike
	CALL ShowMsgDouble
	CALL AdvanceAllBases
	MOV Base2-Occupied, #1
	CALL CopyBasesToDotM
	RET

TripleAction:
	CALL ThrowStrike
	CALL ShowMsgTriple
	CALL AdvanceAllBases
	MOV Base3-Occupied, #1
	CALL CopyBasesToDotM
	RET



; HomeRunAction:
;     CALL ThrowStrike
;     CALL ShowMsgHomeRun


;     CALL IncreaseScore
	

;     RET

CONTROL_MOTOR:

    ; Main Loop
    ; Rotate the Motor forward, then stop, then reverse, then stop
    MAIN_LOOP:
        CALL    ROTATE_MOTOR_F   ; Call the function to rotate the motor forward
        CALL    DELAY            ; Call the delay function
        CALL    STOP_MOTOR       ; Call the function to stop the motor
        CALL    DELAY            ; Call the delay function
        CALL    ROTATE_MOTOR_B   ; Call the function to rotate the motor backward
        CALL    DELAY            ; Call the delay function
        CALL    STOP_MOTOR       ; Call the function to stop the motor
        CALL    DELAY            ; Call the delay function
        RET
    
    ; The rest of your code remains unchanged
    
    ; Rotate the Motor forward
    ROTATE_MOTOR_F:
        MOV     MOTOR_COMMAND, #00000110B  ; Set the motor command to rotate forward
        JMP     SEND_MOTOR_CMD              ; Jump to send the motor command
    
    ; Rotate the Motor backward
    ROTATE_MOTOR_B:
        MOV     MOTOR_COMMAND, #00000101B  ; Set the motor command to rotate backward
        JMP     SEND_MOTOR_CMD              ; Jump to send the motor command
    
    ; Stop the Motor
    STOP_MOTOR:
        MOV     MOTOR_COMMAND, #00000000B  ; Set the motor command to stop
        JMP     SEND_MOTOR_CMD              ; Jump to send the motor command
    
    ; Send the command to the motor
    SEND_MOTOR_CMD:
        MOV     A, MOTOR_COMMAND            ; Move the motor command to register A
        MOV     DPTR, #MOTOR_ADDR           ; Load the motor address into DPTR
        MOVX    @DPTR, A                    ; Write the motor command to the specified address
        RET                                 ; Return from the function
    
    ; Delay function
    DELAY:
        MOV     R7, #008H                   ; Initialize R7 for delay counting
    DELAY1:
        MOV     R6, #0FFH                   ; Initialize R6 for delay counting
    DELAY2:
        MOV     R5, #0FFH                   ; Initialize R5 for delay counting
    DELAY3:
        DJNZ    R5, DELAY3                  ; Decrement R5, loop until it reaches zero
        DJNZ    R6, DELAY2                  ; Decrement R6, loop until it reaches zero
        DJNZ    R7, DELAY1                  ; Decrement R7, loop until it reaches zero
        RET                                 ; Return from the delay function

    ; End of CONTROL_MOTOR function
    RET

HomeRunAction:
    CALL ThrowStrike
    CALL ShowMsgHomeRun
    CALL IncreaseScore ; 홈런 친 타자의 점수 증가
	
	CALL	CONTROL_MOTOR

    ; 선행 주자들에 대한 점수 처리
    MOV A, Base1-Occupied
    CJNE A, #0, IncreaseBase1
    JMP CheckBase2

IncreaseBase1:
    CALL IncreaseScore ; 1루 주자 점수 증가
    MOV Base1-Occupied, #0 ; 1루 비움

CheckBase2:
    MOV A, Base2-Occupied
    CJNE A, #0, IncreaseBase2
    JMP CheckBase3

IncreaseBase2:
    CALL IncreaseScore ; 2루 주자 점수 증가
    MOV Base2-Occupied, #0 ; 2루 비움

CheckBase3:
    MOV A, Base3-Occupied
    CJNE A, #0, IncreaseBase3
    JMP FinishHomeRun

IncreaseBase3:
    CALL IncreaseScore ; 3루 주자 점수 증가
    MOV Base3-Occupied, #0 ; 3루 비움

FinishHomeRun:
	CALL STOP_MOTOR 
    CALL CopyBasesToDotM ; 베이스 상태 업데이트
    RET


DeadAction:
	CALL ThrowStrike
	CALL ShowMsgDead
	CALL AdvanceAllBases
	MOV Base1-Occupied, #1
	CALL CopyBasesToDotM
	RET

;=================================================================
;=================================================================
;                   GAME LOGIC - ADD STRIKE OR BALL
;=================================================================
;=================================================================

;*****************************************************************
; Increase the number of balls
;*****************************************************************

IncBallCount:
	MOV A, Ball-Count
	INC A
	CJNE A, #4, FinishBallInc
	CALL ShowMsgWalk
	CALL WalkBatter
	MOV A, #0

FinishBallInc:
	MOV Ball-Count, A
	CALL DispBallStrkOut
	RET


;*****************************************************************
; Walk the batter
;*****************************************************************

WalkBatter:
	MOV A, Base1-Occupied
	CJNE A, #0, WalkBase1
	MOV Base1-Occupied, #1
	JMP FinishWalk

WalkBase1:
	MOV A, Base2-Occupied
	CJNE A, #0, WalkBase2
	MOV Base2-Occupied, #1
	JMP FinishWalk

WalkBase2:
	MOV A, Base3-Occupied
	CJNE A, #0, WalkBase3
	MOV Base3-Occupied, #1
	JMP FinishWalk

WalkBase3:
	CALL IncreaseScore
	JMP FinishWalk

FinishWalk:
	CALL CopyBasesToDotM
	CALL ClearBallsStrks
	RET

ClearBallsStrks:
	MOV Ball-Count, #0
	MOV Strike-Count, #0
	RET

;*****************************************************************
; Advance Runners at the Bases 
;*****************************************************************

AdvanceAllBases:
	CALL AdvanceBase3
	CALL AdvanceBase2
	CALL AdvanceBase1
	RET
	
AdvanceBase1:
	MOV A, Base1-Occupied
	MOV Base2-Occupied, A
	MOV Base1-Occupied, #0
	RET

AdvanceBase2:
	MOV A, Base2-Occupied
	MOV Base3-Occupied, A
	MOV Base2-Occupied, #0
	RET

AdvanceBase3:
	MOV A, Base3-Occupied
	MOV Base3-Occupied, #0
	CJNE A, #0, IncreaseScore
	RET


;*****************************************************************
; Increase the score
;*****************************************************************

IncreaseScore:
	MOV A, Player-At-Bat
	CJNE A, #1, IncPlayer2Score

; IncPlayer1Score:
; 	MOV A, Score-Player1
; 	INC A
; 	MOV Score-Player1, A
; 	CALL DisplayScores
; 	RET

IncPlayer1Score:
    MOV A, Score-Player1
    INC A
    CJNE A, #00AH, UpdateScore ; Check if A is not equal to 16
    MOV A, #010H               ; If equal, set A to 16
UpdateScore:
    MOV Score-Player1, A
    CALL DisplayScores
    RET



IncPlayer2Score:
	; MOV A, Score-Player2
	; INC A
	; MOV Score-Player2, A
	; CALL DisplayScores
	; RET
    MOV A, Score-Player2
    INC A
    CJNE A, #00AH, UpdateScore2 ; Check if A is not equal to 16
    MOV A, #010H               ; If equal, set A to 16
UpdateScore2:
    MOV Score-Player2, A
    CALL DisplayScores
    RET

;*****************************************************************
; Increase the number of strikes
;*****************************************************************

IncStrikeCount:
	MOV A, Strike-Count
	INC A
	CJNE A, #3, FinishStrikeInc
	CALL ShowMsgStrikeOut
	CALL IncOutCount
	MOV A, #0

FinishStrikeInc:
	MOV Strike-Count, A
	CALL DispBallStrkOut
	RET

;*****************************************************************
; Increase the number of outs
;*****************************************************************

IncOutCount:
	MOV A, Out-Count
	INC A
	CJNE A, #3, FinishOutInc
	CALL SwitchPlayers
	MOV A, #0

FinishOutInc:
	MOV Out-Count, A
	MOV A, #0
	CALL ClearBallsStrks
	CALL DispBallStrkOut
	RET

;*****************************************************************
; Switch Players
;*****************************************************************

SwitchPlayers:
	CALL UnoccupyBases
	MOV A, Player-At-Bat
	INC A
	CJNE A, #3, FinishSwitch
	CALL IncInning
	MOV A, #1

FinishSwitch:
	MOV Player-At-Bat, A
	CALL ClearLCD
	CALL DisplayAtBat
	RET

;*****************************************************************
; Remove the Runners from all the bases
;*****************************************************************

UnoccupyBases:
	MOV Base1-Occupied, #0
	MOV Base2-Occupied, #0
	MOV Base3-Occupied, #0
	CALL CopyBasesToDotM
	RET

;*****************************************************************
; Increase the inning
;*****************************************************************

IncInning:
	MOV A, Inning-Number
	INC A
	CJNE A, #10, FinishInningInc
	CALL GameOver

FinishInningInc:
	MOV Inning-Number, A
	CALL DisplayInningNum
	RET

;*****************************************************************
; Game Over
;*****************************************************************

GameOver:
	CALL ShowMsgGameOver
GameOverLoop:
	CALL DisplayDotMatrix
	JMP GameOverLoop


;=================================================================
;=================================================================
;                 THROW THE BASEBALL ANIMATION
;=================================================================
;=================================================================

;*****************************************************************
; Throw a ball
;*****************************************************************

ThrowBall:
	CALL ThrowPitch
	CALL DisplayPlate
	CALL ThrowBallPlate
	CALL DisplayBases
	RET

;*****************************************************************
; Throw a strike
;*****************************************************************

ThrowStrike:
	CALL ThrowPitch
	CALL DisplayPlate
	CALL ThrowStrikePlate
	CALL DisplayBases
	RET

;*****************************************************************
; Throw a pitch on the field
;*****************************************************************

ThrowPitch:
	CALL InitBallPitch
	JMP ThrowLoop

;*****************************************************************
; Throw a ball over Home Plate
;*****************************************************************

ThrowBallPlate:
	CALL InitBallPlate
	JMP ThrowLoop

;*****************************************************************
; Throw a strike over Home Plate
;*****************************************************************

ThrowStrikePlate:
	CALL InitStrikePlate
	JMP ThrowLoop

;*****************************************************************
; Display a moving baseball on the dot matrix
;*****************************************************************

ThrowLoop:
	CALL ShowBall
	CALL DelayBallOn
	CALL HideBall
	CALL AdvanceBall
	MOV A, Ball-Dot-Row
	CJNE A, #BallLastRow, ThrowLoop
	RET

;*****************************************************************
; Initialize the baseball location before throwing it on the field
;*****************************************************************

InitBallPitch:
	MOV Ball-Dot-Row, #InitPitchRow
	MOV Ball-Row-Bits, #InitPitchBits
	RET

;*****************************************************************
; Initialize the location before throwing a ball over Home Plate
;*****************************************************************

InitBallPlate:
	MOV Ball-Dot-Row, #InitBallRow
	MOV Ball-Row-Bits, #InitBallBits
	RET

;*****************************************************************
; Initialize the location before throwing a strike over Home Plate
;*****************************************************************

InitStrikePlate:
	MOV Ball-Dot-Row, #InitStrikeRow
	MOV Ball-Row-Bits, #InitStrikeBits
	RET

;*****************************************************************
; Show or Hide the baseball on the Dot Matrix
;*****************************************************************

ShowBall:
	CALL SaveBallDotRow
	CALL WriteBall
	RET

HideBall:
	CALL RestoreDotRow
	RET

;*****************************************************************
; Wait while the Ball is displayed
;*****************************************************************

DelayBallOn:
	MOV R4, #BallOnDelay1
DelayBall1:
	MOV R5, #BallOnDelay2
DelayBall2:
	DJNZ R5, DelayBall2
	CALL DisplayDotMatrix
	DJNZ R4, DelayBall1
	RET

;*****************************************************************
; Advance the baseball to the next position
;*****************************************************************

AdvanceBall:
	CALL IncrementBallRow
	CALL RotateBallBits
	RET

IncrementBallRow:
	MOV A, Ball-Dot-Row
	INC A
	MOV Ball-Dot-Row, A
	RET

RotateBallBits:
	MOV A, Ball-Row-Bits
	RL A
	MOV Ball-Row-Bits, A
	RET

;*****************************************************************
; Save the row on the dot matrix before writing the baseball
;*****************************************************************

SaveBallDotRow:
	MOV A, Ball-Dot-Row
	MOV Dot-Saved-Row, A
	CALL SaveDotRow
	RET

;*****************************************************************
; Save the row on the dot matrix before overwriting it
;*****************************************************************

SaveDotRow:
	CALL SaveRedRow
	CALL SaveGreenRow
	RET

SaveRedRow:
	MOV A, #Dot-Red-Matrix
	ADD A, Dot-Saved-Row
	MOV R1, A
	MOV Dot-Red-Saved, @R1
	RET

SaveGreenRow:
	MOV A, #Dot-Green-Matrix
	ADD A, Dot-Saved-Row
	MOV R1, A
	MOV Dot-Green-Saved, @R1
	RET

;*****************************************************************
; Restore the row on the dot matrix which had been overwritten
;*****************************************************************

RestoreDotRow:
	CALL RestoreRedRow
	CALL RestoreGreenRow
	RET

RestoreRedRow:
	MOV A, #Dot-Red-Matrix
	ADD A, Ball-Dot-Row
	MOV R1, A
	MOV @R1, Dot-Red-Saved
	RET

RestoreGreenRow:
	MOV A, #Dot-Green-Matrix
	ADD A, Ball-Dot-Row
	MOV R1, A
	MOV @R1, Dot-Green-Saved
	RET

;*****************************************************************
; Write the baseball on the Dot Matrix
;*****************************************************************

WriteBall:
	CALL WriteBallRed
	CALL EraseBallGreen
	RET

WriteBallRed:
	MOV A, #Dot-Red-Matrix
	ADD A, Ball-Dot-Row
	MOV R1, A
	MOV A, @R1
	ORL A, Ball-Row-Bits
	MOV @R1, A
	RET

EraseBallGreen:
	MOV A, #Dot-Green-Matrix
	ADD A, Ball-Dot-Row
	MOV R1, A
	MOV A, @R1
	CPL A
	ORL A, Ball-Row-Bits
	CPL A
	MOV @R1, A
	RET


;=================================================================
;=================================================================
;                    Keyboard Procedures
;=================================================================
;=================================================================

;*****************************************************************
; Scan the keyboard for any keys pressed
;*****************************************************************

ScanKeyboard:
	MOV Key-Col-Num, #1
	MOV Key-Col-Pattern, #11101111B

ScanOneCol:
	CALL ScanKeyPadCol
	MOV A, Key-Row-Num
	CJNE A, #0, KeyPressed 

	CALL IncrementCol
	MOV A, Key-Col-Num
	CJNE A, #6, ScanOneCol

	MOV Key-Col-Num, #0
	RET

KeyPressed:
	RET

;*****************************************************************
; Increment the number of the column and rotate the pattern
; Input
;	Key-Col-Num
;	Key-Col-Pattern
;*****************************************************************

IncrementCol:

	MOV A, Key-Col-Num
	INC A,
	MOV Key-Col-Num, A
	MOV A, Key-Col-Pattern
	RR A
	MOV Key-Col-Pattern, A
	RET


;*****************************************************************
; Scan One Column And Assign the row to Key-Row-Num
; Input
;	Key-Col-Pattern
;*****************************************************************

ScanKeyPadCol:
	MOV A, Key-Col-Pattern
	MOV DPTR, #Keypad-Data-Out
	MOVX @DPTR, A

	MOV DPTR, #Keypad-Data-In
	MOVX A, @DPTR
	MOV Key-Row-Pattern, A

ScanRow1: CJNE A, #11101111b ScanRow2
	MOV Key-Row-Num, #1
	RET
ScanRow2: CJNE A, #11110111b ScanRow3
	MOV Key-Row-Num, #2
	RET
ScanRow3: CJNE A, #11111011b ScanRow4
	MOV Key-Row-Num, #3
	RET
ScanRow4: CJNE A, #11111101b ScanRow5
	MOV Key-Row-Num, #4
	RET
ScanRow5: CJNE A, #11111110b NoKeyPressed
	MOV Key-Row-Num, #5
	RET
NoKeyPressed:
	MOV Key-Row-Num, #0
	RET


;*****************************************************************
; Store the number of the key pressed into Key-Num
;*****************************************************************

GetKeyNum:
	MOV A, Key-Row-Num
	
GetRow1: CJNE A, #1, GetRow2
	MOV A, Key-Col-Num
	SUBB A, #1
	CJNE A, #4, SaveKeyNum
	JMP NoKeyPressed
GetRow2: CJNE A, #2, GetRow3
	MOV A, Key-Col-Num
	ADD A, #3
	CJNE A, #8, SaveKeyNum
	JMP NoKeyPressed
GetRow3: CJNE A, #3, GetRow4
	MOV A, Key-Col-Num
	ADD A, #7
	CJNE A, #12, SaveKeyNum
	JMP NoKeyPressed
GetRow4: CJNE A, #4, NoNumPressed
	MOV A, Key-Col-Num
	ADD A, #11
	CJNE A, #16, SaveKeyNum
	JMP NoKeyPressed
NoNumPressed:
	MOV A, #NoNumberPressed
		
SaveKeyNum:
	MOV Key-Num, A
	RET

;=================================================================
;=================================================================
;                    DOT MATRIX PROCEDURES
;=================================================================
;=================================================================

;*****************************************************************
; Display a Row of the Dot Matrix
;*****************************************************************

DisplayDotMatrix:
	CALL ClearDOTROW
	CALL IncrementRow
	CALL AssignDOTGreen
	CALL AssignDOTRed
	CALL AssignDOTROW
	CALL DelayDotOn
	RET

;*****************************************************************
; Advance to the next row of the Dot Matrix
;*****************************************************************

IncrementRow:
	MOV A, Dot-Current-Bits
	RL A
	MOV Dot-Current-Bits, A
	MOV A, Dot-Current-Row
	INC A
	CJNE A, #8, FinishIncRow
	MOV A, #0
FinishIncRow:
	MOV Dot-Current-Row, A
	RET

;*****************************************************************
; Assign the green pattern to the DotMatrix-Green Register
;*****************************************************************

AssignDOTGreen:
	MOV A, #Dot-Green-Matrix
	ADD A, Dot-Current-Row
	MOV R1, A
	MOV A, @R1
	
	MOV DPTR, #DotMatrix-Green
	MOVX @DPTR, A
	RET

;*****************************************************************
; Assign the red pattern to the DotMatrix-Red Register
;*****************************************************************

AssignDOTRed:
	MOV A, #Dot-Red-Matrix
	ADD A, Dot-Current-Row
	MOV R1, A
	MOV A, @R1

	MOV DPTR, #DotMatrix-Red
	MOVX @DPTR, A
	RET

;*****************************************************************
; Assign the row pattern to the DotMatrix-Row Register
;*****************************************************************

AssignDOTROW:
	MOV DPTR, #DotMatrix-Row
	MOV A, Dot-Current-Bits
	MOVX @DPTR, A
	RET

;*****************************************************************
; Clear the row pattern to the DotMatrix-Row Register
;*****************************************************************

ClearDOTROW:
	MOV DPTR, #DotMatrix-Row
	MOV A, #0
	MOVX @DPTR, A
	RET

;*****************************************************************
; Wait while the Dot Matrix is Displayed
;*****************************************************************

DelayDotOn:
	MOV R2, #DotOnDelay1
DelayDot1:	MOV R3, #DotOnDelay2
DelayDot2:	DJNZ R3, DelayDot2
	DJNZ R2, DelayDot1
	RET

;*****************************************************************
; These are the Green Dots of the Baseball Field on the Dot Matrix
;*****************************************************************

FieldGreenDots:

DB 11111111b
DB 11111111b
DB 10111011b
DB 11111111b
DB 11111111b
DB 11111111b
DB 10111011b
DB 11111111b

;*****************************************************************
; These are the Red Dots of the Baseball Field on the Dot Matrix
;*****************************************************************

FieldRedDots:

DB 01000000b
DB 01111100b
DB 00111010b
DB 01000110b
DB 01010110b
DB 01000110b
DB 11111011b
DB 01000000b

;*****************************************************************
; These are the Green Dots of the Baseball Field on the Dot Matrix
;*****************************************************************

PlateGreenDots:

DB 11111111b
DB 11111111b
DB 11111111b
DB 11111111b
DB 11111111b
DB 11111111b
DB 11111111b
DB 11111111b

;*****************************************************************
; These are the Red Dots of the Baseball Field on the Dot Matrix
;*****************************************************************

PlateRedDots:

DB 00100000b
DB 01110000b
DB 11100000b
DB 11010000b
DB 10111010b
DB 00110111b
DB 00001110b
DB 00011100b


;=================================================================
;=================================================================
;                      DISPLAY PROCEDURES
;=================================================================
;=================================================================

DisplayAll:
	CALL DisplayBases
	CALL DisplayScores
	CALL DispBallStrkOut
;	CALL DisplayAtBat
	CALL DisplayInningNum
	RET

;*****************************************************************
; Copy the Dots showing the Bases to the Dot Matrix
;*****************************************************************

DisplayBases:
	CALL CopyFieldToDotM
	CALL CopyBasesToDotM
	RET

CopyFieldToDotM:
	CALL CopyFieldToGreen
	CALL CopyFieldToRed
	RET
	
;*****************************************************************
; Copy the Green Dots showing the Field to the Dot Matrix 
;*****************************************************************

CopyFieldToGreen:
	MOV DPTR, #FieldGreenDots
	MOV R1, #Dot-Green-Matrix
	CALL CopyMemoryToDotM
	RET

;*****************************************************************
; Copy the Red Dots showing the Field to the Dot Matrix
;*****************************************************************

CopyFieldToRed:
	MOV DPTR, #FieldRedDots
	MOV R1, #Dot-Red-Matrix
	CALL CopyMemoryToDotM
	RET

;*****************************************************************
; Copy the Dots showing Home Plate to the Dot Matrix
;*****************************************************************

DisplayPlate:
	CALL CopyPlateToGreen
	CALL CopyPlateToRed
	RET
	
;*****************************************************************
; Copy the Green Dots showing Home Plate to the Dot Matrix 
;*****************************************************************

CopyPlateToGreen:
	MOV DPTR, #PlateGreenDots
	MOV R1, #Dot-Green-Matrix
	CALL CopyMemoryToDotM
	RET

;*****************************************************************
; Copy the Red Dots showing Home Plate to the Dot Matrix
;*****************************************************************

CopyPlateToRed:
	MOV DPTR, #PlateRedDots
	MOV R1, #Dot-Red-Matrix
	CALL CopyMemoryToDotM
	RET

;*****************************************************************
; Copy from Memory to the Dot Matrix 
; Input: DPTR = Source Memory Address
;        R1 = Dot Matrix Memory Address
;*****************************************************************

CopyMemoryToDotM:
	MOV R2, #0
CopyDotMatrixRow:
	MOV A, R2
	MOVC A, @A+DPTR
	MOV @R1, A
	INC R1
	INC R2
	CJNE R2, #8, CopyDotMatrixRow
	RET

;*****************************************************************
; Display Scores
;*****************************************************************

DisplayScores:
	MOV A, Score-Player1
	MOV DPTR, #LED-7-Segment1
	MOVX @DPTR, A
	MOV A, #0FFh
	MOV DPTR, #LED-7-Segment2
	MOVX @DPTR, A
	MOV A, Score-Player2
	MOV DPTR, #LED-7-Segment3
	MOVX @DPTR, A
	RET

	
;*****************************************************************
; Display the number of Balls, Strikes, and Outs on the Port Diode
;*****************************************************************

DispBallStrkOut:
	MOV R0, Ball-Count
	MOV R1, Strike-Count
	MOV R2, Out-Count

	MOV A, #0

CountBalls:
	CJNE R0, #0, AddBall1
	JMP CountStrikes
AddBall1:	
	ORL A, #01000000b
	CJNE R0, #1, AddBall2
	JMP CountStrikes
AddBall2:	
	ORL A, #00100000b
	CJNE R0, #2, AddBall3
	JMP CountStrikes
AddBall3:	
	ORL A, #00010000b

CountStrikes:
	CJNE R1, #0, AddStrike1
	JMP CountOuts
AddStrike1:	
	ORL A, #00001000b
	CJNE R1, #1, AddStrike2
	JMP CountOuts
AddStrike2:	
	ORL A, #00000100b

CountOuts:	;Use_Out_Count
	CJNE R2, #0, AddOut1
	JMP FinishBSO
AddOut1:	
	ORL A, #00000010b
	CJNE R2, #1, AddOut2
	JMP FinishBSO
AddOut2:	
	ORL A, #00000001b

FinishBSO:

	XRL A, #11111111b
	MOV P1, A
	RET

;*****************************************************************
; Display Player At Bat
;*****************************************************************

DisplayAtBat:
	MOV A, Player-At-Bat
	CJNE A, #1, Player2AtBat
	CALL ShowMsgPlayWGN
	RET
Player2AtBat:
	CALL ShowMsgPlayWi
	RET


;*****************************************************************
; Display Inning Number
;*****************************************************************

DisplayInningNum:
	MOV A, Inning-Number
	
CheckInning1:
	CJNE A, #1, CheckInning2
	MOV A, #0F9h
	JMP FinishInnDisp
CheckInning2:
	CJNE A, #2, CheckInning3
	MOV A, #0A4h
	JMP FinishInnDisp
CheckInning3:
	CJNE A, #3, CheckInning4
	MOV A, #0B0h
	JMP FinishInnDisp
CheckInning4:
	CJNE A, #4, CheckInning5
	MOV A, #099h
	JMP FinishInnDisp
CheckInning5:
	CJNE A, #5, CheckInning6
	MOV A, #092h
	JMP FinishInnDisp
CheckInning6:
	CJNE A, #6, CheckInning7
	MOV A, #082h
	JMP FinishInnDisp
CheckInning7:
	CJNE A, #7, CheckInning8
	MOV A, #0D8h
	JMP FinishInnDisp
CheckInning8:
	CJNE A, #8, CheckInning9
	MOV A, #080h
	JMP FinishInnDisp
CheckInning9:
	CJNE A, #9, CheckInning0
	MOV A, #090h
	JMP FinishInnDisp
CheckInning0:
	MOV A, #0C0h

FinishInnDisp:
	MOV DPTR, #Seven-Segment
	MOVX @DPTR, A
	RET


;*****************************************************************
; Copy the Bases to the Dot Matrix
;*****************************************************************

CopyBasesToDotM:
	CALL CopyBase1ToDotM
	CALL CopyBase2ToDotM
	CALL CopyBase3ToDotM
	RET

CopyBase1ToDotM:
	MOV A, Base1-Occupied
	CJNE A, #0, AddBase1
	JMP RemoveBase1

CopyBase2ToDotM:
	MOV A, Base2-Occupied
	CJNE A, #0, AddBase2
	JMP RemoveBase2

CopyBase3ToDotM:
	MOV A, Base3-Occupied
	CJNE A, #0, AddBase3
	JMP RemoveBase3

;*****************************************************************
; Add or Remove a runner at Base1, Base2, or Base3
;*****************************************************************

AddBase1:
	CALL WriteBase1Red
	RET

RemoveBase1:
	CALL EraseBase1Red
	RET

AddBase2:
	CALL WriteBase2Red
	RET

RemoveBase2:
	CALL EraseBase2Red
	RET

AddBase3:
	CALL WriteBase3Red
	RET

RemoveBase3:
	CALL EraseBase3Red
	RET

;*****************************************************************
; Write or Erase the Red or Green colors of Base1, Base2, or Base3
;*****************************************************************

WriteBase1Red:
	MOV A, #Dot-Red-Matrix
	ADD A, #Base1Row
	MOV R1, A
	MOV A, @R1
	ORL A, #Base1Bits
	MOV @R1, A
	RET

EraseBase1Red:
	MOV A, #Dot-Red-Matrix
	ADD A, #Base1Row
	MOV R1, A
	MOV A, @R1
	CPL A
	ORL A, #Base1Bits
	CPL A
	MOV @R1, A
	RET

WriteBase2Red:
	MOV A, #Dot-Red-Matrix
	ADD A, #Base2Row
	MOV R1, A
	MOV A, @R1
	ORL A, #Base2Bits
	MOV @R1, A
	RET

EraseBase2Red:
	MOV A, #Dot-Red-Matrix
	ADD A, #Base2Row
	MOV R1, A
	MOV A, @R1
	CPL A
	ORL A, #Base2Bits
	CPL A
	MOV @R1, A
	RET

WriteBase3Red:
	MOV A, #Dot-Red-Matrix
	ADD A, #Base3Row
	MOV R1, A
	MOV A, @R1
	ORL A, #Base3Bits
	MOV @R1, A
	RET

EraseBase3Red:
	MOV A, #Dot-Red-Matrix
	ADD A, #Base3Row
	MOV R1, A
	MOV A, @R1
	CPL A
	ORL A, #Base3Bits
	CPL A
	MOV @R1, A
	RET



;=================================================================
;=================================================================
;                       LCD Procedures
;=================================================================
;=================================================================


;*****************************************************************
; Clear the LCD.
; The message location is in Message-Lo-Byte & Message-Hi-Byte
; Input: None
;*****************************************************************

ClearLCD:
	MOV LCD-Instr-Mem, #Clear-LCD
	CALL WriteInstToLCD
	RET

;*****************************************************************
; Write a message to the LCD.
; The message location is in Message-Lo-Byte & Message-Hi-Byte
; Input:
;	Message-Lo-Byte
;	Message-Hi-Byte
;	Message-Length
;*****************************************************************

WriteMsgToLCD:
	MOV Message-Lo-Byte, DPL
	MOV Message-Hi-Byte, DPH
	MOV Char-Loc-Offset, #00H

WriteLCDLoop:

	CALL WriteMsgCharLCD
	MOV A, Char-Loc-Offset
	INC A
	MOV Char-Loc-Offset, A
	CJNE A, Message-Length, WriteLCDLoop

	RET

;*****************************************************************
; Write a character to the LCD at the cursor position
; Input:
;	Message-Lo-Byte
;	Message-Hi-Byte
;	Char-Loc-Offset
;*****************************************************************

WriteMsgCharLCD:
	MOV DPL, Message-Lo-Byte
	MOV DPH, Message-Hi-Byte
	MOV A, Char-Loc-Offset
	MOVC A, @A+DPTR
	MOV LCD-Data-mem, A

	CALL WriteDataToLCD

	RET

;*********************************************************************
; Print one Character on the LCD Screen. 
; The address of the character is stored in R1
; Input: R1
;*********************************************************************
WriteR1CharToLCD:
            MOV     LCD-Data-Mem, @R1
            CALL    WriteDataToLCD
            RET


;*****************************************************************
; Move the cursor 
; Input:
;	LCD-Cursor-Row
;	LCD-Cursor-Col
;*****************************************************************

MoveCurTopLeft:
	MOV LCD-Cursor-Row, #1
	MOV LCD-Cursor-Col, #2
	CALL MoveCursor
	RET

MoveCurTopCenter:
	MOV LCD-Cursor-Row, #1
	MOV LCD-Cursor-Col, #9
	CALL MoveCursor
	RET

MoveCurTopRight:
	MOV LCD-Cursor-Row, #1
	MOV LCD-Cursor-Col, #14
	CALL MoveCursor
	RET

MoveCurBotLeft:
	MOV LCD-Cursor-Row, #2
	MOV LCD-Cursor-Col, #2
	CALL MoveCursor
	RET

;*************************************************************************
; Move the cursor to the Row and Column numbers given in memory
; Input:
;	LCD-Cursor-Row
;	LCD-Cursor-Col
;*************************************************************************  
MoveCursor:
	MOV     A ,#Move-Cursor-LCD
	MOV     R2,LCD-Cursor-Row
	CJNE    R2,#01H, MoveToRow2
MoveToRow1:
	ADD     A ,#Line1-Address
	JMP     MoveToColumn                 
MoveToRow2:
	ADD     A ,#Line2-Address
MoveToColumn: 
	ADD     A ,LCD-Cursor-Col
	MOV     LCD-Instr-Mem,A 
	CALL    WriteInstToLCD
	RET

;*****************************************************************
; Write an Instruction from memory to the LCD 
; Input:
; 	LCD-Instr-mem
;*****************************************************************

WriteInstToLCD:
	CALL WaitForLCDReady ; Delay until LCD is ready

	MOV DPTR, #LCD-Write-Instr
	MOV A, LCD-Instr-mem
	MOVX @DPTR, A
	
	RET

;*****************************************************************
; Write from Data in memory to the LCD Data Register
; Input:
; 	LCD-Data-mem
;*****************************************************************

WriteDataToLCD:
	CALL WaitForLCDReady ; Delay until LCD is ready

	MOV DPTR, #LCD-Write-Data
	MOV A, LCD-Data-mem
	MOVX @DPTR, A

	RET

;*****************************************************************
; Wait until the LCD is ready
; Read from the LCD Instruction Register to the Accumulator
; If the LCD is not ready then read again.  Continue reading
; until the LCD is Ready
;*****************************************************************

WaitForLCDReady:
	    MOV DPTR, #LCD-Read-Instr
            MOVX A, @DPTR

            JB ACC.7, WaitForLCDReady
            RET



;=================================================================
;=================================================================
;                 Show Messages on the LCD
;=================================================================
;=================================================================


;*****************************************************************
; LCD Display Messages 
;*****************************************************************

ShowMsgCurveOrS:
	CALL ClearMsg
	CALL MoveCurTopLeft
	MOV DPTR, #MessageCurve
	MOV Message-Length, #16
	CALL WriteMsgToLCD
	CALL MoveCurBotLeft
	MOV DPTR, #MessageStraight
	MOV Message-Length, #14
	CALL WriteMsgToLCD
	RET

ShowMsgCurveLR:
	CALL ClearMsg
	CALL MoveCurTopLeft
	MOV DPTR, #MessageCurveL
	MOV Message-Length, #12
	CALL WriteMsgToLCD
	CALL MoveCurBotLeft
	MOV DPTR, #MessageCurveR
	MOV Message-Length, #13
	CALL WriteMsgToLCD
	RET

ShowMsgBC:
	; CALL ClearMsg
	; CALL MoveCurTopLeft
	; MOV DPTR, #MessageBench
	; MOV Message-Length, #12
	; CALL WriteMsgToLCD
	; CALL MoveCurBotLeft
	; MOV DPTR, #MessageClear
	; MOV Message-Length, #13
	; CALL WriteMsgToLCD
	; RET
	CALL ClearTopMsg
	CALL MoveCurTopLeft
	MOV DPTR, #MessageBench
	MOV Message-Length, #13
	CALL WriteMsgToLCD
	RET

ShowMsgBunt:
	CALL ClearTopMsg
	CALL MoveCurTopLeft
	MOV DPTR, #MessageBunt
	MOV Message-Length, #13
	CALL WriteMsgToLCD
	RET

ShowMsgSwingOrN:
	CALL ClearMsg
	CALL MoveCurTopLeft
	MOV DPTR, #MessageSwing
	MOV Message-Length, #15
	CALL WriteMsgToLCD
	CALL MoveCurBotLeft
	MOV DPTR, #MessageNoSwing
	MOV Message-Length, #14
	CALL WriteMsgToLCD
	RET


ShowMsgSwingHrL:
	CALL ClearMsg
	CALL MoveCurTopLeft
	MOV DPTR, #MessageSwingHigh
	MOV Message-Length, #15
	CALL WriteMsgToLCD
	CALL MoveCurBotLeft
	MOV DPTR, #MessageSwingLow
	MOV Message-Length, #14
	CALL WriteMsgToLCD
	RET

ShowMsgPressKey:
	CALL ClearBottomMsg
	CALL MoveCurBotLeft
	MOV DPTR, #MessagePressKey
	MOV Message-Length, #13
	CALL WriteMsgToLCD
	RET

ShowMsgPlay1Up:
	CALL ClearTopMsg
	CALL MoveCurTopLeft
	MOV DPTR, #MessagePlayer1Up
	MOV Message-Length, #11
	CALL WriteMsgToLCD
	RET

ShowMsgPlay2Up:
	CALL ClearTopMsg
	CALL MoveCurTopLeft
	MOV DPTR, #MessagePlayer2Up
	MOV Message-Length, #11
	CALL WriteMsgToLCD
	RET

ShowMsgPlayWGN:
	CALL ClearTopMsg
	CALL MoveCurTopLeft
	MOV DPTR, #MessageNext
	MOV Message-Length, #12
	CALL WriteMsgToLCD
	CALL ShowMsgWagner
	RET

ShowMsgPlayWi:
	CALL ClearTopMsg
	CALL MoveCurTopLeft
	MOV DPTR, #MessageNext
	MOV Message-Length, #12
	CALL WriteMsgToLCD
	CALL ShowMsgWi
	RET

ShowMsgBall:
	CALL ClearTopMsg
	CALL MoveCurTopLeft
	MOV DPTR, #MessageBall
	MOV Message-Length, #4
	CALL WriteMsgToLCD
	RET

ShowMsgWalk:
	CALL ClearTopMsg
	CALL MoveCurTopLeft
	MOV DPTR, #MessageWalk
	MOV Message-Length, #6
	CALL WriteMsgToLCD
	RET

ShowMsgStrike:
	CALL ClearTopMsg
	CALL MoveCurTopLeft
	MOV DPTR, #MessageStrike
	MOV Message-Length, #7
	CALL WriteMsgToLCD
	RET

ShowMsgStrikeOut:
	CALL ClearTopMsg
	CALL MoveCurTopLeft
	MOV DPTR, #MessageStrikeOut
	MOV Message-Length, #12
	CALL WriteMsgToLCD
	RET

ShowMsgOut:
	CALL ClearTopMsg
	CALL MoveCurTopLeft
	MOV DPTR, #MessageOut
	MOV Message-Length, #6
	CALL WriteMsgToLCD
	RET

ShowMsgFOut:
	CALL ClearTopMsg
	CALL MoveCurTopLeft
	MOV DPTR, #MessageFOut
	MOV Message-Length, #13
	CALL WriteMsgToLCD
	RET

ShowMsgSingle:
	CALL ClearTopMsg
	CALL MoveCurTopLeft
	MOV DPTR, #MessageSingle
	MOV Message-Length, #7
	CALL WriteMsgToLCD
	RET

ShowMsgDouble:
	CALL ClearTopMsg
	CALL MoveCurTopLeft
	MOV DPTR, #MessageDouble
	MOV Message-Length, #7
	CALL WriteMsgToLCD
	RET

ShowMsgTriple:
	CALL ClearTopMsg
	CALL MoveCurTopLeft
	MOV DPTR, #MessageTriple
	MOV Message-Length, #7
	CALL WriteMsgToLCD
	RET

ShowMsgHomeRun:
	CALL ClearTopMsg
	CALL MoveCurTopLeft
	MOV DPTR, #MessageHomeRun
	MOV Message-Length, #8
	CALL WriteMsgToLCD
	RET

ShowMsgDead: ;Dead ball
	CALL ClearTopMsg
	CALL MoveCurTopLeft
	MOV DPTR, #MessageDead
	MOV Message-Length, #9
	CALL WriteMsgToLCD
	RET

ShowMsgPlayYagu:
	CALL ClearTopMsg
	CALL MoveCurTopLeft
	MOV DPTR, #MessagePlay
	MOV Message-Length, #5
	CALL WriteMsgToLCD
	CALL ShowMsgYagu
	RET

ShowMsgPlayBall:
	CALL ClearTopMsg
	CALL MoveCurTopLeft
	MOV DPTR, #MessagePlayBall
	MOV Message-Length, #10
	CALL WriteMsgToLCD
	RET

ShowMsgGameOver:
	CALL ClearTopMsg
	CALL MoveCurTopLeft
	MOV DPTR, #MessageGameOver
	MOV Message-Length, #11
	CALL WriteMsgToLCD
	RET

ClearMsg:
	CALL ClearTopMsg
	CALL ClearBottomMsg
	RET

ClearTopMsg:
	CALL MoveCurTopLeft
	MOV DPTR, #MessageClear
	MOV Message-Length, #17
	CALL WriteMsgToLCD
	RET

ClearBottomMsg:
	CALL MoveCurBotLeft
	MOV DPTR, #MessageClear
	MOV Message-Length, #17
	CALL WriteMsgToLCD
	RET


;***************************************************************
;*         Define Messages
;***************************************************************

MessagePlayer1Up:
DB 'P', 'l', 'a', 'y', 'e', 'r', ' ', '1', ' ', 'U', 'p'

MessagePlayer2Up:
DB 'P', 'l', 'a', 'y', 'e', 'r', ' ', '2', ' ', 'U', 'p'

MessageNext:
DB 'N', 'e', 'x', 't', ' ', 'P', 'l', 'a', 'y', 'e', 'r', ' '

MessagePlay:
DB ' ', 'P', 'L', 'A', 'Y', ' '

MessageBall:
DB 'B', 'A', 'L', 'L'

MessageWalk:
DB 'W', 'A', 'L', 'K', '!', '!'

MessageStrike:
DB 'S', 'T', 'R', 'I', 'K', 'E', '!'

MessageStrikeout:
DB 'S', 'T', 'R', 'I', 'K', 'E', 'O', 'U', 'T', '!', '!', '!'

MessageOut:
DB 'O', 'U', 'T', '!', '!', '!'

MessageFOut:
DB 'F','O','U','L', ' ', 'F', 'L', 'Y', ' ', 'O','U','T','!'

MessageSingle:
DB 'S', 'I', 'N', 'G', 'L', 'E', '!'

MessageDouble:
DB 'D', 'O', 'U', 'B', 'L', 'E', '!'

MessageTriple:
DB 'T', 'R', 'I', 'P', 'L', 'E', '!'

MessageHomeRun:
DB 'H', 'O', 'M', 'E', 'R', 'U', 'N','!'

MessageDead: ;Dead ball
DB 'D', 'E', 'A', 'D', 'B', 'A','L','L', '!'

MessagePlayBall:
DB 'P', 'L', 'A', 'Y', ' ', 'B', 'A', 'L', 'L', '!'

MessageGameOver:
DB 'G', 'A', 'M', 'E', ' ', 'O', 'V', 'E', 'R', '!', ' '

MessageClear:
DB ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '

MessageCurve:
DB 'P', 'i', 't', 'c', 'h', 'e', 'r', ':', ' ', '0', '.', 'C', 'U', 'R', 'V', 'E'

MessageStraight:
DB 'o', 'r', ' ', ':', '1', '.', 'S', 'T', 'R', 'A', 'I', 'G', 'H', 'T'

MessageCurveL:
DB '2', '.', 'C', 'U', 'R', 'V', 'E', ' ', 'L', 'E', 'F', 'T'

MessageCurveR:
DB '3', '.', 'C', 'U', 'R', 'V', 'E', ' ', 'R', 'I', 'G', 'H', 'T'

MessageBench:
DB ' ', ' ', 'B', 'E', 'N', 'C', 'H', ' ', 'C', 'L', 'E', 'A','R'

MessageBunt:
DB 'B', 'U', 'N', 'T', ' ','B','U','T',' ','B','A','L','L'

MessageSwing:
DB 'B', 'a', 't', 't', 'e', 'r', ':', ' ', '4', '.', 'S', 'W', 'I', 'N', 'G'

MessageNoSwing:
DB 'o', 'r', ' ', ':', '5', '.', 'N', 'O', ' ', 'S', 'W', 'I', 'N', 'G'

MessageSwingHigh:
DB ' ', ' ', 'S', 'W', 'I', 'N', 'G', ' ', '6', '.', 'H', 'I', 'G', 'H', ' '
;Here_Swing
MessageSwingLow:
DB 'o', 'r', ' ', ':', '7', '.', ' ', ' ', ' ', 'L', 'O', 'W', ' ', ' '

MessagePressKey:
DB 'P', 'r', 'e', 's', 's', ' ', 'a', 'n', 'y', ' ', 'K', 'e', 'y'

MessageVs:
DB ' ', 'v', 's', '.', ' '




;=================================================================
;=================================================================
;                 Show Hangul on the LCD
;=================================================================
;=================================================================

;*********************************************************************
; Print a Hangul Message
;*********************************************************************

ShowMsgYagu:
	CALL StartHangul
	CALL InstallYagu
	CALL InstallWagner
	CALL InstallWi
	CALL MoveCurTopCenter
	CALL PrintYagu
	RET

ShowMsgWagner:
	CALL StartHangul
	CALL InstallWagner
	CALL MoveCurTopRight
	CALL PrintWagner
	RET

ShowMsgWi:
	CALL StartHangul
	CALL InstallWi
	CALL MoveCurTopRight
	CALL PrintWi

ShowMsgWvsW:
;	CALL StartHangul
	CALL MoveCurBotLeft
	CALL PrintWagner
	MOV DPTR, #MessageVs
	MOV Message-Length, #5
	CALL WriteMsgToLCD
	CALL PrintWi
	RET

	RET

;*********************************************************************
; Prepare for Displaying Hangul on the LCD
;*********************************************************************

StartHangul:
	CALL    Send-CGRAM-Start
	MOV     CGRAM-Address, #00H
	RET

;*********************************************************************
; Prepare to send font data to CGRAM memory in the LCD
; Set the CGRAM Address to the beginning of CGRAM Memory
;*********************************************************************
Send-CGRAM-Start:
            MOV     LCD-Instr-Mem, #Start-CGRAM-LCD 
            CALL    WriteInstToLCD          
            RET


;*********************************************************************
; Install each Hangul Character into the LCD Screen
; There can be a maxiumum of 8 character fonts installed
;*********************************************************************

InstallYagu:
	CALL Install-YA
	CALL Install-GU
	RET

InstallWagner:
	CALL Install-WA
	CALL Install-GEU
	CALL Install-NEO
	RET

InstallWi:
	CALL Install-WI
	CALL Install-DAE
	CALL Install-EUN
	RET

;*********************************************************************
; Print a Hangul Message
;*********************************************************************

PrintYagu:
	MOV	R1,#Char-Code-YA
	CALL	WriteR1CharToLCD
	MOV	R1,#Char-Code-GU
	CALL	WriteR1CharToLCD
	RET

PrintWagner:
	MOV	R1,#Char-Code-WA
	CALL	WriteR1CharToLCD
	MOV	R1,#Char-Code-GEU
	CALL	WriteR1CharToLCD
	MOV	R1,#Char-Code-NEO
	CALL	WriteR1CharToLCD
	RET

PrintWi:
	MOV	R1,#Char-Code-WI
	CALL	WriteR1CharToLCD
	MOV	R1,#Char-Code-DAE
	CALL	WriteR1CharToLCD
	MOV	R1,#Char-Code-EUN
	CALL	WriteR1CharToLCD
	RET

;*********************************************************************
; Install a hangul character into LCD CGRAM Memory
; Input: CGRAM-Address
;*********************************************************************
Install-WI:
            MOV DPTR, #FONT_WI
            MOV R1, #Char-Code-WI
            JMP InstallChar
Install-DAE:
            MOV DPTR, #FONT_DAE
            MOV R1, #Char-Code-DAE
            JMP InstallChar
Install-EUN:
            MOV DPTR, #FONT_EUN
            MOV R1, #Char-Code-EUN
            JMP InstallChar
Install-GU:
            MOV DPTR, #FONT_GU
            MOV R1, #Char-Code-GU
            JMP InstallChar
Install-GEU:
            MOV DPTR, #FONT_GEU
            MOV R1, #Char-Code-GEU
            JMP InstallChar
Install-WA:
            MOV DPTR, #FONT_WA
            MOV R1, #Char-Code-WA
            JMP InstallChar
Install-YA:
            MOV DPTR, #FONT_YA
            MOV R1, #Char-Code-YA
            JMP InstallChar
Install-NEO:
            MOV DPTR, #FONT_NEO
            MOV R1, #Char-Code-NEO
            JMP InstallChar
Install-BLANK:
            MOV DPTR, #FONT_BLANK
            MOV R1, #Char-Code-BLANK
            JMP InstallChar

InstallChar:
           MOV @R1, CGRAM-Address
           INC CGRAM-Address
           CALL InstalCharFont
           RET

;*********************************************************************
; Install one character font into the LCD CGRAM Memory
; Input: DPTR
;*********************************************************************
InstalCharFont:
            MOV     Font-Lo-Byte, DPL
            MOV     Font-Hi-Byte, DPH
            MOV     Font-Row-Num, #00H
NextRow:
            CALL    Install-FONT_ROW     
            INC     Font-Row-Num         
            MOV     A, Font-Row-Num
            CJNE    A, #Font-Row-Max, NextRow
            RET

;*********************************************************************
; Install one row of a character font into the LCD Screen
; Input: Font-Lo-Byte, Font-Hi-Byte, Font-Row-Num
;*********************************************************************
Install-FONT_ROW:
                  MOV     DPL, Font-Lo-Byte
                  MOV     DPH, Font-Hi-Byte
                  MOV     A, Font-Row-Num
                  MOVC    A, @A+DPTR                 
                  MOV     LCD-Data-Mem, A
                  CALL    WriteDataToLCD
                  RET        

;***************************************************************
;*         Define Fonts
;***************************************************************


FONT_YA:
            DB 00000000B
            DB 00000010B
            DB 00001011B
            DB 00010110B
            DB 00001011B
            DB 00000010B
            DB 00000010B
            DB 00000000B
FONT_GU:
            DB 00000000B
            DB 00011110B
            DB 00000010B
            DB 00000000B
            DB 00011111B
            DB 00000100B
            DB 00000100B
            DB 00000000B
FONT_WA:
            ; DB 00010101B
            ; DB 00010101B
            ; DB 00010101B
            ; DB 00011101B
			; DB 00000000B
            ; DB 00011110B
            ; DB 00000010B
            ; DB 00000010B
            DB 00010110B
            DB 00011111B
            DB 00010110B
            DB 00011110B
			DB 00000000B
            DB 00011110B
            DB 00000010B
            DB 00000010B

FONT_GEU:
            DB 00000000B
            DB 00011101B
            DB 00001001B
            DB 00010101B
            DB 00000000B
            DB 00010000B
            DB 00011111B
            DB 00000000B
FONT_NEO:
            DB 00000100B
            DB 00001010B
            DB 00000100B
            DB 00000000B
            DB 00011111B
            DB 00000100B
            DB 00000100B
            DB 00000000B
FONT_WI:
            DB 00011101B
            DB 00001001B
            DB 00010001B
            DB 00000000B
            DB 00001110B
            DB 00001010B
            DB 00001110B
            DB 00000000B
FONT_DAE:
            DB 00011101B
            DB 00010101B
            DB 00011111B
            DB 00010101B
            DB 00011101B
            DB 00000000B
            DB 00000000B
            DB 00000000B
FONT_EUN:
            DB 00000100B
            DB 00001010B
            DB 00000100B
            DB 00011111B
            DB 00010101B
            DB 00010000B
            DB 00011111B
			DB 00000000B
FONT_BLANK:
            DB 00000000B
            DB 00000000B
            DB 00000000B
            DB 00000000B
            DB 00000000B
            DB 00000000B
            DB 00000000B
            DB 00000000B

; Play the notes
; SONGMAXPOS is the number of notes to play
; SONGCURRENTPOS is incremented after each note until SONGMAXPOS is reached

PlayGameSong:
		MOV SONGMAXPOS, #12
		MOV SONGCURRENTPOS, #0

PLAYNEXTNOTE:
		CALL PLAYNOTE

		INC SONGCURRENTPOS

		MOV A, SONGCURRENTPOS
		CJNE A, SONGMAXPOS, PLAYNEXTNOTE

		RET

; Play a note for NOTELENGTH duration 
; The buzzer alternates on and off for ONTIME duration and OFFTIME duration
; When NOTECOUNTERHI becomes 0, stop playing the note

PLAYNOTE:	CALL GETNOTEPERIOD
		MOV NOTECOUNTERHI, #NOTELENGTH

PLAYLOOP:	CALL TURNONBUZZER
		MOV DELAYLENGTH, ONTIME
		CALL NoteDelay

		CALL TURNOFFBUZZER
		MOV DELAYLENGTH, OFFTIME
		CALL NoteDelay

		MOV R1, #NOTECOUNTERHI
		CJNE @R1, #0, PLAYLOOP
		RET

; Copy the Note Period from Code Memory to ONTIME and OFFTIME
; Copy 10 to ONTIME.  Copy NOTEPERIOD - 10 to OFFTIME

GETNOTEPERIOD:
		MOV ONTIME, #ONTIMELENGTH

		MOV A, SONGCURRENTPOS
		MOV DPTR, #NOTEPERIODS
		MOVC A, @A+DPTR
		SUBB A, #ONTIMELENGTH
		MOV OFFTIME, A

		RET

; Turn on or off the Buzzer

TURNONBUZZER:
		MOV DPTR, #BUZZER
		MOV A, #10000000B
		MOVX @DPTR, A
		RET

TURNOFFBUZZER:
		MOV DPTR, #BUZZER
		MOV A, #00000000B
		MOVX @DPTR, A
		RET

; Delay for the duration in DELAYLENGTH
; Count down the time remaining to play this note during this time
; If either NOTECOUNTERHI or DELAYLENGTH reaches 0 then return

NoteDelay:
		MOV R7, DELAYLENGTH
		MOV R1, #NOTECOUNTERHI
DELAYLOOP:
		CALL DECNOTECOUNTER
		CJNE @R1, #0, DELAYCONTINUE
		RET
DELAYCONTINUE:
		DJNZ R7, DELAYLOOP
		RET

; Decrement the two byte value of the time remaining to play this note.
; This value is composed of NOTECOUNTERHI || NOTECOUNTERLO,
; First decrement NOTECOUNTERLO. If NOTECOUNTERLO reaches 0, decrement 
; NOTECOUNTERHI, and reset NOTECOUNTERLO to FFh

DECNOTECOUNTER:
		MOV R5, NOTECOUNTERHI
		MOV R6, NOTECOUNTERLO
		DJNZ R6, DECNOTERETURN

		DEC R5
		MOV NOTECOUNTERHI, R5
		MOV R6, #0FFH
DECNOTERETURN:
		MOV NOTECOUNTERLO, R6
		RET



; ======================================
; Note Periods
; ======================================


; ------- Notes on the Scale -------

; 
; ----------------------------
;                                             
; ----------------------------
;                        O
; --------------------O-------
;                  O
; --------------O-------------
;            O
; --------O-------------------
;      O
;  -O-

; Note
;   C  D  E  F  G  A  B  C

; Note Period
; 106 94 84 79 70 62 55 52

; ================================================
; ========= TAKE ME OUT TO THE BALL GAME =========
; ================================================

NOTEPERIODS:
	DB 106, 106, 52, 62, 70, 84, 70, 70, 70, 94, 94, 94

END


