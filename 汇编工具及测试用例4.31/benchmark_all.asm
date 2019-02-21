#############################################################
#测试j,jal,jr指令，如需要可分开测试，执行正常应该是15个周期 revise date 2015/12/17 tiger
#############################################################
.text
benchmark_start:
  addi $s1,$zero, 1   #测试j,jal,jr指令，如需要可分开测试，执行正常应该是15个周期
 j jmp_next1
 addi $s1,$zero, 1
 addi $s2,$zero, 2
 addi $s3,$zero, 3
jmp_next1:
 j jmp_next2
 addi $s1,$zero, 1
 addi $s2,$zero, 2
 addi $s3,$zero, 3
jmp_next2:
 j jmp_next3
 addi $s1,$zero, 1
 addi $s2,$zero, 2
 addi $s3,$zero, 3
jmp_next3:
 j jmp_next4
 addi $s1,$zero, 1
 addi $s2,$zero, 2
 addi $s3,$zero, 3
jmp_next4:jal jmp_count

######################################


#移位测试  需要支持超addi,sll,add,syscall,srl,sll,sra,beq,j,syscall    revise date:2015/12/16 tiger

.text
addi $s0,$zero,1     #简单移位，循环测试，0号区域显示的是初始值1左移1位重复15次的值，1号区域是累加值
addi $s1,$zero,1  
sll $s1, $s1, 31   #逻辑左移31位 $s1=0x80000000
 

###################################################################
#                逻辑右移测试 
# 显示区域依次显示0x80000000 0x20000000 0x08000000 0x02000000 0x00800000 0x00200000 0x00080000 0x00020000 0x00008000 0x00002000 0x00000800 0x00000200 0x00000080 0x00000020 0x00000008 0x00000002 0x00000000  
###################################################################
LogicalRightShift:            #逻辑右移测试，将最高位1逐位向右右移直至结果为零

add    $a0,$0,$s1       #display $s1    #逻辑右移测试，将最高位1逐位向右右移直至结果为零
addi   $v0,$0,34        # display hex
syscall                 # we are out of here.  
     
srl $s1, $s1, 2   
beq $s1, $zero, shift_next1
j LogicalRightShift

shift_next1:

add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.  


###################################################################
#                逻辑左移测试 
# 显示区域依次显示0x00000004 0x00000010 0x00000040 0x00000100 0x00000400 0x00001000 0x00004000 0x00010000 0x00040000 0x00100000 0x00400000 0x01000000 0x04000000 0x10000000 0x40000000 0x00000000 
###################################################################

addi $s1,$zero, 1        #                逻辑左移测试 
LogicalLeftShift:         #逻辑左移测试，将最低位1逐位向左移直至结果为零
sll $s1, $s1, 2  

add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.  
      
beq $s1, $zero, ArithRightShift
j LogicalLeftShift


###################################################################
#                算术右移测试 
# 显示区域依次显示0x80000000 0xf0000000 0xff000000 0xfff00000 0xffff0000 0xfffff000 0xffffff00 0xfffffff0 0xffffffff 
###################################################################
ArithRightShift:          #算术右移测试，#算术移位测试，80000000算术右移，依次显示为F0000000,FF000000,FFF00000,FFFF0000直至FFFFFFFF

addi $s1,$zero,1     #                算术右移测试 
sll $s1, $s1, 31   #逻辑左移31位 $s1=0x80000000

add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.  

sra $s1, $s1, 3    #$s1=0X80000000-->0XF0000000

add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.  


sra $s1, $s1, 4    #0XF0000000-->0XFF000000

add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.  


sra $s1, $s1, 4    #0XFF000000-->0XFFF00000

add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.  

sra $s1, $s1, 4    

add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.  

sra $s1, $s1, 4    

add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.  


sra $s1, $s1, 4    

add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.  


sra $s1, $s1, 4    

add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.  


sra $s1, $s1, 4    


add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.  

#############################################################
#走马灯测试,测试addi,andi,sll,srl,sra,or,ori,nor,syscall  LED按走马灯方式来回显示数据
#############################################################

.text
addi $s0,$zero,1 
sll $s3, $s0, 31      # $s3=0x80000000
sra $s3, $s3, 31      # $s3=0xFFFFFFFF   
addu $s0,$zero,$zero   # $s0=0         
addi $s2,$zero,12 

addiu $s6,$0,3  #走马灯计数
zmd_loop:

addiu $s0, $s0, 1    #计算下一个走马灯的数据
andi $s0, $s0, 15  

