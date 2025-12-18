
local foo = require("foo.foo")

print("hello world from main.lua")

foo.bar()

require("hello_world").hello_world_fn() -- exported from C

