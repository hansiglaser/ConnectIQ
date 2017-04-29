/**
 * Collection and storage class for all available informations
 */

using Toybox.System as System;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Gregorian;
using Toybox.Activity as Activity;
using Toybox.ActivityMonitor as ActivityMonitor;
using Toybox.Position;
using Toybox.Sensor;
using Toybox.UserProfile;

enum {
  OUT_PRINT = 0,      // print information using System.println(), don't store
  OUT_STORE = 1       // store information, can be printed later
}

class AllInfos {

  var SelectOutput;  // OUT_PRINT or OUT_STORE
  var InfoData;  // array of dict {:title=>string, :elements=>array}, elements items are dict {:name=>string, :value=>any, :unit=>string/null}

  /**
   * Constructor
   *
   * @param aSelectOutput  either OUT_PRINT or OUT_STORE
   */
  function initialize(aSelectOutput) {
    SelectOutput = aSelectOutput;
    InfoData     = [];
  }

  // Storage Functions ///////////////////////////////////////////////////////

  /// Add 
  function AddGroup(st) {
    if (SelectOutput == OUT_PRINT) {
      System.println(st);
    } else if (SelectOutput == OUT_STORE) {
      var NewGroup = {:title => st, :elements => []};
      InfoData.add(NewGroup);
    }
  }

  function AddElement(name, value, unit) {
    if (SelectOutput == OUT_PRINT) {
      System.println(ElementVarsToString(name, value, unit));
    } else if (SelectOutput == OUT_STORE) {
      var NewElement = {:name => name, :value => value, :unit => unit};
      InfoData[InfoData.size()-1][:elements].add(NewElement);
    }
  }

  // Output Functions ////////////////////////////////////////////////////////

  function Print() {
    var g;
    var e;
    var Group;
    for (g = 0; g < InfoData.size(); g++) {
      Group = InfoData[g];
      System.println(Group[:title]);
      for (e = 0; e < Group[:elements].size(); e++) {
        System.println(ElementToString(Group[:elements][e]));
      }
    }
  }

  function ElementToString(element) {
    return ElementVarsToString(element[:name], element[:value], element[:unit]);
  }

  function ElementVarsToString(name, value, unit) {
    var st;
    st = "  " + name + " = " + value;
    if (value != null && unit != null) {
      st += unit;
    }
    return st;
  }

  // Information Gathering Functions /////////////////////////////////////////

  function StoreAllInfos() {
    StoreActivityInfos();
    StoreActivityMonitorInfos();
    StorePositionInfos();
    StoreSensorInfos();
    StoreDeviceSettingsInfos();
    StoreSystemStatsInfos();
    StoreUserProfileInfos();
  }

