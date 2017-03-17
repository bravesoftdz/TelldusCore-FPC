unit telldus_core;

{-------------------------------------------------------------------------

  telldus_core.pas

  * Telldus API Headers v2.1.2
    FPC version by Ted Roberth Nilsen.

  * Telldus Technologies AB
    Original source: https://github.com/telldus
                     https://github.com/telldus/telldus/blob/master/telldus-core/client/telldus-core.h
    Documentation:   http://developer.telldus.com/doxygen/index.html

  Changelog:
  ----------

  2017.03.17
  * First version of the unit.

-------------------------------------------------------------------------}

{$mode objfpc}{$H+}
{$I telldus_core.inc}

interface

{$IFNDEF TELLDUS_CORE_CLIENT_TELLDUS_CORE_H_}     // <--- check if we have allready included the headers
{$DEFINE TELLDUS_CORE_CLIENT_TELLDUS_CORE_H_}

{$IFDEF WINDOWS}
  {$DEFINE EXTDECL:=stdcall}
{$ELSE}
  {$DEFINE EXTDECL:=cdecl}
{$ENDIF}

uses
  dynlibs;

  function  TDC_Initialize: boolean;
  procedure TDC_Finalize;
  function  TDC_Present: boolean; inline;
  function  TDC_GetLibHandle: TLibHandle; inline;
  procedure TDC_SetLibHandle(libHandle: TLibHandle); inline;

type

  TDDeviceEvent = procedure(deviceId, method: integer; const data: PChar; callbackId: integer; context: pointer); EXTDECL;
  TDDeviceChangeEvent = procedure(deviceId, changeEvent, changeType, callbackId: integer; context: pointer); EXTDECL;
  TDRawDeviceEvent = procedure(const data: PChar; controllerId, callbackId: integer; context: pointer); EXTDECL;
  TDSensorEvent = procedure(const protocol, model: PChar; id, dataType: integer; const value: PChar; timestamp, callbackId: integer; context: pointer); EXTDECL;
  TDControllerEvent = procedure(controllerId, changeEvent, changeType: integer; const value: PChar; callbackId: integer; context: pointer); EXTDECL;

