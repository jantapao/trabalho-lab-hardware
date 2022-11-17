library ieee;
use ieee.std_logic_1164.all;

entity cpu is
  generic (
    addr_width: natural := 16; -- Memory Address Width (in bits)
    data_width: natural := 8 -- Data Width (in bits)
  );

  port (
    clock: in std_logic; -- Clock signal
    halt : in std_logic; -- Halt processor execution when '1'

    ---- Begin Memory Signals ---
    -- Instruction byte received from memory
    instruction_in : in std_logic_vector(data_width-1 downto 0);
    -- Instruction address given to memory
    instruction_addr: out std_logic_vector(addr_width-1 downto 0);

    mem_data_read : out std_logic; -- When '1', read data from memory
    mem_data_write: out std_logic; -- When '1', write data to memory
    -- Data address given to memory
    mem_data_addr : out std_logic_vector(addr_width-1 downto 0);
    -- Data sent from memory when data_read = '1' and data_write = '0'
    mem_data_in : out std_logic_vector((data_width*2)-1 downto 0);
    -- Data sent to memory when data_read = '0' and data_write = '1'
    mem_data_out : in std_logic_vector((data_width*4)-1 downto 0);
    ---- End Memory Signals ---

    ---- Begin Codec Signals ---
    codec_interrupt: out std_logic; -- Interrupt signal
    codec_read: out std_logic; -- Read signal
    codec_write: out std_logic; -- Write signal
    codec_valid: in std_logic; -- Valid signal

    -- Byte written to codec
    codec_data_out : in std_logic_vector(7 downto 0);
    -- Byte read from codec
    codec_data_in : out std_logic_vector(7 downto 0)
    ---- End Codec Signals ---
  );
end entity;

architecture algorithm of cpu is
  -- Declarações
begin
  CODEC : entity work.codec (algorithm)
  port map (codec_interrupt, codec_read, codec_write, codec_valid, codec_data_in, codec_data_out) ;

  IMEM : entity work.mem (algorithm)
  generic map (addr_width, data_width)
  port map (clock, mem_data_read, mem_data_out, mem_data_addr, mem_data_in, mem_data_out) ;

  DMEM : entity work.mem (algorithm)
  generic map (addr_width, data_width)
  port map (clock, mem_data_read, mem_data_out, mem_data_addr, mem_data_in, mem_data_out) ;

end algorithm ;