  function StoreActivityInfos() {
    var ActInfo = Activity.getActivityInfo();
    if (ActInfo != null) {
      AddGroup("Activity Info");
      AddElement("altitude", ActInfo.altitude, "m"); // The altitude in meters. (Float)
      AddElement("averageCadence", ActInfo.averageCadence, "rpm");  // ⇒ Number // The average cadence in revolutions per minute.
      AddElement("averageDistance", ActInfo.averageDistance, "m");  // ⇒ Float // The swim stroke average distance in meters from the previous interval.
      AddElement("averageHeartRate", ActInfo.averageHeartRate, "bpm");  // ⇒ Number // The average heart rate in beats per minute.
      AddElement("averagePower", ActInfo.averagePower, "W");  // ⇒ Number // The average power in watts.
      AddElement("averageSpeed", ActInfo.averageSpeed, "m/s");  // ⇒ Float // The average speed in meters per second.
      if (ActInfo has :bearing) {
        AddElement("bearing", ActInfo.bearing, "rad");  // ⇒ Float // bearing is the direction from your current location or position to the destination of navigation in radians.
      }
      if (ActInfo has :bearingFromStart) {
        AddElement("bearingFromStart", ActInfo.bearingFromStart, "rad");  // ⇒ Float // bearingFromStart is the direction of desired track from start of navigation to destination in radians.
      }
      AddElement("calories", ActInfo.calories, "kcal");  // ⇒ Number // The current calories burned during the current activity being recorded in kcal.
      AddElement("currentCadence", ActInfo.currentCadence, "rpm");  // ⇒ Number // The current cadence in revolutions per minute.
      AddElement("currentHeading", ActInfo.currentHeading, "rad");  // ⇒ Float // The current true north referenced heading in radians.
      AddElement("currentHeartRate", ActInfo.currentHeartRate, "bpm");  // ⇒ Number // The current heart rate in beats per minute.
      AddElement("currentLocation", LocationToString(ActInfo.currentLocation), null);  // ⇒ Location // The current location.
      AddElement("currentLocationAccuracy", LocAccuracyToString(ActInfo.currentLocationAccuracy), null);  // ⇒ Number // GPS Accuracy (See the accuracy member of the Info object in the Position module for more information).
      AddElement("currentPower", ActInfo.currentPower, "W");  // ⇒ Number // The current power in watts.
      AddElement("currentSpeed", ActInfo.currentSpeed, "m/s");  // ⇒ Float // The current speed in meters per second.
      if (ActInfo has :distanceToDestination) {
        AddElement("distanceToDestination", ActInfo.distanceToDestination, "m");  // ⇒ Float // Distance to the destination in meters.
      }
      if (ActInfo has :distanceToNextPoint) {
        AddElement("distanceToNextPoint", ActInfo.distanceToNextPoint, "m");  // ⇒ Float // Distance to the next point in meters.
      }
      AddElement("elapsedDistance", ActInfo.elapsedDistance, "m");  // ⇒ Float // Distance in meters.
      AddElement("elapsedTime", ActInfo.elapsedTime, "ms");  // ⇒ Number // Elapsed time of the activity in milliseconds.
      if (ActInfo has :elevationAtDestination) {
        AddElement("elevationAtDestination", ActInfo.elevationAtDestination, "m");  // ⇒ Float // Elevation at the destination in meters.
      }
      if (ActInfo has :elevationAtNextPoint) {
        AddElement("elevationAtNextPoint", ActInfo.elevationAtNextPoint, "m");  // ⇒ Float // Elevation at the next point in meters.
      }
      AddElement("energyExpenditure", ActInfo.energyExpenditure, "kcal/min");  // ⇒ Float // Momentary energy expenditure in kcals/min (www.firstbeat.com/consumers/analyzed-by-firstbeat-features#4).
      if (ActInfo has :frontDerailleurIndex) {
        AddElement("frontDerailleurIndex", ActInfo.frontDerailleurIndex, null);  // ⇒ Number // Index of the Front Bicycle Derailleur.
      }
      if (ActInfo has :frontDerailleurMax) {
        AddElement("frontDerailleurMax", ActInfo.frontDerailleurMax, null);  // ⇒ Number // Max index on the Front Bicycle Derailleur.
      }
      if (ActInfo has :frontDerailleurSize) {
        AddElement("frontDerailleurSize", ActInfo.frontDerailleurSize, null);  // ⇒ Number // Gear size on the Front Bicycle Derailleur.
      }
      AddElement("maxCadence", ActInfo.maxCadence, "rpm");  // ⇒ Number // The maximum cadence in revolutions per minute.
      AddElement("maxHeartRate", ActInfo.maxHeartRate, "bpm");  // ⇒ Number // The maximum heart rate in beats per minute.
      AddElement("maxPower", ActInfo.maxPower, "W");  // ⇒ Number // The maximum power in watts.
      AddElement("maxSpeed", ActInfo.maxSpeed, "m/s");  // ⇒ Float // The maximum speed recorded during the timed activity, in meters per second.
      if (ActInfo has :nameOfDestination) {
        AddElement("nameOfDestination", ActInfo.nameOfDestination);  // ⇒ String // Name of the destination.
      }
      if (ActInfo has :nameOfNextPoint) {
        AddElement("nameOfNextPoint", ActInfo.nameOfNextPoint, null);  // ⇒ String // Name of the next point.
      }
      if (ActInfo has :offCourseDistance) {
        AddElement("offCourseDistance", ActInfo.offCourseDistance, "m");  // ⇒ Float // Distance to the nearest point on course in meters.
      }
      if (ActInfo has :rearDerailleurIndex) {
        AddElement("rearDerailleurIndex", ActInfo.rearDerailleurIndex, null);  // ⇒ Number // Index of the Rear Bicycle Derailleur.
      }
      if (ActInfo has :rearDerailleurMax) {
        AddElement("rearDerailleurMax", ActInfo.rearDerailleurMax, null);  // ⇒ Number // Max index on the Rear Bicycle Derailleur.
      }
      if (ActInfo has :rearDerailleurSize) {
        AddElement("rearDerailleurSize", ActInfo.rearDerailleurSize, null);  // ⇒ Number // Gear size on the Rear Bicycle Derailleur.
      }
      AddElement("startLocation", ActInfo.startLocation, null);  // ⇒ Location // The starting location of the activity.
      AddElement("startTime", ActInfo.startTime, null);  // ⇒ Moment // The starting time of the activity.
      AddElement("swimStrokeType", SwimStrokeTypeToString(ActInfo.swimStrokeType), null);  // ⇒ Number // The swim stroke type from the previous length.
      AddElement("swimSwolf", ActInfo.swimSwolf, null);  // ⇒ Number // The swimming SWOLF score from the previous length.
      if (ActInfo has :timerState) {
        AddElement("timerState", TimerStateToString(ActInfo.timerState), null);  // ⇒ Number // The recording timer state.
      }
      AddElement("timerTime", ActInfo.timerTime, "ms");  // ⇒ Number // Timer time in milliseconds.
      AddElement("totalAscent", ActInfo.totalAscent, "m");  // ⇒ Float // The total ascent in meters.
      AddElement("totalDescent", ActInfo.totalDescent, "m");  // ⇒ Float // The total descent in meters.
      if (ActInfo has :track) {
        AddElement("track", ActInfo.track, null);  // ⇒ Float // track is the direction of travel or track in radians.
      }
      if (ActInfo has :trainingEffect) {
        AddElement("trainingEffect", ActInfo.trainingEffect, null);  // ⇒ Float // Training Effect: The activity's level of effect on aerobic fitness.
      }
    } else {
      AddGroup("No acitivity info available.");
    }
  }

