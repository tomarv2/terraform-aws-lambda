data "external" "install_python_dependencies" {
  count = var.runtime_dependencies ? 1 : 0

  program = ["python", "${path.module}/install_dependencies.py", path.cwd, var.source_dir]

}