#######################################
addi $t0,$0,8    
addi $t1,$0,1
left:

sll $s3, $s3, 4   #走马灯左移
or $s3, $s3, $s0

add    $a0,$0,$s3       # display $s3
addi   $v0,$0,34         # system call for LED display 
syscall                 # display 

sub $t0,$t0,$t1
bne $t0,$0,left
#######################################

addi $s0, $s0, 1   #计算下一个走马灯的数据
addi $t8,$0,15
and $s0, $s0, $t8
sll $s0, $s0, 28     

addi $t0,$0,8
addi $t1,$0,1

zmd_right:

srl $s3, $s3, 4  #走马灯右移
or $s3, $s3, $s0

addu    $a0,$0,$s3       # display $s3
addi   $v0,$0,34         # system call for LED display 
syscall                 # display 

sub $t0,$t0,$t1
bne $t0,$0,zmd_right
srl $s0, $s0, 28  
#######################################

sub $s6,$s6,$t1
beq $s6,$0, exit
j zmd_loop

exit:

add $t0,$0,$0
nor $t0,$t0,$t0      #test nor  ori
sll $t0,$t0,16
ori $t0,$t0,0xffff

addu   $a0,$0,$t0       # display $t0
addi   $v0,$0,34         # system call for LED display 
syscall                 # display 
#################################################################################
#本程序实现0-15号字单元的降序排序,此程序可在mars mips仿真器中运行
#运行时请将Mars Setting中的Memory Configuration设置为Compact，data at address 0
#
#################################################################################
 .text
sort_init:
 addi $s0,$0,-1
 addi $s1,$0,0
 
 sw $s0,0($s1)
 addi $s0,$s0,1
 addi $s1,$s1,4
 sw $s0,0($s1)
 addi $s0,$s0,1
 addi $s1,$s1,4
 sw $s0,0($s1)
 addi $s0,$s0,1
 addi $s1,$s1,4
 sw $s0,0($s1)
 addi $s0,$s0,1
 addi $s1,$s1,4
 sw $s0,0($s1)
 addi $s0,$s0,1
 addi $s1,$s1,4
 sw $s0,0($s1)
 addi $s0,$s0,1
 addi $s1,$s1,4
 sw $s0,0($s1)
 addi $s0,$s0,1
 addi $s1,$s1,4
 sw $s0,0($s1)
 addi $s0,$s0,1
 addi $s1,$s1,4
  sw $s0,0($s1)
 addi $s0,$s0,1
 addi $s1,$s1,4
  sw $s0,0($s1)
 addi $s0,$s0,1
 addi $s1,$s1,4
 sw $s0,0($s1)
 addi $s0,$s0,1
 addi $s1,$s1,4
  sw $s0,0($s1)
 addi $s0,$s0,1
 addi $s1,$s1,4
  sw $s0,0($s1)
 addi $s0,$s0,1
 addi $s1,$s1,4
  sw $s0,0($s1)
 addi $s0,$s0,1
 addi $s1,$s1,4
  sw $s0,0($s1)
 addi $s0,$s0,1
 addi $s1,$s1,4
    sw $s0,0($s1)
 addi $s0,$s0,1
 addi $s1,$s1,4
   
 addi $s0,$s0,1
 
 add $s0,$zero,$zero   
 addi $s1,$zero,60   #排序区间
sort_loop:
 lw $s3,0($s0)     
 lw $s4,0($s1)
 slt $t0,$s3,$s4
 beq $t0,$0,sort_next   #降序排序
 sw $s3, 0($s1)
 sw $s4, 0($s0)   
sort_next:
 addi $s1, $s1, -4   
 bne $s0, $s1, sort_loop  
 
 add    $a0,$0,$s0       #display $s0
 addi   $v0,$0,34         # display hex
 syscall                 # we are out of here.  DISP: disp $r0, 0
 
 addi $s0,$s0,4
 addi $s1,$zero,60
 bne $s0, $s1, sort_loop

 addi   $v0,$zero,50         # system call for pause
 syscall                  # we are out of here.   
 
 
#############################################
# insert your ccmb benchmark program here!!!
#############################################

# j benchmark_start       #delete this instruction for ccmb bencmark
#C1 instruction benchmark


#SLLV移位测试    revise date:2018/3/12 tiger
#依次输出  0x00000876 0x00008760 0x00087600 0x00876000 0x08760000 0x87600000 0x76000000 0x60000000 0x00000000