  function StoreActivityMonitorInfos() {
    var ActMonInfo = ActivityMonitor.getInfo();
    if (ActMonInfo != null) {
      AddGroup("Activity Monitor Info");
      if (ActMonInfo has :activeMinutesDay) {
        AddElement("activeMinutesDay", ActiveMinutesToString(ActMonInfo.activeMinutesDay), null);  // ⇒ ActiveMinutes // Number of active mintues for the current day Contains the moderate, vigorous, and total accumulated minutes for the day.
      }
      if (ActMonInfo has :activeMinutesWeek) {
        AddElement("activeMinutesWeek", ActiveMinutesToString(ActMonInfo.activeMinutesWeek), null);  // ⇒ ActiveMinutes // Number of active mintues for the current week Contains the moderate, vigorous, and total accumulated minutes for the week.
      }
      if (ActMonInfo has :activeMinutesWeekGoal) {
        AddElement("activeMinutesWeekGoal", ActMonInfo.activeMinutesWeekGoal, "min");  // ⇒ Number // Value of active mintues goal for the current week.
      }
      if (ActMonInfo has :calories) {
        AddElement("calories", ActMonInfo.calories, "kcal");  // ⇒ Number // Calories burned so far for the day in kCal.
      }
      if (ActMonInfo has :distance) {
        AddElement("distance", ActMonInfo.distance, "cm");  // ⇒ Number // Distance in cm.
      }
      if (ActMonInfo has :floorsClimbed) {
        AddElement("floorsClimbed", ActMonInfo.floorsClimbed, null);  // ⇒ Number // The number of floors climbed.
      }
      if (ActMonInfo has :floorsClimbedGoal) {
        AddElement("floorsClimbedGoal", ActMonInfo.floorsClimbedGoal, null);  // ⇒ Number // The current floor climb goal.
      }
      if (ActMonInfo has :floorsDescended) {
        AddElement("floorsDescended", ActMonInfo.floorsDescended, null);  // ⇒ Number // The number of floors descended.
      }
      if (ActMonInfo has :isSleepMode) {
        AddElement("isSleepMode", ActMonInfo.isSleepMode, null);  // ⇒ Boolean // isSleepMode will be removed in Connect IQ 4.0.0
      }
      if (ActMonInfo has :metersClimbed) {
        AddElement("metersClimbed", ActMonInfo.metersClimbed, "m");  // ⇒ Float // The number of meters climbed.
      }
      if (ActMonInfo has :metersDescended) {
        AddElement("metersDescended", ActMonInfo.metersDescended, "m");  // ⇒ Float // The number of meters descended.
      }
      if (ActMonInfo has :moveBarLevel) {
        AddElement("moveBarLevel", ActMonInfo.moveBarLevel, null);  // ⇒ Number // Current level of the move bar.
      }
      if (ActMonInfo has :stepGoal) {
        AddElement("stepGoal", ActMonInfo.stepGoal, null);  // ⇒ Number // Step goal for the day.
      }
      if (ActMonInfo has :steps) {
        AddElement("steps", ActMonInfo.steps, null);  // ⇒ Number // Steps in number of steps.
      }
    } else {
      AddGroup("No activity monitor info available.");
    }
  }

