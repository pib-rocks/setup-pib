#This python script contains methods to get and save the UIDs from tinkerforge in an external file
#Also it contains method to update the UDIs in the database and to compare the IDs with the database

import rclpy
from tinkerforge.ip_connection import IPConnection

class manageTinkerforge:
        
    UID1 = "XYZ"
    UID2 = "XYZ"
    UID3 = "XYZ"

    def __init__(self):
        self.getUIDs()
        self.persistUIDs()

    def getUIDs():
        self.ipcon.register_callback(IPConnection.CALLBACK_ENUMERATE, self.cb_enumerate)
        self.ipcon.enumerate()

    def persistUIDs():
        file=open("tinkerForgeConfig.txt","w")
        newText="UID1 = " + UID1 + "\nUID2" + UID2 + "\nUID3" + UID3
        file.write(newText)
        file.close()
        return
           
    def returnCurrentUIDs():
        self.getUIDs()
        return [UID1, UID2, UID3]

    def cb_enumerate(self, uid, connected_uid, position, hardware_version, firmware_version, device_identifier, enumeration_type):
        if position == "a":
                global UID1
                UID1 = uid
        if position == "b":
                global UID2
                UID2 = uid
        if position == "e":
                global UID3
                UID3 = uid

def main(args=None):
       rclpy.init(args=args)
       manager = manageTinkerforge()
       rclpy.spin(manager)
       rclpy.shutdown
       manager.ipcon.disconnect()
    

if __name__ == '__main__':
       main()