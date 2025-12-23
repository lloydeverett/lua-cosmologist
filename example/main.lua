
local foo = require("foo.foo")

print("hello world from main.lua")

foo.bar()

require("hello_world").hello_world_fn() -- exported from C

local sandbox_env = { print = print }
print("print function in sandbox = " .. tostring(load("return print", nil, 't', sandbox_env)()))
print("require function in sandbox = " .. tostring(load("return require", nil, 't', sandbox_env)()))

