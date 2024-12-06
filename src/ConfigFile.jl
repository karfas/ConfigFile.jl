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
struct ConfigData
    _data::Dict{Symbol, Any}
    function ConfigData(app::String, mode::Symbol)
        fn = config_file(app, mode)
        if !isfile(fn)
            dir = dirname(fn)
            !isdir(dir) && mkpath(dir)
            @warn "creating config file $fn"
            YAML.write_file(fn, default_config_data())
        end
        @debug "loading config file $fn"
        c = YAML.load_file(fn; dicttype=Dict{Symbol,Any})
        new(c)
    end
end

"""
    get(conf::ConfigData, key::Symbol, default) -> Any

Access configuration values with a default fallback value.

# Arguments
- `conf::ConfigData`: Configuration data instance
- `key::Symbol`: Configuration key to access
- `default`: Value to return if key is not found

# Returns
- The value associated with the key if it exists, otherwise returns the default value

# Example
```julia
config = ConfigData("MyApp", :test)
api_url = get(config, :url, "https://default.example.com")
timeout = get(config, :timeout, 30)  # returns 30 if timeout is not configured
```
"""
Base.get(conf::ConfigData, key::Symbol, default) = get(conf._data, key, default)

"""
    getindex(conf::ConfigData, key::Symbol) -> Any

Access configuration values directly using dictionary-style indexing (`[]`).

# Arguments
- `conf::ConfigData`: Configuration data instance
- `key::Symbol`: Configuration key to access

# Returns
- The value associated with the key

# Throws
- `KeyError` if the key doesn't exist in the configuration

# Example
```julia
config = ConfigData("MyApp", :test)

# Direct access to configuration values
api_url = config[:url]        # returns "https://api.example.com"
timeout = config[:timeout]    # returns 10

# Will throw KeyError if key doesn't exist
try
    missing_value = config[:nonexistent]
catch e
    @warn "Configuration key not found" key=:nonexistent
end
```

See also: [`get`](@ref) for accessing values with default fallbacks.
"""
Base.getindex(conf::ConfigData, key::Symbol) = getindex(conf._data, key)

"""
    getproperty(conf::ConfigData, prop::Symbol) -> Any

Access configuration values using dot notation (property-style access).
This allows accessing configuration values as if they were object properties.

# Arguments
- `conf::ConfigData`: Configuration data instance
- `prop::Symbol`: Property name (configuration key)

# Returns
- The value associated with the property name
- For the special property `_data`, returns the internal dictionary

# Throws
- `KeyError` if the property doesn't exist in the configuration (except for `_data`)

# Example
```julia
config = ConfigData("MyApp", :test)

# Access values as properties
api_url = config.url         # returns "https://api.example.com"
timeout = config.timeout     # returns 10

# Will throw KeyError if property doesn't exist
try
    missing_value = config.nonexistent
catch e
    @warn "Configuration property not found" property=:nonexistent
end
```

See also: [`get`](@ref) for accessing values with default fallbacks, [`getindex`](@ref) for dictionary-style access.
"""
function Base.getproperty(conf::ConfigData, prop::Symbol)
    if prop === :_data
        return getfield(conf, :_data)
    end
    return getindex(conf._data, prop)
end

"""
    propertynames(conf::ConfigData) -> Vector{Symbol}

Get the list of available configuration properties.

# Arguments
- `conf::ConfigData`: Configuration data instance

# Returns
- A vector of symbols representing available configuration keys

# Example
```julia
config = ConfigData("MyApp", :test)
properties = propertynames(config)  # returns [:url, :key, :secret, :timeout]

# Use with hasfield to check property existence
if :url in propertynames(config)
    println("URL configuration exists: \$(config.url)")
end
```
"""
function Base.propertynames(conf::ConfigData)
    return [:_data; collect(keys(getfield(conf, :_data)))]
end

end # module ConfigFile
