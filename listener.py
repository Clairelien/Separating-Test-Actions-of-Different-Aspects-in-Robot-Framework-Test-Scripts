from action import *

# actions_list = ActionsListBuilder().build()
# for acts in actions_list:
#     acts.do()
#     print('*********************')

# am = ActionsMap(actions_list)
# todo_acts = list()
# todo_acts.append(am.get_pre_action('The Toolbar Button Should Be Display In This Order'))
# todo_acts.append(am.get_post_action('Open DcTrack And Login As Administrator'))
# todo_acts.append(am.get_post_action('Fake'))
# for act in todo_acts:
#     if act:
#         print('do actions brf/aft %s' %act[0].where)
#         act[0].do()

class listener:
    ROBOT_LISTENER_API_VERSION = 2
    def __init__(self):
        self.actions_builder = ActionsListBuilder()
        self.actions_list = self.actions_builder.build()
        self.actions_map = ActionsMap(self.actions_list)

    def start_suite(self, name, attributes):
        self.actions_builder.import_actions()

    def start_keyword(self, name, attributes):
        pre_actions = self.actions_map.get_pre_action(name)
        if pre_actions:
            pre_actions[0].do()

    def end_keyword(self, name, attributes):
        post_actions = self.actions_map.get_post_action(name)
        if post_actions:
            post_actions[0].do()