addi $t0,$zero,1     
addi $t1,$zero,3     
addi $s1,$zero,  0x876     

add $a0,$0,$s1           
addi $v0,$zero,34         # system call for print
syscall                  # print

addi $t3,$zero,8

sllv_branch:
sllv $s1,$s1,$t0     #测试指令
sllv $s1,$s1,$t1     #测试指令
add $a0,$0,$s1          
addi $v0,$zero,34         # system call for print
syscall                  # print
addi $t3,$t3, -1    
bne $t3,$zero,sllv_branch

#addi    $v0,$zero,10         # system call for exit
syscall                  # we are out of here.   

#SRLV移位测试    revise date:2018/3/14 tiger
#依次输出  0x87600000 0x08760000 0x00876000 0x00087600 0x00008760 0x00000876 0x00000087 0x00000008 0x00000000

addi $t0,$zero,1     #sllv 移位次数
addi $t1,$zero,3     #sllv 移位次数
addi $s1,$zero, 0x876     #
sll $s1,$s1,20     #

add $a0,$0,$s1           
addi $v0,$zero,34         # system call for print
syscall                  # print

addi $t3,$zero,8

srlv_branch:
srlv $s1,$s1,$t0     #先移1位
srlv $s1,$s1,$t1     #再移3位
add $a0,$0,$s1          
addi $v0,$zero,34         # system call for print
syscall                  # print
addi $t3,$t3, -1    
bne $t3,$zero,srlv_branch   #循环8次

#addi    $v0,$zero,10         # system call for exit
syscall                  # we are out of here.   

#SRAV移位测试    revise date:2018/3/12 tiger
#依次输出  0x87600000 0xf8760000 0xff876000 0xfff87600 0xffff8760 0xfffff876 0xffffff87 0xfffffff8 0xffffffff

addi $t0,$zero,1     #sllv 移位次数
addi $t1,$zero,3     #sllv 移位次数
addi $s1,$zero, 0x876     #
sll $s1,$s1,20     #

add $a0,$0,$s1           
addi $v0,$zero,34         # system call for print
syscall                  # print

addi $t3,$zero,8

srav_branch:
srav $s1,$s1,$t0     #先移1位
srav $s1,$s1,$t1     #再移3位
add $a0,$0,$s1          
addi $v0,$zero,34         # system call for print
syscall                  # print
addi $t3,$t3, -1    
bne $t3,$zero,srav_branch   #循环8次

#addi    $v0,$zero,10         # system call for exit
syscall                  # we are out of here.   

#SUBU测试  循环减1   revise date:2018/3/12 tiger
#依次输出  0x00000010 0x0000000f 0x0000000e 0x0000000d 0x0000000c 0x0000000b 
#           0x0000000a 0x00000009 0x00000008 0x00000007 0x00000006 0x00000005 0x00000004 0x00000003 0x00000002 0x00000001 0x00000000 0xffffffff 0xfffffffe 0xfffffffd 0xfffffffc 0xfffffffb 0xfffffffa 0xfffffff9 0xfffffff8 0xfffffff7 0xfffffff6 0xfffffff5 0xfffffff4 0xfffffff3 0xfffffff2 0xfffffff1 0xfffffff0

addi $t0,$zero,1     #
addi $s1,$zero, 0x10     #

add $a0,$0,$s1           
addi $v0,$zero,34         # system call for print
syscall                  # print

addi $t3,$zero, 0x20

subu_branch:
subu $s1,$s1,$t0     #先移1位
add $a0,$0,$s1          
addi $v0,$zero,34         # system call for print
syscall                  # print
addi $t3,$t3, -1    
bne $t3,$zero,subu_branch   #循环8次

#addi    $v0,$zero,10         # system call for exit
syscall                  # we are out of here.   

#XOR测试    revise date:2018/3/12 tiger
# 0x00007777 xor   0xffffffff =  0xffff8888 
# 0xffff8888 xor   0xffffffff =  0x00007777 
#依次输出 0x00007777 0xffff8888 0x00007777 0xffff8888 0x00007777 0xffff8888 0x00007777 0xffff8888 0x00007777 0xffff8888 0x00007777 0xffff8888 0x00007777 0xffff8888 0x00007777 0xffff8888 0x00007777

addi $t0,$zero,-1     #
addi $s1,$zero, 0x7777     #

add $a0,$0,$s1           
addi $v0,$zero,34         # system call for print
syscall                  # print

addi $t3,$zero, 0x10

