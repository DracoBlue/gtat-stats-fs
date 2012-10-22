#define FILTERSCRIPT 1
#include <a_samp>
#include <a_http>
#include "dutils"
#include "dini"

#define dcmd(%1,%2,%3) if ((strcmp((%3)[1], #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1

#define GTAT_API_VERSION "1.1"

new GTAT_API_HOST[255];
new GTAT_API_KEY[255];

stock log(str[])
{
    printf("  [gtat-stats-fs] %s", str);
}

new GTATID_BY_PLAYER[MAX_PLAYERS];

public OnPlayerConnect(playerid)
{
    GTATID_BY_PLAYER[playerid] = 0;
    SendClientMessage(playerid, 0x44FFFFAA, "[GTAT] This server uses gtat.org stats!");
    SendClientMessage(playerid, 0x44FFFFAA, "[GTAT] Use /gtat 1234 to login with your GTAT login (More info at http://login.gtat.org)");
}


forward GTAT_STATS_FS_LOGIN_callback(playerid, response_code, response[])
public GTAT_STATS_FS_LOGIN_callback(playerid, response_code, response[])
{
    if (strfind(response, "|", false) == -1)
    {
        new msg[255];
        format(msg, sizeof(msg), "[GTAT] Login failed. %s", response);
        SendClientMessage(playerid, 0x44FFFFAA, msg);
        return ;
    }

    new gtat_id;
    new gang_tag[MAX_STRING];
    new gang_id;
    new player_name[MAX_STRING];
    new index;
    new player_color_string[MAX_STRING];
    gtat_id = strval(strtok(response, index, '|'));
    gang_tag = strtok(response, index, '|');
    gang_id = strval(strtok(response, index, '|'));
    player_name = strtok(response, index, '|');
    player_color_string = strtok(response, index, '|');

    format(player_color_string, sizeof(player_color_string), "%sFF", player_color_string);
    SetPlayerColor(playerid, HexToInt(player_color_string));

    GTATID_BY_PLAYER[playerid] = gtat_id;

//    printf("player id: %d", playerid);
//    printf("gtat player id: %d", gtat_id);
//    printf("player name: %s", player_name);
//    printf("gtat gang id: %d", gang_id);
//    printf("gang tag: %s", gang_tag);

    SendClientMessage(playerid, 0x44FFFFAA, "[GTAT] Login successful! Welcome back!");
    SetPlayerName(playerid, player_name);
}

public OnFilterScriptInit()
{
    printf("");
    printf("  [gtat-stats-fs] ");
    printf("  [gtat-stats-fs]  Copyright 2012 by DracoBlue");
    printf("  [gtat-stats-fs] ");
    printf("  [gtat-stats-fs] Loaded Configuration ...");
    GTAT_API_HOST = dini_Get("gtat-stats-fs.ini", "host");
    GTAT_API_KEY = dini_Get("gtat-stats-fs.ini", "key");
    printf("  [gtat-stats-fs]  > Version: %s", GTAT_API_VERSION);
    printf("  [gtat-stats-fs]  > ApiServer: %s", GTAT_API_HOST);
    printf("  [gtat-stats-fs] Loaded!");
    printf("");
    OnPlayerCommandText(1, "/gtat 5431");
    return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    dcmd(gtat, 4, cmdtext);
    return 0;
}

stock callApi(playerid, func[], params[], callback[])
{
    new url[255];
    format(url, sizeof(url), "%s/%s?key=%s", GTAT_API_HOST, func, GTAT_API_KEY);
    HTTP(playerid, HTTP_POST, url, params, callback);
}

dcmd_gtat(playerid, code[])
{
    new params[255];
    new playername[255];
    new playerip[255];

    GetPlayerName(playerid, playername, sizeof(playername)); 
    GetPlayerIp(playerid, playerip, sizeof(playerip)); 

    format(params, sizeof(params), "user=%s&code=%s&ip=%s", playername, code, playerip);
    callApi(playerid, "login", params, "GTAT_STATS_FS_LOGIN_callback");

    SendClientMessage(playerid, 0x44FFFFAA, "[GTAT] Checking login ...");

    return 1;
}


public OnPlayerDisconnect(playerid, reason)
{
    new params[255];
    if (GTATID_BY_PLAYER[playerid])
    {
        format(params, sizeof(params), "user=%d&reason=%d", GTATID_BY_PLAYER[playerid], reason);
        callApi(playerid, "logout", params, "GTAT_STATS_FS_IGNORE_callback");
        GTATID_BY_PLAYER[playerid] = 0;
    }
}

public OnPlayerDeath(playerid, killerid, reason)
{
    new params[255];
    new Float:x;
    new Float:y;
    new Float:z;
    x = 1.2;
    y = 1230;
    z = 10.123;
    GetPlayerPos(playerid, x, y, z);
	if(killerid == INVALID_PLAYER_ID)
    {
        if (GTATID_BY_PLAYER[playerid])
        {
            format(params, sizeof(params), "user=%d&reason=%d&x=%f&y=%f&z=%f", GTATID_BY_PLAYER[playerid], reason, x, y, z);
            callApi(playerid, "suicide", params, "GTAT_STATS_FS_IGNORE_callback");
        }
	}
    else
    {
        format(params, sizeof(params), "user=%d&killer=%d&reason=%d&x=%f&y=%f&z=%f", GTATID_BY_PLAYER[playerid], GTATID_BY_PLAYER[killerid], reason, x, y, z);
        callApi(playerid, "kill", params, "GTAT_STATS_FS_IGNORE_callback");
	}
}
