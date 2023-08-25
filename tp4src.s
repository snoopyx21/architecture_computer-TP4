.data

RetChar: .asciiz "\n"
Tableau: .asciiz "Tableau de taille: "
Aladresse: .asciiz "à l'adresse: "
Adresse: .asciiz "Adresse du premier entier du tableau: "
Place: .asciiz "Place de l'entier dans le tableau: "

.text
.globl __start

__start:

li $s0 0 #nombre d'entiers dans $s0, registre temp. sauvegardé par les fonctions
move $a0 $s0
li $a1 0
jal CreerTableau
move $s1 $v0 #$s1: adresse du premier octet du tableau

##################### Affichage de l'adresse à laquelle commence le tableau
la $a0 Adresse
li $v0 4
syscall
move $a0 $s1
jal AfficheEntier
#####################

move $a0 $s0
move $a1 $s1
jal AfficheTableau

#####################test fonction CherchePlace essayer avec un tableau trié
la $a0 Place
li $v0 4
syscall
move $a0 $s0
move $a1 $s1
li $a2 5
jal CherchePlace
move $a0 $v0
jal AfficheEntier
la $a0 RetChar
li $v0 4
syscall
####################

#####################test fonction CherchePlaceRec essayer avec un tableau trié
la $a0 Place
li $v0 4
syscall
move $a0 $s0
move $a1 $s1
li $a2 5
jal CherchePlaceRec
move $a0 $v0
jal AfficheEntier
la $a0 RetChar
li $v0 4
syscall
####################

####################test de la fonction decalage
move $a0 $s0
move $a1 $s1
jal Decalage

move $a0 $s0
move $a1 $s1
jal AfficheTableau
####################

####################test de la fonction Inserer
move $a0 $s0
move $a1 $s1
li $a2 5
jal Inserer

move $a0 $s0
move $a1 $s1
jal AfficheTableau
####################

####################test de la fonction Tri
move $a0 $s0
move $a1 $s1
jal Tri

move $a0 $s0
move $a1 $s1
jal AfficheTableau
####################

j Exit

Exit:
ori $2, $0, 10
syscall

#################################Fonction CreerTableau
###entrées: $a0: taille (en nombre d'entiers) du tableau à créer
###         $a1: 0: tableau trié dans l'ordre croissant, 1: tableau trié dans l'ordre décroissant, 2: tableau quelconque
###Pré-conditions: $a0 >=0
###Sorties: $v0: adresse (en octet) du premier entier du tableau
###Post-conditions: si $a0==0, $v0 = 0x00000000
###                 les registres temp. $si sont rétablies si utilisées
CreerTableau:
subu $sp $sp 24
sw $s0 20($sp) ###Memory[$sp+20] <= $s0
sw $s1 16($sp)
sw $s2 12($sp)
sw $a0 8($sp)
sw $a1 4($sp)
sw $ra 0($sp)
#corps de la fonction: à compléter
beq $a0 $0 taille0
li $v0 0

#allocation mémoire
li $t0 4
mul $s2 $a0 $t0
move $a0 $s2
li $v0 9 
syscall
move $s0 $v0 #adresse du début du tableau

bgt $a1 1 NbAlea #bgt équivaut à >
bgt $a1 0 NbDesc


NbCroi:
li $s1 0 ## variable incrémenté :offset
LoopRemplissageCroi:
bge $s1 $s2 FinLoopRemplissage ## condition sortie
add $t0 $s0 $s1 ## adresse de l'élément du tableau: adresse de début du tableau + offset
addi $a0 $s1 4 ## entier choisi : offset +4
sw $a0 0($t0) # stockage de l'entier dans le tableau
addi $s1 $s1 4 #incremente l'offset
j LoopRemplissageCroi


NbDesc:
li $s1 0
LoopRemplissageDesc:
bge $s1 $s2 FinLoopRemplissage
add $t0 $s0 $s1 
sub $a0 $s2 $s1 #entier que j'ai chosi : taille - offset
sw $a0 0($t0)
addi $s1 $s1 4 
j LoopRemplissageDesc


NbAlea:
li $s1 0
LoopRemplissageAlea:
bge $s1 $s2 FinLoopRemplissage
add $t0 $s1 $s0
li $a0 255 #on prend n'importe quel nombre
move $t1 $s0
li $a1 200 #limite maximale des nombres aléatoires
li $v0 42
syscall #génération d'un nombre aléatoire 
move $s0 $t1
sw $a0 0($t0)
addi $s1 $s1 4
j LoopRemplissageAlea

taille0:
li $s0 0


FinLoopRemplissage:
move $v0 $s0
#épilogue: à renseigner
lw $s0 20($sp)
lw $s1 16($sp)
lw $s2 12($sp)
lw $a0 8($sp)
lw $a1 4($sp)
lw $ra 0($sp)
addu $sp $sp 24
jr $ra
#########################################################

