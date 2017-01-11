/*
	Simplified Data Encryption Standard (S-DES)
	8-bit 2-round block cipher encryption and decryption algorithm using 10-bit key.
*/


module SDES(input en, input[0:9] key, input[0:7] plaintext, input encrypt, output[0:7] ciphertext);
	reg[0:7] tempB, tempD, IP_out, sw_out, iip_out, feistel_out;
	
	assign ciphertext = (en)?(iip_out):(8'b0);
	
	// Generate Key1 and Key2
	task GenerateKeys;
		input[0:9] Key;
		output[0:7] Key1, Key2;
		
		reg[0:9] p10_out, tempA, tempC;

		begin
			// P10 Permutations
			p10_out = {Key[2], Key[4], Key[1], Key[6], Key[3], Key[9], Key[0], Key[8], Key[7], Key[5]};
		
			// Left Rotation by 1 bit
			tempA = {p10_out[1:4], p10_out[0], p10_out[6:9], p10_out[5]};
		
			// P8 Permutations
			Key1  = {tempA[5], tempA[2], tempA[6], tempA[3], tempA[7], tempA[4], tempA[9], tempA[8]};
		
			// Left Rotation by 3 bits
			tempC = {p10_out[3:4], p10_out[0:2], p10_out[8:9], p10_out[5:7]};
		
			// P8 Permutations
			Key2 = {tempC[5], tempC[2], tempC[6], tempC[3], tempC[7], tempC[4], tempC[9], tempC[8]};
		end
		
	endtask
	
	// Feistel Function
	task Feistel;
	input[0:7] inp_block, key;
	output[0:7] out_block;
	
	reg[0:3] first_chunk, second_chunk, xor_fout, xor_f1, xor_f2, p4_in, p4_out;
	reg[0:7] EP_out, xor_out;
	reg[0:1] s0_out, s1_out;
	
	begin
		first_chunk  = inp_block[0:3];
		second_chunk = inp_block[4:7];
		
		EP_out = {second_chunk[3], second_chunk[0], second_chunk[1], second_chunk[2], second_chunk[1], second_chunk[2], second_chunk[3], second_chunk[0]};
		
		xor_out = EP_out ^ key;
	
		xor_f1 = xor_out[0:3];
		xor_f2 = xor_out[4:7];
		
		S0_Box(xor_f1, s0_out);
		S1_Box(xor_f2, s1_out);
		
		p4_in = {s0_out, s1_out};

		p4_out = {p4_in[1],p4_in[3],p4_in[2],p4_in[0]};
			
		xor_fout = p4_out ^ first_chunk;
		
		out_block = {xor_fout, second_chunk};
	end
	
	endtask
	
	// S0 Box
	task S0_Box;
	input[0:3] inp_bits;
	output[0:1] out_bits;
	
	begin
		case(inp_bits)
			4'b0000: out_bits = 2'b01;
			4'b0001: out_bits = 2'b11;
			4'b0010: out_bits = 2'b00;
			4'b0011: out_bits = 2'b10;
			4'b0100: out_bits = 2'b11;
			4'b0101: out_bits = 2'b01;
			4'b0110: out_bits = 2'b10;
			4'b0111: out_bits = 2'b00;
			4'b1000: out_bits = 2'b00;
			4'b1001: out_bits = 2'b11;
			4'b1010: out_bits = 2'b10;
			4'b1011: out_bits = 2'b01;
			4'b1100: out_bits = 2'b01;
			4'b1101: out_bits = 2'b11;
			4'b1110: out_bits = 2'b11;
			4'b1111: out_bits = 2'b10;
		endcase
	end
	
	endtask

	// S1 Box
	task S1_Box;
	input[0:3] inp_bits;
	output[0:1] out_bits;
	
	begin
		case(inp_bits)
			4'b0000: out_bits = 2'b00;
			4'b0001: out_bits = 2'b10;
			4'b0010: out_bits = 2'b01;
			4'b0011: out_bits = 2'b00;
			4'b0100: out_bits = 2'b10;
			4'b0101: out_bits = 2'b01;
			4'b0110: out_bits = 2'b11;
			4'b0111: out_bits = 2'b11;
			4'b1000: out_bits = 2'b11;
			4'b1001: out_bits = 2'b10;
			4'b1010: out_bits = 2'b00;
			4'b1011: out_bits = 2'b01;
			4'b1100: out_bits = 2'b01;
			4'b1101: out_bits = 2'b00;
			4'b1110: out_bits = 2'b00;
			4'b1111: out_bits = 2'b11;
		endcase
	end
	
	endtask
	
	//always@(plaintext or key or encrypt)
	always@(en)
	begin
		if(en)
		begin
		
		// Generate Key1 and Key2
		GenerateKeys(key, tempB, tempD);
					
		// Initial Permutation
		IP_out = {plaintext[1], plaintext[5], plaintext[2], plaintext[0], plaintext[3], plaintext[7], plaintext[4], plaintext[6]};
		
		// First Round
		if(encrypt)
			Feistel(IP_out, tempB, feistel_out);
		else
			Feistel(IP_out, tempD, feistel_out);
		
		// Swapping 
		sw_out = {feistel_out[4:7], feistel_out[0:3]};
		
		// Second Round
		if(encrypt)
			Feistel(sw_out, tempD, feistel_out);
		else
			Feistel(sw_out, tempB, feistel_out);
		
		// Inverse Initial Permutation
		iip_out = {feistel_out[3], feistel_out[0], feistel_out[2], feistel_out[4], feistel_out[6], feistel_out[1], feistel_out[7], feistel_out[5]};
		end
	end
	
endmodule
