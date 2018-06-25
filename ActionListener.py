import glob
from action import ActionParser
from robot.libraries.BuiltIn import BuiltIn

class ActionListener:
    ROBOT_LISTENER_API_VERSION = 2
    def __init__(self):
        self.action_parser = ActionParser(glob.glob('**/*_ppa.robot', recursive=True) + glob.glob('**/*_ppa.txt', recursive=True))
        self.action_map = self.action_parser.get_action_map()

    def start_suite(self, name, attributes):
        self.action_parser.import_actions()

    def start_keyword(self, name, attributes):
        for action in self.action_map.get_pre_actions(name):
            action.do()

    def end_keyword(self, name, attributes):
        for action in self.action_map.get_post_actions(name, attributes['status']):
            action.do()
