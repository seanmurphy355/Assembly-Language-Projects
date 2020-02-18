TITLE Project Six Cs271 Introduction to MASM  (Masam.asm)
; Author: Sean Murphy
; Last Modified: 12/02/19
; Course / Project Number : CS_271, Program #6 A
; OSU email address: Murphsea@oregonstate.edu
; Due Date:12/08/19
; Discrption: This program will take in a unsigned integer value and readval will accpet a numeric string of some sort to do this
; user will enter a string such as 1234 and it would compute and be stored in the requested OFFSET.
; WriteVal will preform the opposite transofrmation. I will implement a macro called get string that will display a prompt and then grab and 
; store the string in a certain memory location the program will get 10 valid user ints and then store them in a numeric arrayand then will display the
; list of ints their sum and the average value of the list
INCLUDE Irvine32.inc

;constants
VALUE_SIZE = 10;max value size of int
N_Values = 10 ;Max number of userinputs
Size_Of_Strings = 15

;Irvine Macro (displayString) will change the edx register and basicly takes in the address of an output location and then prints the string that it stored at that memory address
;It has no return values or paramaters that it requires  other than the mem location of a string. 	;Refer to lecture 26 for this macro....has no pre conditions to excute other than the call 
displayString	MACRO	Value
	push	edx
	mov		edx,OFFSET Value
	call	WriteString
	pop		edx
ENDM

;Irvine Macro (getString) will change the ecx, edx, eax registers This macro will take in a user string and then will give a memory location
;(parameter) it will return a strings length to the eax register and will will take in string to be displayed, string length and userinput
;has no pre conditions to excute other than the call 
getString      MACRO    Buffer,String  
     push      ecx
     push      edx
     displayString String ;Gives user a string
     mov       edx,OFFSET Buffer ;Stores user Input
     mov       ecx,(SIZEOF Buffer) - 1                                     
     call      ReadString
     pop       edx
     pop       ecx
ENDM
;Irvine Macro (displayString) will change the edx register and basicly takes in the address of an output location and then prints the string that it stored at that memory address
;It has no return values or paramaters that it requires  other than the mem location of a string. 	;Refer to lecture 26 for this macro....has no pre conditions to excute other than the call 
;doesnt use offset
displayotherString	MACRO	Value
	push	edx
	mov		edx,Value
	call	WriteString
	pop		edx
ENDM

.data

UserList	DWORD	N_Values DUP(?)		;an array that will be used as a storage bin for user inputs
ConString	BYTE	Size_Of_Strings DUP(?) ; storage Bin for converting string content
Intro_One 	BYTE	"Demonstrating low-level I/O procedures", 0 ;These intro strings will display to the user the what the program will do functionally 
Intro_Two	BYTE	"Written by: Sean Murphy", 0 ;author name
Intro_Three	BYTE	"Please provide 10 decimal integers.", 0
Intro_Four	BYTE	"Each number needs to be small enough to fit inside a 32 bit register.", 0
Intro_Five	BYTE	"After you have finished inputting the raw numbers I will display a list.", 0
Intro_Six	BYTE	"of the integers, their sum, and their average value.",0
NiceDAy		BYTE	"Thanks for playing!Have a nice Day!",0 ;Prints the exit statement back to the user!
Value		DWORD	? ;will store sum of user values
Error		BYTE	"ERROR: You did not enter an integer number or your number was too big.",0 ;this tells the user they did not enter the correct input
TryAgain	BYTE	"Please try again:",0; try again tells the user to give another try for input.
GrabValue	BYTE	"Please enter an integer number: ",0 ;Asks the user to enter in a value 
HereIsList	BYTE	"You entered the following numbers: ",0 ; string used to display list of values to user
GrabSize	BYTE	21 DUP(?); a array of bytes
lengthV		DWORD	0 ;place holder
sumOfInput	DWORD	?
mySize		DWORD	0 ;place holder
LoopHolder	DWORD	0 ;place holder
NumericSpacer BYTE  " . ",0 ;formating
GiveComma	BYTE	",",0  ;formating
StorageArray DWORD	VALUE_SIZE DUP(?) ;potential bin
stringConversion BYTE  N_Values  DUP(?) ;potential bin
PrintSum BYTE "The sum of these numbers is: ",0;gives sum statement to user
printAverage BYTE "The average is: ",0;string for print average text


