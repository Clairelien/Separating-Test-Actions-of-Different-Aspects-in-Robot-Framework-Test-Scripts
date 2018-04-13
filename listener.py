from action import ActionsListBuilder, ActionsMap, Actions, MapBuilder

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

action_parser = ActionParser()
action_map = action_parser.get_map()

pre_actions = action_map.get_pre_actions('The Toolbar Button Should Be Display In This Order')
for action in pre_actions:
    action.do()