var

  tdInit: procedure(); EXTDECL;
  tdRegisterDeviceEvent: function(eventFunction: TDDeviceEvent; context: pointer): integer; EXTDECL;
  tdRegisterDeviceChangeEvent: function(eventFunction: TDDeviceChangeEvent; context: pointer): integer; EXTDECL;
  tdRegisterRawDeviceEvent: function(eventFunction: TDRawDeviceEvent; context: pointer): integer; EXTDECL;
  tdRegisterSensorEvent: function(eventFunction: TDSensorEvent; context: pointer): integer; EXTDECL;
  tdRegisterControllerEvent: function(eventFunction: TDControllerEvent; context: pointer): integer; EXTDECL;
  tdUnregisterCallback: function(callbackId: integer): integer; EXTDECL;
  tdClose: procedure(); EXTDECL;
  tdReleaseString: procedure(thestring: PChar); EXTDECL;

  tdTurnOn: function(intDeviceId: integer): integer; EXTDECL;
  tdTurnOff: function(intDeviceId: integer): integer; EXTDECL;
  tdBell: function(intDeviceId: integer): integer; EXTDECL;
  tdDim: function(intDeviceId: integer; level: Char): integer; EXTDECL;
  tdExecute: function(intDeviceId: integer): integer; EXTDECL;
  tdUp: function(intDeviceId: integer): integer; EXTDECL;
  tdDown: function(intDeviceId: integer): integer; EXTDECL;
  tdStop: function(intDeviceId: integer): integer; EXTDECL;
  tdLearn: function(intDeviceId: integer): integer; EXTDECL;
  tdMethods: function(id, methodsSupported: integer): integer; EXTDECL;
  tdLastSentCommand: function(intDeviceId, methodsSupported: integer): integer; EXTDECL;
  tdLastSentValue: function(intDeviceId: integer): PChar; EXTDECL;

  tdGetNumberOfDevices: function: integer; EXTDECL;
  tdGetDeviceId: function(intDeviceIndex: integer): integer; EXTDECL;
  tdGetDeviceType: function(intDeviceId: integer): integer; EXTDECL;

  tdGetErrorString: function(intErrorNo: integer): PChar; EXTDECL;

  tdGetName: function(intDeviceId: integer): PChar; EXTDECL;
  tdSetName: function(intDeviceId: integer; const chNewName: PChar): Boolean; EXTDECL;
  tdGetProtocol: function(intDeviceId: integer): PChar; EXTDECL;
  tdSetProtocol: function(intDeviceId: integer; const strProtocol: PChar): Boolean; EXTDECL;
  tdGetModel: function(intDeviceId: integer): PChar; EXTDECL;
  tdSetModel: function(intDeviceId: integer; const intModel: PChar): Boolean; EXTDECL;

  tdGetDeviceParameter: function(intDeviceId: integer; const strName, defaultValue: PChar): PChar; EXTDECL;
  tdSetDeviceParameter: function(intDeviceId: integer; const strName, strValue: PChar): Boolean; EXTDECL;

  tdAddDevice: function(): integer; EXTDECL;
  tdRemoveDevice: function(intDeviceId: integer): Boolean; EXTDECL;

  tdSendRawCommand: function(const command: PChar; reserved: integer): integer; EXTDECL;

  tdConnectTellStickController: procedure(vid, pid: integer; const serial: PChar); EXTDECL;
  tdDisconnectTellStickController: procedure(vid, pid: integer; const serial: PChar); EXTDECL;

  tdSensor: function(protocol: PChar; protocolLen: integer; model: PChar; modelLen: integer; id, dataTypes: PInteger): integer; EXTDECL;
  tdSensorValue: function(const protocol, model: PChar; id, dataType: integer; value: PChar; len: integer; timestamp: PInteger): integer; EXTDECL;

  tdController: function(controllerId, controllerType: PInteger; name: PChar; nameLen: integer; available: PInteger): integer; EXTDECL;
  tdControllerValue: function(controllerId: integer; const name: PChar; value: PChar; valueLen: integer): integer; EXTDECL;
  tdSetControllerValue: function(controllerId: integer; const name, value: PChar): integer; EXTDECL;
  tdRemoveController: function(controllerId: integer): integer; EXTDECL;

