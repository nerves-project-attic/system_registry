defmodule SystemRegistry.Processor.Config do
  use SystemRegistry.Processor

  @mount :config

  #alias SystemRegistry.Storage.Binding, as: B
  alias SystemRegistry.Transaction

  def init(opts) do
    {:ok, %{opts: opts, producers: []}}
  end

  def handle_validate(%Transaction{} = t, s) do
    {:ok, :ok, s}
  end

  def handle_commit(%Transaction{} = _t, s) do
    mount = s.opts[:mount] || @mount
    {:ok, {:ok, false}, s}
  end
end
