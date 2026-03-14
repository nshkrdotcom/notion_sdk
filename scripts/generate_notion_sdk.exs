project_root = Path.expand("..", __DIR__)
args = ["notion.generate" | System.argv()]

{_output, exit_code} =
  System.cmd("mix", args,
    cd: project_root,
    into: IO.stream(:stdio, :line),
    stderr_to_stdout: true
  )

if exit_code != 0 do
  raise "mix notion.generate failed with exit code #{exit_code}"
end
