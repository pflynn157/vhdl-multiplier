library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Mul2 is
    port (
        clk     : in std_logic;                         -- The clock
        reset   : in std_logic;
        A, B    : in std_logic_vector(7 downto 0);      -- The two inputs
        P       : out std_logic_vector(7 downto 0);     -- The product
        ready   : out std_logic
    );
end Mul2;

architecture Behavior of Mul2 is
    
    -- The right shift component
    component Rsh is
        port (
            A, B : in std_logic_vector(7 downto 0);
            P : out std_logic_vector(7 downto 0)
        );
    end component;
    
    -- The left shift component
    component Lsh is
        port (
            A, B : in std_logic_vector(7 downto 0);
            P : out std_logic_vector(7 downto 0)
        );
    end component;
    
    -- The adder
    component Adder is
        port (
            A, B : in std_logic_vector(7 downto 0);
            P : out std_logic_vector(7 downto 0);
            co : out std_logic
        );
    end component;
    
    -- Signals
    signal output1, output2, output : std_logic_vector(7 downto 0) := X"00";
    signal zero, output_final : std_logic_vector(7 downto 0) := X"00";
    signal counter_vec1, counter_vec2 : std_logic_vector(7 downto 0) := X"00";
    signal B_shift1, B_shift2 : std_logic_vector(7 downto 0) := X"00";
    signal imm1, imm_out1, imm2, imm_out2 : std_logic_vector(7 downto 0) := X"00";
    signal counter, stage : integer := 0;
begin
    rsh_unit1 : Rsh port map (A => B, B => counter_vec1, P => B_shift1);
    rsh_unit2 : Rsh port map (A => B, B => counter_vec2, P => B_shift2);
    
    lsh_unit1 : Lsh port map (A => imm1, B => counter_vec1, P => imm_out1);
    lsh_unit2 : Lsh port map (A => imm2, B => counter_vec2, P => imm_out2);
    
    adder1 : Adder port map (A => imm_out1, B => output, P => output1, co => open);
    adder2 : Adder port map (A => imm_out2, B => zero, P => output2, co => open);
    adder_final : Adder port map (A => output1, B => output2, P => output_final, co => open);

    process (clk) is
    begin
        -- If we're on a new clock cycle, and the reset bit is set... Then reset
        if rising_edge(clk) and reset = '1' then
            stage <= 0;
            counter <= 0;
            ready <= '0';
            P <= X"00";
        
        -- Otherwise, we can multiply
        elsif rising_edge(clk) and reset = '0' then
            -- Output the product and reset
            if counter = 8 then
                ready <= '1';
                counter <= 0;
                P <= output_final;
                output <= X"00";
                
            else
                -- Stage 0: Shift B
                if stage = 0 then
                    counter_vec1 <= std_logic_vector(to_unsigned(counter, 8));
                    counter_vec2 <= std_logic_vector(to_unsigned(counter+1, 8));
                    stage <= 1;
                
                -- Stage 1: B(c), B(c+1) AND A
                elsif stage = 1 then
                    if B_shift1(0) = '1' then
                        imm1 <= A;
                    else
                        imm1 <= X"00";
                    end if;
                    
                    if B_shift2(0) = '1' then
                        imm2 <= A;
                    else
                        imm2 <= X"00";
                    end if;
                
                    stage <= 2;
                
                -- Stage 2: Add the partial product and end the cycle
                elsif stage = 2 then
                    output <= output_final;
                
                    ready <= '0';
                    counter <= counter + 2;
                    stage <= 0;
                end if;
            end if;
        end if;
    end process;
end architecture;

