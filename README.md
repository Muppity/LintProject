# PASS Summit 2024  REPO 


# Azure DevOps Pipeline Repository for Azure SQL Database

Welcome to the **Azure SQL DB DevOps Pipeline Repository**! This repository provides essential resources and configuration files to automate the deployment, management, and maintenance of Azure SQL databases through Azure DevOps pipelines.

## Features

- **Azure DevOps Pipelines**: Streamlined YAML configurations for building, testing, and deploying Azure SQL DB.
- **Automated Script Creation**: SQL scripts for database creation, migrations, and management.
- **SQL Fluff Integration**: Linting configuration for SQL Fluff to enforce SQL code standards and ensure code quality.
- **CI/CD Workflow**: Continuous Integration and Continuous Deployment configured for seamless delivery.

## Repository Structure

```plaintext
.
├── pipelines/
│   ├── ci-pipeline.yml         # CI Pipeline configuration
│   ├── cd-pipeline.yml         # CD Pipeline configuration
│   └── db-deployment.yml       # DB-specific deployment pipeline
├── sql-scripts/
│   ├── create-db.sql           # Script for initial database creation
│   ├── migrations/
│   │   └── v1.1.sql            # Sample migration script
│   └── cleanup.sql             # Database cleanup script
├── linting/
│   └── sqlfluff-config.yml     # SQL Fluff configuration file
└── README.md
