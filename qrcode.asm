data segment

enterStr db "Enter text to change to QR code: ", 0Dh, 0Ah, '$'

str db MAX_SIZE DUP(0)
strLen db 0
strPtr db 0

color db 1111b

g(x) db 0, 8, 183, 61, 91, 202, 37, 51, 58
    db 58, 237, 140, 124, 5, 99, 105
    
mask dw 5412h, 5125h, 5E7Ch, 5B4Bh
    dw 45F9h, 40CEh, 4F97h, 4AA0h

expToNum db 1, 2, 4, 8, 16, 32, 64, 128, 29, 58, 116, 232
    db 205, 135, 19, 38, 76, 152, 45, 90, 180, 117, 234, 201
    db 143, 3, 6, 12, 24, 48, 96, 192, 157, 39, 78, 156
    db 37, 74, 148, 53, 106, 212, 181, 119, 238, 193, 159, 35
    db 70, 140, 5, 10, 20, 40, 80, 160, 93, 186, 105, 210
    db 185, 111, 222, 161, 95, 190, 97, 194, 153, 47, 94, 188
    db 101, 202, 137, 15, 30, 60, 120, 240, 253, 231, 211, 187
    db 107, 214, 177, 127, 254, 225, 223, 163, 91, 182, 113, 226
    db 217, 175, 67, 134, 17, 34, 68, 136, 13, 26, 52, 104
    db 208, 189, 103, 206, 129, 31, 62, 124, 248, 237, 199, 147
    db 59, 118, 236, 197, 151, 51, 102, 204, 133, 23, 46, 92
    db 184, 109, 218, 169, 79, 158, 33, 66, 132, 21, 42, 84
    db 168, 77, 154, 41, 82, 164, 85, 170, 73, 146, 57, 114
    db 228, 213, 183, 115, 230, 209, 191, 99, 198, 145, 63, 126
    db 252, 229, 215, 179, 123, 246, 241, 255, 227, 219, 171, 75
    db 150, 49, 98, 196, 149, 55, 110, 220, 165, 87, 174, 65
    db 130, 25, 50, 100, 200, 141, 7, 14, 28, 56, 112, 224
    db 221, 167, 83, 166, 81, 162, 89, 178, 121, 242, 249, 239
    db 195, 155, 43, 86, 172, 69, 138, 9, 18, 36, 72, 144
    db 61, 122, 244, 245, 247, 243, 251, 235, 203, 139, 11, 22
    db 44, 88, 176, 125, 250, 233, 207, 131, 27, 54, 108, 216
    db 173, 71, 142, 1

numToExp db 0; placeholder for 0 indexing
    db 0, 1, 25, 2, 50, 26, 198, 3, 223, 51, 238, 27
    db 104, 199, 75, 4, 100, 224, 14, 52, 141, 239, 129, 28
    db 193, 105, 248, 200, 8, 76, 113, 5, 138, 101, 47, 225
    db 36, 15, 33, 53, 147, 142, 218, 240, 18, 130, 69, 29
    db 181, 194, 125, 106, 39, 249, 185, 201, 154, 9, 120, 77
    db 228, 114, 166, 6, 191, 139, 98, 102, 221, 48, 253, 226
    db 152, 37, 179, 16, 145, 34, 136, 54, 208, 148, 206, 143
    db 150, 219, 189, 241, 210, 19, 92, 131, 56, 70, 64, 30
    db 66, 182, 163, 195, 72, 126, 110, 107, 58, 40, 84, 250
    db 133, 186, 61, 202, 94, 155, 159, 10, 21, 121, 43, 78
    db 212, 229, 172, 115, 243, 167, 87, 7, 112, 192, 247, 140
    db 128, 99, 13, 103, 74, 222, 237, 49, 197, 254, 24, 227
    db 165, 153, 119, 38, 184, 180, 124, 17, 68, 146, 217, 35
    db 32, 137, 46, 55, 63, 209, 91, 149, 188, 207, 205, 144
    db 135, 151, 178, 220, 252, 190, 97, 242, 86, 211, 171, 20
    db 42, 93, 158, 132, 60, 57, 83, 71, 109, 65, 162, 31
    db 45, 67, 216, 183, 123, 164, 118, 196, 23, 73, 236, 127
    db 12, 111, 246, 108, 161, 59, 82, 41, 157, 85, 170, 251
    db 96, 134, 177, 187, 204, 62, 90, 203, 89, 95, 176, 156
    db 169, 160, 81, 11, 245, 22, 235, 122, 117, 44, 215, 79
    db 174, 213, 233, 230, 231, 173, 232, 116, 214, 244, 234, 168
    db 80, 88, 175

