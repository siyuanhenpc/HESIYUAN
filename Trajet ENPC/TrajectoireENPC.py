from __future__ import print_function
import time
import math
import re
import statistics

from statistics import median
from dronekit import connect, VehicleMode, LocationGlobalRelative, Command, LocationGlobal
from pymavlink import mavutil


#Functions for position controller

def millis():
    return int(round(time.time() * 1000))

class waypoint(object):
    """
    Class that contains the informations and functions that define a waypoint. 
    """
    def __init__(self, x, y, positionTolerance, angleTolerance):
        self.x = x
        self.y = y
        self.posTolerance = positionTolerance
        self.angleTolerance = angleTolerance

    def isWaypointReached(self, posX, posY):
        return abs(self.x - posX) < self.posTolerance and abs(self.y - posY) < self.posTolerance

    def isAngleWithinTolerance(self, droneHeading, stationHeading):
        if self.angleTolerance == 0:
            return True
        else:
           angleDiff = degreeAngleDifference(droneHeading, stationHeading);
           return abs(180 - angleDiff) < self.angleTolerance
   
    def getParameters(self):
        return self.x, self.y, self.posTolerance, self.angleTolerance

class pozyxController(object):
    """
    Class retrieving and filtering the pozyx data
    """
    def __init__(self, bufferSize):
        self.bufferSize = bufferSize
        self.buffer = []
        self.timer = 0

    def getNewInformation(self, serverData):
        """
        Parse the data from the server and stores it into the buffer
        """

        if(len(serverData) > 0):
            split = serverData.split('Z: 0')
            
            if(len(split) != 0):
                for i in range(len(split) -1):
                    searchX = re.search('X:(.*), Y', split[i]) 
                    searchY = re.search('Y:(.*),', split[i])

                    if searchX and searchY :
                        X = int(searchX.group(1))
                        Y = int(searchY.group(1))

                        if(X != 0 or Y != 0):
                            self.buffer.append([X, Y])
                            self.timer = millis()

    def hasNewPosition(self):
        # Returns True if the buffer has more elements than bufferSize
        return len(self.buffer) >= self.bufferSize
    
    def getNewPosition(self):

        X, Y = self.filterBuffer()

        # remove last elements of buffer
        while(len(self.buffer) >= self.bufferSize):
            del self.buffer[0]

        return X, Y

    def filterBuffer(self):

        Xbuffer = []
        Ybuffer = []

        # extract extreme values
        for i in range(len(self.buffer)):
            Xbuffer.append(self.buffer[i][0])
            Ybuffer.append(self.buffer[i][1])

        Xmedian = statistics.median(Xbuffer)
        Ymedian = statistics.median(Ybuffer)
        
        distFromMedianX = [abs(x - Xmedian) for x in Xbuffer]
        distFromMedianY = [abs(x - Ymedian) for x in Ybuffer]

        extremeXvalues = [i for i, j in enumerate(distFromMedianX) if j == max(distFromMedianX)]
        extremeYvalues = [i for i, j in enumerate(distFromMedianY) if j == max(distFromMedianY)]

        indexesToRemove = extremeXvalues + list(set(extremeYvalues) - set(extremeXvalues))

        if len(indexesToRemove) != len(Xbuffer):
            for index in sorted(indexesToRemove, reverse=True):
                del Xbuffer[index]
                del Ybuffer[index]

        # Return the mean of the buffered values without the extreme values
        return int(statistics.mean(Xbuffer)), int(statistics.mean(Ybuffer))
     
        

def getTargetAngleError(destinationX, destinationY, currentX, currentY, stationHeading, droneHeading):
    """
    This function computes the error (difference) between the current heading of the boat and the 
    desired heading, which is the the direction pointing to the target point. 
    The output is a value between -180 and +180 degrees
    """

    # Computes the angle between the station X axis and the vector defined by the origin and destination point
    angleToDestination = getAngleBetweenTwoPoints(destinationX, destinationY, currentX, currentY)

    # Converts this angle into the North-East frame
    alpha = degreeAngleDifference(stationHeading, angleToDestination)

    # Computes the angle difference between the boat current orientation and the desired orientation
    angleDiff = degreeAngleDifference(degreeAngleDifference(alpha, droneHeading), 180)

    if angleDiff > 180:
        angleDiff -= 360

    return angleDiff

