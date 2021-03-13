library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity slow_exp is
    port (
        clk     : in std_logic;
        reset   : in std_logic;
        A, B    : in std_logic_vector(7 downto 0);
        P       : out std_logic_vector(7 downto 0);
        ready   : out std_logic
    );
end slow_exp;

architecture Behavior of Slow_Exp is
    
    -- The multiplication component
    component Mul is
        port (
            clk : in std_logic;
            reset : in std_logic;
            A, B : in std_logic_vector(7 downto 0);
            P : out std_logic_vector(7 downto 0);
            ready : out std_logic
        );
    end component;
    
    -- The signals
    signal counter : integer := 1;
    signal stage : integer := 0;
    signal output, input1, input2 : std_logic_vector(7 downto 0) := X"00";
    signal mul_reset, mul_ready : std_logic := '0';
begin
    mul_unit1 : Mul port map(clk => clk, reset => mul_reset, A => input1, B => input2, P => output, ready => mul_ready);

    process (clk) is
    begin
        -- Reset if needed
        if rising_edge(clk) and reset = '1' then
            counter <= 1;
            stage <= 0;
            ready <= '0';
            P <= X"00";
            mul_reset <= '1';
        
        -- Otherwise, do math
        elsif rising_edge(clk) and reset = '0' then
            -- If we have iterated enough, we can return
            if B = std_logic_vector(to_unsigned(counter, 8)) then
            
                ready <= '1';
                counter <= 1;
                stage <= 0;
                P <= output;
                input1 <= X"00";
                input2 <= X"00";
                mul_reset <= '1';
            
            -- Otherwise, work
            else
                ready <= '0';
                mul_reset <= '0';
                
                if stage = 0 then
                    if mul_ready = '0' and counter = 1 then
                        input1 <= A;
                        input2 <= A;
                    else
                        input2 <= output;
                    end if;
                    stage <= 1;
                elsif stage = 1 then
                    if mul_ready = '1' then
                        stage <= 2;
                    end if;
                elsif stage = 2 then
                    input2 <= output;
                    counter <= counter + 1;
                    stage <= 0;
                end if;
            end if;
        end if;
    end process;
end Behavior;