stack segment
    dw   128  dup(0)
ends

code segment
    
drawZInterIrregU proc
    
    mov bl, strPtr
    mov al, str[bx]
    
    mov cx, 2
    call downZBit
    
    mov cx, 2
    call upRectBit
    
    inc dh
    sub dl, 2
    
    mov cx, 4
    call upZBit
    
    inc strPtr
    
    ret
drawZInterIrregU endp

drawZInterIrregD proc
    
    mov bl, strPtr
    mov al, str[bx]
    
    mov cx, 2
    call upZBit
    
    mov cx, 2
    call upRectBit
    
    inc dh
    sub dl, 2
    
    mov cx, 4
    call downZBit
    
    inc strPtr
    
    ret
drawZInterIrregD endp

downZByte proc
    
    writeDownZBytes:
    push cx
    mov bl, strPtr
    mov al, str[bx]
    mov cx, 8
    call downZBit
    inc strPtr
    pop cx
    loop writeDownZBytes
    
    ret
downZByte endp

downZBit proc
    
    writeDownZChar:
    shl al, 1
    jnc noDownZ
    call drawPx
    
    noDownZ:
    
    test cx, 1
    jz evenDownZ
    dec dl
    jmp endDownZ
    
    evenDownZ:
    inc dl
    inc dh
    endDownZ:
    
    cmp dh, 6
    jne skipSplitDownZ
    
    inc dh
    
    skipSplitDownZ:
    loop writeDownZChar
    
    ret
downZBit endp

upZByte proc
    
    writeUpZBytes:
    push cx
    mov bl, strPtr
    mov al, str[bx]
    mov cx, 8
    call upZBit
    inc strPtr
    pop cx
    loop writeUpZBytes
    
    ret
upZByte endp

upZBit proc
    
    writeUpZChar:
    shl al, 1
    jnc noUpZ
    call drawPx
    
    noUpZ:
    
    test cx, 1
    jz evenUpZ
    dec dl
    jmp endUpZ
    
    evenUpZ:
    inc dl
    dec dh
    endUpZ:
    
    cmp dh, 6
    jne skipSplitUpZ
    
    dec dh
    
    skipSplitUpZ:
    loop writeUpZChar
    
    ret
upZBit endp

drawIrregZ proc
    
    mov bl, strPtr
    mov al, str[bx]
    
    dec dl
    
    mov cx, 4
    writeIrregZ:
    
    shl al, 1
    jnc noIrregZ
    call drawPx
    
    noIrregZ:
    
    dec dh
    loop writeIrregZ
    
    mov cx, 4
    call upZBit
    
    inc strPtr
    
    ret
drawIrregZ endp

drawIrregL proc
    
    mov bl, strPtr
    mov al, str[bx]
    
    mov cx, 2
    call upRectBit
    
    sub dl, 2
    inc dh
    
    mov cx, 6
    call downRectBit
    
    inc strPtr
    
    ret
drawIrregL endp

drawHoriByteU proc  ; U represents starting from top(Up)
    
    mov bl, strPtr
    mov al, str[bx]

    mov cx, 4
    call downRectBit
    
    sub dl, 2
    dec dh
    
    mov cx, 4
    call upRectBit
    
    inc strPtr
    
    ret
drawHoriByteU endp

drawHoriByteD proc  ; D represents starting from bottom(Down)
    
    mov bl, strPtr
    mov al, str[bx]
    
    mov cx, 4
    call upRectBit
    
    sub dl, 2
    inc dh
    
    mov cx, 4
    call downRectBit
    
    inc strPtr
    
    ret
drawHoriByteD endp

