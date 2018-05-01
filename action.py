import os
import re
# import glob
from robot.running.builder import ResourceFileBuilder
from robot.libraries.BuiltIn import BuiltIn

class Action:
    def __init__(self, keyword, priority=1):
        self.keyword = keyword
        self.priority = int(priority)

    def do(self):
        BuiltIn().run_keyword(self.keyword)

class Condition:
    def __init__(self, when, where, action, status=None):
        self.when = when.replace('*', '.*')
        self.where = where.replace('*', '.*')
        self.actions = [action]
        self.status = status
        if self.status:
            self.status = self.status.upper()

    def add_action(self, action):
        self.actions.append(action)
        self.__sort_actions()

    def is_satisfied(self, when, where, status):
        if self.status:
            return re.match(self.when, when) and re.match(self.where, where) and self.status == status.upper()
        return re.match(self.when, when) and re.match(self.where, where)

    def __sort_actions(self):
        sorted(self.actions, key=lambda action: action.priority)

class ActionMap:
    def __init__(self):
        self.conditions = list()

    def mapping(self, resource):
        for keyword in resource.keywords:
            for tag in keyword.tags:
                data = tag.split(':')
                kwargs = self.__convert_kwargs(data[2:])
                self.__build_map(keyword.name, data[0], data[1], **kwargs)

    def __convert_kwargs(self, data):
        kwargs = dict()
        for arg in data:
            kwargs[arg.split('=')[0]] = arg.split('=')[1]
        return kwargs

    def __build_map(self, keyword, when,  where, priority=1, status=None):
        action = Action(keyword, priority)
        for condition in self.conditions:
            if condition.is_satisfied(when, where, status):
                condition.add_action(action)
                return
        self.conditions.append(Condition(when, where, action, status))

    def get_pre_actions(self, where):
        for condition in self.conditions:
            if condition.is_satisfied('pre', where, None):
                return condition.actions
        return []

    def get_post_actions(self, where, status):
        for condition in self.conditions:
            if condition.is_satisfied('post', where, status):
                return condition.actions
        return []


class ActionParser:
    def __init__(self, resource_files):
        self.resource_files = resource_files
        self.resources = self.__build_resource()
        self.action_map = ActionMap()
        self.__parse()

    def __build_resource(self):
        return [ResourceFileBuilder().build(resource_file) for resource_file in self.resource_files]

    def import_actions(self):
        for resource_file in self.resource_files:
            BuiltIn().import_resource(os.path.dirname(__file__).replace('\\', '/') + '/' + resource_file.replace('\\', '/'))

    def __parse(self):
        for resource in self.resources:
            self.action_map.mapping(resource)

    def get_action_map(self):
        return self.action_map

# action_parser = ActionParser(glob.glob(
#     '**/*_ppa.robot', recursive=True) + glob.glob('**/*_ppa.txt', recursive=True))