xor_branch:
xor $s1,$s1,$t0     #先移1位
add $a0,$0,$s1          
addi $v0,$zero,34         # system call for print
syscall                  # print
addi $t3,$t3, -1    
bne $t3,$zero,xor_branch   #循环8次

#addi    $v0,$zero,10         # system call for exit
syscall                  # we are out of here.   
#xori 测试    revise date:2018/3/12 tiger
# 0x00007777 xor   0x0000ffff =  0x00008888
# 0x00008888  xor   0x0000ffff =  0x00007777 
# 0x00007777 0x00008888 0x00007777 0x00008888 0x00007777 0x00008888 0x00007777 0x00008888 0x00007777 0x00008888 0x00007777 0x00008888 0x00007777 0x00008888 0x00007777 0x00008888 0x00007777

addi $t0,$zero,-1     #
addi $s1,$zero, 0x7777     #


add $a0,$0,$s1           
addi $v0,$zero,34         # system call for print
syscall                  # print

addi $t3,$zero, 0x10

xori_branch:
xori $s1,$s1, 0xffff     #先移1位
add $a0,$0,$s1          
addi $v0,$zero,34         # system call for print
syscall                  # print
addi $t3,$t3, -1    
bne $t3,$zero,xori_branch   #循环8次

#addi    $v0,$zero,10         # system call for exit
syscall                  # we are out of here.   
#LUI测试    revise date:2018/3/12 tiger
#依次输出 0xfedcffff 0xba980000 0x76540000 0x32100000 0xfedcffff 0xba980000 0x76540000 0x32100000 0xfedcffff 0xba980000 0x76540000 0x32100000 0xfedcffff 0xba980000 0x76540000 0x32100000 0xfedcffff 0xba980000 0x76540000 0x32100000 0xfedcffff 0xba980000 0x76540000 0x32100000 0xfedcffff 0xba980000 0x76540000 0x32100000 0xfedcffff 0xba980000 0x76540000 0x32100000

addi $t3,$zero,  0x8

lui_branch:
lui $s1,  0xFEDC 
ori $s1,$s1, 0xffff
add $a0,$0,$s1          
addi $v0,$zero,34         # system call for print
syscall    
lui $s1,  0xBA98
add $a0,$0,$s1          
syscall    
lui $s1,  0x7654     
add $a0,$0,$s1          
syscall    
lui $s1,  0x3210     
add $a0,$0,$s1          
syscall    
                           # print
addi $t3,$t3, -1    
bne $t3,$zero,lui_branch

#addi    $v0,$zero,10         # system call for exit
syscall                  # we are out of here.   
#sltiu 测试    revise date:2018/3/12 tiger
#依次输出  0x00001997 0x00001996 0x00001995 0x00001994 0x00001993 0x00001992 0x00001991 0x00001990 0x0000198f 0x0000198e 0x0000198d 0x0000198c 0x0000198b 0x0000198a 0x00001989 0x00001988 0x00001987 0x00001986 0x00001985 0x00001984 0x00001983 0x00001982 0x00001981 0x00001980 0x0000197f 0x0000197e 0x0000197d 0x0000197c 0x0000197b 0x0000197a 0x00001979 0x00001978 0x00001977 0x00001976 0x00001975 0x00001974 0x00001973 0x00001972 0x00001971 0x00001970 0x0000196f 0x0000196e 0x0000196d 0x0000196c 0x0000196b 0x0000196a 0x00001969 0x00001968 0x00001967 0x00001966 0x00001965 0x00001964 0x00001963 0x00001962 0x00001961 0x00001960 0x0000195f 0x0000195e 0x0000195d 0x0000195c 0x0000195b 0x0000195a 0x00001959 0x00001958 0x00001957 0x00001956 0x00001955 0x00001954 0x00001953 0x00001952 0x00001951 0x00001950 0x0000194f 0x0000194e 0x0000194d 0x0000194c 0x0000194b 0x0000194a 0x00001949

addi $t0,$zero,-1    
addi $t1,$zero,0     
addi $s1,$zero, 0x1997  
sltiu_branch:
add $a0,$0,$s1          
addi $v0,$zero,34        # system call for print
syscall                  # print
add $s1,$s1,$t0     
sltiu $t1,$s1, 0x1949
beq $t1,$zero,sltiu_branch

