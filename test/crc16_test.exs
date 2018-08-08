defmodule Crc16Test do
  use ExUnit.Case, async: true
  doctest Crc16

  setup do
    # {:ok, server_pid} = Crc16.start_link([])
    pid = start_supervised(Crc16)
    %{crc: pid}
  end

  test "Calculate crc16 code on etalon message" do
    assert Crc16.get([1,2,3,4,5,6,7,8,9,10]) == {:ok, 52555}
  end
end
