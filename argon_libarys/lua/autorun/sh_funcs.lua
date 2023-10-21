Argon = Argon or {}
Argon.__index = Argon
Argon.Libary = Argon.Libary or {}
Argon.Libary.__index = Argon.Libary
local function AddFile(File, dir)
    local fileSide = string.lower(string.Left(File , 3))

    if SERVER and fileSide == "sv_" then
        include(dir..File)
        print("[ALIB] SV INCLUDE: " .. File)
    elseif fileSide == "sh_" then
        if SERVER then 
            AddCSLuaFile(dir..File)
            print("[ALIB] SH ADDCS: " .. File)
        end
        include(dir..File)
        print("[ALIB] SH INCLUDE: " .. File)
    elseif fileSide == "cl_" then
        if SERVER then 
            AddCSLuaFile(dir..File)
            print("[ALIB] CL ADDCS: " .. File)
        elseif CLIENT then
            include(dir..File)
            print("[ALIB] CL INCLUDE: " .. File)
        end
    end
end

local function IncludeDir(dir)
    if dir == "error_msg" then
        --print("[ALIB] ERROR: No directory specified") // would print how ever error is better to notice
        error("[ALIB] ERROR: No directory specified")
        return
    end
    dir = dir .. "/"
    local File, Directory = file.Find(dir.."*", "LUA")

    for k, v in ipairs(File) do
        if string.EndsWith(v, ".lua") then
            AddFile(v, dir)
        end
    end
    
    for k, v in ipairs(Directory) do
        print("[ALIB] Directory: " .. v)
        IncludeDir(dir..v)
    end

end
Argon.Libary.LoadDirs = {}
Argon.Libary.LoadFiles = function(dir) // dir = directory
    IncludeDir(dir or "error_msg")
    table.Add(Argon.Libary.LoadDirs, {dir})
end



hook.Add("Think" , "ArgonLibaryLoaded" , function()
    hook.Remove("Think" , "ArgonLibaryLoaded")
    hook.Run("ArgonLibaryLoaded" , CurTime())
end)


function Argon.Libary:TableLen(tbl)
    local i = 0
    for k , v in pairs(tbl) do
        i = i + 1
    end
    return i
end