  // TODO: ActivityMonitor.getHeartRateHistory(), ActivityMonitor.getHistory()

  // TODO: PersistentContent.getCourses(), getRoutes(), getTracks(), getWaypoints(), getWorkouts() --> Interator

  function StorePositionInfos() {
    var LocInfo = Position.getInfo();
    if (LocInfo != null) {
      AddGroup("Position Info");
      AddElement("accuracy", LocAccuracyToString(LocInfo.accuracy), null);  // ⇒ Number // Positional accuracy (good, usable, poor, not available).
      AddElement("altitude", LocInfo.altitude, "m");  // ⇒ Float // Elevation in meters (mean sea level).
      AddElement("heading", LocInfo.heading, "rad");  // ⇒ Float // True north referenced heading in radians.
      AddElement("position", LocationToString(LocInfo.position), null);  // ⇒ Location // Lat/Lon.
      AddElement("speed", LocInfo.speed, "m/s");  // ⇒ Float // Horizontal speed in meters per second.
      AddElement("when", MomentToString(LocInfo.when), null);  // ⇒ Moment // GPS time stamp of fix.
    } else {
      AddGroup("No position info available.");
    }
  }

  function StoreSensorInfos() {
    var SensorInfo = Sensor.getInfo();
    if (SensorInfo != null) {
      AddGroup("Sensor Info");
      if (SensorInfo has :accel) {
        AddElement("accel", SensorInfo.accel, "milli-g");  // ⇒ Array // Accelerometer reading for X, Y, and Z as an Array of Number values (milli-g-units).
      }
      AddElement("altitude", SensorInfo.altitude, "m");  // ⇒ Float // Altitude (m) (See the altitude member of the Info object in the Position module for more information).
      AddElement("cadence", SensorInfo.cadence, "rpm");  // ⇒ Number // Cadence (rpm) Cadence is derived (in order of priority) from bike sensors (cadence or speed must be enabled), advanced running dynamics sensors (e.g. heart strap with running dynamics enabled), footpod, or watch-based cadence calculations.
      AddElement("heading", SensorInfo.heading, "rad");  // ⇒ Float // True north referenced heading (radians).
      AddElement("heartRate", SensorInfo.heartRate, "bpm");  // ⇒ Number // HR (bpm).
      if (SensorInfo has :mag) {
        AddElement("mag", SensorInfo.mag, "mG");  // ⇒ Array // Magnetometer reading for X, Y, and Z as an Array of Number values (mGauss).
      }
      AddElement("power", SensorInfo.power, "W");  // ⇒ Number // Power (W).
      AddElement("pressure", SensorInfo.pressure, "Pa");  // ⇒ Float // Pressure (Pa) Returns base level (sea-level) pressure.
      AddElement("speed", SensorInfo.speed, "m/s");  // ⇒ Float // Speed (m/s) (See the speed member of the Info object in the Position module for more information).
      AddElement("temperature", SensorInfo.temperature, "°C");  // ⇒ Float // Temperature (degC).
    } else {
      AddGroup("No sensor info available.");
    }
  }