const

  //-------------------------------------------------------------------------
  //  Device method flags
  //  Flags for the different methods/commands a device can support.
  //  Can be used as bit flags in e.g. tdMethods().
  //-------------------------------------------------------------------------

  TELLSTICK_TURNON  = 1;                        // Device method: TURNON
  TELLSTICK_TURNOFF = 2;                        // Device method: TURNOFF
  TELLSTICK_BELL    = 4;                        // Device method: BELL
  TELLSTICK_TOGGLE  = 8;                        // Device method: TOGGLE
  TELLSTICK_DIM     = 16;                       // Device method: DIM
  TELLSTICK_LEARN   = 32;                       // Device method: LEARN
  TELLSTICK_EXECUTE = 64;                       // Device method: EXECUTE
  TELLSTICK_UP      = 128;                      // Device method: UP
  TELLSTICK_DOWN    = 256;                      // Device method: DOWN
  TELLSTICK_STOP    = 512;                      // Device method: STOP

  //-------------------------------------------------------------------------
  //  Sensor value types
  //  The supported sensor value types are returned from tdSensor() and
  //  used when querying a sensor for a specific value in tdSensorValue().
  //-------------------------------------------------------------------------

  TELLSTICK_TEMPERATURE   = 1;                  // Sensor value type: TEMPERATURE
  TELLSTICK_HUMIDITY      = 2;                  // Sensor value type: HUMIDITY
  TELLSTICK_RAINRATE      = 4;                  // Sensor value type: RAINRATE
  TELLSTICK_RAINTOTAL     = 8;                  // Sensor value type: RAINTOTAL
  TELLSTICK_WINDDIRECTION = 16;                 // Sensor value type: WINDDIRECTION
  TELLSTICK_WINDAVERAGE   = 32;                 // Sensor value type: WINDAVERAGE
  TELLSTICK_WINDGUST      = 64;                 // Sensor value type: WINDGUST

  //-------------------------------------------------------------------------
  //  Error codes
  //  The error codes returned from some API functions.
  //-------------------------------------------------------------------------

  TELLSTICK_SUCCESS                     =  0;   // Error code: SUCCESS
  TELLSTICK_ERROR_NOT_FOUND             = -1;   // Error code: NOT FOUND
  TELLSTICK_ERROR_PERMISSION_DENIED     = -2;   // Error code: PERMISSION DENIED
  TELLSTICK_ERROR_DEVICE_NOT_FOUND      = -3;   // Error code: DEVICE NOT FOUND
  TELLSTICK_ERROR_METHOD_NOT_SUPPORTED  = -4;   // Error code: METHOD NOT SUPPORTED
  TELLSTICK_ERROR_COMMUNICATION         = -5;   // Error code: COMMUNICATION
  TELLSTICK_ERROR_CONNECTING_SERVICE    = -6;   // Error code: CONNECTING SERVICE
  TELLSTICK_ERROR_UNKNOWN_RESPONSE      = -7;   // Error code: UNKNOWN RESPONSE
  TELLSTICK_ERROR_SYNTAX                = -8;   // Error code: SYNTAX
  TELLSTICK_ERROR_BROKEN_PIPE           = -9;   // Error code: BROKEN PIPE
  TELLSTICK_ERROR_COMMUNICATING_SERVICE = -10;  // Error code: COMMUNICATING SERVICE
  TELLSTICK_ERROR_CONFIG_SYNTAX         = -11;  // Error code: CONFIG SYNTAX
  TELLSTICK_ERROR_UNKNOWN               = -99;  // Error code: UNKNOWN

  //-------------------------------------------------------------------------
  //  Device types
  //  The device type as returned from tdGetDeviceType().
  //-------------------------------------------------------------------------

  TELLSTICK_TYPE_DEVICE = 1;                    // Device typedef: DEVICE
  TELLSTICK_TYPE_GROUP	= 2;                    // Device typedef: GROUP
  TELLSTICK_TYPE_SCENE	= 3;                    // Device typedef: SCENE

  //-------------------------------------------------------------------------
  //  Controller type
  //  The controller type as returned from tdController().
  //-------------------------------------------------------------------------

  TELLSTICK_CONTROLLER_TELLSTICK     = 1;       // Controller typedef: TELLSTICK
  TELLSTICK_CONTROLLER_TELLSTICK_DUO = 2;       // Controller typedef: TELLSTICK DUO
  TELLSTICK_CONTROLLER_TELLSTICK_NET = 3;       // Controller typedef: TELLSTICK NET

  //-------------------------------------------------------------------------
  //  Device changes
  //  Flags used in event callbacks.
  //-------------------------------------------------------------------------

  TELLSTICK_DEVICE_ADDED         = 1;           // Device change: ADDED
  TELLSTICK_DEVICE_CHANGED       = 2;           // Device change: CHANGED
  TELLSTICK_DEVICE_REMOVED       = 3;           // Device change: REMOVED
  TELLSTICK_DEVICE_STATE_CHANGED = 4;           // Device change: STATE CHANGED

  //-------------------------------------------------------------------------
  //  Change types
  //  Flags used in event callbacks.
  //-------------------------------------------------------------------------

  TELLSTICK_CHANGE_NAME      = 1;               // Change type: NAME
  TELLSTICK_CHANGE_PROTOCOL  = 2;               // Change type: PROTOCOL
  TELLSTICK_CHANGE_MODEL     = 3;               // Change type: MODEL
  TELLSTICK_CHANGE_METHOD    = 4;               // Change type: METHOD
  TELLSTICK_CHANGE_AVAILABLE = 5;               // Change type: AVAILABLE
  TELLSTICK_CHANGE_FIRMWARE  = 6;               // Change type: FIRMWARE

