import os
from robot.running.builder import ResourceFileBuilder
from robot.libraries.BuiltIn import BuiltIn

class Action:
    def __init__(self, keyword, priority=1):
        self.keyword = keyword
        self.priority = int(priority)

    def do(self):
        BuiltIn().run_keyword(self.keyword)
        # print('do action: %s' % self.keyword)

class Condition:
    def __init__(self, when, where, action):
        self.when = when
        self.where = where
        self.actions = [action]

    def add_action(self, action):
        self.actions.append(action)
        self.__sort_actions()

    def is_satisfied(self, when, where):
        return self.when == when and self.where == where

    def __sort_actions(self):
        sorted(self.actions, key=lambda action: action.priority)

class ActionMap:
    def __init__(self):
        self.conditions = list()

    def mapping(self, resource):
        for keyword in resource.keywords:
            for tag in keyword.tags:
                self.__build_map(keyword.name, self.__convert_tag_to_condition_info(tag))

    def __convert_tag_to_condition_info(self, tag):
        data = tag.split(':')
        if len(data) == 3:
            return {'when': data[0], 'where': data[1], 'priority': data[2]}
        elif len(data) == 2:
            return {'when': data[0], 'where': data[1], 'priority': 1}

    def __build_map(self, keyword, condition_info):
        action = Action(keyword, condition_info['priority'])
        for condition in self.conditions:
            if condition.is_satisfied(condition_info['when'], condition_info['where']):
                condition.add_action(action)
                return
        self.conditions.append(
            Condition(condition_info['when'], condition_info['where'], action))

    def get_pre_actions(self, where):
        for condition in self.conditions:
            if condition.is_satisfied('pre', where):
                return condition.actions
        return []

    def get_post_actions(self, where):
        for condition in self.conditions:
            if condition.is_satisfied('post', where):
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
