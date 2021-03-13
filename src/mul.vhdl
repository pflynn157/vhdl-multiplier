library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Mul is
    port (
        clk     : in std_logic;                         -- The clock
        reset   : in std_logic;
        A, B    : in std_logic_vector(7 downto 0);      -- The two inputs
        P       : out std_logic_vector(7 downto 0);     -- The product
        ready   : out std_logic
    );
end Mul;

architecture Behavior of Mul is

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
    signal output, output_final : std_logic_vector(7 downto 0) := X"00";
    signal B_shift, counter_vec, imm, imm2 : std_logic_vector(7 downto 0) := X"00";
    signal counter, stage : integer := 0;
begin
    rsh_unit : Rsh port map (A => B, B => counter_vec, P => B_shift);
    lsh_unit : Lsh port map (A => imm, B => counter_vec, P => imm2);
    adder_unit : Adder port map (A => imm2, B => output, P => output_final, co => open);
    
    process (clk) is
    begin
        -- If we're on a new clock cycle, and the reset bit is set... Then reset
        if rising_edge(clk) and reset = '1' then
            stage <= 0;
            counter <= 0;
            ready <= '0';
            counter_vec <= X"00";
            P <= X"00";
            
        -- Otherwise if we're on a new clock cycle and the reset bit is not set,
        -- then start multiplying
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
                    counter_vec <= std_logic_vector(to_unsigned(counter, 8));
                    stage <= 1;
                    
                -- Stage 1: B(0) AND A
                elsif stage = 1 then
                    if B_shift(0) = '1' then
                        imm <= A;
                    else
                        imm <= X"00";
                    end if;
                    stage <= 2;
                    
                -- Stage 3: Add the partial product and end the cyle
                elsif stage = 2 then
                    output <= output_final;
                    --stage <= 3;
                    
                    ready <= '0';
                    counter <= counter + 1;
                    stage <= 0;
                end if;
            end if;
        end if;
    end process;
end architecture;