downRectByte proc
    
    writeDownRectBytes:
    push cx
    mov bl, strPtr
    mov al, str[bx]
    mov cx, 8
    call downRectBit
    inc strPtr
    pop cx
    loop writeDownRectBytes
    
    ret
downRectByte endp

downRectBit proc
    
    writeDownVertChar:
    
    shl al, 1
    jnc noDownVertPx
    call drawPx
    
    noDownVertPx:
    
    test cx, 1
    jz evenDownVertCount
    inc dh
    inc dl
    jmp endDownVertCheck
    evenDownVertCount:
    dec dl
    endDownVertCheck:
    
    cmp dx, 1416h
    jne skipSplitVertDown
    
    add dh, 5
    
    skipSplitVertDown:
    
    loop writeDownVertChar
    
    ret
downRectBit endp

upRectByte proc
    
    writeUpRectBytes:
    push cx
    mov bl, strPtr
    mov al, str[bx]
    mov cx, 8
    call upRectBit
    inc strPtr
    pop cx
    loop writeUpRectBytes
    
    ret
upRectByte endp

upRectBit proc
    
    writeUpVertChar:
    
    shl al, 1
    jnc noUpVertPx
    call drawPx
    
    noUpVertPx:
    
    test cx, 1
    jz evenUpVertCount
    dec dh
    inc dl
    jmp endUpVertCheck
    evenUpVertCount:
    dec dl
    endUpVertCheck:
    
    cmp dx, 1818h
    jne skipSplitVertUp
    
    sub dh, 5
    
    skipSplitVertUp:
    
    loop writeUpVertChar

    ret
upRectBit endp


drawSmallCorner proc
    mov dh, 22
    mov dl, 22
    call drawPx
    
    mov dh, 20
    mov dl, 20
    mov cx, 4
    drawSmallCornerTop:
    call drawPx
    inc dl
    loop drawSmallCornerTop
    
    mov cx, 4
    drawSmallCornerRight:
    call drawPx
    inc dh
    loop drawSmallCornerRight
    
    mov cx, 4
    drawSmallCornerBottom:
    call drawPx
    dec dl
    loop drawSmallCornerBottom
    
    mov cx, 4
    drawSmallCornerLeft:
    call drawPx
    dec dh
    loop drawSmallCornerLeft
    
    ret
drawSmallCorner endp   

drawCorner proc
    push dx
    push cx
    
    call drawPx
    mov cx, 6   
    drawCornerTop:
    inc dl
    call drawPx
    loop drawCornerTop
    
    mov cx, 6   
    drawCornerRight:
    inc dh
    call drawPx
    loop drawCornerRight
    
    mov cx, 6   
    drawCornerBottom:
    dec dl
    call drawPx
    loop drawCornerBottom
    
    mov cx, 5   
    drawCornerLeft:
    dec dh
    call drawPx
    loop drawCornerLeft
    
    inc dh
    add dl, 2   
    mov cx, 3
    drawCenterOuter:
    push cx
    mov cx, 3   
    drawCenterInner:
    call drawPx
    inc dh
    loop drawCenterInner
    sub dh, 3
    inc dl
    pop cx
    loop drawCenterOuter
    
    pop cx
    pop dx
    ret
drawCorner endp

drawPx proc     ; dh input row, dl input col
    push ax
    push cx
    push dx
    
    add dx, 0101h
    
    mov ax, 5
    mul dl
    mov cx, ax
    add cx, 93
    
    mov ax, 5
    mul dh
    mov dx, ax
    add dx, 33
    sub dx, 5
    
    mov ah, 5
     
    drawPxCol:
    mov al, 5
    sub cx, 5
    
    drawPxRow:
    
    push ax
    mov al, color
	mov ah, 0ch
	int 10h
	pop ax
	inc cx
	
	dec al
	cmp al, 0
	ja drawPxRow
	
	inc dx
	
	dec ah
	cmp ah, 0
	ja drawPxCol
    
    pop dx
    pop cx
    pop ax
    ret
drawPx endp

