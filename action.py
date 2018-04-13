import os
import glob
from robot.running.builder import ResourceFileBuilder
from robot.libraries.BuiltIn import BuiltIn

class Actions:
    def __init__(self, keyword, when, where, priority=1):
        self.keywords = [{'name': keyword, 'priority': int(priority)}]
        self.when = when
        self.where = where

    def add(self, keyword, priority=0):
        self.keywords.append({'name': keyword, 'priority': int(priority)})
        self.__sort_keyword()

    def __sort_keyword(self):
        self.keywords = sorted(self.keywords, key=lambda kw: kw['priority'])

    def do(self):
        for keyword in self.keywords:
            BuiltIn().run_keyword(keyword['name'])

    def is_exist(self, when, where):
        return self.when == when and self.where == where


class ActionsMap:
    def __init__(self, actions_list):
        self.actions_list = actions_list
        self.pre_actions_list = list()
        self.post_actions_list = list()
        self.__classfy_actions()

    def __classfy_actions(self):
        for actions in self.actions_list:
            if actions.when == 'pre':
                self.pre_actions_list.append(actions)
            if actions.when == 'post':
                self.post_actions_list.append(actions)

    def get_pre_action(self, where):
        return [actions for actions in self.pre_actions_list if actions.where == where]

    def get_post_action(self, where):
        return [actions for actions in self.post_actions_list if actions.where == where]


class ActionsListBuilder:
    def __init__(self):
        self.resource_files = glob.glob(
            '**/*_ppa.robot', recursive=True) + glob.glob('**/*_ppa.txt', recursive=True)
        self.resources = self.__build_resource()
        self.__actions_list = list()

    def __build_resource(self):
        resources = list()
        for resource_file in self.resource_files:
            resources.append(ResourceFileBuilder().build(resource_file))
        return resources

    def import_actions(self):
        for resource_file in self.resource_files:
            BuiltIn().import_resource(os.path.dirname(__file__).replace(
                '\\', '/') + '/' + resource_file.replace('\\', '/'))

    def build(self):
        for resource in self.resources:
            for keyword in resource.keywords:
                self.__build_actions_with_keyword(keyword)
        return self.__actions_list

    def __build_actions_with_keyword(self, keyword):
        for tag in keyword.tags:
            actions_info = self.__convert_tag_to_actions_info(tag)
            if self.__actions_is_exist(actions_info['when'], actions_info['where']):
                self.__add_action_to_existing_actions(
                    keyword.name, actions_info['when'], actions_info['where'], actions_info['priority'])
            else:
                self.__actions_list.append(Actions(
                    keyword.name, actions_info['when'], actions_info['where'], actions_info['priority']))

    def __convert_tag_to_actions_info(self, tag):
        data = tag.split(':')
        if len(data) == 3:
            return {'when': data[0], 'where': data[1], 'priority': data[2]}
        elif len(data) == 2:
            return {'when': data[0], 'where': data[1], 'priority': 1}

    def __actions_is_exist(self, when, where):
        for actions in self.__actions_list:
            if actions.is_exist(when, where):
                return True
        return False

    def __add_action_to_existing_actions(self, keyword, when, where, priority):
        for actions in self.__actions_list:
            if actions.when == when and actions.where == where:
                actions.add(keyword, priority)
                break
