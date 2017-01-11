module TOPM(
		CLK,						// Clocking the module 
		DataInBlock,			// 8-bit Single Data Block
		//Key,						// 10-bit key
		//enc,						// 1-bit Encryption/Decryption Flag
		SelectButton,			// 1-bit Selection Button
		DataOutBlock			// 8-bit Single Data Block
		);

		input 			CLK;
		input 	[0:9] DataInBlock;
		//input 	[0:9] Key;
		//input 			enc;
		input				SelectButton;
		
		output 	[0:7] DataOutBlock;
		
		reg 		[0:7] RegDataInBlock;
		reg		[0:9] RegKey;
		reg				Regenc;
		reg				Enable	  = 1'b0 ;
		reg		[0:2]	InputStage = 2'b00;
		
		always@(posedge SelectButton)
		begin
			
			// Check which input to be taken
			case(InputStage)
			2'b00:
			begin
				// Input Data Block
				Enable = 1'b0;
				RegDataInBlock = DataInBlock[0:7];
				InputStage = InputStage + 1;
			end
			2'b01:
			begin
				// Input Key
				RegKey = DataInBlock[0:9];
				InputStage = InputStage + 1;
			end
			2'b10:
			begin
				// Encrypt or Decrypt Switch
				Regenc = DataInBlock[0];
				InputStage = 2'b00;
				Enable = 1'b1;
			end
			endcase
			
		end
		
		
		SDES	inst0 (.en(Enable), .key(RegKey), .plaintext(RegDataInBlock), .encrypt(Regenc), .ciphertext(DataOutBlock));
		
endmodule