#addi    $v0,$zero,10         # system call for exit
syscall                  # we are out of here.   
#MULTU乘法测试  1111*2*2*2......  revise date:2018/3/12 tiger
#依次输出  0x00001111 0x00002222 0x00004444 0x00008888 0x00011110 0x00022220 0x00044440 0x00088880 0x00111100 0x00222200 0x00444400 0x00888800 0x01111000 0x02222000 0x04444000 0x08888000 0x11110000 0x22220000 0x44440000 0x88880000 0x11100000 0x22200000 0x44400000 0x88800000 0x11000000 0x22000000 0x44000000 0x88000000 0x10000000 0x20000000 0x40000000 0x80000000 0x00000000

addi $t0,$zero,2     #sllv 移位次数
addi $s1,$zero, 0x1111     #

add $a0,$0,$s1           
addi $v0,$zero,34         # system call for print
syscall                  # print

addi $t3,$zero,32  #循环次数
multu_branch:
multu $s1,$t0     #测试指令
mflo $s1          #测试指令
add $a0,$0,$s1          
addi $v0,$zero,34         # system call for print
syscall                  # print
addi $t3,$t3, -1    
bne $t3,$zero,multu_branch   #循环8次

#addi    $v0,$zero,10         # system call for exit
syscall                  # we are out of here.   
#divu mflo测试   11110000 /2/2/2  ....  revise date:2018/3/14 tiger
#依次输出0x11110000 0x08888000 0x04444000 0x02222000 0x01111000 0x00888800 0x00444400 0x00222200 0x00111100 0x00088880 0x00044440 0x00022220 0x00011110 0x00008888 0x00004444 0x00002222 0x00001111 0x00000888 0x00000444 0x00000222 0x00000111 0x00000088 0x00000044 0x00000022 0x00000011 0x00000008 0x00000004 0x00000002 0x00000001

addi $t0,$zero,2     # /2
addi $s1,$zero,0x1111     
sll $s1,$s1,16
add $a0,$0,$s1           
addi $v0,$zero,34         
syscall                  
addi $t3,$zero,28         #循环次数

divu_branch:
 divu $s1,$t0             #测试指令
 mflo $s1                 #测试指令
 add $a0,$0,$s1          
 addi $v0,$zero,34         
 syscall                  #输出当前值
 addi $t3,$t3, -1    
 bne $t3,$zero,divu_branch   #循环


#addi    $v0,$zero,10         
syscall                  # 暂停或退出
#C2 instruction benchmark



#Mem instruction benchmark

#LB测试    revise date:2018/3/12 tiger
#依次输出 0xffffff81 0xffffff82 0xffffff83 0xffffff84 0xffffff85 0xffffff86 0xffffff87 0xffffff88 0xffffff89 0xffffff8a 0xffffff8b 0xffffff8c 0xffffff8d 0xffffff8e 0xffffff8f 0xffffff90 0xffffff91 0xffffff92 0xffffff93 0xffffff94 0xffffff95 0xffffff96 0xffffff97 0xffffff98 0xffffff99 0xffffff9a 0xffffff9b 0xffffff9c 0xffffff9d 0xffffff9e 0xffffff9f 0xffffffa0
addi $t1,$zero,0     #init_addr 
addi $t3,$zero,16     #counter

#预先写入数据，实际是按字节顺序存入 0x81,82,84,86,87,88,89.......等差数列
ori $s1,$zero, 0x8483  #
addi $s2,$zero, 0x0404  #
sll $s1,$s1,16
sll $s2,$s2,16
ori $s1,$s1, 0x8281  #    注意一般情况下MIPS采用大端方式
addi $s2,$s2, 0x0404  #   init_data= 0x84838281 next_data=init_data+ 0x04040404
lb_store:
sw $s1,($t1)
add $s1,$s1,$s2   #data +1
addi $t1,$t1,4    # addr +4  
addi $t3,$t3,-1   #counter
bne $t3,$zero,lb_store

addi $t3,$zero,32   #循环次数
addi $t1,$zero,0    # addr 
lb_branch:
lb $s1,($t1)         #测试指令
add $a0,$0,$s1          
addi $v0,$zero,34         #输出
syscall                  
addi $t1,$t1, 1    
addi $t3,$t3, -1    
bne $t3,$zero,lb_branch



#addi    $v0,$zero,10         # system call for exit
syscall                  # we are out of here.   

