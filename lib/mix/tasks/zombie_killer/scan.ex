defmodule Mix.Tasks.ZombieKiller.Scan do
  use Mix.Task

  # really? Yeah, I am gonna use a test dep here.
  import ExUnit.CaptureIO

  @shortdoc "Finds dead code in your app."
  def run([otp_app]) do
    otp_app = String.to_atom(otp_app)
    Mix.shell().info("Finding dead code...")

    IO.puts("# Potential dead code")
    IO.puts("=====================")

    get_files
    |> IO.inspect(label: ">>>>>>>>>>>>>>>>")

    # |> Enum.filter(fn {_, deps_count} -> deps_count == 0 end)
    # |> Enum.map(fn {mod, _} -> mod end)
    # |> Enum.sort()
    # |> Enum.join("\n")
    # |> IO.puts()
  end

  def run(_) do
    Mix.shell().info("""
    Invalid args.

    Usage:
      mix do app.start, zombie_killer:scan your_otp_app

    Example:
      mix do app.start, zombie_killer:scan logger
    """)
  end

  def get_files do
    mix_run(:xref, ~w[graph --only-nodes])
  end

  def mix_run(task, args) do
    capture_io(fn ->
      Mix.Task.run(task, args)
    end)
    |> String.split("\n", trim: true)
  end
end
