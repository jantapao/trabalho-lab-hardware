library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity testbench is
end ;

architecture mixed of testbench is
  signal interrupt : std_logic ;
  signal read_signal : std_logic ;
  signal write_signal : std_logic ;
  signal valid : std_logic ;
  signal codec_data_in : std_logic_vector(7 downto 0) ;
  signal codec_data_out : std_logic_vector(7 downto 0) ;

begin
  codec : entity work.codec(algorithm)
  port map (interrupt, read_signal, write_signal, valid, codec_data_in, codec_data_out) ;

  check_codec : process is
  begin
    interrupt <= '1' ;

    read_signal <= '0' ;
    write_signal <= '1' ;
    codec_data_in <= x"FF" ;

    wait for 50 ns ;

    assert valid = '1' report "Erro na Validação da Escrita" ;

    write_signal <= '0' ;
    read_signal <= '1' ;

    wait for 50 ns ;

    assert valid = '1' report "Erro na Validação da Leitura" ;
    assert codec_data_out = x"FF" report "Erro na Leitura" ;

    read_signal <= '0' ;
    write_signal <= '1' ;
    codec_data_in <= x"64" ;

    wait for 50 ns ;

    assert valid = '1' report "Erro na Validação da Escrita" ;

    write_signal <= '0' ;
    read_signal <= '1' ;

    wait for 50 ns ;

    assert valid = '1' report "Erro na Validação da Leitura" ;
    assert codec_data_out = x"64" report "Erro na Leitura" ;
 
    interrupt <= '0' ;

    wait for 50 ns ;

    report "Fim da Simulação" ;

    wait ;
  end process check_codec ;
end mixed ;