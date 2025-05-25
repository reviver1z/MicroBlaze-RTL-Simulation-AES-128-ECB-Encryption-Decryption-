library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use ieee.numeric_std.all;
use std.textio.all;

entity testbench is
end entity testbench;

architecture my_testbench of testbench is
  signal clk   : std_logic := '0';
  signal clk_n   : std_logic := '1';
  signal rst_n : std_logic := '1';
  signal rst : std_logic := '0';
  signal rs232_uart_txd : std_logic := 'Z';
  signal rs232_uart_rxd : std_logic;

component design_1_wrapper is
  port (
    diff_clock_rtl_0_clk_n : in STD_LOGIC;
    diff_clock_rtl_0_clk_p : in STD_LOGIC;
    reset_rtl_0 : in STD_LOGIC;
    uart_rtl_0_rxd : in STD_LOGIC;
    uart_rtl_0_txd : out STD_LOGIC
  );
end component;

  signal character_state : std_logic_vector (2 downto 0) := "000";
  signal counter : std_logic_vector (31 downto 0) := x"00000000";
  signal number_of_bits_received : std_logic_vector (31 downto 0) := x"00000000";
  signal data_received : std_logic_vector (9 downto 0) := "0000000000";
  file output_file_stdout : text; 
  signal charbuffer : String (1 to 20);        
  signal charbuffer_index : integer := 1;
