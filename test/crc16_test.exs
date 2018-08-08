defmodule Crc16Test do
  use ExUnit.Case, async: true
  doctest Crc16

  test "Calculate crc16 code on etalon message" do
    assert Crc16.get_crc([1,2,3,4,5,6,7,8,9,10]) == {:ok, 52555}
  end

  test "Data verification with no error" do
    assert Crc16.get_crc([1,2,3,4,5,6,7,8,9,10,205, 75]) == {:ok, 0}
  end

  test "Data verification with error" do
    assert Crc16.get_crc([1,2,3,4,5,6,7,8,9,10,205, 76]) != {:ok, 0}
  end
end
