# ConfigFile.jl Documentation

ConfigFile.jl is a Julia module for managing application configuration files in YAML format. It provides a simple and intuitive interface for loading, accessing, and managing configuration data.

## Features

- Load and manage YAML configuration files
- Support for multiple configuration modes (dev, test, prod)
- Automatic creation of default configuration files
- Safe configuration access with default values
- Dictionary-style access to configuration values
- Standard configuration directory structure (`$HOME/.config/app-name/`)

## Installation

```julia
using Pkg
Pkg.add("ConfigFile")
```

## Quick Start

```julia
using ConfigFile

# Create/load configuration for MyApp in test mode
config = ConfigFile.ConfigData("MyApp", :test)

# Access configuration values with defaults
api_url = get(config, :url, "https://default.example.com")
timeout = get(config, :timeout, 30)

# Or use dictionary-style access (throws KeyError if key doesn't exist)
api_url = config[:url]
timeout = config[:timeout]
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

## Configuration Access Methods

ConfigFile.jl provides two ways to access configuration values:

1. Using `get` with default values (safe access):
   ```julia
   api_url = get(config, :url, "https://default.example.com")
   ```

2. Using dictionary-style indexing (throws KeyError if key doesn't exist):
   ```julia
   api_url = config[:url]
   ```

Choose the method that best suits your needs:
- Use `get` when you want to provide fallback values
- Use `[]` when you expect the key to exist and want to handle missing keys as errors