def degreeAngleDifference(angle1, angle2):
    """
    Coputes the angle difference in degrees between two given angles.
    The given angles have to be in degrees and defined between 0 and 360
    """
    if angle1 - angle2 < 0:
        return angle1 - angle2 + 360;
    else:
        return angle1 - angle2;

def localToGlobalErrorConversion(currentLat, x, y, stationHeading):
    # 1 - rotate the coordinates to align in the North-East referential
    Xnorth = x * math.cos(stationHeading * math.pi / 180) + y * math.sin(stationHeading * math.pi / 180)
    Yeast = x * math.sin(stationHeading * math.pi / 180) - y * math.cos(stationHeading * math.pi / 180)

    # 2 - convert the distances into Lon, Lat distances
    deltaLat, deltaLon = converMetricToGlobal(currentLat, Xnorth, Yeast)

    return deltaLat, deltaLon

def getAngleBetweenTwoPoints(X1,Y1, X2, Y2):
    """
    Computes the angle of a vector created by two points
    Result in degrees (0 - 360degree)
    """
    dx = X2 - X1
    dy = Y2 - Y1
    if dx == 0 :
        if dy >= 0:
            return 90
        else :
            return 270
    else:
        angle = math.atan(dy/dx) * 180 / math.pi
        if dx >= 0 and dy >= 0:
            return angle
        elif dx >= 0 and dy < 0:
            return angle + 360
        elif dx < 0 and dy >= 0:
            return angle + 180
        elif dx < 0 and dy < 0:
            return angle + 180

def getDistanceBetweenTwoPoints(X1,Y1, X2, Y2):
    dx = X2 - X1
    dy = Y2 - Y1
    return math.sqrt(dx**2 +dy**2)

def convertGlobalToMetric(currentLat, deltaLat, deltaLon):
    """
    Converts a distance measured in latitude and longitude difference metric distance along the North and East direction. 
    This conversion depends on which latitude the drone is located
    Params :
    - currentLat : the current latitude at which the drone is operatin (in degrees)
    - deltaLat : the latitude distance that needs to be converted (in degrees)
    - deltaLon : the longitude distance that needs to be converted (in degrees)

    Outputs: returns the converted distances in mm along the North and East directions
    """
    latitudeToMM, longitudeToMM = getGeoToMetricCoef(currentLat);
    return deltaLat * latitudeToMM, deltaLon * longitudeToMM

def converMetricToGlobal(currentLat, deltaNorth, deltaEast):
    """
    Converts a distance measured in millimeters along the North and East directions into latitude and longitude distances. 
    This conversion depends on which latitude the drone is located
    Params :
    - currentLat : the current latitude at which the drone is operatin (in degrees)
    - deltaNorth : the distance along the North directions that needs to be converted to latitude (in mm)
    - deltaEast : the distance along the East directions that needs to be converted to longitude (in mm)

    Outputs: returns the converted distances in latitude and longitude in degrees
    """
    latitudeToMM, longitudeToMM = getGeoToMetricCoef(currentLat);
    return deltaNorth / latitudeToMM, deltaEast / longitudeToMM

def getGeoToMetricCoef(currentLat):
     # current latitude converted in radians
    radianLattitude = currentLat * math.pi / 180;

    # factor converting 1E-7 degres of latitude to the equivalent in mm at a given latitude
    latitudeToMM = (111132.92 - 559.82 * math.cos(2 * radianLattitude) + 1.175 * math.cos(4 * radianLattitude) - 0.0023*math.cos(6*radianLattitude)) * 1000;
    
    # factor converting 1E-7 degres of latitude to the equivalent in mm at a given latitude
    longitudeToMM = (111412.84 * math.cos(radianLattitude) - 93.5 * math.cos(3*radianLattitude) - 0.118*math.cos(5*radianLattitude))* 1000;

    return latitudeToMM, longitudeToMM

