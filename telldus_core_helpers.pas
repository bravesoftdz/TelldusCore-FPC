unit telldus_core_helpers;

{-------------------------------------------------------------------------

  telldus_core_helpers.pas - Telldus API Helper unit.
  - Part of Telldus FPC package by Ted Roberth Nilsen.


  Changelog:
  ----------

  2017.03.17
  * First version of the unit.

-------------------------------------------------------------------------}

{$MODE objfpc}{$H+}
{$I telldus_core_helpers.inc}

interface

uses
  telldus_core;

const

  // Tellstick Device all methods flags
  TD_METHOD_ALL           = TELLSTICK_TURNON + TELLSTICK_TURNOFF + TELLSTICK_BELL + TELLSTICK_TOGGLE + TELLSTICK_DIM
                          + TELLSTICK_LEARN  + TELLSTICK_EXECUTE + TELLSTICK_UP   + TELLSTICK_DOWN   + TELLSTICK_STOP;

type

  //---------------------------------------------------------
  //  TTDMsgEvent
  //---------------------------------------------------------
  TTDMsgEvent             = packed record
    private
    public
      context             : pointer;                  // Pointer that will be passed back in the callback.
      deviceId            : integer;                  // The id of the device that changed
      method              : integer;                  // The new device state. Can be TELLSTICK_TURNON, TELLSTICK_TURNOFF, etc.
      callbackId          : integer;                  // The id of the callback.
      data                : string;                   // If method is TELLSTICK_DIM this holds the current value as a human readable string, example "128" for 50%.
      procedure   initialize; inline;
      procedure   setValue(const AData: string; ADeviceId, AMethod, ACallbackId: integer; AContext: pointer);
  end;
  PTDMsgEvent             = ^TTDMsgEvent;

  //---------------------------------------------------------
  //  TTDMsgRaw
  //---------------------------------------------------------
  TTDMsgRaw               = packed record
    private
    public
      context             : pointer;                  // Pointer that will be passed back in the callback.
      controllerId        : integer;                  // Id of receiving controller.
      callbackId          : integer;                  // The id of the callback.
      data                : string;                   // Raw device data.
      procedure   initialize; inline;
      procedure   setValue(const AData: string; AControllerId, ACallbackId: integer; AContext: pointer);
  end;
  PTDMsgRaw               = ^TTDMsgRaw;

  //---------------------------------------------------------
  //  TTDMsgSensor
  //---------------------------------------------------------
  TTDMsgSensor            = packed record
    private
    public
      context             : pointer;                  // Pointer that will be passed back in the callback.
      id                  : integer;                  // The unique id for the sensor.
      dataType            : integer;                  // The type that value is. Can be one of TELLSTICK_TEMPERATURE, TELLSTICK_HUMIDITY, TELLSTICK_RAINTOTAL, TELLSTICK_RAINRATE, TELLSTICK_WINDDIRECTION, TELLSTICK_WINDAVERAGE or TELLSTICK_WINDGUST.
      callbackId          : integer;                  // The id of the callback.
      timestamp           : integer;                  // The time (as returned by the time() system call) when the value was received.
      protocol            : string;                   // The sensor's protocol.
      model               : string;                   // The model of the sensor.
      value               : string;                   // A human readable string of the data.
      procedure   initialize; inline;
      procedure   setValue(const AProtocol, AModel, AValue: string; AId, ADataType, ACallbackId, ATimeStamp: integer; AContext: pointer);
  end;
  PTDMsgSensor            = ^TTDMsgSensor;

  //---------------------------------------------------------
  //  TTDMsgChange
  //---------------------------------------------------------
  TTDMsgChange            = packed record
    private
    public
      context             : pointer;                  // Pointer that will be passed back in the callback.
      deviceId            : integer;                  // The id of the device that was added, changed or removed.
      changeEvent         : integer;                  // One of the constants TELLSTICK_DEVICE_ADDED, TELLSTICK_DEVICE_CHANGED or TELLSTICK_DEVICE_REMOVED.
      changeType          : integer;                  // If changeEvent is TELLSTICK_DEVICE_CHANGED, this parameter indicates what has changed (e.g TELLSTICK_CHANGE_NAME, TELLSTICK_CHANGE_PROTOCOL, TELLSTICK_CHANGE_MODEL or TELLSTICK_CHANGE_METHOD).
      callbackId          : integer;                  // The id of the callback.
      procedure   initialize; inline;
      procedure   setValue(ADeviceId, AChangeEvent, AChangeType, ACallbackId: integer; AContext: pointer);
  end;
  PTDMsgChange            = ^TTDMsgChange;

  //---------------------------------------------------------
  //  TTDMsgController
  //---------------------------------------------------------
  TTDMsgController        = packed record
    private
    public
      context             : pointer;                  // Pointer that will be passed back in the callback.
      controllerId        : integer;                  // The id of the controller that was added, changed or removed.
      changeEvent         : integer;                  // One of the constants TELLSTICK_DEVICE_ADDED, TELLSTICK_DEVICE_CHANGED, TELLSTICK_DEVICE_STATE_CHANGED or TELLSTICK_DEVICE_REMOVED.
      // If changeEvent is:
      // * TELLSTICK_DEVICE_ADDED this is the controller's type (e.g. TELLSTICK_CONTROLLER_TELLSTICK or TELLSTICK_CONTROLLER_TELLSTICK_DUO),
      // * TELLSTICK_DEVICE_CHANGED this indicates what has changed (e.g. TELLSTICK_CHANGE_NAME or TELLSTICK_CHANGE_FIRMWARE),
      // * TELLSTICK_DEVICE_STATE_CHANGED this indicates which state that has changed (e.g. TELLSTICK_CHANGE_AVAILABLE),
      // * TELLSTICK_DEVICE_REMOVED this is unused.
      changeType          : integer;
      callbackId          : integer;                  // The id of the callback.
      // If changeEvent is:
      // * TELLSTICK_DEVICE_CHANGED this is the property's new value,
      // * TELLSTICK_DEVICE_STATE_CHANGED this is the new state. For TELLSTICK_CHANGE_AVAILABLE this is either "0" or "1".
      value               : string;
      procedure   initialize; inline;
      procedure   setValue(const AValue: string; AControllerId, AChangeEvent, AChangeType, ACallbackId: integer; AContext: pointer);
  end;
  PTDMsgController        = ^TTDMsgController;

  //=========================================================
  //  Helper functions for Telldus-Core
  //=========================================================

  procedure td_ReleaseString(var result: string; pt: PChar); overload; inline;
  function  td_ReleaseString(pt: PChar): string; overload; inline;

  //=========================================================
  //  Convert functions for Telldus-Core
  //=========================================================

  function  td_DeviceMethod_String(const value: integer): string;
  function  td_DeviceMethod_Value(const value: string): integer;

  function  td_SensorType_String(const value: integer): string;
  function  td_SensorType_Value(const value: string): integer;

  function  td_ErrorCode_String(const value: integer): string;
  function  td_ErrorCode_Value(const value: string): integer;

  function  td_DeviceType_String(const value: integer): string;
  function  td_DeviceType_Value(const value: string): integer;

  function  td_ControllerType_String(const value: integer): string;
  function  td_ControllerType_Value(const value: string): integer;

  function  td_DeviceChange_String(const value: integer): string;
  function  td_DeviceChange_Value(const value: string): integer;

  function  td_ChangeType_String(const value: integer): string;
  function  td_ChangeType_Value(const value: string): integer;