#################################Fonction CherchePlace
###entrées: $a0: taille (en nombre d'entiers) du tableau
###         $a1: adresse du premier élément du tableau
###         $a2: l'entier dont on cherche la place
###Pré-conditions: $a0 >=0,
###                le tableau est trié
###Sorties: $v0: offset (en octet) de la place à laquelle devrait se trouver l'entier dans $a2
###Post-conditions: si $a0==0, $v0 = 0
###                 les registres temp. $si sont rétablies si utilisées
CherchePlace:
#prologue: à renseigner
subu $sp $sp 28
sw $s0 24($sp)
sw $s1 20($sp)
sw $s2 16($sp)
sw $a0 12($sp)
sw $a1 8($sp)
sw $a2 4($sp)
sw $ra 0($sp)
#corps de la fonction: à compléter
li $s1, 0
beq $a0 $0 FinLoopParcours
move $s0 $a1 #adresse du début du tableau
li $t0 4
mul $s2 $a0 $t0
LoopParcours:
bge $s1 $s2 FinLoopParcours
add $t0 $s0 $s1 #adresse de l'élément du tableau = adresse du début de tableau + offset
lw $t1 0($t1)
ble $a2 $t1 FinLoopParcours
addi $s1 $s1 4
j LoopParcours

FinLoopParcours:
move $v0 $s1
#épilogue: à renseigner
lw $s0 24($sp)
lw $s1 20($sp)
lw $s2 16($sp)
lw $a0 12($sp)
lw $a1 8($sp)
lw $a2 4($sp)
lw $ra 0($sp)
addi $sp $sp 28
jr $ra
#########################################################

#################################Fonction CherchePlaceRec
###entrées: $a0: taille (en nombre d'entiers) du tableau
###         $a1: adresse du premier élément du tableau
###         $a2: l'entier dont on cherche la place
###Pré-conditions: $a0 >=0,
###                le tableau est trié
###Sorties: $v0: offset (en octet) de la place à laquelle devrait se trouver l'entier dans $a2
###Post-conditions: si $a0==0, $v0 = 0
###                 les registres temp. $si sont rétablies si utilisées
CherchePlaceRec:
#prologue: à renseigner
subu $sp $sp 28
sw $s0 24($sp)
sw $s1 20($sp)
sw $s2 16($sp)
sw $a0 12($sp)
sw $a1 8($sp)
sw $a2 4($sp)
sw $ra 0($sp)
#corps de la fonction: à compléter
li $v0 0
beq $a0 $0 Fin
lw $t1 0($a1)
ble $a2 $t1 Fin
subi $a0 $a0 1
addi $a1 $a1 4
beq $a0 $0 FinParcours
jal CherchePlaceRec

FinParcours:
addi $v0 $v0 4
 
Fin:
#épilogue: à renseigner
lw $s0 24($sp)
lw $s1 20($sp)
lw $s2 16($sp)
lw $a0 12($sp)
lw $a1 8($sp)
lw $a2 4($sp)
lw $ra 0($sp)
addi $sp $sp 28
jr $ra
#########################################################

#################################Fonction Decalage
###entrées: $a0: taille (en nombre d'entiers) du tableau
###         $a1: adresse du premier élément du tableau
###Pré-conditions: $a0 >=0,
###                les 4 octets à la suite du tableau peuvent être écris
###Sorties:
###Post-conditions: le tableau est décalé d'une case vers la droite
###                 les registres temp. $si sont rétablies si utilisées
Decalage:
#prologue: à renseigner
subu $sp $sp 28
sw $s0 24($sp)
sw $s1 20($sp)
sw $s2 16($sp)
sw $a0 12($sp)
sw $a1 8($sp)
sw $a2 4($sp)
sw $ra 0($sp)
#corps de la fonction: à compléter
move $s0 $a0
li $t0 4
mul $s2 $t0 $a0
subi $s2 $s2 4
LoopScan:
blt $s2 $0 FinLoopScan
add $t0 $s0 $s2 #adresse de l'élément du tableeau = adresse du début du tableau + offset
lw $t1 0($t0)
sw $t1 4($t0)
subi $s2 $s2 4 #on décrémente 'l'offset
j LoopScan

FinLoopScan:
#épilogue: à renseigner
lw $s0 24($sp)
lw $s1 20($sp)
lw $s2 16($sp)
lw $a0 12($sp)
lw $a1 8($sp)
lw $a2 4($sp)
lw $ra 0($sp)
addi $sp $sp 28
jr $ra
#########################################################

#################################Fonction Inserer
###entrées: $a0: taille (en nombre d'entiers) du tableau
###         $a1: adresse du premier élément du tableau
###         $a2: l'entier à insérer
###Pré-conditions: $a0 >=0,
###                le tableau commençant à $a1 de taille $a0 est trié
###                les 4 octets à la suite du tableau peuvent être écris
###Sorties:
###Post-conditions: le tableau commençant à $a1, de taille $a0+1 est trié
###                 les registres temp. $si sont rétablies si utilisées
Inserer:
#prologue: à renseigner
subu $sp $sp 28
sw $s0 24($sp)
sw $s1 20($sp)
sw $s2 16($sp)
sw $a0 12($sp)
sw $a1 8($sp)
sw $a2 4($sp)
sw $ra 0($sp)
#corps de la fonction: à compléter
jal CherchePlace #$vo = la bonne place
add $a1 $s1 $v0 #adresse correspondant à la bonne place
li $t0 4
div $s0 $v0 $t0 #nombre d'éléments en avant
sub $a0 $a0 $s0 
jal Decalage
sw $a2 0($a1) #affectation de l'entier à la bonne place
#épilogue: à renseigner
lw $s0 24($sp)
lw $s1 20($sp)
lw $s2 16($sp)
lw $a0 12($sp)
lw $a1 8($sp)
lw $a2 4($sp)
lw $ra 0($sp)
addi $sp $sp 28
jr $ra
#########################################################

