data "external" "install_python_dependencies" {
  for_each = {
    for key, value in var.lambda_config :
    key => value
    if lookup(value, "runtime_dependencies", null) != null
  }

  program = ["python", "${path.module}/install_dependencies.py", path.cwd, each.value.source_dir]
}