#LBU 测试    revise date:2018/3/12 tiger#
#依次输出   0x00000081 0x00000082 0x00000083 0x00000084 0x00000085 0x00000086 0x00000087 0x00000088 0x00000089 0x0000008a 0x0000008b 0x0000008c 0x0000008d 0x0000008e 0x0000008f 0x00000090 0x00000091 0x00000092 0x00000093 0x00000094 0x00000095 0x00000096 0x00000097 0x00000098 0x00000099 0x0000009a 0x0000009b 0x0000009c 0x0000009d 0x0000009e 0x0000009f 0x000000a0

addi $t1,$zero,0     #init_addr 
addi $t3,$zero,16     #counter

#预先写入数据，实际是按字节顺序存入 0x81,82,84,86,87,88,89.......等差数列
ori $s1,$zero, 0x8483  #
addi $s2,$zero, 0x0404  #
sll $s1,$s1,16
sll $s2,$s2,16
ori $s1,$s1, 0x8281  #    注意一般情况下MIPS采用大端方式
addi $s2,$s2, 0x0404  #   init_data= 0x84838281 next_data=init_data+ 0x04040404

lbu_store:
sw $s1,($t1)
add $s1,$s1,$s2   #data +1
addi $t1,$t1,4    # addr +4  
addi $t3,$t3,-1   #counter
bne $t3,$zero,lbu_store

addi $t3,$zero,32
addi $t1,$zero,0    # addr +4  
lbu_branch:
lbu $s1,($t1)     #测试指令
add $a0,$0,$s1          
addi $v0,$zero,34         
syscall                  # 输出
addi $t1,$t1, 1    
addi $t3,$t3, -1    
bne $t3,$zero,lbu_branch

#addi    $v0,$zero,10         # system call for exit
syscall                  # we are out of here.   

#LH 测试    revise date:2018/3/12 tiger
#依次输出  0xffff8281 0xffff8483 0xffff8685 0xffff8887 0xffff8a89 0xffff8c8b 0xffff8e8d 0xffff908f 0xffff9291 0xffff9493 0xffff9695 0xffff9897 0xffff9a99 0xffff9c9b 0xffff9e9d 0xffffa09f 0xffffa2a1 0xffffa4a3 0xffffa6a5 0xffffa8a7 0xffffaaa9 0xffffacab 0xffffaead 0xffffb0af 0xffffb2b1 0xffffb4b3 0xffffb6b5 0xffffb8b7 0xffffbab9 0xffffbcbb 0xffffbebd 0xffffc0bf

addi $t1,$zero,0     #init_addr 
addi $t3,$zero,16     #counter

#预先写入数据，实际是按字节顺序存入 0x81,82,84,86,87,88,89.......等差数列
ori $s1,$zero, 0x8483  #
addi $s2,$zero, 0x0404  #
sll $s1,$s1,16
sll $s2,$s2,16
ori $s1,$s1, 0x8281  #    注意一般情况下MIPS采用大端方式
addi $s2,$s2, 0x0404  #   init_data= 0x84838281 next_data=init_data+ 0x04040404

lh_store:
sw $s1,($t1)
add $s1,$s1,$s2   #data +1
addi $t1,$t1,4    # addr +4  
addi $t3,$t3,-1   #counter
bne $t3,$zero,lh_store

addi $t3,$zero,32
addi $t1,$zero,0    # addr  
lh_branch:
lh $s1,($t1)     #测试指令
add $a0,$0,$s1          
addi $v0,$zero,34         
syscall                  # print
addi $t1,$t1, 2    
addi $t3,$t3, -1    
bne $t3,$zero,lh_branch

#addi    $v0,$zero,10         # system call for exit
syscall                  # we are out of here.   

#LHU 测试    revise date:2018/3/12 tiger
#依次输出  0x00008281 0x00008483 0x00008685 0x00008887 0x00008a89 0x00008c8b 0x00008e8d 0x0000908f 0x00009291 0x00009493 0x00009695 0x00009897 0x00009a99 0x00009c9b 0x00009e9d 0x0000a09f 0x0000a2a1 0x0000a4a3 0x0000a6a5 0x0000a8a7 0x0000aaa9 0x0000acab 0x0000aead 0x0000b0af 0x0000b2b1 0x0000b4b3 0x0000b6b5 0x0000b8b7 0x0000bab9 0x0000bcbb 0x0000bebd 0x0000c0bf

addi $t1,$zero,0     #init_addr 
addi $t3,$zero,16     #counter