implementation

uses
  sysutils;

const
  {$IFDEF WINDOWS}
    NAME_LIBTELLDUSCORE = 'TelldusCore';        // telldus-core library name
  {$ELSE}
    NAME_LIBTELLDUSCORE = 'libtelldus-core';    // telldus-core library name
  {$ENDIF}

var
  libTDC : TLibHandle = NilHandle;              // telldus-core library handle


//-------------------------------------------------------------------------
//  TDC_Present
//  - Returns True if Telldus-Core library is loaded and present.
//-------------------------------------------------------------------------
function TDC_Present: boolean;
begin
  Result := libTDC <> NilHandle;
end;

//-------------------------------------------------------------------------
//  TDC_GetLibHandle
//  - Returns the handle of Telldus-Core library.
//-------------------------------------------------------------------------
function TDC_GetLibHandle: TLibHandle;
begin
  Result := libTDC;
end;

//-------------------------------------------------------------------------
//  TDC_SetLibHandle
//  - Set the handle of Telldus-Core library.
//-------------------------------------------------------------------------
procedure TDC_SetLibHandle(libHandle: TLibHandle);
begin
  libTDC := libHandle;;
end;

//-------------------------------------------------------------------------
//  TDC_NilFunctions
//  - Nil all the function variables
//-------------------------------------------------------------------------
procedure TDC_NilFunctions;
begin

  tdInit := nil;
  tdRegisterDeviceEvent := nil;
  tdRegisterDeviceChangeEvent := nil;
  tdRegisterRawDeviceEvent := nil;
  tdRegisterSensorEvent := nil;
  tdRegisterControllerEvent := nil;
  tdUnregisterCallback := nil;
  tdClose := nil;
  tdReleaseString := nil;
  tdTurnOn := nil;
  tdTurnOff := nil;
  tdBell := nil;
  tdDim := nil;
  tdExecute := nil;
  tdUp := nil;
  tdDown := nil;
  tdStop := nil;
  tdLearn := nil;
  tdMethods := nil;
  tdLastSentCommand := nil;
  tdLastSentValue := nil;
  tdGetNumberOfDevices := nil;
  tdGetDeviceId := nil;
  tdGetDeviceType := nil;
  tdGetErrorString := nil;
  tdGetName := nil;
  tdSetName := nil;
  tdGetProtocol := nil;
  tdSetProtocol := nil;
  tdGetModel := nil;
  tdSetModel := nil;
  tdGetDeviceParameter := nil;
  tdSetDeviceParameter := nil;
  tdAddDevice := nil;
  tdRemoveDevice := nil;
  tdSendRawCommand := nil;
  tdConnectTellStickController := nil;
  tdDisconnectTellStickController := nil;
  tdSensor := nil;
  tdSensorValue := nil;
  tdController := nil;
  tdControllerValue := nil;
  tdSetControllerValue := nil;
  tdRemoveController := nil;

end;

//-------------------------------------------------------------------------
//  TDC_LoadLib
//-------------------------------------------------------------------------
procedure TDC_LoadLib;

  procedure initProc(var procPointer; procName: PChar);
  begin
    pointer(procPointer) := dynlibs.GetProcedureAddress(libTDC, procName);
  end;

