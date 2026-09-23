locals {
  kubernetes_templates = {
    "07-application-secret.yaml" = "07-application-secret.yaml.tftpl"
    "08-user-service.yaml"       = "08-user-service.yaml.tftpl"
    "09-student-service.yaml"    = "09-student-service.yaml.tftpl"
    "10-lecturer-service.yaml"   = "10-lecturer-service.yaml.tftpl"
    "11-course-service.yaml"     = "11-course-service.yaml.tftpl"
    "12-enrollment-service.yaml" = "12-enrollment-service.yaml.tftpl"
    "13-frontend.yaml"           = "13-frontend.yaml.tftpl"
  }
}

resource "local_file" "kubernetes_manifests" {
  for_each = local.kubernetes_templates

  filename = "${path.module}/../kubernetes-generated/${each.key}"

  content = templatefile(
    "${path.module}/../kubernetes-templates/${each.value}",
    {
      storage_connection_string = azurerm_storage_account.storage_account.primary_connection_string
      acr_login_server          = azurerm_container_registry.acr.login_server
    }
  )
}