#预先写入数据，实际是按字节顺序存入 0x81,82,84,86,87,88,89.......等差数列
ori $s1,$zero, 0x8483  #
addi $s2,$zero, 0x0404  #
sll $s1,$s1,16
sll $s2,$s2,16
ori $s1,$s1, 0x8281  #    注意一般情况下MIPS采用大端方式
addi $s2,$s2, 0x0404  #   init_data= 0x84838281 next_data=init_data+ 0x04040404

lhu_store:
sw $s1,($t1)
add $s1,$s1,$s2   #data +1
addi $t1,$t1,4    # addr +4  
addi $t3,$t3,-1   #counter
bne $t3,$zero,lhu_store

addi $t3,$zero,32   #循环次数
addi $t1,$zero,0    # addr
lhu_branch:
lhu $s1,($t1)     #测试指令
add $a0,$0,$s1          
addi $v0,$zero,34         
syscall                  # print
addi $t1,$t1, 2    
addi $t3,$t3, -1    
bne $t3,$zero,lhu_branch

#addi    $v0,$zero,10         # system call for exit
syscall                  # we are out of here.   
#SB 测试    revise date:2018/3/14 tiger
#依次输出   0x00000000 0x00000001 0x00000002 0x00000003 0x00000004 0x00000005 0x00000006 0x00000007 0x00000008 0x00000009 0x0000000a 0x0000000b 0x0000000c 0x0000000d 0x0000000e 0x0000000f 0x00000010 0x00000011 0x00000012 0x00000013 0x00000014 0x00000015 0x00000016 0x00000017 0x00000018 0x00000019 0x0000001a 0x0000001b 0x0000001c 0x0000001d 0x0000001e 0x0000001f 0x03020100 0x07060504 0x0b0a0908 0x0f0e0d0c 0x13121110 0x17161514 0x1b1a1918 0x1f1e1d1c

addi $t1,$zero,0     #init_addr 
addi $t3,$zero,32     #counter

#sb写入 01,02,03,04
addi $s1,$zero, 0x00  #
addi $s2,$zero, 0x01  #

sb_store:
sb $s1,($t1)
add $a0,$0,$s1          
addi $v0,$zero,34        # system call for print
syscall                  # print

add $s1,$s1,$s2          #data +1
addi $t1,$t1,1           # addr ++  
addi $t3,$t3,-1          #counter
bne $t3,$zero,sb_store

addi $t3,$zero,8
addi $t1,$zero,0    # addr   
sb_branch:
lw $s1,($t1)       #读出数据 
add $a0,$0,$s1          
addi $v0,$zero,34        # system call for print
syscall                  # print
addi $t1,$t1,4    
addi $t3,$t3, -1    
bne $t3,$zero,sb_branch

#addi    $v0,$zero,10      # system call for exit
syscall                  # we are out of here.   
#SH 测试    revise date:2018/3/14 tiger
#依次输出 0x00000001 0x00000002 0x00000003 0x00000004 0x00000005 0x00000006 0x00000007 0x00000008 0x00000009 0x0000000a 0x0000000b 0x0000000c 0x0000000d 0x0000000e 0x0000000f 0x00000010 0x00000011 0x00000012 0x00000013 0x00000014 0x00000015 0x00000016 0x00000017 0x00000018 0x00000019 0x0000001a 0x0000001b 0x0000001c 0x0000001d 0x0000001e 0x0000001f 0x00000020 0x00020001 0x00040003 0x00060005 0x00080007 0x000a0009 0x000c000b 0x000e000d 0x0010000f 0x00120011 0x00140013 0x00160015 0x00180017 0x001a0019 0x001c001b 0x001e001d 0x0020001f

addi $t1,$zero,0     #init_addr 
addi $t3,$zero,32     #counter

#SH写入 01,02,03,04
addi $s1,$zero, 0x0001  #
addi $s2,$zero, 0x01  #
sh_store:
sh $s1,($t1)
add $a0,$0,$s1          
addi $v0,$zero,34         # system call for print
syscall                  # print

add $s1,$s1,$s2   #data +1
addi $t1,$t1,2    # addr +4  
addi $t3,$t3,-1   #counter
bne $t3,$zero,sh_store


addi $t3,$zero,16
addi $t1,$zero,0    # addr 
sh_branch:
lw $s1,($t1)     
add $a0,$0,$s1          
addi $v0,$zero,34         # system call for print
syscall                  # print
addi $t1,$t1,4    
addi $t3,$t3, -1    
bne $t3,$zero,sh_branch

#addi    $v0,$zero,10         # system call for exit
syscall                  # we are out of here.   
#Branch instruction benchmark


