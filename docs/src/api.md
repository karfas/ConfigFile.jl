# API Reference

## Module

```@docs
ConfigFile.ConfigFile
```

## Types

```@docs
ConfigFile.ConfigData
```

## Configuration Path Functions

```@docs
ConfigFile.config_base
ConfigFile.config_dir
ConfigFile.config_file
```

## Configuration Data Functions

```@docs
ConfigFile.default_config_data
```

## Configuration Access Methods

### Property Access
```@docs
Base.getproperty(::ConfigFile.ConfigData, ::Symbol)
Base.propertynames(::ConfigFile.ConfigData)
```

### Dictionary Access
```@docs
Base.getindex(::ConfigFile.ConfigData, ::Symbol)
```

### Safe Access with Defaults
```@docs
Base.get(::ConfigFile.ConfigData, ::Symbol, ::Any)
```