begin
    uut : design_1_wrapper port map (diff_clock_rtl_0_clk_n => clk_n, diff_clock_rtl_0_clk_p => clk, reset_rtl_0 => rst_n,
                                     uart_rtl_0_txd => rs232_uart_txd,
                                     uart_rtl_0_rxd => rs232_uart_rxd);

  -- system input clock = 100 MHz, half-period = 5 ns
  -- UART Baud rate 115200. => 100M/115200 TB-clock-cycles.
  --    (100M/115200) = 868 = 0x364, half/mid = 434 = 0x1B2
  
  clk   <= not clk after 5 ns ;			
  clk_n <= not clk;

  process
  begin
    file_open(output_file_stdout, "STD_OUTPUT", write_mode);
    rst_n <= '0';
    rst <= '1';
    wait for 80 ns;
    rst_n <= '1';
    rst <= '0';
    wait;
  end process;



  process (clk)
    variable line1 : line;
  begin
    if rising_edge (clk) then
        if '1' = rst_n then
        counter <= std_logic_vector (unsigned (counter) + x"00000001");
        case character_state is
            when "000" => 
                if '0' = rs232_uart_txd then
                    character_state <= "001"; -- start bit '0' received.
                    counter <= x"00000000";
                end if;
            when "001" => -- start bit clock cycles
                if counter = x"000001B2" then 
                    character_state <= "010"; -- reached middle of start bit.
                    counter <= x"00000000";
                end if;
            when "010" => -- receiving characters
                if counter = x"00000364" then -- goto next character
                    data_received(9) <= rs232_uart_txd;
                    data_received(8 downto 0) <= data_received(9 downto 1);
                    counter <= x"00000000";
                    if number_of_bits_received = x"00000007" then
                        number_of_bits_received <= x"00000000";
                        character_state <= "011";
                    else
                        number_of_bits_received <= std_logic_vector (unsigned (number_of_bits_received) + x"00000001");
                    end if;
                end if;
            when "011" =>
                if counter = x"00000364" then -- middle of stop character
                    -- report "received " & integer'image (to_integer (unsigned (data_received(9 downto 2))));
                    -- write (line1, character'val(to_integer(unsigned(data_received(9 downto 2)))));
                    -- writeline (output_file_stdout, line1);
                    if (charbuffer_index = 19) then         
                        charbuffer (1) <= character'val(to_integer(unsigned(data_received(9 downto 2))));
                        charbuffer_index <= 2;
                        write (line1, charbuffer, left);
                        writeline (output_file_stdout, line1);
                    elsif (10 = to_integer(unsigned(data_received(9 downto 2)))) then
                        charbuffer_index <= 1;
                        write (line1, charbuffer, left);
                        writeline (output_file_stdout, line1);
                    else
                        charbuffer(charbuffer_index) <= character'val(to_integer(unsigned(data_received(9 downto 2))));
                        charbuffer_index <= charbuffer_index + 1;
                    end if;
                    character_state <= "000";
                    counter <= x"00000000";
                end if;
            when others =>
                counter <= x"00000000";
                data_received <= "0000000000";
                number_of_bits_received <= x"00000000";
                character_state <= "000";
        end case;
        end if;
    end if;
  end process;

end architecture my_testbench;















--ShortCut: Ctrl + / MrRanger TestBench:
--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use ieee.numeric_std.all;
--use std.textio.all;

--entity testbench is
--end entity testbench;

--architecture my_testbench of testbench is
--  signal clk            : std_logic := '0';
--  signal clk_n          : std_logic := '1';
--  signal rst_n          : std_logic := '1';
--  signal rst            : std_logic := '0';

--  signal rs232_uart_txd : std_logic := 'Z';
--  signal rs232_uart_rxd : std_logic := '1';
  
--  signal bram_wrdata_a_0 : std_logic_vector(31 downto 0);

--  component design_1_wrapper is
--    port (
--      bram_wrdata_a_0        : out std_logic_vector(31 downto 0);
--      diff_clock_rtl_0_clk_n : in  std_logic;
--      diff_clock_rtl_0_clk_p : in  std_logic;
--      reset_rtl_0            : in  std_logic;
--      uart_rtl_0_rxd         : in  std_logic;
--      uart_rtl_0_txd         : out std_logic
--    );
--  end component;

--  signal character_state         : std_logic_vector(2 downto 0) := "000";
--  signal counter                 : std_logic_vector(31 downto 0) := x"00000000";
--  signal number_of_bits_received : std_logic_vector(31 downto 0) := x"00000000";
--  signal data_received           : std_logic_vector(9 downto 0)  := (others => '0');
--  file output_file_stdout        : text; 
--  signal charbuffer              : String(1 to 20) := (others => ' ');
--  signal charbuffer_index        : integer := 1;

--  -----------------------------------------------------------------------------
--  -- A helper function to compute base^exp for a real base and integer exponent.
--  -----------------------------------------------------------------------------
--  function power_r(base: real; exp: integer) return real is
--    variable result : real := 1.0;
--  begin
--    if exp > 0 then
--      for i in 1 to exp loop
--         result := result * base;
--      end loop;
--    elsif exp < 0 then
--      for i in 1 to -exp loop
--         result := result / base;
--      end loop;
--    end if;
--    return result;
--  end function;

--  -----------------------------------------------------------------------------
--  -- Converts a 32-bit IEEE 754 single-precision float (in std_logic_vector format) into a real value.
--  -----------------------------------------------------------------------------
--  function ieee754_to_real(v: std_logic_vector(31 downto 0)) return real is
--    variable sign_bit : real;
--    variable exponent : integer;
--    variable mantissa : integer;
--    variable fraction : real;
--    variable result   : real;
--  begin
--    if v(31) = '1' then
--       sign_bit := -1.0;
--    else
--       sign_bit := 1.0;
--    end if;
--    exponent := to_integer(unsigned(v(30 downto 23))) - 127;
--    mantissa := to_integer(unsigned(v(22 downto 0)));
--    fraction := 1.0 + real(mantissa) / power_r(2.0, 23);
--    result := sign_bit * fraction * power_r(2.0, exponent);
--    return result;
--  end function;

--begin

--  uut: design_1_wrapper port map (
--      bram_wrdata_a_0        => bram_wrdata_a_0,
--      diff_clock_rtl_0_clk_n => clk_n,
--      diff_clock_rtl_0_clk_p => clk,
--      reset_rtl_0            => rst_n,
--      uart_rtl_0_rxd         => rs232_uart_rxd,
--      uart_rtl_0_txd         => rs232_uart_txd
--  );

--  clk   <= not clk after 5 ns;
--  clk_n <= not clk;

--  process
--  begin
--    file_open(output_file_stdout, "STD_OUTPUT", write_mode);
--    rst_n <= '0';
--    rst   <= '1';
--    wait for 80 ns;
--    rst_n <= '1';
--    rst   <= '0';
--    wait;
--  end process;

--  process(clk)
--    variable line1 : line;
--  begin
--    if rising_edge(clk) then
--      if rst_n = '1' then
--        counter <= std_logic_vector(unsigned(counter) + 1);
--        case character_state is
--          when "000" =>
--            if rs232_uart_txd = '0' then
--              character_state <= "001";
--              counter         <= x"00000000";
--            end if;
--          when "001" =>
--            if counter = x"000001B2" then 
--              character_state <= "010";
--              counter         <= x"00000000";
--            end if;
--          when "010" =>
--            if counter = x"00000364" then
--              data_received(9) <= rs232_uart_txd;
--              data_received(8 downto 0) <= data_received(9 downto 1);
--              counter         <= x"00000000";
--              if number_of_bits_received = x"00000007" then
--                number_of_bits_received <= x"00000000";
--                character_state <= "011";
--              else
--                number_of_bits_received <= std_logic_vector(unsigned(number_of_bits_received) + 1);
--              end if;
--            end if;
--          when "011" =>
--            if counter = x"00000364" then
--              null;
--            end if;
--          when others =>
--            counter                 <= x"00000000";
--            data_received           <= (others => '0');
--            number_of_bits_received <= (others => '0');
--            character_state         <= "000";
--        end case;
--      end if;
--    end if;
--  end process;

--  print_sum_proc: process
--    variable line2      : line;
--    variable comp_sum   : real;
--    variable msg_str    : string(1 to 20);
--    variable num_line   : line;
--    variable num_str    : string(1 to 14);
--    variable i          : integer;
--    variable old_msg_str: string(1 to 20) := (others => ' ');
--  begin
--    wait for 150 us;
--    loop
--      comp_sum := ieee754_to_real(bram_wrdata_a_0);
--      num_line := null;
--      std.textio.write(num_line, comp_sum, RIGHT, 14, 5);
--      num_str := num_line.all(1 to 14);
--      msg_str := "Sum = " & num_str;
--      if msg_str /= old_msg_str then
--        for i in 1 to 20 loop
--          charbuffer(i) <= ' ';
--        end loop;
--        wait for 1 us;
--        for i in 1 to 20 loop
--          charbuffer(i) <= msg_str(i);
--        end loop;
--        old_msg_str := msg_str;
--        line2 := null;
--        std.textio.write(line2, msg_str);
--        std.textio.writeline(output_file_stdout, line2);
--      end if;
--      wait for 50 us;
--    end loop;
--  end process print_sum_proc;

--end architecture my_testbench;
