
                         
include emu8086.inc
org 100h 
.data
MSG1 DB "please enter time",0Dh,0Ah, "$"
msg2 DB ,0Dh,0Ah,"please enter day",0Dh,0Ah, "$"
msg3 DB ,0Dh,0Ah,"please enter date",0Dh,0Ah, "$"
arrtime DB 11 dup(?),'$' 
arrday DB 10 dup(?),'$'
arrdate DB 11 dup(?),'$'
;-------------------------------------------  
daysOfWeek db "Saturday$", "Sunday$","Monday$", "Tuesday$", "Wednesday$","Thursday$","Friday$" 
 lengthofDay db  9 , 7 , 7 , 8 , 10 , 9 , 7  
 dayIndex db 0  ; from 0 to 6  
 ;------------------------------------
 
  monthsOfYear db "Jan$","Feb$", "Mar$", "Apr$","May$","June$","July$","Aug$","Sept$","Oct$","Nov$","Dec$" 
 
  lengthofMonth db 4 , 4 , 4 , 4 , 4 , 5 , 5 , 4 , 5 , 4 , 4 ,4 
  
  monthIndex2 db 0   ; from 0 to 11
  ;---------------------------------------
.code 
MOV AH,9
Mov DX , offset MSG1 ;print please enter time  '.
INT 21H
;-----------------
mov cx , 11
mov si,0 
Entertime:
mov ah,1
int 21h
Sub al,30h
mov arrtime[si],al
inc si
    loop Entertime     
;----------------- 
MOV AH,9
Mov DX , offset MSG2 ;print please enter day  '.
INT 21H
;-----------------

mov si,0 
Enterday:
mov ah,1
int 21h
mov arrday[si],al
inc si
     cmp al ,'y'
      jnz Enterday
;-----------------
MOV AH,9
Mov DX , offset MSG3 ;print please enter data  '.
INT 21H
;-----------------
mov cx , 11
mov si,0 
Enterdata:
mov ah,1
int 21h
Sub al,30h
mov arrdate[si],al
inc si
    loop Enterdata
;-------------------------------
call display 
;------------------------------- 
mov cx , 0
digit1s:
mov al, arrtime[7] 
add al ,30h  
   cmp al , '9'
     jz  digit2s      
 inc arrtime[7]
 call disp_time
   loop digit1s
;-------------------------------
digit2s:
mov arrtime[7],0    ;zero of digit 1s     
mov al, arrtime[6]
  cmp al , 5         ;if digit2s = 5 
    jz digit1m        ; jmp digit1m bacuse inc 
inc arrtime[6]      ;else inc digit2s
  call disp_time
  cmp al , 5        ;if digit2s not = 5 jmp digit1s repeat steps
    jnz digit1s
;--------------------------------
digit1m:
mov arrtime[6],0         ;zero of digit 2s
           
mov al, arrtime[4]      
  cmp al ,9             ;if digit1s = 9
   jz digit2m           ; jmp digit2m bacuse inc 
inc arrtime[4]
   call disp_time
  cmp al ,9             ;if digit2s not = 5 jmp digit1s repeat steps
    jnz digit1s
;-------------------------------

digit2m:
mov arrtime[4],0
        
mov al, arrtime[3] 
    cmp al , 5
      jz digit1h 
inc  arrtime[3]
   call disp_time
  cmp al ,5
    jnz digit1s   
;------------------------------
digit1h:
mov arrtime[3],0
        
mov al, arrtime[1] 
    cmp arrtime[0] , 1
        jz ch1
    cmp arrtime[0] , 0
       jz ch2
ch1:
      cmp al , 1
         jz digittupe
      cmp al  ,   2
        jz ch3
              
ch2:
    cmp al , 9
      jz digit2h   
    inc  arrtime[1]
        call display
    cmp al ,9
        jnz digit1s 
ch3:
   mov arrtime[0] ,0
   mov arrtime[1],  1
   call disp_time
   cmp al , al
   jz digit1s
;-------------------------------
digit2h:
mov arrtime[1],0   
inc  arrtime[0] 
  jnz digit1s 
  
;-------------------------------
digittupe:
mov al , arrtime[9]
   add al , 30h 
  cmp al , 'A' 
     jz AtoP 
  cmp al ,'P'
    jz changeday
AtoP:
mov arrtime[9],'P'
 sub arrtime[9],30h
mov arrtime[1],2 
    cmp al,al
    jz digit1s
;--------------------------------
changeday:
   mov arrtime[9],'A'
    sub arrtime[9],30h
   mov arrtime[1],2 
   
   cmp arrday[0],'S'
      jz surday1
   cmp arrday[0],'M'
      jz day3
   cmp arrday[0],'T'
      jz surday2 
   cmp arrday[0],'W'
      jz day5
      
surday1:
  cmp arrday[1] ,'a'
     jz day1
  cmp arrday[1] ,'u'
      jz day2 
surday2:
  cmp arrday[1] ,'u'
     jz day4
  cmp arrday[1] ,'h'
      jz day6 
