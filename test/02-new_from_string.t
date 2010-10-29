#!/usr/bin/env lua

require 'Spore'

require 'Test.More'

plan(19)

error_like( [[Spore.new_from_string(true)]],
            "bad argument #1 to new_from_string %(string expected, got boolean%)" )

error_like( [[Spore.new_from_string('', '', true)]],
            "bad argument #3 to new_from_string %(string expected, got boolean%)" )

error_like( [[Spore.new_from_string('{ BAD }')]],
            "Invalid JSON data" )

error_like( [[Spore.new_from_string('{ }', '{ }')]],
            "no method in spec" )

error_like( [=[Spore.new_from_string([[
{
    base_url : "http://services.org/restapi/",
    methods : {
        get_info : {
            path : "/show",
        }
    }
}
]])]=],
            "get_info without field method" )

error_like( [=[Spore.new_from_string([[
{
    base_url : "http://services.org/restapi/",
    methods : {
        get_info : {
            method : "GET",
        }
    }
}
]])]=],
            "get_info without field path" )

error_like( [=[Spore.new_from_string([[
{
    base_url : "http://services.org/restapi/",
    methods : {
        get_info : {
            path : "/show",
            method : "GET",
            expected_status : true,
        }
    }
}
]])]=],
            "expected_status of get_info is not an array" )

error_like( [=[Spore.new_from_string([[
{
    base_url : "http://services.org/restapi/",
    methods : {
        get_info : {
            path : "/show",
            method : "GET",
            required_params : true,
        }
    }
}
]])]=],
            "required_params of get_info is not an array" )

error_like( [=[Spore.new_from_string([[
{
    base_url : "http://services.org/restapi/",
    methods : {
        get_info : {
            path : "/show",
            method : "GET",
            optional_params : true,
        }
    }
}
]])]=],
            "optional_params of get_info is not an array" )

error_like( [=[Spore.new_from_string([[
{
    base_url : "http://services.org/restapi/",
    methods : {
        get_info : {
            path : "/show",
            method : "GET",
            "form-data" : true,
        }
    }
}
]])]=],
            "form%-data of get_info is not an hash" )

error_like( [=[Spore.new_from_string([[
{
    base_url : "http://services.org/restapi/",
    methods : {
        get_info : {
            path : "/show",
            method : "GET",
            headers : true,
        }
    }
}
]])]=],
            "headers of get_info is not an hash" )

error_like( [=[Spore.new_from_string([[
{
    methods : {
        get_info : {
            path : "/show",
            method : "GET",
        }
    }
}
]])]=],
            "base_url is missing" )

error_like( [=[Spore.new_from_string([[
{
    methods : {
        get_info : {
            path : "/show",
            method : "GET",
        }
    }
}
]], { base_url = 'services.org' })]=],
            "base_url without host" )

error_like( [=[Spore.new_from_string([[
{
    methods : {
        get_info : {
            path : "/show",
            method : "GET",
        }
    }
}
]], { base_url = '//services.org/restapi/' })]=],
            "base_url without scheme" )

error_like( [=[Spore.new_from_string([[
{
    base_url : "http://services.org/restapi/",
    methods : {
        get_info : {
            path : "/show",
            method : "GET",
        }
    }
}
]], [[
{
    base_url : "http://services.org/restapi/",
    methods : {
        get_info : {
            path : "/show",
            method : "GET",
        }
    }
}
]])]=],
            "get_info duplicated" )

local client = Spore.new_from_string([[
{
    base_url : "http://services.org/restapi/",
    methods : {
        get_info : {
            path : "/show",
            method : "GET",
        }
    }
}
]])
type_ok( client, 'table' )
type_ok( client.enable, 'function' )
type_ok( client.reset_middlewares, 'function' )
type_ok( client.get_info, 'function' )

