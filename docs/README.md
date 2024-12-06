# ConfigFile.jl Documentation

## Overview

ConfigFile.jl is a Julia module for managing application configuration files in YAML format. It provides a simple and intuitive interface for loading, accessing, and managing configuration data.

## Features

- Load and manage YAML configuration files
- Support for multiple configuration modes (dev, test, prod)
- Automatic creation of default configuration files
- Safe configuration access with default values
- Standard configuration directory structure (`$HOME/.config/app-name/`)

## API Reference

### Types

#### `ConfigData`

A structure representing loaded configuration data.

```julia
struct ConfigData
    _data::Dict{Symbol, Any}
end
```

Constructor:
```julia
ConfigData(app::String, mode::Symbol)
```

Creates a new ConfigData instance by loading configuration from a file.

### Configuration Path Functions

#### `config_base()`
Get the base directory for configuration files (`$HOME/.config`).

#### `config_dir(app_name::String)`
Get the configuration directory for a specific application.

#### `config_file(app_name::String, mode::Symbol)`
Get the path to a specific configuration file.

### Configuration Data Functions

#### `default_config_data()`
Generate default configuration data with standard values.

#### `get(conf::ConfigData, key::Symbol, default)`
Access configuration values with a default fallback value.

## Usage Examples

```julia
using ConfigFile

# Create/load configuration for MyApp in test mode
config = ConfigFile.ConfigData("MyApp", :test)

# Access configuration values with defaults
api_url = get(config, :url, "https://default.example.com")
timeout = get(config, :timeout, 30)
```

## Configuration Structure

Configuration files are stored in YAML format in the following directory structure:
```
$HOME/.config/
└── application-name/
    ├── dev.yaml
    ├── test.yaml
    └── prod.yaml
```

## Default Configuration

When a configuration file doesn't exist, it will be automatically created with default values:

```yaml
url: https://api.example.com
key: abc123
secret: def456
timeout: 10
```
