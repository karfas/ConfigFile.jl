"""
    module ConfigFile

A module for managing application configuration files in YAML format.

This module provides functionality to:
- Load and manage configuration files for different applications
- Support multiple configuration modes (e.g., dev, test, prod)
- Automatically create default configuration files if they don't exist
- Access configuration values through a dictionary-like interface

Configuration files are stored in `\$HOME/.config/application-name/mode.yaml`.
"""
module ConfigFile

using YAML
using Logging

using PropDicts

"""
    config_base() -> String

Get the base directory for configuration files.

# Returns
- The path to the user's configuration directory (`\$HOME/.config`)
"""
config_base() = joinpath(ENV["HOME"], ".config")

"""
    config_dir(app_name::String) -> String

Get the configuration directory for a specific application.

# Arguments
- `app_name::String`: Name of the application

# Returns
- The path to the application's configuration directory
"""
config_dir(app_name::String) = joinpath(config_base(), app_name)

"""
    config_file(app_name::String, mode::Symbol) -> String

Get the path to a specific configuration file.

# Arguments
- `app_name::String`: Name of the application
- `mode::Symbol`: Configuration mode (e.g., :dev, :test, :prod)

# Returns
- The full path to the configuration file
"""
config_file(app_name::String, mode::Symbol) = joinpath(config_dir(app_name), "$mode.yaml")

"""
    default_config_data() -> Dict

Generate default configuration data.

# Returns
- A dictionary containing default configuration values

# Example
```julia
Dict(
    :url => "https://api.example.com",
    :key => "abc123",
    :secret => "def456",
    :timeout => 10
)
```
"""
default_config_data() = Dict(
    :url => "https://api.example.com",
    :key => "abc123",
    :secret => "def456",
    :timeout => 10
)

"""
    struct ConfigData

A structure representing loaded configuration data.

# Fields
- `_data::Dict{Symbol, Any}`: Internal dictionary storing configuration values

# Constructor
    ConfigData(app::String, mode::Symbol)

Create a new ConfigData instance by loading configuration from a file.

# Arguments
- `app::String`: Name of the application
- `mode::Symbol`: Configuration mode (e.g., :dev, :test, :prod)

# Example
```julia
# Load test configuration for MyApp
config = ConfigData("MyApp", :test)

# Access configuration values
api_url = config[:url]
timeout = config[:timeout]
```

The configuration file will be automatically created with default values if it doesn't exist.
"""

"""
    ConfigData(app::String, mode::Symbol; defaults::Dict{Symbol,Any} = default_config_data())

Create a new ConfigData instance by loading configuration from a file, with optional custom defaults.

# Arguments
- `app::String`: Name of the application
- `mode::Symbol`: Configuration mode (e.g., :dev, :test, :prod)
- `defaults::Dict{Symbol,Any}`: Optional dictionary containing default configuration values

# Returns
- A PropDict containing the configuration data

# Example
```julia
# Load test configuration for MyApp with custom defaults
config = ConfigData("MyApp", :test, defaults=Dict(
    :url => "http://localhost:8080",
    :timeout => 30
))
```

The configuration file will be automatically created with the specified default values if it doesn't exist.
"""
ConfigData(app::String, mode::Symbol; defaults::Dict{Symbol,Any} = default_config_data()) = begin
    fn = config_file(app, mode)
    if !isfile(fn)
        dir = dirname(fn)
        !isdir(dir) && mkpath(dir)
        @warn "creating config file $fn"
        YAML.write_file(fn, defaults)
    end
    @debug "loading config file $fn"
    YAML.load_file(fn; dicttype=Dict{Symbol,Any}) |> PropDicts.PropDict
end
export ConfigData

end # module ConfigFile
