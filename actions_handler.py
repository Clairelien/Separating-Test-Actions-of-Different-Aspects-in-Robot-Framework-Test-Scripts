import os
import glob
from robot.running.builder import ResourceFileBuilder
from robot.libraries.BuiltIn import BuiltIn

class Actions:
    def __init__(self, keyword, when, where, priority=0):
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
            # BuiltIn().run_keyword(keyword['name'])
            print('do action %s' % keyword['name'])

    def is_exist(self, when, where):
        return self.when == when and self.where == where

class ActionsMap:
    def __init__(self, actions):
        self.actions = actions
        self.pre_actions = list()
        self.post_actions = list()
        self.__classfy_actions()

    def __classfy_actions(self):
        for action in self.actions:
            if action.when == 'pre':
                self.pre_actions.append(action)
            if action.when == 'post':
                self.post_actions.append(action)

    def get_pre_action(self, where):
        return [action for action in self.pre_actions if action.where == where]

    def get_post_action(self, where):
        return [action for action in self.post_actions if action.where == where]

class ActionsListBuilder:
    def __init__(self):
        self.resource_files = glob.glob('**/*_ppa.robot', recursive=True) + glob.glob('**/*_ppa.txt', recursive=True)
        self.resources = self.__build_resource()
        self.__actions_list = list()

    def __build_resource(self):
        resources = list()
        for resource_file in self.resource_files:
            resources.append(ResourceFileBuilder().build(resource_file))
        return resources

    def import_actions(self):
        for resource_file in self.resource_files:
            BuiltIn().import_resource(os.path.dirname(__file__).replace('\\', '/') + '/' + resource_file('\\', '/'))

    def build(self):
        for resource in self.resources:
            for keyword in resource.keywords:
                self.__build_actions_with_keyword(keyword)
        return self.__actions_list

    def __build_actions_with_keyword(self, keyword):
        actions = list()
        for tag in keyword.tags:
            data = tag.split(':')
            for actions in self.__actions_list:
                if actions.is_exist(data[0], data[1]):
                    if (len(data) == 3):
                        actions.add(keyword.name, data[2])
                    else:
                        actions.add(keyword.name)
                else:
                    self.__actions_list.append(
                        Action(keyword.name, tag.split(':')[0], tag.split(':')[1]))
            # actions = actions + [Action(keyword.name, tag.split(':')[0], tag.split(':')[1])]

    def __find_duplicate_actions(self, when, where):
        return [actions for actions in self.__actions_list if actions.is_exist(when, where)]


# class actions_handler:
#     ROBOT_LISTENER_API_VERSION = 2

#     def __init__(self):
#         self.pre_actions = []
#         self.post_actions = []
#         self.resource_files = glob.glob('**/*_ppa.robot', recursive=True) + (glob.glob('**/*_ppa.txt', recursive=True)
#         self.resources = self.__build_resource(self.resource_files)
#         self.__action_match(self.res.keywords)

#     def __build_resource(self, files):
#         res = list()
#         for res_file in files:
#             res.append(ResourceFileBuilder().build(ppa_file))
#         return res

#     def __action_match(self, keywords):
#         for kw in keywords:
#             for tag in kw.tags:
#                 if tag.split(':')[0] == 'pre':
#                     self.pre_actions.append([tag.split(':')[1], kw.name])
#                     if kw.name.split(' ')[0] == 'Select' and kw.name.split(' ')[2] == 'Frame':
#                         self.post_actions.append([tag.split(':')[1], 'Unselect Frame'])
#                 elif tag.split(':')[0] == 'post':
#                     self.post_actions.append([tag.split(':')[1], kw.name])

#     def start_suite(self, name, attributes):
#         BuiltIn().import_resource(os.path.dirname(__file__).replace('\\', '/') + '/dct_ppa.robot')

#     def start_keyword(self, name, attributes):
#         for pre_action in self.pre_actions:
#             if pre_action[0] == name:
#                 self.start_keyword(pre_action[1], None)
#                 BuiltIn().run_keyword(pre_action[1])
#                 self.end_keyword(pre_action[1], None)

#     def end_keyword(self, name, attributes):
#         for post_action in self.post_actions:
#             if post_action[0] ==name:
#                 self.start_keyword(post_action[1], None)
#                 BuiltIn().run_keyword(post_action[1])
#                 self.end_keyword(post_action[1], None)

acts = ActionsBuilder().build()
for act in acts:
    print('keyword: %s' % act.keyword_name)
    print('when: %s' % act.when)
    print('where: %s' % act.where)
    print('*********************')

am = ActionsMap(acts)
todo_acts = list()
todo_acts.append(am.get_pre_action('The Toolbar Button Should Be Display In This Order'))
todo_acts.append(am.get_post_action('Open DcTrack And Login As Administrator'))
todo_acts.append(am.get_post_action('Fake'))
for act in todo_acts:
    if act:
        act[0].do()

# class Listener:
#     ROBOT_LISTENER_API_VERSION = 2
#     def __init__(self):
#         actions = ActionBuilder().build()
#         ah = ActionHandler(actions)

#     def start_suite(self, name, attributes):
#         ah.import_resources()

#     def start_keyword(self, name, attributes):
#         ah.do_corresponding_action('pre', name)

#     def end_keyword(self, name, attributes):
#         ah.do_corresponding_action('post', name)
