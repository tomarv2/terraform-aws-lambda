data "archive_file" "zip" {
  for_each = {
    for key, value in var.lambda_config :
    key => value
    if try(value.source_file, value.source_dir) != null
  }
  type        = try(each.value.archive_type, "zip")
  source_file = try(each.value.source_file, null)
  source_dir  = try(each.value.runtime_dependencies, null) == true ? "/tmp/lambda_dist_pkg/" : try(each.value.source_dir, null)
  output_path = try(each.value.output_path, null)
  excludes    = try(each.value.exclude_files, null)

  depends_on = [data.external.install_python_dependencies]
}
