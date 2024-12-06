# ConfigFile.jl

A simple and intuitive configuration management package for Julia applications.

[![Documentation](https://img.shields.io/badge/docs-dev-blue.svg)](https://karfas.github.io/ConfigFile.jl/)
[![Build Status](https://github.com/karfas/ConfigFile.jl/workflows/CI/badge.svg)](https://github.com/karfas/ConfigFile.jl/actions)

## Features

- Load and manage YAML configuration files
- Support for multiple configuration modes (dev, test, prod)
- Automatic creation of default configuration files
- Multiple ways to access configuration:
  * Property-style access (`config.url`)
  * Dictionary-style access (`config[:url]`)
  * Safe access with defaults (`get(config, :url, default)`)
- Standard configuration directory structure (`$HOME/.config/app-name/`)

## Installation

You can install ConfigFile.jl in two ways:

1. From the Julia package registry (not yet available):
```julia
using Pkg
Pkg.add("ConfigFile")
```

2. Directly from GitHub:
```julia
using Pkg
Pkg.add(url="https://github.com/karfas/ConfigFile.jl.git")
```

## Quick Start

```julia
using ConfigFile

# Create/load configuration for MyApp in test mode
config = ConfigFile.ConfigData("MyApp", :test)

# Access configuration values using property notation (recommended)
api_url = config.url
timeout = config.timeout

# Or use dictionary-style access
api_url = config[:url]
timeout = config[:timeout]

# Or use get with default values for safety
api_url = get(config, :url, "https://default.example.com")
timeout = get(config, :timeout, 30)

# List available configuration properties
for prop in propertynames(config)
    println("\$(prop): \$(getproperty(config, prop))")
end
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

When a configuration file doesn't exist, it will be automatically created with default values:

```yaml
url: https://api.example.com
key: abc123
secret: def456
timeout: 10
```

## Configuration Access Methods

ConfigFile.jl provides three ways to access configuration values:

1. Property-style access (recommended for known keys):
   ```julia
   api_url = config.url
   timeout = config.timeout
   ```

2. Dictionary-style access (for dynamic keys):
   ```julia
   api_url = config[:url]
   timeout = config[:timeout]
   ```

3. Safe access with defaults (for optional values):
   ```julia
   api_url = get(config, :url, "https://default.example.com")
   timeout = get(config, :timeout, 30)
   ```

### Error Handling

Different access methods handle missing keys differently:

```julia
# Property and dictionary access throw KeyError for missing keys
try
    value = config.nonexistent
catch e
    @warn "Key not found" key=:nonexistent
end

# get returns the default value for missing keys
value = get(config, :nonexistent, "default")  # returns "default"
```

## Documentation

For more detailed information, please visit our [documentation](https://karfas.github.io/ConfigFile.jl/).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
