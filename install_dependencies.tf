resource "null_resource" "install_python_dependencies" {
  count = var.runtime_dependencies ? 1 : 0

  provisioner "local-exec" {
    command = var.dependencies_path != null ? var.dependencies_path : "bash ${path.module}/install_dependencies.sh"

    environment = {
      source_code_path = var.source_dir
      function_name    = "${var.teamid}-${var.prjid}"
      path_module      = path.module
      runtime          = var.runtime
      path_cwd         = path.cwd
    }
  }
}
