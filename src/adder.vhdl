library IEEE;
use IEEE.std_logic_1164.all;

-- A single bit full adder
entity full_adder is
    port (
        a, b, ci : in std_logic;
        s, co : out std_logic
    );
end full_adder;

library IEEE;
use IEEE.std_logic_1164.all;

-- An eight-bit adder
entity adder is
    port (
        A : in std_logic_vector(7 downto 0);
        B : in std_logic_vector(7 downto 0);
        P : out std_logic_vector(7 downto 0);
        co : out std_logic
    );
end adder;

-- The logic for the single-bit adder
architecture rtl_full_adder of full_adder is
begin
    s <= (a xor b) xor ci;
    co <= ((a xor b) and ci) or (a and b);
end rtl_full_adder;

-- The logic for the 8-bit adder
architecture rtl_adder of adder is
    component full_adder
        port (
            a, b, ci : in std_logic;
            s, co : out std_logic
        );
    end component;
    
    signal c : std_logic_vector(8 downto 0);
begin
    op1 : full_adder port map(a => A(0), b => B(0), ci => '0', s => P(0), co => c(1));
    op2 : full_adder port map(a => A(1), b => B(1), ci => c(1), s => P(1), co => c(2));
    op3 : full_adder port map(a => A(2), b => B(2), ci => c(2), s => P(2), co => c(3));
    op4 : full_adder port map(a => A(3), b => B(3), ci => c(3), s => P(3), co => c(4));
    op5 : full_adder port map(a => A(4), b => B(4), ci => c(4), s => P(4), co => c(5));
    op6 : full_adder port map(a => A(5), b => B(5), ci => c(5), s => P(5), co => c(6));
    op7 : full_adder port map(a => A(6), b => B(6), ci => c(6), s => P(6), co => c(7));
    op8 : full_adder port map(a => A(7), b => B(7), ci => c(7), s => P(7), co => c(8));
    co <= c(8);
end rtl_adder;

