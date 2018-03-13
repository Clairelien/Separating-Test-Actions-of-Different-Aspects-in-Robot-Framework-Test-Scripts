import os
from robot.running.builder import ResourceFileBuilder
from robot.model import SuiteVisitor
from robot.libraries.BuiltIn import BuiltIn

class actions_handler:
    ROBOT_LISTENER_API_VERSION = 2

    def __init__(self):
        self.res = ResourceFileBuilder().build('pre_and_post_actions.robot')
        self.pre_actions = []
        self.post_actions = []
        self.__action_match(self.res.keywords)

    def __action_match(self, keywords):
        for kw in keywords:
            for tag in kw.tags:
                if tag.split(':')[0] == 'pre':
                    self.pre_actions.append([tag.split(':')[1], kw.name])
                    if kw.name.split(' ')[0] == 'Select' and kw.name.split(' ')[2] == 'Frame':
                        self.post_actions.append([tag.split(':')[1], 'Unselect Frame'])
                elif tag.split(':')[0] == 'post':
                    self.post_actions.append([tag.split(':')[1], kw.name])

    def start_suite(self, name, attributes):
        BuiltIn().import_resource(os.path.dirname(__file__).replace('\\', '/') + '/pre_and_post_actions.robot')

    def start_keyword(self, name, attributes):
        for pre_action in self.pre_actions:
            if pre_action[0] == name:
                self.start_keyword(pre_action[1], None)
                BuiltIn().run_keyword(pre_action[1])
                self.end_keyword(pre_action[1], None)

    def end_keyword(self, name, attributes):
        for post_action in self.post_actions:
            if post_action[0] ==name:
                self.start_keyword(post_action[1], None)
                BuiltIn().run_keyword(post_action[1])
                self.end_keyword(post_action[1], None)
