HOST = "localhost"
PORT = 4223
UID = "XXYYZZ" #replace with hat UID
UID1 = "XYZ" # Replace with the UID of first Servo Bricklet
UID2 = "XYZ" # Replace with the UID of second Servo Bricklet
UID3 = "XYZ" # Replace with the UID of third Servo Bricklet

from tinkerforge.ip_connection import IPConnection
from tinkerforge.brick_hat import BrickHAT
from tinkerforge.bricklet_servo_v2 import BrickletServoV2
import rclpy
from rclpy.node import Node
import json
import websockets
from std_msgs.msg import String

class Motor_control(Node):
    def __init__(self):
        super().__init__('motor_control')
        self.subscription = self.create_subscription(
            String,
            'motor_settings',  # Topic name that Cerebra publishes to
            self.callback,
            10
        )

        #servo to bricklet map, All motor names for each servo bricklet and map it to bricklet 1, 2, 3
        self.motor_bricklet_map = {
            "turn_head_motor": 1,
            "tilt_forward_motor": 1, 
            "tilt_sideways_motor": 1,
            "thumb_left_opposition": 1,
            "thumb_left_stretch": 1,
            "index_left_stretch": 1,
            "middle_left_stretch": 1,
            "ring_left_stretch": 1,
            "pinky_left_stretch": 1,
            "thumb_right_opposition": 1,
            "thumb_right_stretch": 2,
            "index_right_stretch": 2,
            "middle_right_stretch": 2,
            "ring_right_stretch": 2,
            "pinky_right_stretch": 2,
            "/upper_arm_left_rotation": 2,
            "/ellbow_left": 2,
            "/lower_arm_left_rotation": 2,
            "/wrist_left": 2,
            "/shoulder_vertical_left": 2,
            "/shoulder_horizontal_left": 3,
            "/upper_arm_right_rotation": 3,
            "/ellbow_right": 3,
            "/lower_arm_right_rotation": 3,
            "/wrist_right": 3,
            "/shoulder_vertical_right": 3,
            "/shoulder_horizontal_right": 3,
        }
        #Servo to port/pin map
        self.motor_map = {
            "turn_head_motor": 0,
            "tilt_forward_motor": 1, 
            "tilt_sideways_motor": 2,
            "thumb_left_opposition": 3,
            "thumb_left_stretch": 4,
            "index_left_stretch": 5,
            "middle_left_stretch": 6,
            "ring_left_stretch": 7,
            "pinky_left_stretch": 8,
            "thumb_right_opposition": 9,
            "thumb_right_stretch": 0,
            "index_right_stretch": 1,
            "middle_right_stretch": 2,
            "ring_right_stretch": 3,
            "pinky_right_stretch": 4,
            "/upper_arm_left_rotation": 5,
            "/ellbow_left": 6,
            "/lower_arm_left_rotation": 7,
            "/wrist_left": 8,
            "/shoulder_vertical_left": 9,
            "/shoulder_horizontal_left": 0,
            "/upper_arm_right_rotation": 1,
            "/ellbow_right": 2,
            "/lower_arm_right_rotation": 3,
            "/wrist_right": 4,
            "/shoulder_vertical_right": 5,
            "/shoulder_horizontal_right": 6,
        }
        self.ipcon = IPConnection()  # Create IP connection
        self.hat = BrickHAT(UID, self.ipcon)        
        # Handles for three Servo Bricklets
        self.servo1 = BrickletServoV2(UID1, self.ipcon)  
        self.servo2 = BrickletServoV2(UID2, self.ipcon)  
        self.servo3 = BrickletServoV2(UID3, self.ipcon)  
        self.ipcon.connect(HOST, 4223)

    def callback(self, msg):
        try:
            # Extract the message sent by cerebra, isolate motor and value raw value
            data_str = msg.data[msg.data.find('[') + 1: msg.data.rfind(']')]
            data = data_str.strip('{}').strip('"')
            motor, value = data.split('},{')
            motor = motor.split(':')[1].strip('"')
            value = int(value.split(':')[1])
            motor_port = self.motor_map.get(motor)
            motor_bricklet = self.motor_bricklet_map.get(motor)
            #print motor name, which bricklet connected to it, which port and what value on terminal
            self.get_logger().info(f"Motor: {motor}, Connected to port '{motor_port}' On bricklet '{motor_bricklet}', Will move by '{value}'")
            
            # Move motor retrieved from message, each condition depends on which bricklet motor is connected to
            if motor_bricklet == 1:
                   #Improve range of motion by modifying pwm, then move motor 
                    self.servo1.set_pulse_width(motor_port, 700, 2500)
                    self.servo1.set_position(motor_port, value)
                    self.servo1.set_enable(motor_port, True)
            elif motor_bricklet == 2:
                    self.servo2.set_position(motor_port, value)
                    self.servo2.set_pulse_width(motor_port, 700, 2500)
                    self.servo2.set_enable(motor_port, True)            
            elif motor_bricklet == 3:
                    self.servo3.set_position(motor_port, value)
                    self.servo3.set_pulse_width(motor_port, 700, 2500)
                    self.servo3.set_enable(motor_port, True)

        except Exception as e:
            self.get_logger().warn(f"Error processing message: {str(e)}")

async def rosbridge_listener():
    url = 'ws://localhost:9090'  

    async with websockets.connect(url) as websocket:
        while True:
            message = await websocket.recv()
            data = json.loads(message)
            if 'op' in data and data['op'] == 'publish':
                node = Motor_control()
                msg = String()
                msg.data = data['msg']['data']
                node.callback(msg)


def main(args=None):
    rclpy.init(args=args)
    motor_control = Motor_control()
    rclpy.spin(motor_control)
    rclpy.shutdown()
    motor_control.ipcon.disconnect()


if __name__ == '__main__':
    main()
