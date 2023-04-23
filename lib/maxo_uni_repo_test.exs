defmodule MaxoUniRepoTest do
  use ExUnit.Case
  use MnemeDefaults

  test "greeting" do
    auto_assert(MaxoUniRepo.greeting())
  end
end
