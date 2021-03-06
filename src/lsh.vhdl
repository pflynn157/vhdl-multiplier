-- The left shifter
library IEEE;
use IEEE.std_logic_1164.all;

entity Lsh is
    port (
        A, B : in std_logic_vector(7 downto 0);
        P : out std_logic_vector(7 downto 0)
    );
end entity;

architecture Behavior of Lsh is
    signal buf1, buf2, buf3 : std_logic_vector(7 downto 0) := X"00";
begin
    -- Shift 2^0
    process (A, B)
    begin
        if B(0) = '0' then
            buf1 <= A;
        else
            buf1(0) <= '0';
            buf1(1) <= A(0);
            buf1(2) <= A(1);
            buf1(3) <= A(2);
            buf1(4) <= A(3);
            buf1(5) <= A(4);
            buf1(6) <= A(5);
            buf1(7) <= A(6);
        end if;
    end process;
    
    -- Shift 2^1
    process (A, B, buf1)
    begin
        if B(1) = '0' then
            buf2 <= buf1;
        else
            buf2(0) <= '0';
            buf2(1) <= '0';
            buf2(2) <= buf1(0);
            buf2(3) <= buf1(1);
            buf2(4) <= buf1(2);
            buf2(5) <= buf1(3);
            buf2(6) <= buf1(4);
            buf2(7) <= buf1(5);
        end if;
    end process;
    
    -- Shift 2^2
    process (A, B, buf2)
    begin
        if B(2) = '0' then
            buf3 <= buf2;
        else
            buf3(0) <= '0';
            buf3(1) <= '0';
            buf3(2) <= '0';
            buf3(3) <= '0';
            buf3(4) <= buf2(0);
            buf3(5) <= buf2(1);
            buf3(6) <= buf2(2);
            buf3(7) <= buf2(3);
        end if;
    end process;

    P <= buf3;
end architecture;