    // TODO: SensorHistory.getElevationHistory(), getHeartRateHistory(), getPressureHistory(), getTemperatureHistory() --> Iterator

  function StoreDeviceSettingsInfos() {
    var DevSettings = System.getDeviceSettings();
    if (DevSettings != null) {
      AddGroup("Device Settings");
      AddElement("activityTrackingOn", DevSettings.activityTrackingOn, null);  // ⇒ Boolean // True if activity Tracking is enabled on the device.
      AddElement("alarmCount", DevSettings.alarmCount, null);  // ⇒ Number // The number of alarms set to go off on the device.
      AddElement("distanceUnits", DistanceUnitsToString(DevSettings.distanceUnits), null);  // ⇒ Number // UNIT_METRIC if distance is shown in kilometers, UNIT_STATUTE if it is shown in miles.
      if (DevSettings has :doNotDisturb) {
        AddElement("doNotDisturb", DevSettings.doNotDisturb, null);  // ⇒ Boolean // True if “Do Not Disturb” mode is enabled on the device.
      }
      AddElement("elevationUnits", ElevationUnitsToString(DevSettings.elevationUnits), null);  // ⇒ Number // UNIT_METRIC if elevation is shown in meters, UNIT_STATUTE if it is shown in feet.
      AddElement("firmwareVersion", DevSettings.firmwareVersion, null);  // ⇒ Array // Get the current firmware version as a two entry array [ major, minor ].
      AddElement("heightUnits", HeightUnitsToString(DevSettings.heightUnits), null);  // ⇒ Number // UNIT_METRIC if height is shown in meters, UNIT_STATUTE if it is shown in feet.
      AddElement("inputButtons", InputButtonsToString(DevSettings.inputButtons), null);  // ⇒ Number // Enumerate if Select/Up/Down/Menu buttons are supported using the BUTTON_INPUT_XXXX enum values.
      AddElement("is24Hour", DevSettings.is24Hour, null);  // ⇒ Boolean // True if unit shows 24 hour units, false if it displays 12 hour.
      AddElement("isTouchScreen", DevSettings.isTouchScreen, null);  // ⇒ Boolean // Does this unit have a touch screen?.
      AddElement("monkeyVersion", DevSettings.monkeyVersion, null);  // ⇒ Array // Get the CIQ version as a three entry array [major, minor, micro ].
      AddElement("notificationCount", DevSettings.notificationCount, null);  // ⇒ Number // The number of active notifications.
      AddElement("paceUnits", PaceUnitsToString(DevSettings.paceUnits), null);  // ⇒ Number // UNIT_METRIC if pace is shown in kilometers/hour, UNIT_STATUTE if it is shown in miles/hour.
      AddElement("partNumber", DevSettings.partNumber, null);  // ⇒ String // Get the part number for this product as a string.
      AddElement("phoneConnected", DevSettings.phoneConnected, null);  // ⇒ Boolean // True if a mobile phone is connected to the device, false otherwise.
      AddElement("screenHeight", DevSettings.screenHeight, null);  // ⇒ Number // The height of the device screen in pixels To get the height of the screen area currently available to the app, use Graphics.Dc.getHeight().
      AddElement("screenShape", ScreenShapeToString(DevSettings.screenShape), null);  // ⇒ Number // SCREEN_SHAPE_XXXX enum value that describes the screen shape.
      AddElement("screenWidth", DevSettings.screenWidth, null);  // ⇒ Number // The width of the device screen in pixels To get the width of the screen area currently available to the app, use Graphics.Dc.getWidth().
      AddElement("temperatureUnits", TemperatureUnitsToString(DevSettings.temperatureUnits), null);  // ⇒ Number // UNIT_METRIC if temperature is shown in Celsius, UNIT_STATUTE if it is shown in Fahrenheit.
      AddElement("tonesOn", DevSettings.tonesOn, null);  // ⇒ Object // True if tones are enabled on the unit, false if they are disabled return [Boolean].
      AddElement("vibrateOn", DevSettings.vibrateOn, null);  // ⇒ Boolean // True if vibration is enabled on the unit, false if it is disabled.
      AddElement("weightUnits", WeightUnitsToString(DevSettings.weightUnits), null);  // ⇒ Number // UNIT_METRIC if weight is shown in kilograms, UNIT_STATUTE if it is shown in pounds.
    } else {
      AddGroup("No device settings available.");
    }
  }

