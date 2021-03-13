library ieee;
use ieee.std_logic_1164.all;

entity slow_exp_tb is
end slow_exp_tb;

architecture behavior of slow_exp_tb is
    
    -- Declare our component
    component Slow_Exp is
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
    uut : Slow_Exp port map (clk => clk, reset => reset, A => A, B => B, P => P, ready => ready);
    
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
        --A <= X"0A";
        --B <= X"02";
        --wait until ready = '1';
        --assert P = X"64" report "10 ** 2 failed" severity error;
        
        A <= X"03";
        B <= X"03";
        wait until ready = '1';
        assert P = X"1B" report "3 ** 3 failed" severity error;
        
        --A <= X"0A";
        --B <= X"02";
        --wait until ready = '1';
        --assert P = X"64" report "10 ** 2 failed" severity error;
        
        A <= X"03";
        B <= X"05";
        wait until ready = '1';
        assert P = X"F3" report "3 ** 5 failed" severity error;
        
        --A <= X"11";
        --B <= X"03";
        --wait until ready = '1';
        --assert P = X"33" report "17 * 3 failed" severity error;
        
        wait;
        
    end process;
end architecture;

