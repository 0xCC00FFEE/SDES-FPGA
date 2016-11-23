<h1>SDES FPGA</h1>

This is a hardware synthesizable digital design for the Simplified DES algorithm with a simple single-case testbench code written in Verilog. Following are block diagrams for each building block in S-DES Algorithm.
<hr><br><br>
<b>SDES System Block Diagram</b><br>
<img src="https://i.imgur.com/Uxer9Re.png"><br><br>

<b>Sub-keys Generation Block Diagram</b><br>
<img src="https://i.imgur.com/dGQLPtq.png"><br><br>

<b>2-Round Feistel Function Block Diagram</b><br>
<img src="https://i.imgur.com/q25egOP.png"><br><br>

<b>Substitution Boxes</b><br>
<img src="https://i.imgur.com/JeE7nQ9.png"><br><br>

<hr><br>

Permutate-10:<br>
3 | 5 | 2 | 7 | 4 | 10 | 1 | 9 | 8 | 6

Permutate-8:<br>
6 | 3 | 7 | 4 | 8 | 5 | 10 | 9

Permutate-4:<br>
2 | 4 | 3 | 1

Expand and Permutate:<br>
4 | 1 | 2 | 3 | 2 | 3 | 4 | 1

Initial Permutation:<br>
2 | 6 | 3 | 1 | 4 | 8 | 5 | 7 

Final Permutation (Inverse Initial Permutation / IP^-1):<br>
4 | 1 | 3 | 5 | 7 | 2 | 8 | 6 

LS-1: Left Rotation by 1-bit

LS-2: Left Rotation by 2-bit

SW: 4-bit Swap

