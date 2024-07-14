module KeyExpansion_D #(
    parameter Nk=4,
    parameter Nr=10, 
    parameter len = 128
)(
    input [0:(Nk * 32) - 1] Key,
    output [0:(128*(Nr+1))-1] Fullkey
);

    reg [0:31] w1, w_shifted, SB_out, w_next;
    reg [0:31] RC;
    reg [0:(128*(Nr+1))-1] Fullkey_Temp[0:4*(Nr + 1)];
    reg [0:(128*(Nr+1))-1] Fullkey_Shifted;
    
    integer i;
    always @(*) begin
        Fullkey_Temp[Nk-1] = Key;    
        for(i = Nk; i < 4*(Nr+1) ; i = i + 1) begin
        
            w1 = Fullkey_Temp[i-1][(len * (Nr + 1) - 32) +: 32];
            if(i % Nk == 0) begin
                w_shifted = {w1[8:31],w1[0:7]};  
                SB_out = SBOX (w_shifted);	
                RC = RCON (i/Nk) ; 
                w1 = SB_out ^ RC;   
            end
            else if(Nk > 6 && i % Nk == 4) begin
                w1 = SBOX(w1);
            end
            
            w_next    = (Fullkey_Temp[i-1][(len*(Nr+1)-(Nk*32))+31-:32] ^ w1);
            Fullkey_Shifted = Fullkey_Temp[i-1] << 32;
            Fullkey_Temp[i] = {Fullkey_Shifted[0 : (len * (Nr + 1) - 32) - 1], w_next};
        end
    end

    assign Fullkey = Fullkey_Temp[4*(Nr + 1)-1];

    function[0:31] RCON;
        input [0:31] roundnum; 
        begin
            case(roundnum)
                4'h1: RCON=32'h01000000;
                4'h2: RCON=32'h02000000;
                4'h3: RCON=32'h04000000;
                4'h4: RCON=32'h08000000;
                4'h5: RCON=32'h10000000;
                4'h6: RCON=32'h20000000;
                4'h7: RCON=32'h40000000;
                4'h8: RCON=32'h80000000;
                4'h9: RCON=32'h1b000000;
                4'ha: RCON=32'h36000000;
                default: RCON=32'h00000000;
            endcase
        end
    endfunction

    function [0:31] SBOX;
        input [0:31] input_word;
        begin
            SBOX[0:7]  =Change(input_word[0:7]);
            SBOX[8:15] =Change(input_word[8:15]);
            SBOX[16:23]=Change(input_word[16:23]);
            SBOX[24:31]=Change(input_word[24:31]);
        end
    endfunction

	function [7:0] Change(input [7:0] a);  
	begin
		case (a)
		8'h00: Change=8'h63;
		8'h01: Change=8'h7c;
		8'h02: Change=8'h77;
		8'h03: Change=8'h7b;
		8'h04: Change=8'hf2;
		8'h05: Change=8'h6b;
		8'h06: Change=8'h6f;
		8'h07: Change=8'hc5;
		8'h08: Change=8'h30;
		8'h09: Change=8'h01;
		8'h0a: Change=8'h67;
		8'h0b: Change=8'h2b;
		8'h0c: Change=8'hfe;
		8'h0d: Change=8'hd7;
		8'h0e: Change=8'hab;
		8'h0f: Change=8'h76;
		8'h10: Change=8'hca;
		8'h11: Change=8'h82;
		8'h12: Change=8'hc9;
		8'h13: Change=8'h7d;
		8'h14: Change=8'hfa;
		8'h15: Change=8'h59;
		8'h16: Change=8'h47;
		8'h17: Change=8'hf0;
		8'h18: Change=8'had;
		8'h19: Change=8'hd4;
		8'h1a: Change=8'ha2;
		8'h1b: Change=8'haf;
		8'h1c: Change=8'h9c;
		8'h1d: Change=8'ha4;
		8'h1e: Change=8'h72;
		8'h1f: Change=8'hc0;
		8'h20: Change=8'hb7;
		8'h21: Change=8'hfd;
		8'h22: Change=8'h93;
		8'h23: Change=8'h26;
		8'h24: Change=8'h36;
		8'h25: Change=8'h3f;
		8'h26: Change=8'hf7;
		8'h27: Change=8'hcc;
		8'h28: Change=8'h34;
		8'h29: Change=8'ha5;
		8'h2a: Change=8'he5;
		8'h2b: Change=8'hf1;
		8'h2c: Change=8'h71;
		8'h2d: Change=8'hd8;
		8'h2e: Change=8'h31;
		8'h2f: Change=8'h15;
		8'h30: Change=8'h04;
		8'h31: Change=8'hc7;
		8'h32: Change=8'h23;
		8'h33: Change=8'hc3;
		8'h34: Change=8'h18;
		8'h35: Change=8'h96;
		8'h36: Change=8'h05;
		8'h37: Change=8'h9a;
		8'h38: Change=8'h07;
		8'h39: Change=8'h12;
		8'h3a: Change=8'h80;
		8'h3b: Change=8'he2;
		8'h3c: Change=8'heb;
		8'h3d: Change=8'h27;
		8'h3e: Change=8'hb2;
		8'h3f: Change=8'h75;
		8'h40: Change=8'h09;
		8'h41: Change=8'h83;
		8'h42: Change=8'h2c;
		8'h43: Change=8'h1a;
		8'h44: Change=8'h1b;
		8'h45: Change=8'h6e;
		8'h46: Change=8'h5a;
		8'h47: Change=8'ha0;
		8'h48: Change=8'h52;
		8'h49: Change=8'h3b;
		8'h4a: Change=8'hd6;
		8'h4b: Change=8'hb3;
		8'h4c: Change=8'h29;
		8'h4d: Change=8'he3;
		8'h4e: Change=8'h2f;
		8'h4f: Change=8'h84;
		8'h50: Change=8'h53;
		8'h51: Change=8'hd1;
		8'h52: Change=8'h00;
		8'h53: Change=8'hed;
		8'h54: Change=8'h20;
		8'h55: Change=8'hfc;
		8'h56: Change=8'hb1;
		8'h57: Change=8'h5b;
		8'h58: Change=8'h6a;
		8'h59: Change=8'hcb;
		8'h5a: Change=8'hbe;
		8'h5b: Change=8'h39;
		8'h5c: Change=8'h4a;
		8'h5d: Change=8'h4c;
		8'h5e: Change=8'h58;
		8'h5f: Change=8'hcf;
		8'h60: Change=8'hd0;
		8'h61: Change=8'hef;
		8'h62: Change=8'haa;
		8'h63: Change=8'hfb;
		8'h64: Change=8'h43;
		8'h65: Change=8'h4d;
		8'h66: Change=8'h33;
		8'h67: Change=8'h85;
		8'h68: Change=8'h45;
		8'h69: Change=8'hf9;
		8'h6a: Change=8'h02;
		8'h6b: Change=8'h7f;
		8'h6c: Change=8'h50;
		8'h6d: Change=8'h3c;
		8'h6e: Change=8'h9f;
		8'h6f: Change=8'ha8;
		8'h70: Change=8'h51;
		8'h71: Change=8'ha3;
		8'h72: Change=8'h40;
		8'h73: Change=8'h8f;
		8'h74: Change=8'h92;
		8'h75: Change=8'h9d;
		8'h76: Change=8'h38;
		8'h77: Change=8'hf5;
		8'h78: Change=8'hbc;
		8'h79: Change=8'hb6;
		8'h7a: Change=8'hda;
		8'h7b: Change=8'h21;
		8'h7c: Change=8'h10;
		8'h7d: Change=8'hff;
		8'h7e: Change=8'hf3;
		8'h7f: Change=8'hd2;
		8'h80: Change=8'hcd;
		8'h81: Change=8'h0c;
		8'h82: Change=8'h13;
		8'h83: Change=8'hec;
		8'h84: Change=8'h5f;
		8'h85: Change=8'h97;
		8'h86: Change=8'h44;
		8'h87: Change=8'h17;
		8'h88: Change=8'hc4;
		8'h89: Change=8'ha7;
		8'h8a: Change=8'h7e;
		8'h8b: Change=8'h3d;
		8'h8c: Change=8'h64;
		8'h8d: Change=8'h5d;
		8'h8e: Change=8'h19;
		8'h8f: Change=8'h73;
		8'h90: Change=8'h60;
		8'h91: Change=8'h81;
		8'h92: Change=8'h4f;
		8'h93: Change=8'hdc;
		8'h94: Change=8'h22;
		8'h95: Change=8'h2a;
		8'h96: Change=8'h90;
		8'h97: Change=8'h88;
		8'h98: Change=8'h46;
		8'h99: Change=8'hee;
		8'h9a: Change=8'hb8;
		8'h9b: Change=8'h14;
		8'h9c: Change=8'hde;
		8'h9d: Change=8'h5e;
		8'h9e: Change=8'h0b;
		8'h9f: Change=8'hdb;
		8'ha0: Change=8'he0;
		8'ha1: Change=8'h32;
		8'ha2: Change=8'h3a;
		8'ha3: Change=8'h0a;
		8'ha4: Change=8'h49;
		8'ha5: Change=8'h06;
		8'ha6: Change=8'h24;
		8'ha7: Change=8'h5c;
		8'ha8: Change=8'hc2;
		8'ha9: Change=8'hd3;
		8'haa: Change=8'hac;
		8'hab: Change=8'h62;
		8'hac: Change=8'h91;
		8'had: Change=8'h95;
		8'hae: Change=8'he4;
		8'haf: Change=8'h79;
		8'hb0: Change=8'he7;
		8'hb1: Change=8'hc8;
		8'hb2: Change=8'h37;
		8'hb3: Change=8'h6d;
		8'hb4: Change=8'h8d;
		8'hb5: Change=8'hd5;
		8'hb6: Change=8'h4e;
		8'hb7: Change=8'ha9;
		8'hb8: Change=8'h6c;
		8'hb9: Change=8'h56;
		8'hba: Change=8'hf4;
		8'hbb: Change=8'hea;
		8'hbc: Change=8'h65;
		8'hbd: Change=8'h7a;
		8'hbe: Change=8'hae;
		8'hbf: Change=8'h08;
		8'hc0: Change=8'hba;
		8'hc1: Change=8'h78;
		8'hc2: Change=8'h25;
		8'hc3: Change=8'h2e;
		8'hc4: Change=8'h1c;
		8'hc5: Change=8'ha6;
		8'hc6: Change=8'hb4;
		8'hc7: Change=8'hc6;
		8'hc8: Change=8'he8;
		8'hc9: Change=8'hdd;
		8'hca: Change=8'h74;
		8'hcb: Change=8'h1f;
		8'hcc: Change=8'h4b;
		8'hcd: Change=8'hbd;
		8'hce: Change=8'h8b;
		8'hcf: Change=8'h8a;
		8'hd0: Change=8'h70;
		8'hd1: Change=8'h3e;
		8'hd2: Change=8'hb5;
		8'hd3: Change=8'h66;
		8'hd4: Change=8'h48;
		8'hd5: Change=8'h03;
		8'hd6: Change=8'hf6;
		8'hd7: Change=8'h0e;
		8'hd8: Change=8'h61;
		8'hd9: Change=8'h35;
		8'hda: Change=8'h57;
		8'hdb: Change=8'hb9;
		8'hdc: Change=8'h86;
		8'hdd: Change=8'hc1;
		8'hde: Change=8'h1d;
		8'hdf: Change=8'h9e;
		8'he0: Change=8'he1;
		8'he1: Change=8'hf8;
		8'he2: Change=8'h98;
		8'he3: Change=8'h11;
		8'he4: Change=8'h69;
		8'he5: Change=8'hd9;
		8'he6: Change=8'h8e;
		8'he7: Change=8'h94;
		8'he8: Change=8'h9b;
		8'he9: Change=8'h1e;
		8'hea: Change=8'h87;
		8'heb: Change=8'he9;
		8'hec: Change=8'hce;
		8'hed: Change=8'h55;
		8'hee: Change=8'h28;
		8'hef: Change=8'hdf;
		8'hf0: Change=8'h8c;
		8'hf1: Change=8'ha1;
		8'hf2: Change=8'h89;
		8'hf3: Change=8'h0d;
		8'hf4: Change=8'hbf;
		8'hf5: Change=8'he6;
		8'hf6: Change=8'h42;
		8'hf7: Change=8'h68;
		8'hf8: Change=8'h41;
		8'hf9: Change=8'h99;
		8'hfa: Change=8'h2d;
		8'hfb: Change=8'h0f;
		8'hfc: Change=8'hb0;
		8'hfd: Change=8'h54;
		8'hfe: Change=8'hbb;
		8'hff: Change=8'h16;
		endcase
	end
endfunction
endmodule