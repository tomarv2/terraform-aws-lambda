data "archive_file" "zip_file" {
  count = var.source_file != null ? 1 : 0

  type        = var.archive_type
  source_file = var.source_file
  output_path = var.output_path
}

data "archive_file" "zip_dir" {
  count = var.source_dir != null ? 1 : 0

  type        = var.archive_type
  source_dir  = var.runtime_dependencies == true ? "/tmp/lambda_dist_pkg/" : var.source_dir
  output_path = var.output_path
  excludes    = var.exclude_files

  depends_on = [data.external.install_python_dependencies]
}
