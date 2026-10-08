LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Calculadora_Completa IS
  PORT (
    -- Entradas do 1º Número (Teclado A)
    a0, a1, a2, a3, a4, a5, a6, a7, a8, a9: IN std_logic;
    -- Entradas do 2º Número (Teclado B)
    b0, b1, b2, b3, b4, b5, b6, b7, b8, b9: IN std_logic;

    -- Saídas para o Display da Unidade
    S_a0, S_b0, S_c0, S_d0, S_e0, S_f0, S_g0: OUT std_logic;
    -- Saídas para o Display da Dezena
    S_a1, S_b1, S_c1, S_d1, S_e1, S_f1, S_g1: OUT std_logic
  );
END Calculadora_Completa;

ARCHITECTURE Comportamento OF Calculadora_Completa IS
    -- Fios internos para interligar os módulos dentro do código
    signal A_bin, B_bin : std_logic_vector(3 downto 0);
    signal Soma_bin : std_logic_vector(4 downto 0);
    
    signal a_uni, b_uni, c_uni, d_uni: std_logic; 
    signal e_dez, f_dez, g_dez, h_dez: std_logic; 
BEGIN
    -- ==========================================
    -- 1. CONVERSOR DEC2BIN (ENTRADAS A e B)
    -- ==========================================
    A_bin(3) <= a9 or a8;
    A_bin(2) <= a4 or a5 or a6 or a7;
    A_bin(1) <= a2 or a3 or a6 or a7;
    A_bin(0) <= a1 or a3 or a5 or a7 or a9;

    B_bin(3) <= b9 or b8;
    B_bin(2) <= b4 or b5 or b6 or b7;
    B_bin(1) <= b2 or b3 or b6 or b7;
    B_bin(0) <= b1 or b3 or b5 or b7 or b9;

    -- ==========================================
    -- 2. SOMADOR (A + B)
    -- ==========================================
    Soma_bin <= std_logic_vector(unsigned('0' & A_bin) + unsigned('0' & B_bin));

    -- ==========================================
    -- 3. CONVERSOR BIN2DEC (Shift-and-Add-3)
    -- ==========================================
    process(Soma_bin) is
        variable BIN_org: std_logic_vector(4 DOWNTO 0);
        variable BCD0_org, BCD1_org: std_logic_vector(3 DOWNTO 0);
        variable BIN_shf: std_logic_vector(4 DOWNTO 0);
        variable BCD0_shf, BCD1_shf: std_logic_vector(3 DOWNTO 0);
        variable a, b, c, d, e, f, g, h: std_logic;
    begin
        BIN_org := Soma_bin;
        BCD0_org := "0000";
        BCD1_org := "0000";
        
        for i in 4 downto 0 loop
            a := BCD0_org(3); b := BCD0_org(2);
            c := BCD0_org(1); d := BCD0_org(0);
            
            e := BCD1_org(3); f := BCD1_org(2);
            g := BCD1_org(1); h := BCD1_org(0);
            
            BCD0_shf(3) := ((b and d) or (b and c)) or a;
            BCD0_shf(2) := (b and not c and not d) or (a and d) or (a and c);
            BCD0_shf(1) := (not a and not b and c) or (c and d) or (a and not c and not d) or (a and b and not d);
            BCD0_shf(0) := (not a and not b and d) or (not a and b and c and not d) or (a and not b and not d) or (a and b and d) or (a and not c and not d);
                
            BCD1_shf(3) := (f and h) or (f and g) or e;
            BCD1_shf(2) := (f and not g and not h) or (e and h) or (e and g);
            BCD1_shf(1) := (not e and not f and g) or (g and h) or (e and not g and not h) or (e and f and not h);
            BCD1_shf(0) := (not e and not f and h) or (not e and f and g and not h) or (e and not f and not h) or (e and f and h) or (e and not g and not h);
            
            BCD0_org := BCD0_shf;
            BCD1_org := BCD1_shf;
            
            BCD1_shf(3) := BCD1_org(2);
            BCD1_shf(2) := BCD1_org(1);
            BCD1_shf(1) := BCD1_org(0);
            BCD1_shf(0) := BCD0_org(3);
            
            BCD0_shf(3) := BCD0_org(2);
            BCD0_shf(2) := BCD0_org(1);
            BCD0_shf(1) := BCD0_org(0);
            BCD0_shf(0) := BIN_org(4);
            
            BIN_shf(4) := BIN_org(3);
            BIN_shf(3) := BIN_org(2);
            BIN_shf(2) := BIN_org(1);
            BIN_shf(1) := BIN_org(0);
            BIN_shf(0) := '0';
            
            BIN_org := BIN_shf;
            BCD0_org := BCD0_shf;
            BCD1_org := BCD1_shf;
         end loop;
         
        a_uni <= BCD0_org(3); b_uni <= BCD0_org(2);
        c_uni <= BCD0_org(1); d_uni <= BCD0_org(0);
        
        e_dez <= BCD1_org(3); f_dez <= BCD1_org(2);
        g_dez <= BCD1_org(1); h_dez <= BCD1_org(0);
    end process;

    -- ==========================================
    -- 4. DECODIFICADORES 7-SEGMENTOS
    -- ==========================================
    S_a0 <= a_uni or c_uni or not ((not b_uni and d_uni) or (b_uni and not d_uni));
    S_b0 <= not b_uni or not ((not c_uni and d_uni) or (c_uni and not d_uni));
    S_c0 <= b_uni or not c_uni or d_uni;
    S_d0 <= a_uni or (not b_uni and not d_uni) or (not b_uni and c_uni) or (c_uni and not d_uni) or (b_uni and not c_uni and d_uni);
    S_e0 <= (not b_uni and not d_uni) or (c_uni and not d_uni);
    S_f0 <= a_uni or (not c_uni and not d_uni) or (b_uni and not c_uni) or (b_uni and not d_uni);
    S_g0 <= a_uni or ((not b_uni and c_uni) or (b_uni and not c_uni)) or (c_uni and not d_uni);

    S_a1 <= e_dez or g_dez or not ((not f_dez and h_dez) or (f_dez and not h_dez));
    S_b1 <= not f_dez or not ((not g_dez and h_dez) or (g_dez and not h_dez));
    S_c1 <= f_dez or not g_dez or h_dez;
    S_d1 <= e_dez or (not f_dez and not h_dez) or (not f_dez and g_dez) or (g_dez and not h_dez) or (f_dez and not g_dez and h_dez);
    S_e1 <= (not f_dez and not h_dez) or (g_dez and not h_dez);
    S_f1 <= e_dez or (not g_dez and not h_dez) or (f_dez and not g_dez) or (f_dez and not h_dez);
    S_g1 <= e_dez or ((not g_dez and f_dez) or (g_dez and not f_dez)) or (g_dez and not h_dez);

END Comportamento;