def toRad(degrees):
    return degrees * math.pi / 180

def toDeg(radians):
    return int(radians * 180 / math.pi)


# Deprecated class, only usefull for tests and simulation
class fakePosition(object):
     def __init__(self):
         self.lastPosition = 0
         self.destLat = 48.8416640;
         self.destLon = 2.3412300;
         self.destHeading = 263;
         self.newPosition = False
         
     def getFakePos(self, droneLocation):
        """
        For testing purposes only : recreates a X,Y position relative to a point on the map to simulate a local 
        positionin system
        """       

        deltaLat = droneLocation.lat - self.destLat;
        deltaLon = droneLocation.lon - self.destLon; 
        Xnorth, Yeast = convertGlobalToMetric(self.destLat, deltaLat, deltaLon)
        X = Xnorth * math.cos(self.destHeading * math.pi/180) + Yeast * math.sin(self.destHeading * math.pi/180)
        Y = Xnorth * math.sin(self.destHeading * math.pi/180) - Yeast * math.cos(self.destHeading * math.pi/180)

        return int(X), int(Y)
    
     def isNewPositionAvailable(self):
        if(millis() - self.lastPosition > 100):
            self.lastPosition = millis()
            return True
        else:
            return False

#Functions from droneController
def isBoatInGuidedMode(vehicle):
    if vehicle.mode == VehicleMode('GUIDED'):
        return True;
    else:
        return False;

def setBoatInGuidedMode(vehicle):
    print("Setting GUIDED mode...")
    while(vehicle.armed):
        vehicle.armed = False
        time.sleep(1)

    while not isBoatInGuidedMode(vehicle):
        # send a few commands before entering guided mode (required by arducopter)
        setBoatVelocityLocal(vehicle, 0, 0)
        time.sleep(0.1)
        setBoatVelocityLocal(vehicle, 0, 0)
        time.sleep(0.1)
        setBoatVelocityLocal(vehicle, 0, 0)
        time.sleep(0.1)
        setBoatVelocityLocal(vehicle, 0, 0)
        time.sleep(0.1)
        setBoatVelocityLocal(vehicle, 0, 0)
        time.sleep(0.1)
        # send guided command
        vehicle.mode = VehicleMode('GUIDED')
        time.sleep(0.5)

    while not vehicle.armed: 
        vehicle.armed = True
        time.sleep(1)

    print("GUIDED mode activated")


def setBoatPositionLocal(vehicle, x, y, z):
    """ Remember: vz is positive downward!!!
    http://ardupilot.org/dev/docs/copter-commands-in-guided-mode.html
    
    Bitmask to indicate which dimensions should be ignored by the vehicle 
    (a value of 0b0000000000000000 or 0b0000001000000000 indicates that 
    none of the setpoint dimensions should be ignored). Mapping: 
    bit 1: x,  bit 2: y,  bit 3: z, 
    bit 4: vx, bit 5: vy, bit 6: vz, 
    bit 7: ax, bit 8: ay, bit 9:
    
    
    """
    msg = vehicle.message_factory.set_position_target_local_ned_encode(
            0,
            0, 0,
            mavutil.mavlink.MAV_FRAME_BODY_NED,
            0b0000111111111000, #-- BITMASK -> Consider only the velocities
            x, y, z,        #-- POSITION
            0, 0, 0,        #-- VELOCITY
            0, 0, 0,        #-- ACCELERATIONS
            0, 0)
    vehicle.send_mavlink(msg)
    vehicle.flush()

