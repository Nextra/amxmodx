/* AMX Mod X script.
*
* (c) 2002-2004, JustinHoMi
*  modified by BAILOPAN,Manip,PM,SniperBeamer
*
* This file is provided as is (no warranties).
*/

#include <amxmod>
#include <csstats>

new g_pingSum[33]
new g_pingCount[33]

public plugin_init()
  register_plugin("Stats Logging","0.1","JustinHoMi")

public client_disconnect(id) {
  if ( is_user_bot( id ) ) return PLUGIN_CONTINUE
  remove_task( id )
  new szTeam[16],szName[32],szAuthid[32], iStats[8], iHits[8], szWeapon[24]
  new iUserid = get_user_userid( id )
  get_user_team(id, szTeam, 15 )
  get_user_name(id, szName ,31 )
  get_user_authid(id, szAuthid , 31 )
  for(new i = 1 ; i < 31 ; ++i ) {
    if( get_user_wstats( id , i ,iStats , iHits ) )   {
    
      if ( i == CSW_HEGRENADE)
        copy(szWeapon[7],16,"grenade")
      else
        get_weaponname( i , szWeapon , 23 )
        
      log_message("^"%s<%d><%s><%s>^" triggered ^"weaponstats^" (weapon ^"%s^") (shots ^"%d^") (hits ^"%d^") (kills ^"%d^") (headshots ^"%d^") (tks ^"%d^") (damage ^"%d^") (deaths ^"%d^")",
        szName,iUserid,szAuthid,szTeam,szWeapon[7],iStats[4],iStats[5],iStats[0], iStats[2],iStats[3],iStats[6],iStats[1])
      log_message("^"%s<%d><%s><%s>^" triggered ^"weaponstats2^" (weapon ^"%s^") (head ^"%d^") (chest ^"%d^") (stomach ^"%d^") (leftarm ^"%d^") (rightarm ^"%d^") (leftleg ^"%d^") (rightleg ^"%d^")",
        szName,iUserid,szAuthid,szTeam,szWeapon[7],iHits[1],iHits[2],iHits[3],  iHits[4],iHits[5],iHits[6],iHits[7])
    }
  }
  new iTime = get_user_time( id , 1 )
  log_message("^"%s<%d><%s><%s>^" triggered ^"time^" (time ^"%d:%02d^")",
    szName,iUserid,szAuthid,szTeam, (iTime / 60),  (iTime % 60) )
  log_message("^"%s<%d><%s><%s>^" triggered ^"latency^" (ping ^"%d^")",
    szName,iUserid,szAuthid,szTeam, (g_pingSum[id] / ( g_pingCount[id] ? g_pingCount[id] : 1 ) ) )
  return PLUGIN_CONTINUE
}

public client_putinserver(id) {
  if ( !is_user_bot( id ) ){
    g_pingSum[ id ] = g_pingCount[ id ] = 0
    set_task( 19.5 , "getPing" , id , "" , 0 , "b" )
  }
}

public getPing( id ) {
  new iPing, iLoss
  get_user_ping( id , iPing, iLoss)
  g_pingSum[ id ] += iPing
  ++g_pingCount[ id ]
}