day1: 
   mov dayIndex,1
    call disp_time
    call displaynewday
    call changedate
    
day2: 
   mov dayIndex,2
    call disp_time
    call displaynewday
    call changedate
day3: 
   mov dayIndex,3
    call disp_time
    call displaynewday 
   call changedate 
day4:
   mov dayIndex,4
    call disp_time
    call displaynewday
    call changedate
day5:
   mov dayIndex,5
    call disp_time
    call displaynewday
     call changedate
day6:

   mov dayIndex,6
    call disp_time
    call displaynewday 
   call changedate
;----------------------------
changedate proc 
     
    cmp arrdate[0], 3
       jnz change1
     add arrdate[3],30h
     cmp arrdate[3] , 'J'
        jz chackmonth1
     cmp arrdate[3] , 'F'
        jz month2
     cmp arrdate[3] , 'M'
        jz chackmonth2   
     cmp arrdate[3] , 'A' 
        jz chackmonth3
     cmp arrdate[3] , 'S'
        jz month9
     cmp arrdate[3] , 'O'
        jz month10
     cmp arrdate[3] , 'N'
        jz month11
     cmp arrdate[3] , 'D'
        jz month12
chackmonth1:
    add arrdate[4],30h
    cmp arrdate[4],'a'
        jz month1 
    cmp arrdate[4],'u'
        jz chacku
chacku: 
    add arrdate[5],30h
    cmp arrdate[5],'n' 
        jz month6
        jnz month7 
        
;------------------------------------
 chackmonth2:
      add arrdate[5],30h
      cmp arrdate[5] ,'r'
          jz month3
          jnz  month5
;-----------------------------------
chackmonth3:
      add arrdate[4],30h
     cmp arrdate[4],'p'
        jz  month4
        jnz  month8               
change1:
   cmp arrdate[1] ,9
      jnz incdate 
    inc arrdate[0]
    mov arrdate[1],0
     call disp_date
      cmp al ,al
      jz digit1s
      
incdate:
  inc arrdate[1] 
  call disp_date
    cmp al ,al
    jz digit1s 
 ;-----------------------
month31_12:
      inc arrdate[1]
      sub arrdate[3],30h
      sub arrdate[4] ,30h
      call disp_date
     cmp al ,al 
      jz digit1s
;------------------------ 
month31_1:
      inc arrdate[1]
      sub arrdate[3],30h
      call disp_date
       cmp al ,al 
      jz digit1s
;------------------------ 
month31_13:
      inc arrdate[1]
      sub arrdate[3] ,30h
       sub arrdate[4] ,30h
      sub arrdate[5],30h
      call disp_date
     cmp al ,al 
      jz digit1s
;------------------------
month1:
    cmp arrdate[1],0
        jz month31_12
    mov arrdate[1] ,1 
    mov arrdate[0] ,0
    call disp_date 
    mov monthIndex2 ,1
    call displaynewdate
    cmp al ,al 
      jz digit1s
;---------------
month2:
    cmp arrdate[1],0
         
    mov arrdate[1] ,1 
    mov arrdate[0] ,0
    call disp_date 
    mov monthIndex2 ,2
    call displaynewdate
    cmp al ,al 
      jz digit1s
;---------------
month3:
    cmp arrdate[1],0
           jz month31_13
    mov arrdate[1] ,1 
    mov arrdate[0] ,0
    call disp_date 
    mov monthIndex2 ,3
    call displaynewdate
    cmp al ,al 
      jz digit1s
;---------------
month4: 
    mov arrdate[1] ,1 
    mov arrdate[0] ,0
    call disp_date 
    mov monthIndex2 , 4
    call displaynewdate
      cmp al ,al 
        jz digit1s
;---------------
month5:
    cmp arrdate[1],0
        jz month31_13
    mov arrdate[1] ,1 
    mov arrdate[0] ,0
    call disp_date 
    mov monthIndex2 ,5
    call displaynewdate
    cmp al ,al 
      jz digit1s
;---------------
month6:
   
    mov arrdate[1] ,1 
    mov arrdate[0] ,0
    call disp_date 
    mov monthIndex2 ,6
    call displaynewdate
    cmp al ,al 
      jz digit1s
;---------------
month7: 
     cmp arrdate[1],0
        jz month31_13
    mov arrdate[1] ,1 
    mov arrdate[0] ,0
    call disp_date 
    mov monthIndex2 ,7
    call displaynewdate
    cmp al ,al 
      jz digit1s
;---------------
month8:
    cmp arrdate[1],0
        jz month31_12
    mov arrdate[1] ,1 
    mov arrdate[0] ,0
    call disp_date 
    mov monthIndex2 ,8
    call displaynewdate
    cmp al ,al 
      jz digit1s
;---------------
month9:
  
    mov arrdate[1] ,1 
    mov arrdate[0] ,0
    call disp_date 
    mov monthIndex2 ,9
    call displaynewdate
    cmp al ,al 
      jz digit1s