#################################Fonction Tri
###entrées: $a0: taille (en nombre d'entiers) du tableau
###         $a1: adresse du premier élément du tableau
###Pré-conditions: $a0 >=0,
###Sorties:
###Post-conditions: le tableau commençant à $a1, de taille $a0 est trié
###                 les registres temp. $si sont rétablies si utilisées
Tri:
#prologue: à renseigner
subu $sp $sp 28
sw $s0 24($sp)
sw $s1 20($sp)
sw $s2 16($sp)
sw $a0 12($sp)
sw $a1 8($sp)
sw $a2 4($sp)
sw $ra 0($sp)
#corps de la fonction: à compléter
move $s0 $a1 #adresse du début du tableau
move $s2 $a0 #nombres d'éléments du tableau
li $s1 0 #offset
li $a0 0 #taille du tableau, il est stocké dans $s2
LoopTri:
beq $a0 $s2 FinLoopTri
add $t0 $s0 $s1  #adresse premiere element + offset
lw $a2 0($s0)
jal Inserer
addi $a0 $a0 1 #incrementation de la taille du tableau
addi $s1 $s1 4 #incrementation de l'offset
j LoopTri

FinLoopTri:
#épilogue: à renseigner
lw $s0 24($sp)
lw $s1 20($sp)
lw $s2 16($sp)
lw $a0 12($sp)
lw $a1 8($sp)
lw $a2 4($sp)
lw $ra 0($sp)
addi $sp $sp 28
jr $ra
#########################################################



TriRec:
#prologue
subu $sp $sp 28
sw $s0 24($sp)
sw $s1 20($sp)
sw $s2 16($sp)
sw $a0 12($sp)
sw $a1 8($sp)
sw $a2 4($sp)
sw $ra 0($sp)
#corps de la fonction
beq $a0 $0 FinTriRec
li $t0 4
mul $s2 $a0 $t0 
subi $s2 $s2 4 #offset de la fin du tableau
add $t0 $s2 $a1 #adresse du denrier element = adresse du debut + offset
lw $a2 0($t0) #dernier element
subi $a0 $a0 1
jal TriRec #on trie le tableau
jal Inserer #on insere le dernier element non trié à sa bonne place

FinTriRec:
#épilogue
lw $s0 24($sp)
lw $s1 20($sp)
lw $s2 16($sp)
lw $a0 12($sp)
lw $a1 8($sp)
lw $a2 4($sp)
lw $ra 0($sp)
addi $sp $sp 28
jr $ra




#################################Fonction AfficheTableau
###entrées: $a0: taille (en nombre d'entiers) du tableau à afficher
###Pré-conditions: $a0 >=0
###Sorties:
###Post-conditions: les registres temp. $si sont rétablies si utilisées
AfficheTableau:
#prologue:
subu $sp $sp 24
sw $s0 20($sp)
sw $s1 16($sp)
sw $s2 12($sp)
sw $a0 8($sp)
sw $a1 4($sp)
sw $ra 0($sp)

#corps de la fonction:
la $a0 Tableau
li $v0 4
syscall
lw $a0 8($sp)
jal AfficheEntier
la $a0 Aladresse
li $v0 4
syscall
lw $a0 4($sp)
jal AfficheEntier

lw $a0 8($sp)
lw $a1 4($sp)

li $s0 4
mul $s2 $a0 $s0 #$a0: nombre d'octets occupés par le tableau
li $s1 0 #s1: variable incrémentée: offset
LoopAffichage:
bge $s1 $s2 FinLoopAffichage
lw $a1 4($sp)
add $t0 $a1 $s1 #adresse de l'entier: adresse de début du tableau + offset
lw $a0 0($t0)
jal AfficheEntier
addi $s1 $s1 4 #on incrémente la variable
j LoopAffichage

FinLoopAffichage:

la $a0 RetChar
li $v0 4
syscall

#épilogue:
lw $s0 20($sp)
lw $s1 16($sp)
lw $s2 12($sp)
lw $a0 8($sp)
lw $a1 4($sp)
lw $ra 0($sp)
addu $sp $sp 24
jr $ra
#########################################################

#################################Fonction AfficheEntier
###entrées: $a0: entier à afficher
###Pré-conditions:
###Sorties:
###Post-conditions:
AfficheEntier:
#prologue:
subu $sp $sp 8
sw $a0 4($sp)
sw $ra 0($sp)

#corps de la fonction:
li $v0 1
syscall

la $a0 RetChar
li $v0 4
syscall

#épilogue:
lw $a0 4($sp)
lw $ra 0($sp)
addu $sp $sp 8
jr $ra
#########################################################
