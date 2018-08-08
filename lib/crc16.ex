defmodule Crc16 do
  @moduledoc """
  Brings result of CRC calculation.
  Polynom: CRC-16-CCITT (x^16 + x^12 + x^5 + 1) or 0x1021.
  """

  use GenServer
  use Bitwise
  require Logger

  @polynom 0x1021

  

  ## Client API

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: :crc_handler)
  end

  @spec get_crc([byte]) :: integer
  def get_crc(package) do
    GenServer.call(:crc_handler, {:get_crc, package})
  end

  def help() do
    GenServer.call(:crc_handler, :help)
  end



  ## Server callbacks

  @doc """
  Generates CRC lookup table.
  """
  def init (:ok) do
    {:ok,
    Enum.map(0..255, fn(i) ->
      Enum.reduce(0..7, i <<< 8, fn(_, crc) ->
        case crc &&& 0x8000 do
          0x8000 -> ((crc <<< 1) ^^^ @polynom) &&& 0xFFFF
          _ -> (crc <<< 1)  &&& 0xFFFF
        end 
      end)
    end)
    }
  end

  @doc """
  Calculates 16-bit CRC for given package.
  If package contains 16-bit CRC as its tail, returns 0x0000
  in case of package is error free.
  """
  def handle_call({:get_crc, package}, _from, crc_lookup_table) do
    {:reply,
      {:ok,
        Enum.reduce(package, 0x0000, fn(byte, crc) ->
          ((crc <<< 8) &&& 0xFFFF) ^^^ (Enum.at(crc_lookup_table, ((crc >>> 8) &&& 0xFF) ^^^ (byte &&& 0xFF)) &&& 0xFFFF)
        end)
      },
      crc_lookup_table
    }
  end

  @doc """
  Returns info about polinom and full-size CRC lookup table.
  """
  def handle_call(:help, _from, crc_lookup_table) do
    # Returns the CRC lookup table for test reson.
    {:reply, {:ok, "Polynom: CRC-16-CCITT (x^16 + x^12 + x^5 + 1) or 0x1021.", crc_lookup_table}, crc_lookup_table}
  end
end