.code
main PROC
	
	call	introduction; Will print out the introduction strings to the user all above push values are the mem locations of the strings.

	mov		ecx,N_Values ;set ecx to amount of loops we want from our proc
	mov		edi,OFFSET StorageArray 

	ReadInVals:; read in user numeric strings
	push    LoopHolder 
    push    OFFSET UserList  ;push Ref to user list                                  
    call    ReadVal  ; Read in a user string and then It will convert the digit string to numeric, while validating the user’s input
    inc     LoopHolder
	loop	ReadInVals

	
	mov		esi, OFFSET UserList ;set esi to ref userList
	mov     edi, OFFSET ConString ;set edi to ref empty string
	mov	    ecx, N_Values 
	
	call	crlf
	displayString HereIsList;display the initial list string
	call	crlf

printStringValues:;prints the transformed string value as a loop.
	push	[esi]
	push	edi
    call    WriteVal;writeVals will perform the opposite transformation from into to string
	cmp		ecx,2
	jl		GenerateSum  ;leave loop after 10 prints so we dont get the extra comma
	displayString  GiveComma
	add		esi,4
	loop	printStringValues

GenerateSum:
	push	OFFSET ConString ;passing ref to constring
	push	OFFSET UserList ;passing ref to array list
	push	OFFSET sumOfInput ;bin value ref
	call	UserSum ; will calculate the sum of the users inputs and display it

	push	OFFSET ConString ;passing ref to constring
	push	OFFSET UserList  ;passing ref to array list
	push	OFFSET sumOfInput  ;bin value ref
	call	Average ;will print the average of the of the user inputs


	call	Finished ;Will print out the exit statement for the program to let the user know that the desired task has been completed
	exit	; exit to operating system
main ENDP

;parameters being sent are some pre built strings +  It uses the displayString macro in order to print these strings.
;This Procedure will carry out the introduction of this program! giving the user basic info on the progams purpose!no pre or post conditions just called ,changes ebx content as well as ebp,esp,edx in order to grab strings by reference
introduction	PROC
	mov		ebp, esp  ;keep additional usage of the stack within the procedure from invalidating the stack Offset
	push	ebp

	displayString	Intro_One 	;gives a mem location of a string
	call	Crlf
	displayString	Intro_Two 	;gives a mem location of a string
	call	Crlf
	call	Crlf
	displayString	Intro_Three	;gives a mem location of a string and then gives it to the displayString macro to carry out the print statements.
	call	Crlf
	displayString	Intro_Four	
	call	Crlf				;Prints out White space
	displayString	Intro_Five 	
	call	Crlf
	displayString	Intro_Six
	call	Crlf
	call	crlf

	pop		ebp
	ret		;clean up
introduction	ENDP


;ReadVal will invoke the getString macro to get the user’s string of digits. It will then convert the digit string to numeric, while validating the user’s input.
;This Procedure will also carry out any data validation that is required returns a numnber	and contains no pre or post conditions other then
;all other calls excute fine before this call...returns a filled user array to the stack as uses the input that user gives as a string parameter it changes the eax,edx,ebx,esi,eax,ecx registers
ReadVal PROC

    pushad
    mov		ebp, esp  ;keep additional usage of the stack within the procedure from invalidating the stack Offset
	push	ebp
	push	edx  ;push items to stack
	push	ecx
	push	edi

GrabValidInt: ;Ask user for a valid integer see if the int is valid if not then this gets called again and takes in the first 10 valid ints

	displayString NumericSpacer
	getString GrabSize, GrabValue
    jmp		CheckStringContenet                 
	 
InvalidStringValue:   ;Will give the user error messages using the displayString macro and will jump to grabing a valid int                              
    displayString Error	
	displayString TryAgain
	call	crlf
	jmp		GrabValidInt  

CheckStringContenet: 
    mov		mySize, eax
    mov		ecx, eax
    mov		esi, OFFSET GrabSize	
    mov		edi, OFFSET Value	

Sort:        ;Checks digits                 
    lodsb
	cmp		al,58                         
    jge		InvalidStringValue
    cmp		al,47         ;Make Sure we are in valid range for a ascii value if not jmp to grabvalid int and try again ascii values are between 
    jle		InvalidStringValue                       
    loop	Sort ;check each value to make sure each char is within range to be a valid integer
    jmp		ValidInput                    


ValidInput:   ;if the input is valid then check to see if that input is 32 bits if not go again pareDecimal32 will check to see if its a valid size if not it will turn on the carry flag
    mov     edx, OFFSET GrabSize	
    mov     ecx, mySize
    call    ParseDecimal32    ;returns a 32-bit signed integer equivalent to the specified value            
    .IF CARRY?                              
    jmp     InvalidStringValue  ;if carry flag is on then jump to invalid value
	
    .ENDIF
    mov		edi, [ebp+36]                  
    mov     ebx, [ebp+40]                 
    imul    ebx, 4                       
    mov    [edi+ebx], eax    ;Place the new user input into the array and store it.           