begin

  initProc((tdInit), 'tdInit');
  initProc((tdRegisterDeviceEvent), 'tdRegisterDeviceEvent');
  initProc((tdRegisterDeviceChangeEvent), 'tdRegisterDeviceChangeEvent');
  initProc((tdRegisterRawDeviceEvent), 'tdRegisterRawDeviceEvent');
  initProc((tdRegisterSensorEvent), 'tdRegisterSensorEvent');
  initProc((tdRegisterControllerEvent), 'tdRegisterControllerEvent');
  initProc((tdUnregisterCallback), 'tdUnregisterCallback');
  initProc((tdClose), 'tdClose');
  initProc((tdReleaseString), 'tdReleaseString');
  initProc((tdTurnOn), 'tdTurnOn');
  initProc((tdTurnOff), 'tdTurnOff');
  initProc((tdBell), 'tdBell');
  initProc((tdDim), 'tdDim');
  initProc((tdExecute), 'tdExecute');
  initProc((tdUp), 'tdUp');
  initProc((tdDown), 'tdDown');
  initProc((tdStop), 'tdStop');
  initProc((tdLearn), 'tdLearn');
  initProc((tdMethods), 'tdMethods');
  initProc((tdLastSentCommand), 'tdLastSentCommand');
  initProc((tdLastSentValue), 'tdLastSentValue');
  initProc((tdGetNumberOfDevices), 'tdGetNumberOfDevices');
  initProc((tdGetDeviceId), 'tdGetDeviceId');
  initProc((tdGetDeviceType), 'tdGetDeviceType');
  initProc((tdGetErrorString), 'tdGetErrorString');
  initProc((tdGetName), 'tdGetName');
  initProc((tdSetName), 'tdSetName');
  initProc((tdGetProtocol), 'tdGetProtocol');
  initProc((tdSetProtocol), 'tdSetProtocol');
  initProc((tdGetModel), 'tdGetModel');
  initProc((tdSetModel), 'tdSetModel');
  initProc((tdGetDeviceParameter), 'tdGetDeviceParameter');
  initProc((tdSetDeviceParameter), 'tdSetDeviceParameter');
  initProc((tdAddDevice), 'tdAddDevice');
  initProc((tdRemoveDevice), 'tdRemoveDevice');
  initProc((tdSendRawCommand), 'tdSendRawCommand');
  initProc((tdConnectTellStickController), 'tdConnectTellStickController');
  initProc((tdDisconnectTellStickController), 'tdDisconnectTellStickController');
  initProc((tdSensor), 'tdSensor');
  initProc((tdSensorValue), 'tdSensorValue');
  initProc((tdController), 'tdController');
  initProc((tdControllerValue), 'tdControllerValue');
  initProc((tdSetControllerValue), 'tdSetControllerValue');
  initProc((tdRemoveController), 'tdRemoveController');

end;

//-------------------------------------------------------------------------
//  TDC_Initialize
//  - Load and Initialize the telldus-core library.
//  - Called from initialization section (if TDC_AutoInitialize is defined).
//-------------------------------------------------------------------------
function TDC_Initialize: boolean;
begin

  try

    if libTDC = NilHandle then begin
      TDC_NilFunctions;
      libTDC := dynlibs.LoadLibrary(NAME_LIBTELLDUSCORE + '.' + dynlibs.SharedSuffix);
    end;

    if libTDC <> NilHandle
      then TDC_LoadLib;

  finally

    Result := libTDC <> NilHandle;

  end;

end;

//-------------------------------------------------------------------------
//  TDC_Finalize
//  - Unload and free the telldus-core library, nil function variables.
//  - Called from finalization section (if TDC_AutoInitialize is defined).
//-------------------------------------------------------------------------
procedure TDC_Finalize;
begin

  if libTDC <> NilHandle then begin
    dynlibs.UnloadLibrary(libTDC);
    libTDC := NilHandle;
    TDC_NilFunctions;
  end;

end;

{$IFDEF TDC_AutoInitialize}     // <--- Define to automatic initialize the unit

//=========================================================
//  initialization
//=========================================================
initialization
begin
  TDC_Initialize;
end;

//=========================================================
//  finalization
//=========================================================
finalization
begin
  TDC_Finalize;
end;

{$ENDIF TDC_AutoInitialize}


{$ELSE TELLDUS_CORE_CLIENT_TELLDUS_CORE_H_}

  // Throw out a warning if the headers is allready defined!
  {$WARNING: TELLDUS_CORE_CLIENT_TELLDUS_CORE_H_ is allready defined!}

implementation

{$ENDIF TELLDUS_CORE_CLIENT_TELLDUS_CORE_H_}     // <--- endif TELLDUS_CORE_CLIENT_TELLDUS_CORE_H_

end.