const

  //---------------------------------------------------------
  // TTDMsgEvent default value
  //---------------------------------------------------------
  TDEVENT_DEFAULT : TTDMsgEvent = (
    context       : nil;
    deviceId      : 0;
    method        : 0;
    callbackId    : 0;
    data          : '';
  );

  //---------------------------------------------------------
  // TTDMsgRaw default value
  //---------------------------------------------------------
  TDRAWEVENT_DEFAULT : TTDMsgRaw = (
    context       : nil;
    controllerId  : 0;
    callbackId    : 0;
    data          : '';
  );

  //---------------------------------------------------------
  // TTDMsgSensor default value
  //---------------------------------------------------------
  TDSENSOREVENT_DEFAULT : TTDMsgSensor = (
    context       : nil;
    id            : 0;
    dataType      : 0;
    callbackId    : 0;
    timestamp     : 0;
    protocol      : '';
    model         : '';
    value         : '';
  );

  //---------------------------------------------------------
  // TTDMsgChange default value
  //---------------------------------------------------------
  TDCHANGEEVENT_DEFAULT : TTDMsgChange = (
    context       : nil;
    deviceId      : 0;
    changeEvent   : 0;
    changeType    : 0;
    callbackId    : 0;
  );

  //---------------------------------------------------------
  // TTDMsgController default value
  //---------------------------------------------------------
  TDCONTROLLEREVENT_DEFAULT : TTDMsgController = (
    context       : nil;
    controllerId  : 0;
    changeEvent   : 0;
    changeType    : 0;
    callbackId    : 0;
    value         : '';
  );


