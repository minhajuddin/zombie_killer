defmodule Mix.Tasks.ZombieKiller.Scan do
  use Mix.Task

  # really? Yeah, I am gonna use a test dep here.
  import ExUnit.CaptureIO

  @shortdoc "Finds dead code in your app."
  def run([otp_app]) do
    otp_app = String.to_atom(otp_app)
    Mix.shell().info("Finding dead code...")
    #:ok = Application.ensure_started(otp_app)

    IO.puts("# Potential dead code")
    IO.puts("=====================")

    otp_app
      |> IO.inspect(label: ">>>>>>>>>>>>>>>>")
    |> get_mod_deps
    |> Enum.filter(fn {_, deps_count} -> deps_count == 0 end)
    |> Enum.map(fn {mod, _} -> mod end)
    |> Enum.sort()
    |> Enum.join("\n")
    |> IO.puts()
  end

  def run(_) do
    Mix.shell().info("""
    Invalid args.

    Usage:
      mix zombie_killer:scan your_otp_app

    Example:
      mix zombie_killer:scan logger
    """)
  end

  def get_mod_deps(otp_app) do
    with {:ok, modules} <- :application.get_key(otp_app, :modules) do
      for mod <- modules do
        module_wo_prefix = mod |> Module.split() |> Enum.join(".")

        deps_count =
          capture_io(fn ->
            Mix.Task.run(:xref, ["callers", module_wo_prefix])
          end)
          |> String.length()

        {module_wo_prefix, deps_count}
      end
    end
  end
end
