using Test
using YAML
using ConfigFile

@testset "ConfigFile Module Tests" begin
    test_app = "TestApp"
    test_mode = :test
    home_dir = ENV["HOME"]
    
    @testset "Configuration Paths" begin
        # Test base config directory
        @test ConfigFile.config_base() == joinpath(home_dir, ".config")
        
        # Test app config directory
        expected_app_dir = joinpath(home_dir, ".config", test_app)
        @test ConfigFile.config_dir(test_app) == expected_app_dir
        
        # Test config file path
        expected_file = joinpath(expected_app_dir, "test.yaml")
        @test ConfigFile.config_file(test_app, test_mode) == expected_file
    end
    
    @testset "Default Configuration" begin
        default_config = ConfigFile.default_config_data()
        @test default_config isa Dict{Symbol, Any}
        @test haskey(default_config, :url)
        @test haskey(default_config, :key)
        @test haskey(default_config, :secret)
        @test haskey(default_config, :timeout)
        @test default_config[:url] == "https://api.example.com"
        @test default_config[:timeout] == 10
    end
    
    @testset "Configuration Loading and Creation" begin
        # Clean up any existing test config
        test_config_dir = ConfigFile.config_dir(test_app)
        test_config_file = ConfigFile.config_file(test_app, test_mode)
        isdir(test_config_dir) && rm(test_config_dir, recursive=true)
        
        # Test automatic config creation
        @test !isfile(test_config_file)
        config = ConfigFile.ConfigData(test_app, test_mode)
        @test isfile(test_config_file)
        
        # Test loading existing config
        config2 = ConfigFile.ConfigData(test_app, test_mode)
        @test config2 isa ConfigFile.ConfigData
        
        # Test custom config values
        custom_config = Dict{Symbol,Any}(
            :url => "https://custom.example.com",
            :key => "custom-key",
            :secret => "custom-secret",
            :timeout => 30
        )
        YAML.write_file(test_config_file, custom_config)
        
        config3 = ConfigFile.ConfigData(test_app, test_mode)
        @test get(config3, :url, nothing) == "https://custom.example.com"
        @test get(config3, :timeout, nothing) == 30
    end
    
    @testset "Configuration Access" begin
        config = ConfigFile.ConfigData(test_app, test_mode)
        
        # Test get method with default values
        @test get(config, :url, "default") isa String
        @test get(config, :timeout, 60) isa Integer
        
        # Test get method with non-existent keys
        @test get(config, :nonexistent, "default") == "default"
        @test get(config, :missing_timeout, 60) == 60
        
        # Test dictionary-style access with getindex
        @test config[:url] == "https://custom.example.com"
        @test config[:timeout] == 30
        
        # Test getindex throws KeyError for non-existent keys
        @test_throws KeyError config[:nonexistent]
        @test_throws KeyError config[:missing_timeout]
        
        # Test both access methods return same values
        @test get(config, :url, "default") == config[:url]
        @test get(config, :timeout, 60) == config[:timeout]
    end
    
    # Cleanup
    test_config_dir = ConfigFile.config_dir(test_app)
    isdir(test_config_dir) && rm(test_config_dir, recursive=true)
end