implementation


//---------------------------------------------------------
//  TTDMsgEvent
//---------------------------------------------------------
procedure TTDMsgEvent.initialize;
begin
  Self := TDEVENT_DEFAULT;
end;

procedure TTDMsgEvent.setValue(const AData: string; ADeviceId, AMethod, ACallbackId: integer; AContext: pointer);
begin
  context    := AContext;
  deviceId   := ADeviceId;
  method     := AMethod;
  callbackId := ACallbackId;
  data       := AData;
end;

//---------------------------------------------------------
//  TTDMsgRaw
//---------------------------------------------------------
procedure TTDMsgRaw.initialize;
begin
  Self := TDRAWEVENT_DEFAULT;
end;

procedure TTDMsgRaw.setValue(const AData: string; AControllerId, ACallbackId: integer; AContext: pointer);
begin
  context      := AContext;
  controllerId := AControllerId;
  callbackId   := ACallbackId;
  data         := AData;
end;

//---------------------------------------------------------
//  TTDMsgSensor
//---------------------------------------------------------
procedure TTDMsgSensor.initialize;
begin
  Self := TDSENSOREVENT_DEFAULT;
end;

procedure TTDMsgSensor.setValue(const AProtocol, AModel, AValue: string; AId, ADataType, ACallbackId, ATimeStamp: integer; AContext: pointer);
begin
  context    := AContext;
  id         := AId;
  dataType   := ADataType;
  callbackId := ACallbackId;
  timestamp  := ATimeStamp;
  protocol   := AProtocol;
  model      := AModel;
  value      := AValue;
end;

//---------------------------------------------------------
//  TTDMsgChange
//---------------------------------------------------------
procedure TTDMsgChange.initialize;
begin
  Self := TDCHANGEEVENT_DEFAULT;
end;

procedure TTDMsgChange.setValue(ADeviceId, AChangeEvent, AChangeType, ACallbackId: integer; AContext: pointer);
begin
  context     := AContext;
  deviceId    := ADeviceId;
  changeEvent := AChangeEvent;
  changeType  := AChangeType;
  callbackId  := ACallbackId;
end;

//---------------------------------------------------------
//  TTDMsgController
//---------------------------------------------------------
procedure TTDMsgController.initialize;
begin
  Self := TDCONTROLLEREVENT_DEFAULT;
end;

procedure TTDMsgController.setValue(const AValue: string; AControllerId, AChangeEvent, AChangeType, ACallbackId: integer; AContext: pointer);
begin
  context      := AContext;
  controllerId := AControllerId;
  changeEvent  := AChangeEvent;
  changeType   := AChangeType;
  callbackId   := ACallbackId;
  value        := AValue;
end;


//=========================================================
//  Helper functions for Telldus-Core
//=========================================================

procedure td_ReleaseString(var result: string; pt: PChar);
begin
  result := strpas(pt);
  tdReleaseString(pt);
end;

function td_ReleaseString(pt: PChar): string;
begin
  td_ReleaseString(Result{%H-}, pt);
end;


//=========================================================
//  Convert functions for Telldus-Core
//=========================================================

//---------------------------------------------------------
// * Get DeviceMethod as string.
function td_DeviceMethod_String(const value: integer): string;
begin
  case value of
    TELLSTICK_TURNON:  Result := 'TELLSTICK_TURNON';
    TELLSTICK_TURNOFF: Result := 'TELLSTICK_TURNOFF';
    TELLSTICK_BELL:    Result := 'TELLSTICK_BELL';
    TELLSTICK_TOGGLE:  Result := 'TELLSTICK_TOGGLE';
    TELLSTICK_DIM:     Result := 'TELLSTICK_DIM';
    TELLSTICK_LEARN:   Result := 'TELLSTICK_LEARN';
    TELLSTICK_EXECUTE: Result := 'TELLSTICK_EXECUTE';
    TELLSTICK_UP:      Result := 'TELLSTICK_UP';
    TELLSTICK_DOWN:    Result := 'TELLSTICK_DOWN';
    TELLSTICK_STOP:    Result := 'TELLSTICK_STOP';
    else               Result := 'UNKNOWN_DEVICEMETHOD';
  end;
