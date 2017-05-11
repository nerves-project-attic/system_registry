defmodule SystemRegistry.Processor do

  @callback handle_validate(Transaction.t, state :: term) ::
    {:ok, Transaction.t} | {:error, term}

  @callback handle_commit(Transaction.t, state :: term) ::
    {:ok, Transaction.t} | {:error, term}

  defmacro __using__(_opts) do
    quote do
      @behaviour SystemRegistry.Processor
      use GenServer

      def start_link(opts \\ []) do
        GenServer.start_link(SystemRegistry.Processor, {__MODULE__, opts})
      end

      def validate(pid, transaction) do
        GenServer.call(pid, {:validate, transaction})
      end

      def commit(pid, transaction) do
        GenServer.call(pid, {:commit, transaction})
      end

      def init(opts) do
        {:ok, opts}
      end

      defoverridable [init: 1]
    end
  end

  def call(processors, fun, args) do
    errors =
      Enum.reduce(processors, [], fn ({mod, pid}, errors) ->
        case apply(mod, fun, [pid | args]) do
          {:ok, _result} -> errors
          {:error, error} -> [error | errors]
        end
      end)
    case errors do
      [] -> :ok
      errors -> {:error, errors}
    end
  end

  def init({mod, opts}) do
    SystemRegistry.Local.register_processor({mod, self()})
    {:ok, opts} = mod.init(opts)
    {:ok, {mod, opts}}
  end

  def handle_call({:validate, transaction}, _from, {mod, opts}) do

    case mod.handle_validate(transaction, opts) do
      {:ok, t, s} -> {:reply, {:ok, t}, {mod, s}}
      {:error, error, s} -> {:reply, {:error, error}, {mod, s}}
    end
  end

  def handle_call({:commit, transaction}, _from, {mod, opts}) do
    case mod.handle_commit(transaction, opts) do
      {:ok, t, s} -> {:reply, {:ok, t}, {mod, s}}
      {:error, error, s} -> {:reply, {:error, error}, {mod, s}}
    end
  end

  def handle_info(message, {mod, opts}) do
    {reply, opts} = mod.handle_info(message, opts)
    {reply, {mod, opts}}
  end
end