  function StoreSystemStatsInfos() {
    var SysStats = System.getSystemStats();
    if (SysStats != null) {
      AddGroup("System Status");
      AddElement("battery", SysStats.battery, "%");  // ⇒ Float // Battery life remaining in percent (between 0.0 and 100.0).
      AddElement("freeMemory", SysStats.freeMemory, "B");  // ⇒ Number // Free memory in bytes.
      AddElement("totalMemory", SysStats.totalMemory, "B");  // ⇒ Number // Total available memory in bytes.
      AddElement("usedMemory", SysStats.usedMemory, "B");  // ⇒ Number // Memory used by this application in bytes.
    } else {
      AddGroup("No system status available.");
    }
  }

  function StoreUserProfileInfos() {
    var CurSport = UserProfile.getCurrentSport();
    AddGroup("HR Zones for current sport: " + CurrentSportToString(CurSport));

    var HRZones = UserProfile.getHeartRateZones(CurSport);
    AddElement("Zone 1",  HRZones[0]   .format("%3d") + "-" + HRZones[1].format("%3d"), "bpm");
    AddElement("Zone 2", (HRZones[1]+1).format("%3d") + "-" + HRZones[2].format("%3d"), "bpm");
    AddElement("Zone 3", (HRZones[2]+1).format("%3d") + "-" + HRZones[3].format("%3d"), "bpm");
    AddElement("Zone 4", (HRZones[3]+1).format("%3d") + "-" + HRZones[4].format("%3d"), "bpm");
    AddElement("Zone 5", (HRZones[4]+1).format("%3d") + "-" + HRZones[5].format("%3d"), "bpm");

    var Profile = UserProfile.getProfile();
    if (Profile != null) {
      AddGroup("User Profile");
      AddElement("activityClass", Profile.activityClass, null);  // ⇒ Number // Activity level from 0-100; 20 is low activity, 50 is medium, 80 is high (athlete).
      AddElement("birthYear", Profile.birthYear, null);  // ⇒ Number // Birth Year.
      AddElement("gender", GenderToString(Profile.gender), null);  // ⇒ Number // Gender enum.
      AddElement("height", Profile.height, "cm");  // ⇒ Number // Height in centimeters.
      AddElement("restingHeartRate", Profile.restingHeartRate, "bpm");  // ⇒ Number // Heart rate.
      AddElement("runningStepLength", Profile.runningStepLength, "mm");  // ⇒ Number // Running step length in millimeters.
      AddElement("sleepTime", DurationToString(Profile.sleepTime), null);  // ⇒ Duration // Typical sleep time as configured by the user.
      AddElement("wakeTime", DurationToString(Profile.wakeTime), null);  // ⇒ Duration // Typical wake time as configured by the user.
      AddElement("walkingStepLength", Profile.walkingStepLength, "mm");  // ⇒ Number // Walking step length in millimeters.
      AddElement("weight", Profile.weight, "g");  // ⇒ Number // Weight in grams.
    } else {
      AddGroup("No user profile available.");
    }
  }

  // Beautification Functions ////////////////////////////////////////////////