end;

// * Get DeviceMethod value from string.
function td_DeviceMethod_Value(const value: string): integer;
begin
  case value of
    'TELLSTICK_TURNON':  Result := TELLSTICK_TURNON;
    'TELLSTICK_TURNOFF': Result := TELLSTICK_TURNOFF;
    'TELLSTICK_BELL':    Result := TELLSTICK_BELL;
    'TELLSTICK_TOGGLE':  Result := TELLSTICK_TOGGLE;
    'TELLSTICK_DIM':     Result := TELLSTICK_DIM;
    'TELLSTICK_LEARN':   Result := TELLSTICK_LEARN;
    'TELLSTICK_EXECUTE': Result := TELLSTICK_EXECUTE;
    'TELLSTICK_UP':      Result := TELLSTICK_UP;
    'TELLSTICK_DOWN':    Result := TELLSTICK_DOWN;
    'TELLSTICK_STOP':    Result := TELLSTICK_STOP;
    else                 Result := TELLSTICK_ERROR_UNKNOWN;
  end;
end;

//---------------------------------------------------------
// * Get SensorType as string.
function td_SensorType_String(const value: integer): string;
begin
  case value of
    TELLSTICK_TEMPERATURE:   Result := 'TELLSTICK_TEMPERATURE';
    TELLSTICK_HUMIDITY:      Result := 'TELLSTICK_HUMIDITY';
    TELLSTICK_RAINRATE:      Result := 'TELLSTICK_RAINRATE';
    TELLSTICK_RAINTOTAL:     Result := 'TELLSTICK_RAINTOTAL';
    TELLSTICK_WINDDIRECTION: Result := 'TELLSTICK_WINDDIRECTION';
    TELLSTICK_WINDAVERAGE:   Result := 'TELLSTICK_WINDAVERAGE';
    TELLSTICK_WINDGUST:      Result := 'TELLSTICK_WINDGUST';
    else                     Result := 'UNKNOWN_SENSOR';
  end;
end;

// * Get SensorType value from string.
function td_SensorType_Value(const value: string): integer;
begin
  case value of
    'TELLSTICK_TEMPERATURE':   Result := TELLSTICK_TEMPERATURE;
    'TELLSTICK_HUMIDITY':      Result := TELLSTICK_HUMIDITY;
    'TELLSTICK_RAINRATE':      Result := TELLSTICK_RAINRATE;
    'TELLSTICK_RAINTOTAL':     Result := TELLSTICK_RAINTOTAL;
    'TELLSTICK_WINDDIRECTION': Result := TELLSTICK_WINDDIRECTION;
    'TELLSTICK_WINDAVERAGE':   Result := TELLSTICK_WINDAVERAGE;
    'TELLSTICK_WINDGUST':      Result := TELLSTICK_WINDGUST;
    else                       Result := TELLSTICK_ERROR_UNKNOWN;
  end;
end;

//---------------------------------------------------------
// * Get ErrorCode as string.
function td_ErrorCode_String(const value: integer): string;
begin
  case value of
    TELLSTICK_SUCCESS:                     Result := 'TELLSTICK_SUCCESS';
    TELLSTICK_ERROR_NOT_FOUND:             Result := 'TELLSTICK_ERROR_NOT_FOUND';
    TELLSTICK_ERROR_PERMISSION_DENIED:     Result := 'TELLSTICK_ERROR_PERMISSION_DENIED';
    TELLSTICK_ERROR_DEVICE_NOT_FOUND:      Result := 'TELLSTICK_ERROR_DEVICE_NOT_FOUND';
    TELLSTICK_ERROR_METHOD_NOT_SUPPORTED:  Result := 'TELLSTICK_ERROR_METHOD_NOT_SUPPORTED';
    TELLSTICK_ERROR_COMMUNICATION:         Result := 'TELLSTICK_ERROR_COMMUNICATION';
    TELLSTICK_ERROR_CONNECTING_SERVICE:    Result := 'TELLSTICK_ERROR_CONNECTING_SERVICE';
    TELLSTICK_ERROR_UNKNOWN_RESPONSE:      Result := 'TELLSTICK_ERROR_UNKNOWN_RESPONSE';
    TELLSTICK_ERROR_SYNTAX:                Result := 'TELLSTICK_ERROR_SYNTAX';
    TELLSTICK_ERROR_BROKEN_PIPE:           Result := 'TELLSTICK_ERROR_BROKEN_PIPE';
    TELLSTICK_ERROR_COMMUNICATING_SERVICE: Result := 'TELLSTICK_ERROR_COMMUNICATING_SERVICE';
    TELLSTICK_ERROR_CONFIG_SYNTAX:         Result := 'TELLSTICK_ERROR_CONFIG_SYNTAX';
    TELLSTICK_ERROR_UNKNOWN:               Result := 'TELLSTICK_ERROR_UNKNOWN';
    else                                   Result := 'UNKNOWN_ERROR';
  end;