start:
    mov ax, data
    mov ds, ax
    
    mov ah, 0
    mov al, 3
    int 10h
    
    mov bx, 0
    
    mov ax, data
    lea dx, enterStr
    mov ah, 9
    int 21h
    
    getInput:
    
    mov ah, 01h
    int 16h
    
    jz getInput
    
    mov ah, 0
    int 16h
    
    cmp al, 32
    jb notValidChar
    
    validChar:
    cmp strLen, MAX_SIZE
    je getInput
    
    mov bl, strLen
    mov str[bx], al
    
    inc strLen
    
    mov ah, 0Eh
    int 10h
    
    
    MAX_SIZE equ 53
    
    notValidChar:
    
    cmp al, 8               ; Check if backspace pressed
    jne notBackspace
    
    mov ah, 3
    int 10h
    
    cmp dl, 0
    je atPageStart
    dec strLen
    dec dl
    
    mov bl, strLen
    mov str[bx], 0
    atPageStart:
    
    mov ah, 2
    int 10h
    
    mov ah, 0Ah
    mov cx, 1
    mov bh, 0
    mov al, 0
    int 10h
    
    notBackspace:
    
    cmp ah, 1Ch
    jne getInput
    
    
    cmp strLen, 0
    je endProg
    
    ; add padding
    
    mov bh, 0
    mov bl, strLen
    mov ax, 0Eh
    mov str[bx], al
    
    mov cx, 53
    sub cl, strLen
    jz endAddPadding
    
    addPadding:
    inc bx
    test cx, 1
    jz evenCountAddPadding
    mov str[bx], 0C1h
    loop addPadding
    jmp endAddPadding
    
    evenCountAddPadding:
    mov str[bx], 01Eh
    
    loop addPadding
    endAddPadding:
    
    ; end add padding
    
    
    mov al, 13h
    mov ah, 0
    int 10h
    
    ; SETUP QR CODE
    mov dx, 0           
    call drawCorner
    
    mov dx, 22
    call drawCorner
    
    mov dh, 22
    mov dl, 0
    call drawCorner
    
    
    mov dh, 6
    mov dl, 6
    mov cx, 7
    drawDottedHori:
    add dl, 2
    call drawPx
    loop drawDottedHori
    
    mov dh, 6
    mov dl, 6
    mov cx, 9
    drawDottedVert:
    add dh, 2
    call drawPx
    loop drawDottedVert
    
    mov dh, 21
    mov dl, 8
    call drawPx
    
    
    call drawSmallCorner
    
    
    mov dh, 28
    mov dl, 27
    call drawPx
    ; QR formatting over
    
    ; write size
    mov dh, 26
    mov dl, 28
    mov ah, 0
    mov al, strLen
    mov cx, 8
    writeSize:
    shl al, 1
    jnc noSizePx
    call drawPx
    
    noSizePx:
    
    test cx, 1
    jz evenSizeCount
    dec dh
    inc dl
    jmp endSizeCheck
    evenSizeCount:
    dec dl
    endSizeCheck:
    loop writeSize
    ; end write size
    
    mov cx, 3
    call upRectByte
    
    call drawHoriByteD
    
    mov cx, 4
    call downRectByte
    
    call drawHoriByteU
    
    mov cx, 3
    call upRectByte
    
    call drawIrregL
    
    mov cx, 3
    call downRectByte
    
    dec dh
    sub dl, 2
    mov cx, 1
    
    call upRectByte
    
    call drawIrregZ
    
    mov cx, 4
    call upZByte
    
    mov cx, 2
    
    drawBytesLoop:
    push cx
    
    mov bl, strPtr
    mov al, str[bx]
    
    call drawZInterIrregD
    
    mov cx, 6
    call downZByte
    
    call drawZInterIrregU
    
    mov cx, 6
    call upZByte
    pop cx
    loop drawBytesLoop
    
    call drawZInterIrregD
    
    mov cx, 2
    call downZByte
    
    mov bl, strPtr
    mov al, str[bx]
    
    mov cx, 4
    call downZBit
    
    mov color, 0100b
    call drawPx
    mov color, 1111b
    
    
    ; error correction
    
    mov strPtr, 0
    mov bl, strPtr
    mov al, str[bx]
    
    jmp endProg

endProg:


mov ax, 4c00h
int 21h  

ends

end start