  function LocationToString(loc) {
    if (loc != null) {
      return loc.toGeoString(Position.GEO_DEG);
    } else {
      return "null";
    }
  }

  function LocAccuracyToString(locaccuracy) {
    // The QUALITY enum is used to represent the quality of GPS fix with which
    // the Location information was calculated.
    if        (locaccuracy == Position.QUALITY_NOT_AVAILABLE) {
      return "not available"; // GPS is not available
    } else if (locaccuracy == Position.QUALITY_LAST_KNOWN) {
      return "last known"; // The Location is based on the last known GPS fix.
    } else if (locaccuracy == Position.QUALITY_POOR) {
      return "poor"; // The Location was calculated with a poor GPS fix. Only a 2-D GPS fix is available, likely due to a limited number of tracked satellites.
    } else if (locaccuracy == Position.QUALITY_USABLE) {
      return "usable"; // The Location was calculated with a usable GPS fix. A 3-D GPS fix is available, with marginal HDOP (horizontal dilution of precision)
    } else if (Position.QUALITY_GOOD == locaccuracy) {
      return "good"; // The Location was calculated with a good GPS fix. A 3-D GPS fix is available, with good-to-excellent HDOP.
    } else {
      return locaccuracy.toString();
    }
  }

  function SwimStrokeTypeToString(swimstroketype) {
    // The SWIM_STROKE enum is used to evaluate the results of the activity swim stroke info.
    if        (Activity.SWIM_STROKE_FREESTYLE == swimstroketype) {
      return "Freestyle stroke";
    } else if (Activity.SWIM_STROKE_BACKSTROKE == swimstroketype) {
      return "Backstroke";
    } else if (Activity.SWIM_STROKE_BREASTSTROKE == swimstroketype) {
      return "Breaststroke";
    } else if (Activity.SWIM_STORKE_BUTTERFLY == swimstroketype) {
      return "Butterfly stroke";
    } else if (Activity.SWIM_STROKE_DRILL == swimstroketype) {
      return "Drill mode";
    } else if (Activity.SWIM_STROKE_MIXED == swimstroketype) {
      return "Mixed stroke mode";
    } else if (Activity.SWIM_STROKE_IM == swimstroketype) {
      return "Mixed interval"; // with equal number of butterfly, backstroke, breaststroke, and freestyle in that order.
    } else {
      return swimstroketype;//.toString();
    }
  }

  function TimerStateToString(timerstate) {
    // The TIMER_STATE enum is used to indicate the state of the recording timer.
    if        (Activity.TIMER_STATE_OFF == timerstate) {
      return "off"; // The timer is off. There is not an active recording
    } else if (Activity.TIMER_STATE_STOPPED == timerstate) {
      return "stopped"; // The timer is stopped. The recording is active, with the timer stopped.
    } else if (Activity.TIMER_STATE_PAUSED == timerstate) {
      return "paused"; // The timer is paused. The recording is active with the timer paused. This state occurs when the timer is active, but has been stopped with the Auto-Pause feature.
    } else if (Activity.TIMER_STATE_ON == timerstate) {
      return "on"; // The timer is on. The recording is active and the timer is running.
    } else {
      return timerstate.toString();
    }
  }

  function ActiveMinutesToString(activeMinutes) {
    if (activeMinutes != null) {
      return "moderate: " + activeMinutes.moderate + " + vigorous: " + activeMinutes.vigorous + " = total: " + activeMinutes.total;
    } else {
      return "null";
    }
  }

  function MomentToString(moment) {
    if (moment != null) {
      var info = Gregorian.info(moment, Time.FORMAT_SHORT);  // returns an Info object with day, day_of_week, hour, min, month, sec, year
      return 
        info.year.format("%04d") + "-" + info.month.format("%02d") + "-" + info.day.format("%02d") + " " +
        info.hour.format("%02d") + ":" + info.min.format("%02d") + ":" + info.sec.format("%02d");
    } else {
      return "null";
    }
  }