end;

// * Get ErrorCode value from string.
function td_ErrorCode_Value(const value: string): integer;
begin
  case value of
    'TELLSTICK_SUCCESS':                     Result := TELLSTICK_SUCCESS;
    'TELLSTICK_ERROR_NOT_FOUND':             Result := TELLSTICK_ERROR_NOT_FOUND;
    'TELLSTICK_ERROR_PERMISSION_DENIED':     Result := TELLSTICK_ERROR_PERMISSION_DENIED;
    'TELLSTICK_ERROR_DEVICE_NOT_FOUND':      Result := TELLSTICK_ERROR_DEVICE_NOT_FOUND;
    'TELLSTICK_ERROR_METHOD_NOT_SUPPORTED':  Result := TELLSTICK_ERROR_METHOD_NOT_SUPPORTED;
    'TELLSTICK_ERROR_COMMUNICATION':         Result := TELLSTICK_ERROR_COMMUNICATION;
    'TELLSTICK_ERROR_CONNECTING_SERVICE':    Result := TELLSTICK_ERROR_CONNECTING_SERVICE;
    'TELLSTICK_ERROR_UNKNOWN_RESPONSE':      Result := TELLSTICK_ERROR_UNKNOWN_RESPONSE;
    'TELLSTICK_ERROR_SYNTAX':                Result := TELLSTICK_ERROR_SYNTAX;
    'TELLSTICK_ERROR_BROKEN_PIPE':           Result := TELLSTICK_ERROR_BROKEN_PIPE;
    'TELLSTICK_ERROR_COMMUNICATING_SERVICE': Result := TELLSTICK_ERROR_COMMUNICATING_SERVICE;
    'TELLSTICK_ERROR_CONFIG_SYNTAX':         Result := TELLSTICK_ERROR_CONFIG_SYNTAX;
    'TELLSTICK_ERROR_UNKNOWN':               Result := TELLSTICK_ERROR_UNKNOWN;
    else                                     Result := TELLSTICK_ERROR_UNKNOWN;
  end;
end;

//---------------------------------------------------------
// * Get DeviceType as string.
function td_DeviceType_String(const value: integer): string;
begin
  case value of
    TELLSTICK_TYPE_DEVICE: Result := 'TELLSTICK_TYPE_DEVICE';
    TELLSTICK_TYPE_GROUP:  Result := 'TELLSTICK_TYPE_GROUP';
    TELLSTICK_TYPE_SCENE:  Result := 'TELLSTICK_TYPE_SCENE';
    else                   Result := 'UNKNOWN_TYPE';
  end;
end;

// * Get DeviceType value from string.
function td_DeviceType_Value(const value: string): integer;
begin
  case value of
    'TELLSTICK_TYPE_DEVICE': Result := TELLSTICK_TYPE_DEVICE;
    'TELLSTICK_TYPE_GROUP':  Result := TELLSTICK_TYPE_GROUP;
    'TELLSTICK_TYPE_SCENE':  Result := TELLSTICK_TYPE_SCENE;
    else                     Result := TELLSTICK_ERROR_UNKNOWN;
  end;
end;

