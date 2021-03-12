library ieee;
use ieee.std_logic_1164.all;

entity mul_tb2 is
end mul_tb2;

architecture behavior of mul_tb2 is
    
    -- Declare our component
    component Mul2 is
        port (
            clk : in std_logic;
            reset : in std_logic;
            A, B : in std_logic_vector(7 downto 0);
            P : out std_logic_vector(7 downto 0);
            ready : out std_logic
        );
    end component;
    
    -- Bind to the component
    signal clk, reset, ready : std_logic := '0';
    signal A, B, P : std_logic_vector(7 downto 0) := X"00";
    
    -- Clock period definitions
    constant clk_period : time := 10 ns;
begin
    -- Initialize component
    uut : Mul2 port map (clk => clk, reset => reset, A => A, B => B, P => P, ready => ready);
    
    -- Clock process definitions
    I_clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
 
    -- Test process
    stim_proc: process
    begin
        -- hold reset state for 100 ns.
        wait for 100 ns;
        reset <= '1'; 
        wait for clk_period;
        reset <= '0';
        
        -- Start testing
        A <= "00000101";
        B <= "00000010";
        wait until ready = '1';
        assert P = X"0A" report "5 * 2 failed" severity error;
        
        A <= X"07";
        B <= X"02";
        wait until ready = '1';
        assert P = X"0E" report "7 * 2 failed" severity error;
        
        A <= X"03";
        B <= X"03";
        wait until ready = '1';
        assert P = X"09" report "3 * 3 failed" severity error;
        
        A <= X"11";
        B <= X"03";
        wait until ready = '1';
        assert P = X"33" report "17 * 3 failed" severity error;
        
        wait;
        
    end process;
end architecture;

