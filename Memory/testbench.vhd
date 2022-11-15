library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench is
end ;

architecture mixed of testbench is
  constant addr_width : natural := 16 ;
  constant data_width : natural := 8 ;

  signal clock : std_logic ;
  signal data_read : std_logic ;
  signal data_write : std_logic ;
  signal data_addr : std_logic_vector(addr_width - 1 downto 0) ;
  signal data_in : std_logic_vector(data_width - 1 downto 0) ;
  signal data_out : std_logic_vector((data_width * 4) - 1 downto 0) := (others => '0') ;

begin
  memory : entity work.mem(algorithm)
  generic map (addr_width, data_width)
  port map (clock, data_read, data_write, data_addr, data_in, data_out);

  check_memory : process is
  begin
    clock <= '0' ;
    wait for 10 ns ;
    clock <= '1' ;
    wait for 10 ns ;

    data_read <= '0' ;
    data_write <= '1' ;
    data_addr <= std_logic_vector(to_unsigned(0, addr_width)) ;
    data_in <=  x"FF" ;

    clock <= '0' ;
    wait for 10 ns ;
    clock <= '1' ;
    wait for 10 ns ;

    data_read <= '0' ;
    data_write <= '1' ;
    data_addr <= std_logic_vector(to_unsigned(1, addr_width)) ;
    data_in <=  x"FA" ;

    clock <= '0' ;
    wait for 10 ns ;
    clock <= '1' ;
    wait for 10 ns ;

    data_read <= '0' ;
    data_write <= '1' ;
    data_addr <= std_logic_vector(to_unsigned(2, addr_width)) ;
    data_in <=  x"96" ;

    clock <= '0' ;
    wait for 10 ns ;
    clock <= '1' ;
    wait for 10 ns ;

    data_read <= '0' ;
    data_write <= '1' ;
    data_addr <= std_logic_vector(to_unsigned(3, addr_width)) ;
    data_in <=  x"64" ;

    clock <= '0' ;
    wait for 10 ns ;
    clock <= '1' ;
    wait for 10 ns ;

    data_read <= '1' ;
    data_write <= '0' ;
    data_addr <= std_logic_vector(to_unsigned(0, addr_width)) ;

    clock <= '0' ;
    wait for 10 ns ;
    clock <= '1' ;
    wait for 10 ns ;

    assert data_out = x"6496FAFF" report "Erro" ;

    report "Fim da Simulação..." ;

    wait ;
  end process check_memory ;

end mixed ;