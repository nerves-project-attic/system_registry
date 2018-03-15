defmodule SystemRegistryTest.Case do
  use ExUnit.CaseTemplate

  using do
    quote do
      import unquote(__MODULE__)
      alias SystemRegistryTest.Case
    end
  end

  setup do
    Application.stop(:system_registry)
    Application.start(:system_registry)

    :ok
  end
end
