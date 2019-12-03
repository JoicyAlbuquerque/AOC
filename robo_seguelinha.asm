.data
	#Alguns exemplos de cores
	yellow:   .word 0xF5F62E
	white:	  .word 0xFFFFFF
	blue: 	  .word 0x2E8CF6
	orange:   .word 0xF67F2E
	black:	  .word 0x00000
	endereco: .word 0 
.text
	j main
	set_tela: 
		addi $t0, $zero, 65536
		add $t1, $t0, $zero 
		lui $t1, 0x1004 
		jr $ra

	set_cores:

		lw $s5, black
		lw $s6, blue
		lw $s7, orange
		jr $ra
		
	rand:	
		li $t5, 50
		#gera um numero aleatório
		li $a0, 1
		li $a1, 100
		li $v0, 42 #random
		syscall
		add $a0, $a0, 1
		move $t3, $a0
		
		beq $t3, 50, y
		bgt $t3, $t5, x
		slt $t4,$t3,$t5
		beq $t4, 1, y
		
		x:
			add $t4, $zero, 4
			jr $ra
		
		y:
			add $t4, $zero, 512
			jr $ra

	rand2:
		li $t5, 5
		#gera um numero aleatório
		li $a0, 1
		li $a1, 80
		li $v0, 42 #random
		syscall
		add $a0, $a0, 7
		move $s0, $a0
		jr $ra
		

	rand3:
		li $t5, 5
		#gera um numero aleatório
		li $a0, 1
		li $a1, 10
		li $v0, 42 #random
		syscall
		add $a0, $a0, 5
		move $s0, $a0
		jr $ra
			
	rand4:
		li $t5, 5
		#gera um numero aleatório
		li $a0, 1
		li $a1, 60
		li $v0, 42 #random
		syscall
		add $a0, $a0, 10
		move $t9, $a0
		jr $ra
						
	desenha:
		jal rand
		jal rand2
		jal rand4
		add $t0, $zero, $t1
		addi $t2, $zero, 0
		#addi $t0, $t1, 50
			
		espaco_x: #Loop de linha branca no canto superior esquerdo
			addi $t0, $t0, 4 #Pulo +4 no pixel
			addi $t2, $t2, 1 #Contador +1
			beq $t2, $s0, exit_1
			j espaco_x
		exit_1:
			addi $t2, $zero, 0
			espaco_y: #Loop de linha amarela para baixo ao final da branca
				addi $t0, $t0, 512 #Ando de linha em linha, ou seja, 512
				addi $t2, $t2, 1
				beq $t2, $s0, exit_2
				j espaco_y
			exit_2:
			add $s1, $zero, $t0 #s1 = valor do inicio da reta
			addi $t2, $zero, 0
			loop_1: #Loop da reta laranja
				sw $s7, ($t0) 
				add $t0, $t0, $t4 
				addi $t2, $t2, 1
				beq $t2, $t9, exit_3
				j loop_1
				
				exit_3:
					add $s2, $zero, $t0 #s2 = final da reta
					add $s4, $zero, $t0
					addi $t2, $zero, 0
					j desenhareta2
					jr $ra
					
					
	desenhareta2:
			beq $t4, 4, linhax
			beq $t4, 512, linhay
			linhax:
			sw $s7, ($s4) 
			add $s4, $s4, 512 
			addi $t2, $t2, 1
			beq $t2, 30, exit_4
			j linhax
			exit_4:
				add $s4, $zero, $s4 #s2 = final da reta
				j desenharobo
				jr $ra
				
			linhay:
			sw $s7, ($s4) 
			add $s4, $s4, 4
			addi $t2, $t2, 1
			beq $t2, 30, exit_5
			j linhay
			exit_5:
				add $s4, $zero, $s4 #s2 = final da reta
				j desenharobo
				jr $ra
	desenharobo:
		jal rand3
		add $t0, $zero, $t1
		addi $t2, $zero, 0
			
		espaco_x2: #Loop de linha branca no canto superior esquerdo
			addi $t0, $t0, 4 #Pulo +4 no pixel
			addi $t2, $t2, 1 #Contador +1
			beq $t2, $s0, exit_12
			j espaco_x2
		exit_12:
			addi $t2, $zero, 0
			espaco_y2: #Loop de linha amarela para baixo ao final da branca
				addi $t0, $t0, 512 #Ando de linha em linha, ou seja, 512
				addi $t2, $t2, 1
				beq $t2, $s0, exit_robo
				j espaco_y2
				exit_robo:
				addi $t2, $zero, 0
				
	anda_robo:
		add $s3, $t1, $zero
		add $t6, $zero, $t0
		addi $t0, $t0, 4
		sw $zero, ($t6)
		sw $s6, ($t0)
		beq $t0,$s1,segue_reta
		beq $t0, $s2, segue_reta
		beq $t0,$s3, reinicia
		j anda_robo
		
	reinicia:
		add $t0, $zero, $t1
		add $t6, $zero, $t0
		addi $t0, $t0, 4
		sw $zero, ($t6)
		sw $s6, ($t0)
		beq $t0, $s1 ,segue_reta
		beq $t0, $s2, segue_reta
		
	segue_reta:
		beq $t4, 4, segue_4
		beq $t4, 512, segue_512
	segue_4:
		add $t6, $zero, $t0
		addi $t0, $t0, 4
		sw $s7, ($t6)
		sw $s6, ($t0)
		beq $t0, $s2, segue4_linha2
		j segue_4

	segue4_linha2:
		add $t6, $zero, $t0
		addi $t0, $t0, 512
		sw $s7, ($t6)
		sw $s6, ($t0)
		beq $t0, $s4, sair
		j segue4_linha2
		
	segue_512:
		add $t6, $zero, $t0
		addi $t0, $t0, 512
		sw $s7, ($t6)
		sw $s6, ($t0)
		beq $t0, $s2, segue512_linha2
		j segue_512

	segue512_linha2:
		add $t6, $zero, $t0
		addi $t0, $t0, 4
		sw $s7, ($t6)
		sw $s6, ($t0)
		beq $t0, $s4, sair
		j segue512_linha2		
	sair:
		li $v0,10 
   	 	syscall	
		
		
	main: 
		jal set_tela
		jal set_cores
		jal desenha
		jal desenharobo
		jal anda_robo
		

