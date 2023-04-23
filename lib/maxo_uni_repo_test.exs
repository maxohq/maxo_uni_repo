defmodule MaxoUniRepoTest do
  use ExUnit.Case
  use MnemeDefaults

  test "greeting" do
    auto_assert("Welcome to Maxo!" <- MaxoUniRepo.greeting())
  end
end
