library ieee;
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;

entity mem_2bytes is

  generic (
    addr_width : natural := 16; -- Memory Address Width (in bits)
    data_width : natural := 8 -- Data Width (in bits)
  );

  port (
    clock : in std_logic; -- Clock signal; Write on Falling-Edge

    data_read : in std_logic; -- When '1', read data from memory
    data_write : in std_logic; -- When '1', write data to memory

    -- Data address given to memory
    data_addr : in std_logic_vector(addr_width - 1 downto 0);

    -- Data sent from memory when data_read = '1' and data_write = '0'
    data_in : in std_logic_vector((data_width * 2) - 1 downto 0);

    -- Data sent to memory when data_read = '0' and data_write = '1'
    data_out : out std_logic_vector((data_width * 4) - 1 downto 0)
  );

end;

architecture algorithm of mem_2bytes is
  type t_mem is array ((2**addr_width)-1 downto 0) of std_logic_vector(data_width-1 downto 0) ;
  signal memory : t_mem ;

begin
  leitura: process (data_read, data_addr) is
    variable read_value : std_logic_vector(data_width-1 downto 0) ;

  begin
    if data_read = '1' and data_write = '0' then
      read_value := memory(to_integer(unsigned(data_addr))) ;
      for i in 0 to data_width-1 loop
        data_out(i) <= read_value(i) ;
      end loop ;

      read_value := memory(to_integer(unsigned(data_addr)) + 1) ;
      for i in data_width to (2*data_width)-1 loop
        data_out(i) <= read_value(i-data_width) ;
      end loop ;

      read_value := memory(to_integer(unsigned(data_addr)) + 2) ;
      for i in 2*data_width to (3*data_width)-1 loop
        data_out(i) <= read_value(i-(2*data_width)) ;
      end loop ;

      read_value := memory(to_integer(unsigned(data_addr)) + 3) ;
      for i in 3*data_width to (4*data_width)-1 loop
        data_out(i) <= read_value(i-(3*data_width)) ;
      end loop ;
    end if ;
  end process leitura;

  escrita: process (data_write, data_addr, data_in, clock) is
  begin
    if data_write = '1' and data_read = '0' then
      for i in data_width - 1 downto 0 loop
        memory(to_integer(unsigned(data_addr)))(i) <= data_in(i) ;
      end loop ;
      for i in (2 * data_width) - 1 downto data_width loop
        memory(to_integer(unsigned(data_addr)) + 1)(i) <= data_in(i) ;
      end loop ;  
    end if ;
  end process escrita ;
end algorithm ;