;----------------------
month10:
    cmp arrdate[1],0
           jz month31_1
    mov arrdate[1] ,1 
    mov arrdate[0] ,0
    call disp_date 
    mov monthIndex2 ,10
    call displaynewdate
    cmp al ,al 
      jz digit1s
;---------------
month11:
    cmp arrdate[1],0
      
    mov arrdate[1] ,1 
    mov arrdate[0] ,0
    call disp_date 
    mov monthIndex2 ,11
    call displaynewdate
    cmp al ,al 
      jz digit1s
;---------------
month12:
    cmp arrdate[1],0
            jz month31_1
    mov arrdate[1] ,1 
    mov arrdate[0] ,0
       cmp arrdate[10],9 
         jz digit9y
    inc arrdate[10]    
complete:   
   call disp_date 
    mov monthIndex2 ,0
    call displaynewdate
    cmp al ,al 
      jz digit1s
        
digit9y:
     mov arrdate[10],0 
      cmp arrdate[9], 9
           jz digit8y
      inc arrdate[9]
       cmp al ,al 
         jz complete 
digit8y:
       mov arrdate[9],0 
       cmp arrdate[8], 9 
         jz digit7y
         inc arrdate[8] 
       cmp al ,al 
         jz complete
digit7y:
    mov arrdate[8],0 
    inc arrdate[7] 
       cmp al ,al 
         jz complete                   
; function display time
disp_time proc 
    push ax 
    mov cx,11
    mov si,0   
    GOTOXY 3,8
    mov ah,0eh
    count_arrtime:  
        mov al,arrtime[si]
        add al,30h
        int 10h   
        inc si   
            loop count_arrtime
         pop ax               
ret
disp_time endp 

;function display day                  
disp_day proc  
          MOV AH,9
          GOTOXY 3,9
          Mov DX , offset arrday 
          INT 21H
                        
ret
disp_day endp
;-----------display new day-----------------
displaynewday proc
 Mov DX , offset daysOfWeek 
cmp dayIndex , 0 
jne notEqual
jmp E

notEqual:
mov cl , dayIndex   
mov si , 0
getDay: 
  add DL , lengthofDay[si]  
  inc si
loop getDay


E: 
GOTOXY 3,9
MOV AH,09h
INT 21H 
ret
displaynewday endp
;------------display new date --------------
displaynewdate proc

Mov DX , offset monthsOfYear 
cmp monthIndex2 , 0 
jne notEqual2
jmp Et
notEqual2:
mov cl , monthIndex2   
mov si , 0
getMonth: 
  add DL , lengthofMonth[si] 
  inc si
loop getMonth
Et:
GOTOXY 6,10
MOV AH,09h
INT 21H  
ret
displaynewdate endp
;--------------------------------------------
;function display date
disp_date proc  
    mov cx,11
    mov si,0
    mov ah,0eh  
    GOTOXY 3,10
    count_arrdate:  
        mov al,arrdate[si]
        add al,30h
        int 10h   
        inc si   
            loop count_arrdate
                        
ret
disp_date endp   


;function display star
disp_star_line proc  
     mov cx,1
      first_line:  
      push cx
      mov cx,23
      mov ah,2
      mov dl,'*'
      l1:
          int 21h
              loop l1  
          pop cx 
          
          ;newline
          MOV AH,2
          MOV DL,0Dh
          INT 21H
          MOV DL,0Ah
          INT 21H      
          
      loop first_line 
   
ret 
disp_star_line endp   

;function display rectangle
display proc
     ;first line
       GOTOXY 0,7
       call disp_star_line
      
      ;second line
      mov cx,1
      
      second_line:
         push cx  
   
          mov ah,2
          mov dl,'*'
          int 21h     
          
          ;-------- 
          call disp_time
          ;--------    
             
          mov ah,2 
          GOTOXY 22,8
          mov dl,'*'
          int 21h 
                  
          MOV AH,2
          MOV DL,0Dh
          INT 21H
          MOV DL,0Ah
          INT 21H
                  
          pop cx
          loop second_line     
          
      ;third line 
        
      mov cx,1    
      third_line:
          push cx   
          mov ah,2
          mov dl,'*'
          int 21h     
          
          ;-------- 
          call disp_day
          ;--------
          mov ah,2 
         GOTOXY 22,9
          mov dl,'*'
          int 21h   
          
          
          ;new line        
          MOV AH,2
          MOV DL,0Dh
          INT 21H
          MOV DL,0Ah
          INT 21H
                  
          pop cx
          loop third_line     
      
     ; forth line
     mov cx,1
      fourth_line:
      push cx  
      mov ah,2
      mov dl,'*'
      int 21h 
      ;-------- 
      call disp_date
      ;--------
     
      mov ah,2  
      GOTOXY 22,10
      mov dl,'*'
      int 21h  
      
     ;new line         
      MOV AH,2
      MOV DL,0Dh
      INT 21H
      MOV DL,0Ah
      INT 21H
              
      pop cx
        loop fourth_line     
                  
                  
   ;fifth line                 
     GOTOXY 0,11
     call disp_star_line
      
      
    ret

display endp
    






         

ret




