
.MODEL SMALL
.STACK 100H
.DATA

 msg1 DB 0DH,0AH, ' - Health Conference Ticket Application - $'

 msg2 DB 0DH,0AH,0DH,0AH,' 1.Book a ticket $'
 msg3 DB 0DH,0AH,' 2.Calculate the price $'
 msg4 DB 0DH,0AH,' 3.Exit the application $'
 msg5 DB 0DH,0AH,0DH,0AH,' YOUR SELECTION (WHEN FINISH 0): $'
 msg6 DB 0DH,0AH,0DH,0AH,' How many tickets would YOU like to buy $' ,0DH,0AH
 msg7 DB 0DH,0AH,0DH,0AH,' PRESS ANY KEY TO RETURN MENU: $'

 TICKETS db " TICKETS: ",0DH,0AH
 DB "      | TICKET              | Price      ",0DH,0AH
 DB "  ****|*********************|************",0DH,0AH
 DB "   1  |Medical Student      | 300 RS     ",0DH,0AH
 DB "  ****|*********************|************",0DH,0AH
 DB "   2  |Resident Doctor      | 500 RS     ",0DH,0AH
 DB "  ****|*********************|************",0DH,0AH
 DB "   3  |Specialist Doctor    | 1300 RS    ",0DH,0AH,0DH,0AH, '$';
 DB "  ***************************************",0DH,0AH,0DH,0AH,'$'
  
 Invoice DB 0DH,0AH,0DH,0AH,'YOUR TOTAL INVOICE : $'
 Discount DB 0DH,0AH,0DH,0AH,'YOUR HAVE DISCOUNT 50% $'
 Discount_code DB 0DH,0AH,0DH,0AH,'DO YOU HAVE DISCOUNT CODE (50%) PRESS 1 : $'

 TOTAL DW 0 ;use double word bc the number are big
 Discount_50 DW 50  ; *50%100= x - real number
 D100 DW 100

 .CODE
 MAIN PROC

 MOV ax, @data
 MOV ds, ax

 The_start: ;label

 LEA DX, msg1 ; load and print msg1
 MOV AH,9
 INT 21H

 LEA DX, msg2 ; load and print msg2=A.Book a ticket
 MOV AH,9
 INT 21H

 LEA DX, msg3 ; load and print msg3=B.Calculate the price
 MOV AH,9
 INT 21H

 LEA DX, msg4 ; load and print msg4=C.Exit the application
 MOV AH,9
 INT 21H

 LEA DX, msg5 ; load and print msg5=YOUR SELECTION (WHEN FINISH 0):
 MOV AH,9
 INT 21H

 MOV AH , 1 ; read a first CHOICE from user
 INT 21H

 CMP AL,"1" ; comper
 JE book    ; go to label book
 
 CMP AL,"2"
 JE calculate
 
 CMP AL,"3"
 JE Exit

 JMP The_start ; if the use inter any key 
 
 book:
 
 LEA dx, TICKETS ; load
 mov ah, 9
 int 21h

 In_LOOP:

 LEA DX, msg5 ; load and print MSG_5=YOUR SELECTION
 MOV AH,9
 INT 21H

 MOV AH , 1 ; Dispy the choose of user
 INT 21H
 
 CMP AL,"0"    ;will go to the start
 JE The_start

 CMP AL,"1"    ;will comper the user input if equle = 1 then go to price_300 lable
 JE Price_300
 
 CMP AL,"2"   ;use the registre AL for arthmitic number
 JE Price_500
 
 CMP AL,"3"
 JE Price_1300

 Price_300:
 MOV BX,300    ;save 300 to BX (general registre) then jump to num_tickets
 JMP num_tickets
 
 Price_500:
 MOV BX,500
 JMP num_tickets

 Price_1300:
 MOV BX,1300
 JMP num_tickets
 
 num_tickets:

 LEA DX, msg6 ;load and print MSG6=How many tickets would YOU like to buy 
 MOV AH,9
 INT 21H

 CALL INDEC ;number of tickets
 MUL BX     

 ADD TOTAL,AX

 JMP In_LOOP ;jump to loop

 calculate:  ;lable
 
 LEA DX, invoice ; load 
 MOV AH,9        ;Display to the user
 INT 21H

 MOV AX, TOTAL
 CALL OUTDEC

 LEA DX, Discount_code ;if user have dicound or not
 MOV AH,9
 INT 21H

 MOV AH , 1  ;read a first CHOICE
 INT 21H

 CMP AL,"1"  ;comper if the enter of user equl 1 go label Disply
 JNE Disply

 LEA DX, Discount ; load and print MSG_0
 MOV AH,9
 INT 21H

 MOV AX,TOTAL  
 MUL Discount_50
 DIV D100 ; (TOTAL=300)*50/100 =150 value of dicound
 SUB TOTAL, AX ;300-(AX=150)=150 

 Disply:

 LEA DX, Invoice ;load and print masge YOUR TOTAL INVOICE
 MOV AH,9
 INT 21H

 MOV AX, TOTAL
 CALL OUTDEC ;larg number
 
 LEA DX, msg7 ;load masge PRESS ANY KEY TO RETURN MENU
 MOV AH,9
 INT 21H

 MOV AH , 1 ; read user CHOICE
 INT 21H

 JMP The_start ; if press any key go to start

 Exit:

 MOV AH, 4CH ; return control to DOS
 INT 21H

 MAIN ENDP
 
 
 
;-------------outdec---------
 OUTDEC	PROC
PUSH	AX
PUSH	BX
PUSH	CX
PUSH	DX
OR	AX,AX
JGE	@END_IF1
PUSH	AX
MOV	DL,'-'
MOV	AH,2
INT	21H
POP	AX
NEG	AX
@END_IF1:
XOR	CX,CX
MOV	BX,10D
@REPEAT1:
XOR	DX,DX
DIV	BX
PUSH	DX
INC	CX
OR	AX,AX
JNE	@REPEAT1
MOV	AH,2
@PRINT_LOOP:
POP	DX
OR	DL,30H
INT	21H
LOOP	@PRINT_LOOP
POP	DX
POP	CX
POP	BX
POP	AX

RET
OUTDEC	ENDP
INDEC	PROC
;READ dec number
PUSH	BX
PUSH	CX
PUSH	DX

@BEGIN:
MOV	AH,2
MOV	DL,':'
INT	21H
XOR	BX,BX
XOR	CX,CX

MOV	AH,1
INT	21H
CMP	AL,'-'
JE	@MINUS
CMP	AL,'+'
JE	@PLUS	
JMP	@REPEAT2
@MINUS:
MOV	CX,1
@PLUS:
INT	21H
@REPEAT2:
CMP	AL,'0'
JNGE	@NOT_DIGIT
CMP	AL,'9'
JNLE	@NOT_DIGIT
AND	AX,000FH
PUSH	AX
MOV	AX,10
MUL	BX
POP	BX

ADD	BX,AX
MOV	AH,1
INT	21H
CMP	AL,0DH
JNE	@REPEAT2
MOV	AX,BX
OR	CX,CX
JE	@EXIT
NEG	AX
@EXIT:
POP	DX
POP	CX
POP	BX
RET
@NOT_DIGIT:
MOV	AH,2
MOV	DL,0DH
INT	21H
MOV	DL,0AH
INT	21H
JMP	@BEGIN
INDEC	ENDP
;end

 END MAIN