//---------------------------------------------------------
// * Get ControllerType as string.
function td_ControllerType_String(const value: integer): string;
begin
  case value of
    TELLSTICK_CONTROLLER_TELLSTICK:     Result := 'TELLSTICK_CONTROLLER_TELLSTICK';
    TELLSTICK_CONTROLLER_TELLSTICK_DUO: Result := 'TELLSTICK_CONTROLLER_TELLSTICK_DUO';
    TELLSTICK_CONTROLLER_TELLSTICK_NET: Result := 'TELLSTICK_CONTROLLER_TELLSTICK_NET';
    else                                Result := 'UNKNOWN_CONTROLLER';
  end;
end;

// * Get ControllerType value from string.
function td_ControllerType_Value(const value: string): integer;
begin
  case value of
    'TELLSTICK_CONTROLLER_TELLSTICK':     Result := TELLSTICK_CONTROLLER_TELLSTICK;
    'TELLSTICK_CONTROLLER_TELLSTICK_DUO': Result := TELLSTICK_CONTROLLER_TELLSTICK_DUO;
    'TELLSTICK_CONTROLLER_TELLSTICK_NET': Result := TELLSTICK_CONTROLLER_TELLSTICK_NET;
    else                                  Result := TELLSTICK_ERROR_UNKNOWN;
  end;
end;

//---------------------------------------------------------
// * Get DeviceChange as string.
function td_DeviceChange_String(const value: integer): string;
begin
  case value of
    TELLSTICK_DEVICE_ADDED:         Result := 'TELLSTICK_DEVICE_ADDED';
    TELLSTICK_DEVICE_CHANGED:       Result := 'TELLSTICK_DEVICE_CHANGED';
    TELLSTICK_DEVICE_REMOVED:       Result := 'TELLSTICK_DEVICE_REMOVED';
    TELLSTICK_DEVICE_STATE_CHANGED: Result := 'TELLSTICK_DEVICE_STATE_CHANGED';
    else                            Result := 'UNKNOWN_DEVICECHANGE';
  end;
end;

// * Get DeviceChange value from string.
function td_DeviceChange_Value(const value: string): integer;
begin
  case value of
    'TELLSTICK_DEVICE_ADDED':         Result := TELLSTICK_DEVICE_ADDED;
    'TELLSTICK_DEVICE_CHANGED':       Result := TELLSTICK_DEVICE_CHANGED;
    'TELLSTICK_DEVICE_REMOVED':       Result := TELLSTICK_DEVICE_REMOVED;
    'TELLSTICK_DEVICE_STATE_CHANGED': Result := TELLSTICK_DEVICE_STATE_CHANGED;
    else                              Result := TELLSTICK_ERROR_UNKNOWN;
  end;
end;

//---------------------------------------------------------
// * Get ChangeType as string.
function td_ChangeType_String(const value: integer): string;
begin
  case value of
    TELLSTICK_CHANGE_NAME:      Result := 'TELLSTICK_CHANGE_NAME';
    TELLSTICK_CHANGE_PROTOCOL:  Result := 'TELLSTICK_CHANGE_PROTOCOL';
    TELLSTICK_CHANGE_MODEL:     Result := 'TELLSTICK_CHANGE_MODEL';
    TELLSTICK_CHANGE_METHOD:    Result := 'TELLSTICK_CHANGE_METHOD';
    TELLSTICK_CHANGE_AVAILABLE: Result := 'TELLSTICK_CHANGE_AVAILABLE';
    TELLSTICK_CHANGE_FIRMWARE:  Result := 'TELLSTICK_CHANGE_FIRMWARE';
    else                        Result := 'UNKNOWN_CHANGE';
  end;
end;

// * Get ChangeType value from string.
function td_ChangeType_Value(const value: string): integer;
begin
  case value of
    'TELLSTICK_CHANGE_NAME':      Result := TELLSTICK_CHANGE_NAME;
    'TELLSTICK_CHANGE_PROTOCOL':  Result := TELLSTICK_CHANGE_PROTOCOL;
    'TELLSTICK_CHANGE_MODEL':     Result := TELLSTICK_CHANGE_MODEL;
    'TELLSTICK_CHANGE_METHOD':    Result := TELLSTICK_CHANGE_METHOD;
    'TELLSTICK_CHANGE_AVAILABLE': Result := TELLSTICK_CHANGE_AVAILABLE;
    'TELLSTICK_CHANGE_FIRMWARE':  Result := TELLSTICK_CHANGE_FIRMWARE;
    else                          Result := TELLSTICK_ERROR_UNKNOWN;
  end;
end;

end.