def setBoatPositionGlobal(vehicle, lat, lon, alt):
    """
    Bitmask to indicate which dimensions should be ignored by the vehicle 
    (a value of 0b0000000000000000 or 0b0000001000000000 indicates that 
    none of the setpoint dimensions should be ignored). Mapping: 
    bit 1: x,  bit 2: y,  bit 3: z, 
    bit 4: vx, bit 5: vy, bit 6: vz, 
    bit 7: ax, bit 8: ay, bit 9:
    """

    msg = vehicle.message_factory.set_position_target_global_int_encode(
            0,
            0, 0,
            mavutil.mavlink.MAV_FRAME_GLOBAL_RELATIVE_ALT,
            0b0000111111111000,     #-- BITMASK -> Consider only the velocities
            lat, lon, alt,          #-- POSITION
            0, 0, 0,                #-- VELOCITY
            0, 0, 0,                #-- ACCELERATIONS
            0, 0)
    vehicle.send_mavlink(msg)
    vehicle.flush()

def setBoatVelocityLocal(vehicle, speed, yawRate):
    """
    Bitmask to indicate which dimensions should be ignored by the vehicle 
    (a value of 0b0000000000000000 or 0b0000001000000000 indicates that 
    none of the setpoint dimensions should be ignored). Mapping: 
    bit 1: x,  bit 2: y,  bit 3: z, 
    bit 4: vx, bit 5: vy, bit 6: vz, 
    bit 7: ax, bit 8: ay, bit 9:
    """

    msg = vehicle.message_factory.set_position_target_local_ned_encode(
            0,
            0, 0,
            mavutil.mavlink.MAV_FRAME_BODY_NED,
            0b0000011111000111, #-- BITMASK -> Consider only the velocities and Yaw rate
            0, 0, 0,            #-- POSITION
            speed, 0, 0,        #-- VELOCITY
            0, 0, 0,            #-- ACCELERATIONS
            0, yawRate)
    vehicle.send_mavlink(msg)
    vehicle.flush()

def condition_yaw(heading, relative=True):
    if relative:
        is_relative=1 #yaw relative to direction of travel
    else:
        is_relative=0 #yaw is an absolute angle
    if heading>0:
        param3=1
    else:
        param3=-1
        heading=-heading
    # create the CONDITION_YAW command using command_long_encode()
    msg = vehicle.message_factory.command_long_encode(
        0, 0,    # target system, target component
        mavutil.mavlink.MAV_CMD_CONDITION_YAW, #command
        0, #confirmation
        heading,    # param 1, yaw in degrees
        0,          # param 2, yaw speed deg/s
        param3,          # param 3, direction -1 ccw, 1 cw
        is_relative, # param 4, relative offset 1, absolute angle 0
        0, 0, 0)    # param 5 ~ 7 not used
    # send command to vehicle
    vehicle.send_mavlink(msg)

def getDroneGpsLocation(vehicle):
    return vehicle.location.global_frame;

def getDroneHeading(vehicle):
    return vehicle.heading;

def setNewWPspeed(vehicle, newValue):
    previousValue = vehicle.parameters['WP_SPEED']
    vehicle.parameters['WP_SPEED'] = newValue
    return previousValue

def disarm(vehicle):
    vehicle.armed = False

def limitSpeedWithAngle(angleError, angleTolerance, speed):
    """
    Apply a linear function to the speed so that it is maximal when aligned with the destination
    and linearly reduced when it is pointing away
    """
    factor = (angleTolerance - abs(angleError))/angleTolerance

    if factor < 0 :
        return 0
    else :
        return speed * factor


def nonBlockingDelay(delay):
    if millis()%delay < 1:
        return True
    else :
        return False
    
def arm_and_takeoff(aTargetAltitude):
    """
    Arms vehicle and fly to aTargetAltitude.
    """

    print("Basic pre-arm checks")
    # Don't let the user try to arm until autopilot is ready
    while not vehicle.is_armable:
        print(" Waiting for vehicle to initialise...")
        time.sleep(1)

        
    print("Arming motors")
    # Copter should arm in GUIDED mode
    vehicle.mode = VehicleMode("GUIDED")
    vehicle.armed = True #

    while not vehicle.armed:      
        print(" Waiting for arming...")
        time.sleep(1)

    print("Taking off!")
    vehicle.simple_takeoff(aTargetAltitude) # Take off to target altitude

    # Wait until the vehicle reaches a safe height before processing the goto (otherwise the command 
    #  after Vehicle.simple_takeoff will execute immediately).
    while True:
        print(" Altitude: ", vehicle.location.global_relative_frame.alt)      
        if vehicle.location.global_relative_frame.alt>=aTargetAltitude*0.95: #Trigger just below target alt.
            print("Reached target altitude")
            break
        time.sleep(1)



