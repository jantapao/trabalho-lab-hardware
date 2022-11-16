library ieee, std;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;

entity codec is
  port (
    interrupt: in std_logic; -- Interrupt signal
    read_signal: in std_logic; -- Read signal
    write_signal: in std_logic; -- Write signal
    valid: out std_logic; -- Valid signal

    -- Byte written to codec
    codec_data_in : in std_logic_vector(7 downto 0);
    -- Byte read from codec
    codec_data_out : out std_logic_vector(7 downto 0)
  );
end codec;

architecture algorithm of codec is
begin
  processao : process (interrupt, read_signal, write_signal, codec_data_in) is
    type t_arq is file of std_logic_vector ;
    file arq_sinais : t_arq ;
    variable file_data_out : std_logic_vector(7 downto 0) ;
    variable status : file_open_status ;
    variable tam_codec : natural ;
    variable exit_code : std_logic ;

  begin
    if interrupt = '1' and read_signal = '1' and write_signal = '0' then
      file_open(status, arq_sinais, "arquivo.dat", read_mode) ;
      if status /= open_ok then
        report "Erro na abertura do arquivo" severity warning ;
        exit_code := '0' ;
      else
        while not endfile(arq_sinais) loop
          read(arq_sinais, file_data_out, tam_codec) ;
          if tam_codec > file_data_out'length then
            report "Pacote longo - Ignorado" severity warning ;
          else
            if tam_codec <= file_data_out'length then
              codec_data_out <= file_data_out ;
              exit_code := '1' ;
            end if ;
          end if ;
        end loop;
        file_close(arq_sinais) ;
      end if ;
    end if ;
    if interrupt = '1' and write_signal = '1' and read_signal = '0' then
      file_open(status, arq_sinais, "arquivo.dat", write_mode) ;
      if status /= open_ok then
        report "Erro na abertura do arquivo" severity warning ;
        exit_code := '0' ;
      else
        write(arq_sinais, codec_data_in) ;
        exit_code := '1' ;
        file_close(arq_sinais) ;
      end if ;
    end if ;
    valid <= exit_code ;
  end process processao ;

end algorithm ;