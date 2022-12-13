
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "blob-to-sqldb-rg" {
  name     = "blob-to-sqldb-rg"
  location = "East US 2"
}

resource "azurerm_storage_account" "productsblobtosqldb" {
  name                     = "productsblobtosqldb"
  location                 = azurerm_resource_group.blob-to-sqldb-rg.location
  resource_group_name      = azurerm_resource_group.blob-to-sqldb-rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_logic_app_workflow" "products-blob-to-sqldb-lg" {
  name                = "products-blob-to-sqldb-lg"
  location            = azurerm_resource_group.blob-to-sqldb-rg.location
  resource_group_name = azurerm_resource_group.blob-to-sqldb-rg.name
}

resource "azurerm_sql_server" "products-sqlserver" {
  name                         = "products-sqlserver"
  location                     = azurerm_resource_group.blob-to-sqldb-rg.location
  resource_group_name          = azurerm_resource_group.blob-to-sqldb-rg.name
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"

  tags = {
    environment = "stage"
  }
}

resource "azurerm_sql_database" "products-sqldb" {
  name                = "products-sqldb"
  location            = azurerm_resource_group.blob-to-sqldb-rg.location
  resource_group_name = azurerm_resource_group.blob-to-sqldb-rg.name
  server_name         = azurerm_sql_server.products-sqlserver.name

#   extended_auditing_policy {
#     storage_endpoint                        = azurerm_storage_account.productsblobtosqldb.primary_blob_endpoint
#     storage_account_access_key              = azurerm_storage_account.productsblobtosqldb.primary_access_key
#     storage_account_access_key_is_secondary = true
#     retention_in_days                       = 6
#   }

  tags = {
    environment = "stage"
  }
}