#--------------------------------------------------
#-------------- CONNECTION
#--------------------------------------------------

#-- Connect to the vehicle
print('Connecting...')
# vehicle = connect(connection_string) 
# vehicle = connect('udp:0.0.0.0:14551', wait_ready=True)
vehicle = connect('tcp:127.0.0.1:5762', wait_ready=True)

#--------------------------------------------------
#-------------- MAIN FUNCTION
#--------------------------------------------------
print("Starting test")
time.sleep(1)

print("Starting mission")
# Set the vehicle to guided mode : blocking function
setBoatInGuidedMode(vehicle)

arm_and_takeoff(10)

#====== CODE PARAMETERS =======

# speed (in m/s) at which the boat will move in tests 1
velocity = 1
# speed (in deg/s) at which the boat will rotate in test 2
yaw = 120 # turn right
yaw_2 = -120 # turn left
# time (in milliseconds) during which the speed order is sent before stopping the order in test 1
timeBeforeOrderCut_32  = 32000
timeBeforeOrderCut_24  = 24000
timeBeforeOrderCut_8  = 8000

timeBeforeOrderCut_16  = 16000
timeBeforeOrderCut_12  = 12000
timeBeforeOrderCut_8  = 8000
timeBeforeOrderCut_4  = 4000
# time (in milliseconds) during which the boat turns before stopping the order in test 2
timeBeforeChangingDir = 1000

#===============================

testNumber = 1
testStart = 0
direction = 1

