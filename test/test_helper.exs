Application.start(:logger)
Logger.configure(handle_sasl_reports: true)
Logger.remove_backend(:console)

Code.compiler_options(ignore_module_conflict: true)

assert_timeout = String.to_integer(System.get_env("ELIXIR_ASSERT_TIMEOUT") || "200")

ExUnit.start(assert_receive_timeout: assert_timeout, max_cases: 1)