  function DurationToString(duration) {
    if (duration != null) {
      var moment = duration.add(Time.today());//new Time.Moment(0));
      var info = Gregorian.info(moment, Time.FORMAT_SHORT);  // returns an Info object with day, day_of_week, hour, min, month, sec, year
      return 
//        info.year.format("%04d") + "-" + info.month.format("%02d") + "-" + info.day.format("%02d") + " " +
        info.hour.format("%02d") + ":" + info.min.format("%02d") + ":" + info.sec.format("%02d");
    } else {
      return "null";
    }
  }

  function DistanceUnitsToString(distanceUnits) {
    if        (System.UNIT_METRIC  == distanceUnits) {
      return "km";
    } else if (System.UNIT_STATUTE == distanceUnits) {
      return "mi";
    } else {
      return distanceUnits.toString();
    }
  }

  function ElevationUnitsToString(elevationUnits) {
    if        (System.UNIT_METRIC  == elevationUnits) {
      return "m";
    } else if (System.UNIT_STATUTE == elevationUnits) {
      return "ft";
    } else {
      return elevationUnits.toString();
    }
  }

  function HeightUnitsToString(heightUnits) {
    if        (System.UNIT_METRIC  == heightUnits) {
      return "m";
    } else if (System.UNIT_STATUTE == heightUnits) {
      return "ft";
    } else {
      return heightUnits.toString();
    }
  }

  function PaceUnitsToString(paceUnits) {
    if        (System.UNIT_METRIC  == paceUnits) {
      return "km/h";
    } else if (System.UNIT_STATUTE == paceUnits) {
      return "mph";
    } else {
      return paceUnits.toString();
    }
  }

  function TemperatureUnitsToString(temperatureUnits) {
    if        (System.UNIT_METRIC  == temperatureUnits) {
      return "°C";
    } else if (System.UNIT_STATUTE == temperatureUnits) {
      return "°F";
    } else {
      return temperatureUnits.toString();
    }
  }

  function WeightUnitsToString(weightUnits) {
    if        (System.UNIT_METRIC  == weightUnits) {
      return "kg";
    } else if (System.UNIT_STATUTE == weightUnits) {
      return "pd";
    } else {
      return weightUnits.toString();
    }
  }

  function InputButtonsToString(inputButtons) {
    var result = "";
    if (inputButtons & System.BUTTON_INPUT_SELECT) { result += "Select, "; }
    if (inputButtons & System.BUTTON_INPUT_UP)     { result += "Up, ";     }
    if (inputButtons & System.BUTTON_INPUT_DOWN)   { result += "Down, ";   }
    if (inputButtons & System.BUTTON_INPUT_MENU)   { result += "Menu, ";   }
    return result.substring(0, result.length()-2);   // cut off trailing ", "
  }

  function ScreenShapeToString(screenShape) {
    if        (System.SCREEN_SHAPE_ROUND      == screenShape) {
      return "round";
    } else if (System.SCREEN_SHAPE_SEMI_ROUND == screenShape) {
      return "semi-round";
    } else if (System.SCREEN_SHAPE_RECTANGLE  == screenShape) {
      return "rectangle";
    } else {
      return screenShape.toString();
    }
  }

  function CurrentSportToString(currentSport) {
    // The HR_ZONE_SPORT enum specifies the sport heart rate zones should be read from.
    if        (UserProfile.HR_ZONE_SPORT_GENERIC  == currentSport) {
      return "generic";
    } else if (UserProfile.HR_ZONE_SPORT_RUNNING  == currentSport) {
      return "running";
    } else if (UserProfile.HR_ZONE_SPORT_BIKING   == currentSport) {
      return "biking";
    } else if (UserProfile.HR_ZONE_SPORT_SWIMMING == currentSport) {
      return "swimming";
    } else {
      return currentSport.toString();
    }
  }

  function GenderToString(gender) {
    // The GENDER enum specifies the gender of the user working out.
    if        (UserProfile.GENDER_FEMALE == gender) {
      return "female";
    } else if (UserProfile.GENDER_MALE   == gender) {
      return "male";
    } else {
      return gender.toString();
    }
  }

}

// vi:syntax=javascript filetype=javascript