while True:

    if isBoatInGuidedMode(vehicle):
         
        if(testStart == 0):
            print("Starting test: going forward during 4s")
            testStart = millis()
         
        # Test 1 : vehicles should go straight foreward for 4 seconds at given speed in m/s
        if(testNumber == 1):
            setBoatVelocityLocal(vehicle, velocity, 0)
            if(millis()) - testStart > timeBeforeOrderCut_8:
                for i in range(20):
                    setBoatVelocityLocal(vehicle, 0, 0)
                    time.sleep(0.01)
                testNumber += 1
                testStart = millis()
                print("Starting test: turning during 1s")

        # Test 2 : vehicles should turn during 2 seconds
        if(testNumber == 2):
            condition_yaw(yaw_2, relative=True)
            testNumber += 1
            time.sleep(2)
            print("Finish turn going forward during 4s")
            testStart = millis()

        velocity = 1
        # Test 3 : vehicles should go straight foreward for 4 seconds at given speed in m/s
        if(testNumber == 3):
            setBoatVelocityLocal(vehicle, velocity, 0)
            if(millis()) - testStart > timeBeforeOrderCut_8:
                for i in range(20):
                    setBoatVelocityLocal(vehicle, 0, 0)
                    time.sleep(0.01)
                testNumber += 1
                testStart = millis()
                print("Starting test: turning during 1s")
        # Test 4 : vehicles should turn during 2 seconds
        if(testNumber == 4):
            condition_yaw(yaw, relative=True)
            testNumber += 1
            time.sleep(2)
            print("Finish turn going forward during 4s")
            testStart = millis()
            
        velocity = 1
        # Test 5 : vehicles should go straight foreward for 4 seconds at given speed in m/s
        if(testNumber == 5):
            setBoatVelocityLocal(vehicle, velocity, 0)
            if(millis()) - testStart > timeBeforeOrderCut_8:
                for i in range(20):
                    setBoatVelocityLocal(vehicle, 0, 0)
                    time.sleep(0.01)
                testNumber += 1
                testStart = millis()
                print("Starting test: turning during 1s")
        # Test 6 : vehicles should turn during 2 seconds
        if(testNumber == 6):
            condition_yaw(yaw, relative=True)
            testNumber += 1
            time.sleep(2)
            print("Finish turn going forward during 4s")
            testStart = millis()
            
        velocity = 1
        # Test 7 : vehicles should go straight foreward for 4 seconds at given speed in m/s
        if(testNumber == 7):
            setBoatVelocityLocal(vehicle, velocity, 0)
            if(millis()) - testStart > timeBeforeOrderCut_8:
                for i in range(20):
                    setBoatVelocityLocal(vehicle, 0, 0)
                    time.sleep(0.01)
                testNumber += 1
                testStart = millis()
                print("Starting test: turning during 1s")
        # Test 8 : vehicles should turn during 2 seconds
        if(testNumber == 8):
            condition_yaw(yaw_2, relative=True)
            testNumber += 1
            time.sleep(2)
            print("Finish turn going forward during 4s")
            testStart = millis()
            
        velocity = 1
        # Test 9 : vehicles should go straight foreward for 4 seconds at given speed in m/s
        if(testNumber == 9):
            setBoatVelocityLocal(vehicle, velocity, 0)
            if(millis()) - testStart > timeBeforeOrderCut_8:
                for i in range(20):
                    setBoatVelocityLocal(vehicle, 0, 0)
                    time.sleep(0.01)
                testNumber += 1
                testStart = millis()
                print("Starting test: turning during 1s")
        # Test 10 : vehicles should turn during 2 seconds
        if(testNumber == 10):
            condition_yaw(yaw_2, relative=True)
            testNumber += 1
            time.sleep(2)
            print("Finish turn going forward during 4s")
            testStart = millis()
            
        velocity = 1
        # Test 11 : vehicles should go straight foreward for 8 seconds at given speed in m/s
        if(testNumber == 11):
            setBoatVelocityLocal(vehicle, velocity, 0)
            if(millis()) - testStart > timeBeforeOrderCut_16:
                for i in range(20):
                    setBoatVelocityLocal(vehicle, 0, 0)
                    time.sleep(0.01)
                testNumber += 1
                testStart = millis()
                print("Starting test: turning during 1s")
        # Test 12 : vehicles should turn during 1 seconds
        if(testNumber == 12):
            condition_yaw(yaw, relative=True)
            testNumber += 1
            time.sleep(2)
            print("Finish turn going forward during 8s")
            testStart = millis()
            
        velocity = 1
        # Test 13 : vehicles should go straight foreward for 8 seconds at given speed in m/s
        if(testNumber == 13):
            setBoatVelocityLocal(vehicle, velocity, 0)
            if(millis()) - testStart > timeBeforeOrderCut_16:
                for i in range(20):
                    setBoatVelocityLocal(vehicle, 0, 0)
                    time.sleep(0.01)
                testNumber += 1
                testStart = millis()
                print("Starting test: turning during 1s")
        # Test 14 : vehicles should turn during 2 seconds
        if(testNumber == 14):
            condition_yaw(yaw, relative=True)
            testNumber += 1
            time.sleep(2)
            print("Finish turn going forward during 8s")
            testStart = millis()

        velocity = 1
        # Test 15 : vehicles should go straight foreward for 8 seconds at given speed in m/s
        if(testNumber == 15):
            setBoatVelocityLocal(vehicle, velocity, 0)
            if(millis()) - testStart > timeBeforeOrderCut_16:
                for i in range(20):
                    setBoatVelocityLocal(vehicle, 0, 0)
                    time.sleep(0.01)
                testNumber += 1
                testStart = millis()
                print("Starting test: turning during 1s")
        # Test 16 : vehicles should turn during 2 seconds
        if(testNumber == 16):
            condition_yaw(yaw_2, relative=True)
            testNumber += 1
            time.sleep(2)
            print("Finish turn going forward during 8s")
            testStart = millis()

        velocity = 1
        # Test 17 : vehicles should go straight foreward for 4 seconds at given speed in m/s
        if(testNumber == 17):
            setBoatVelocityLocal(vehicle, velocity, 0)
            if(millis()) - testStart > timeBeforeOrderCut_8:
                for i in range(20):
                    setBoatVelocityLocal(vehicle, 0, 0)
                    time.sleep(0.01)
                testNumber += 1
                testStart = millis()
                print("Starting test: turning during 1s")
        # Test 18 : vehicles should turn during 2 seconds
        if(testNumber == 18):
            condition_yaw(yaw_2, relative=True)
            testNumber += 1
            time.sleep(2)
            print("Finish turn going forward during 4s")
            testStart = millis()

        velocity = 1
        # Test 19 : vehicles should go straight foreward for 4 seconds at given speed in m/s
        if(testNumber == 19):
            setBoatVelocityLocal(vehicle, velocity, 0)
            if(millis()) - testStart > timeBeforeOrderCut_8:
                for i in range(20):
                    setBoatVelocityLocal(vehicle, 0, 0)
                    time.sleep(0.01)
                testNumber += 1
                testStart = millis()
                print("Starting test: turning during 1s")
        # Test 20 : vehicles should turn during 2 seconds
        if(testNumber == 20):
            condition_yaw(yaw, relative=True)
            testNumber += 1
            time.sleep(2)
            print("Finish turn going forward during 4s")
            testStart = millis()

        velocity = 1
        # Test 21 : vehicles should go straight foreward for 4 seconds at given speed in m/s
        if(testNumber == 21):
            setBoatVelocityLocal(vehicle, velocity, 0)
            if(millis()) - testStart > timeBeforeOrderCut_8:
                for i in range(20):
                    setBoatVelocityLocal(vehicle, 0, 0)
                    time.sleep(0.01)
                testNumber += 1
                testStart = millis()
                print("Starting test: turning during 1s")
        # Test 22 : vehicles should turn during 2 seconds
        if(testNumber == 22):
            condition_yaw(yaw, relative=True)
            testNumber += 1
            time.sleep(2)
            print("Finish turn going forward during 4s")
            testStart = millis()

        velocity = 1
        # Test 23 : vehicles should go straight foreward for 4 seconds at given speed in m/s
        if(testNumber == 23):
            setBoatVelocityLocal(vehicle, velocity, 0)
            if(millis()) - testStart > timeBeforeOrderCut_8:
                for i in range(20):
                    setBoatVelocityLocal(vehicle, 0, 0)
                    time.sleep(0.01)
                testNumber += 1
                testStart = millis()
                print("Starting test: turning during 1s")
        # Test 24 : vehicles should turn during 2 seconds
        if(testNumber == 24):
            condition_yaw(yaw_2, relative=True)
            testNumber += 1
            time.sleep(2)
            print("Finish turn going forward during 4s")
            testStart = millis()

        velocity = 1
        # Test 25 : vehicles should go straight foreward for 4 seconds at given speed in m/s
        if(testNumber == 25):
            setBoatVelocityLocal(vehicle, velocity, 0)
            if(millis()) - testStart > timeBeforeOrderCut_8:
                for i in range(20):
                    setBoatVelocityLocal(vehicle, 0, 0)
                    time.sleep(0.01)
                testNumber += 1
                testStart = millis()
                print("Starting test: turning during 1s")
        # Test 26 : vehicles should turn during 2 seconds
        if(testNumber == 26):
            condition_yaw(yaw_2, relative=True)
            testNumber += 1
            time.sleep(2)
            print("Finish turn going forward during 4s")
            testStart = millis()

        velocity = 1
        # Test 27 : vehicles should go straight foreward for 12 seconds at given speed in m/s
        if(testNumber == 27):
            setBoatVelocityLocal(vehicle, velocity, 0)
            if(millis()) - testStart > (timeBeforeOrderCut_24):
                for i in range(20):
                    setBoatVelocityLocal(vehicle, 0, 0)
                    time.sleep(0.01)
                testNumber += 1
                testStart = millis()
                print("Starting test: turning during 1s")
        # Test 28 : vehicles should turn during 2 seconds
        if(testNumber == 28):
            condition_yaw(yaw_2, relative=True)
            testNumber += 1
            time.sleep(2)
            print("Finish turn going forward during 12s")
            testStart = millis()

        velocity = 1
        # Test 29 : vehicles should go straight foreward for 12 seconds at given speed in m/s
        if(testNumber == 29):
            setBoatVelocityLocal(vehicle, velocity, 0)
            if(millis()) - testStart > timeBeforeOrderCut_8:
                for i in range(20):
                    setBoatVelocityLocal(vehicle, 0, 0)
                    time.sleep(0.01)
                testNumber += 1
                testStart = millis()
                print("Starting test: turning during 1s")
        # Test 30 : vehicles should turn during 2 seconds
        if(testNumber == 30):
            condition_yaw(yaw, relative=True)
            testNumber += 1
            time.sleep(2)
            print("Finish turn going forward during 4s")
            testStart = millis()

        velocity = 1
        # Test 31 : vehicles should go straight foreward for 4 seconds at given speed in m/s
        if(testNumber == 31):
            setBoatVelocityLocal(vehicle, velocity, 0)
            if(millis()) - testStart > timeBeforeOrderCut_8:
                for i in range(20):
                    setBoatVelocityLocal(vehicle, 0, 0)
                    time.sleep(0.01)
                testNumber += 1
                testStart = millis()
                print("Starting test: turning during 1s")
        # Test 32 : vehicles should turn during 2 seconds
        if(testNumber == 32):
            condition_yaw(yaw, relative=True)
            testNumber += 1
            time.sleep(2)
            print("Finish turn going forward during 4s")
            testStart = millis()

        velocity = 1
        # Test 33 : vehicles should go straight foreward for 4 seconds at given speed in m/s
        if(testNumber == 33):
            setBoatVelocityLocal(vehicle, velocity, 0)
            if(millis()) - testStart > timeBeforeOrderCut_8:
                for i in range(20):
                    setBoatVelocityLocal(vehicle, 0, 0)
                    time.sleep(0.01)
                testNumber += 1
                testStart = millis()
                print("Starting test: turning during 1s")
        # Test 34 : vehicles should turn during 2 seconds
        if(testNumber == 34):
            condition_yaw(yaw_2, relative=True)
            testNumber += 1
            time.sleep(2)
            print("Finish turn going forward during 4s")
            testStart = millis()

        velocity = 1
        # Test 35 : vehicles should go straight foreward for 4 seconds at given speed in m/s
        if(testNumber == 35):
            setBoatVelocityLocal(vehicle, velocity, 0)
            if(millis()) - testStart > timeBeforeOrderCut_8:
                for i in range(20):
                    setBoatVelocityLocal(vehicle, 0, 0)
                    time.sleep(0.01)
                testNumber += 1
                testStart = millis()
                print("Starting test: turning during 1s")
        # Test 36 : vehicles should turn during 2 seconds
        if(testNumber == 36):
            condition_yaw(yaw_2, relative=True)
            testNumber += 1
            time.sleep(2)
            print("Finish turn going forward during 16s")
            testStart = millis()
        
        velocity = 1
        # Test 37 : vehicles should go straight foreward for 16 seconds at given speed in m/s
        if(testNumber == 37):
            setBoatVelocityLocal(vehicle, velocity, 0)
            if(millis()) - testStart > timeBeforeOrderCut_32:
                for i in range(20):
                    setBoatVelocityLocal(vehicle, 0, 0)
                    time.sleep(0.01)
                testNumber += 1
                testStart = millis()
                print("FINISH")
                
    time.sleep(8)
#Lorsque la mission est finie on passe en mode de vol RTL pour retourner au point de depart et se poser
print('Return to launch')
vehicle.mode = VehicleMode("RTL")

#On arrete le drone
print("Close vehicle object")
vehicle.close()
