#include <stdio.h>
#include <string.h>
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
#include <unistd.h>

const char* LUA_MAIN_PATH = "/zip/main.lua";

int lua_error_handler(lua_State *L) {
    const char *msg = lua_tostring(L, -1);
    if (msg == NULL) {
        msg = "lua error occurred; unable to obtain error message";
    }

    luaL_traceback(L, L, msg, 1);
    const char *traceback  = lua_tostring(L, -1);
    lua_pop(L, 1);

    if (traceback == NULL) {
        traceback = "lua error occurred; unable to obtain error traceback";
    }
    fprintf(stderr, "%s\n", traceback);

    return 0; // no result pushed on stack
}

int main(int argc, char** argv) {
    if (access(LUA_MAIN_PATH, F_OK) != 0) {
        fprintf(stderr, "[cosmologist] failed to find main.lua enclosed in binary (expected at %s)\n", LUA_MAIN_PATH);
        return 1;
    }

    lua_State *L = luaL_newstate();
    if (L == NULL) {
        fprintf(stderr, "[cosmologist] memory allocation error while creating lua state\n");
        return 1;
    }

    luaL_openlibs(L);

    if (luaL_dostring(L, "package.path = \"./?.lua;./?/init.lua;/zip/?.lua;/zip/lua/?.lua\"") != LUA_OK) {
        fprintf(stderr, "[cosmologist] failed to set lua package.path");
        lua_close(L);
        return 1;
    }

    lua_pushcfunction(L, lua_error_handler);

    if (luaL_loadfile(L, LUA_MAIN_PATH) != LUA_OK) {
        fprintf(stderr, "[cosmologist] error loading lua: %s\n", lua_tostring(L, -1));
        lua_close(L);
        return 1;
    }

    if (lua_pcall(L, 0, 0, -2 /* lua_error_handler */) != LUA_OK) {
        lua_close(L);
        return 1;
    }

    lua_close(L);
    return 0;
}

