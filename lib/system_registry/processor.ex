defmodule SystemRegistry.Processor do
  @doc "Handles a validation. Takes a transaction, and returns {:ok, reply, state} or {:error, reason, state}."
  @callback handle_validate(SystemRegistry.Transaction.t(), state :: term) ::
              {:ok, term, state :: term} | {:error, reason :: term, state :: term}

  @doc "Handles a commit. Takes a transaction and returns {:ok, reply, state} | {:error, reason, state}."
  @callback handle_commit(SystemRegistry.Transaction.t(), state :: term) ::
              {:ok, term, state :: term} | {:error, reason :: term, state :: term}

  defmacro __using__(_opts) do
    quote do
      @behaviour SystemRegistry.Processor
      use GenServer

      def start_link(opts \\ []) do
        GenServer.start_link(SystemRegistry.Processor, {__MODULE__, opts}, name: __MODULE__)
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

      defoverridable init: 1
    end
  end

  def call(processors, fun, args) do
    errors =
      Enum.reduce(processors, [], fn {mod, pid}, errors ->
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
    SystemRegistry.Processor.Server.register_processor({mod, self()})
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

  def handle_call(message, from, {mod, opts}) do
    case mod.handle_call(message, from, opts) do
      {:noreply, s} -> {:noreply, {mod, s}}
      {:noreply, s, timeout} -> {:noreply, {mod, s}, timeout}
      {:reply, reply, s} -> {:reply, reply, {mod, s}}
      {:reply, reply, s, timeout} -> {:reply, reply, {mod, s}, timeout}
      {:stop, reason, s} -> {:stop, reason, {mod, s}}
      {:stop, reason, reply, s} -> {:stop, reason, reply, {mod, s}}
    end
  end

  def handle_cast(message, {mod, opts}) do
    case mod.handle_cast(message, opts) do
      {:noreply, s} -> {:noreply, {mod, s}}
      {:noreply, s, timeout} -> {:noreply, {mod, s}, timeout}
      {:stop, reason, s} -> {:stop, reason, {mod, s}}
      {:stop, reason, reply, s} -> {:stop, reason, reply, {mod, s}}
    end
  end

  def handle_info(message, {mod, opts}) do
    {reply, opts} = mod.handle_info(message, opts)
    {reply, {mod, opts}}
  end
end