#blez 测试    小于等于零跳转     累加运算，从负数开始向零运算  revise date:2018/3/12 tiger  
#依次输出0xfffffff1 0xfffffff2 0xfffffff3 0xfffffff4 0xfffffff5 0xfffffff6 0xfffffff7 0xfffffff8 0xfffffff9 0xfffffffa 0xfffffffb 0xfffffffc 0xfffffffd 0xfffffffe 0xffffffff 0x00000000

addi $s1,$zero,-15       #初始值
blez_branch:
add $a0,$0,$s1          
addi $v0,$zero,34         
syscall                  #输出当前值
addi $s1,$s1,1  
blez $s1,blez_branch   


#addi    $v0,$zero,10         
syscall                  # 暂停或退出
#bgtz 测试    大于零跳转  递减运算 ，从正数开始向零运算  revise date:2018/3/12 tiger
#依次输出0x0000000f 0x0000000e 0x0000000d 0x0000000c 0x0000000b 0x0000000a 0x00000009 0x00000008 0x00000007 0x00000006 0x00000005 0x00000004 0x00000003 0x00000002 0x00000001 
  
addi $s1,$zero,15  
bgtz_branch:
add $a0,$0,$s1          
addi $v0,$zero,34         
syscall                  # 输出当前值
addi $s1,$s1,-1  
bgtz $s1,bgtz_branch    #当前测试指令

#addi    $v0,$zero,10         
syscall                  # 程序暂停或退出
#bltz 测试    小于0跳转   累加运算，从负数开始向零运算 revise date:2018/3/12 tiger  
#依次输出0xfffffff1 0xfffffff2 0xfffffff3 0xfffffff4 0xfffffff5 0xfffffff6 0xfffffff7 0xfffffff8 0xfffffff9 0xfffffffa 0xfffffffb 0xfffffffc 0xfffffffd 0xfffffffe 0xffffffff
addi $s1,$zero,-15       #初始值
bltz_branch:
add $a0,$0,$s1          
addi $v0,$zero,34         
syscall                  #输出当前值
addi $s1,$s1,1 
bltz $s1,bltz_branch     #当前指令


#addi    $v0,$zero,10    
syscall                  #暂停或退出
#bgez 测试    大于等于零跳转   递减运算 ，从正数开始向零运算revise date:2018/3/12 tiger  
#依次输出0x0000000f 0x0000000e 0x0000000d 0x0000000c 0x0000000b 0x0000000a 0x00000009 0x00000008 0x00000007 0x00000006 0x00000005 0x00000004 0x00000003 0x000000020 x000000010 x00000000
addi $s1,$zero,15  #初始值
bgez_branch:
add $a0,$0,$s1          
addi $v0,$zero,34         
syscall                  # 输出当前值
addi $s1,$s1,-1
bgez $s1,bgez_branch   #测试指令

#addi    $v0,$zero,10         #停机指令
syscall                  # 系统调用
                 
 #addi    $v0,$zero,10         # system call for exit
 syscall                  # we are out of here.   
 
 #MIPS处理器实现中请用停机指令实现syscall

jmp_count: addi $s0,$zero, 0
       addi $s0,$s0, 1
       add    $a0,$0,$s0      
       addi   $v0,$0,34         # display hex
       syscall                 # we are out of here.  
       
       addi $s0,$s0, 2
       add    $a0,$0,$s0      
       addi   $v0,$0,34         # display hex
       syscall                 # we are out of here.  
       
       addi $s0,$s0, 3
       add    $a0,$0,$s0      
       addi   $v0,$0,34         # display hex
       syscall                 # we are out of here.  
       
       addi $s0,$s0, 4       
       add    $a0,$0,$s0      
       addi   $v0,$0,34         # display hex
       syscall                 # we are out of here.  
       
       addi $s0,$s0, 5              
       add    $a0,$0,$s0      
       addi   $v0,$0,34         # display hex
       syscall                 # we are out of here.  
       
       addi $s0,$s0, 6              
       add    $a0,$0,$s0      
       addi   $v0,$0,34         # display hex
       syscall                 # we are out of here.  

       addi $s0,$s0, 7              
       add    $a0,$0,$s0      
       addi   $v0,$0,34         # display hex
       syscall                 # we are out of here.  

       addi $s0,$s0, 8              
       add    $a0,$0,$s0      
       addi   $v0,$0,34         # display hex
       addi   $v0,$0,34         # display hex       
       syscall                 # we are out of here.  

       
       jr $31