EndOfProcedure:
	popad
	pop		edx
	pop		ebp ; get stack items
	pop		ecx ; restore the top of the stack for edx,ebx,edi,eax,ebp
	pop		edi
   
    ret       8;cleanup
ReadVal ENDP


;WriteVal . WriteVal will perform the opposite transformation. 
;For example, WriteVal can accept a 32 bit unsigned int and display the corresponding ASCII representation on the console
;(e.g. if WriteVal receives the value 49858 then the text "49858" will be displayed on the screen).
;Write val take in references to the edi,and the esi registers and there contents and changes the contents of the eax,al,edx,ebx registers. It will get passed converted numeric data and convert it back into strings
;It requires edi and esi as parameters and there are no notable pre or post conditions other then the proc call and that all other procs run without before this proc is
;called
WriteVal PROC
	push	ebp
	mov		ebp, esp  ;keep additional usage of the stack within the procedure from invalidating the stack Offset
	; convert number to string
	mov		eax, [ebp+12]	;set to array
	mov		edi, [ebp+8]	;set to storage bin that will be used for string
	add		edi,Size_Of_Strings
	dec		edi	
	std						
	mov		ebx, 10		;the Divirder value must be 10 when converting
	push	eax
	mov		al, 0
	stosb			;stores a byte from the AL register into the destination operand.
	pop		eax

	ConvertToString:
	mov		edx, 0
	div		ebx				;divide by 10
	add		edx, 48			;CharCode Conversion
	push	eax
	mov		eax, edx
	stosb					
	pop		eax				; restore eax
	cmp		eax, 0			; Check that value of the quotient if zero then we are finished if not continue the loop
	jne		ConvertToString		
	
	inc		edi	
	displayotherString	edi ;display The converted content in string format (though I had to make a second macro for this because it did not like OFFSET
	pop		ebp

	
	ret		8;cleanup
WriteVal ENDP




;UserSum proc will generate the sum of the users input and then call writeval in order to have the value displayed as a string.
;The procedure requires a string bin, an int bin and a user array with values. This procedure will change the contents of ebp,eax,ecx,esi,edi and the ebx registers
;The procedure will return the user sum only as a print statement though and this procedure has no pre conditions other then the correct data values are passed to it
UserSum	Proc
	Push	ebp
	mov		ebp,esp  ;keep additional usage of the stack within the procedure from invalidating the stack Offset
	call	crlf
	displayString PrintSum ;print statement for the sum of the values
	
	mov		eax,0
	mov		ecx,N_Values 
	mov		esi,[ebp+12]
	mov		edi,[ebp+16]
	mov		ebx,[ebp+8]

	AddElement: ;adds elements in order to generate the sum of each value
	add		eax, [esi]		
	add		esi, 4
	loop	AddElement

	push	eax
	push	ebx
	call	writeVal ;push the newly generated sum to writeval to convert it

	pop		ebp
	ret		16 ;clean up 
UserSum	ENDP	



;Average Proc will take in the user filled array and generate the average of those values this procedure utilizes the writeval procedure as well
;The procedure requires a string bin, an int bin and a user array with values. This procedure will change the contents of ebp,eax,ecx,esi,edi and the ebx registers
;The procedure will return the user average only as a print statement though and this procedure has no pre conditions other then the correct data values are passed to it
Average Proc

	Push	ebp
	mov		ebp,esp   ;keep additional usage of the stack within the procedure from invalidating the stack Offset
	
	call	crlf
	displayString printAverage ;print statement for average value

	mov		eax,0
	mov		ecx,N_Values ;set regi to desired values(via ref)
	mov		esi,[ebp+12]
	mov		edi,[ebp+16]

AddElement: ;adds elements in order to generate the sum of each value
	add		eax, [esi]		
	add		esi, 4
	loop	AddElement

	mov		edx,0
	mov		ebx,10   ;set to total number of inputs before division takes place
	div		ebx

	mov		edx,[ebp+8]	
	push	eax         
	push	edx
	call	writeVal ;push the newly generated Average to writeval to convert it

	pop		ebp
	ret		16 ;clean up 
Average		ENDP

;lets the user know that the program is over this procedure changes only the content of the ebp,esp regis the pre condition is only that all other procedures have been called and excuted
;this procedure just displays the exiting string back to the user. It does use  
Finished	PROC

	call	Crlf
	displayString	NiceDAy		
	call	Crlf
	ret	 ;clean up

Finished	ENDP

END main