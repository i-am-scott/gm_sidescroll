GM.Version = '0.0.1'
GM.Name = 'Sidescroller Thing'
GM.Author = 'Scott'
GM.Website = ''
DeriveGamemode 'base'

require 'nw'
require 'cmd'

ss = ss or {}

TEAM_SPECTATOR = 1
TEAM_PLAYER = 2

PLAYER = FindMetaTable 'Player'
ENTITY = FindMetaTable 'Entity'
VECTOR = FindMetaTable 'Vector'

team.SetUp(TEAM_SPECTATOR, 'Spectator', Color(0,255,0), false)
team.SetUp(TEAM_PLAYER, 'Player', Color(255,0, 255), false)

print([[
8 8888      88 `8.`888b                 ,8' 8 8888      88
8 8888      88  `8.`888b               ,8'  8 8888      88
8 8888      88   `8.`888b             ,8'   8 8888      88
8 8888      88    `8.`888b     .b    ,8'    8 8888      88
8 8888      88     `8.`888b    88b  ,8'     8 8888      88
8 8888      88      `8.`888b .`888b,8'      8 8888      88
8 8888      88       `8.`888b8.`8888'       8 8888      88
` 8888     ,8P        `8.`888`8.`88'        ` 8888     ,8P
  8888   ,d8P          `8.`8' `8,`'           8888   ,d8P
   `Y88888P'            `8.`   `8'             `Y88888P'
]])

include 'color.lua'
include 'loader.lua'

loader.PrepareRecursive(GM.FolderName .. '/gamemode/modules/ui/', true)
loader.PrepareRecursive(GM.FolderName .. '/gamemode/modules/abilities/', true)
loader.PrepareRecursive(GM.FolderName .. '/gamemode/modules/movement/', true)
loader.PrepareRecursive(GM.FolderName .. '/gamemode/modules/camera/', true)
loader.PrepareRecursive(GM.FolderName .. '/gamemode/modules/hud/', true)
loader.PrepareRecursive(GM.FolderName .. '/gamemode/modules/map/' .. game.GetMap() .. '/', true)

MsgC(col.pink, '| All gamer modules have be loaded\n')