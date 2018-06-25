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
    def __init__(self, when, what, status=None):
        self.when = when
        self.what = what
        self.status = status
        if self.status:
            self.status = self.status.upper()

    def is_satisfied(self, when, what, status=None):
        """
        >>> Condition('pre', 'BuildIn.*').is_satisfied('pre', 'BuildIn.Should Be Equal')
        True
        >>> Condition('pre', 'BuildIn.*').is_satisfied('post', 'BuildIn.Should Be Equal', 'fail')
        False
        >>> Condition('post', 'BuildIn.*').is_satisfied('post', 'BuildIn.Should Be Equal', 'fail')
        True
        >>> Condition('post', 'BuildIn.*').is_satisfied('pre', 'BuildIn.Should Be Equal')
        False
        >>> Condition('post', '!BuildIn.*').is_satisfied('post', 'BuildIn.Should Be Equal', 'fail')
        False
        >>> Condition('post', 'fbSeleniumLibrary.*').is_satisfied('post', 'BuildIn.Should Be Equal', 'fail')
        False
        >>> Condition('post', '!fbSeleniumLibrary.*').is_satisfied('post', 'BuildIn.Should Be Equal', 'fail')
        True
        >>> Condition('post', '!BuildIn.Should Be Equal').is_satisfied('post', 'BuildIn.Should Be Equal', 'fail')
        False
        >>> Condition('post', '!BuildIn.Should Be Equal', 'fail').is_satisfied('post', 'fbSeleniumLibrary.Should Be Equal', 'fail')
        True
        >>> Condition('post', '!BuildIn.Should Be Equal', 'pass').is_satisfied('post', 'fbSeleniumLibrary.Should Be Equal', 'fail')
        False
        >>> Condition('post', '@fbSeleniumLibrary\..+').is_satisfied('post', 'fbSeleniumLibrary.Should Be Equal', 'fail')
        True
        >>> Condition('post', '@fbSeleniumLibrary\..+').is_satisfied('post', 'BuildIn.Should Be Equal')
        False
        >>> Condition('post', '@fbSeleniumLibrary\..+').is_satisfied('post', 'fbSeleniumLibrary.')
        False
        >>> Condition('post', '@(?!fbSeleniumLibrary\..+)').is_satisfied('post', 'BuildIn.Should Be Equal')
        True
        """
        if self.status:
            return re.match(self.when.replace('*', '.*'), when) != None and self.__match_what(what) and self.status == status.upper()
        return re.match(self.when.replace('*', '.*'), when) != None and self.__match_what(what)

    def __match_what(self, what):
        if self.what.startswith("@"):
            # return re.match("^%s$" % self.what[1:], what) != None
            return re.match(self.what[1:], what) != None
        if self.what.startswith("!"):
            return not re.match("^%s$" % self.what[1:].replace('.', '\.').replace('*', '.+'), what)
        return re.match("^%s$" % self.what.replace('.', '\.').replace('*', '.+'), what) != None

class ActionMap:
    def __init__(self):
        self.conditional_actions = list()

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

    def __build_map(self, keyword, when,  what, priority=1, status=None):
        self.conditional_actions.append({'Condition':Condition(when, what, status), 'Action':Action(keyword, priority)})

    def get_pre_actions(self, what):
        pre_actions = list()
        for conditional_action in self.conditional_actions:
            if conditional_action['Condition'].is_satisfied('pre', what, None):
                pre_actions.append(conditional_action['Action'])
        return sorted(pre_actions, key=lambda action: action.priority)

    def get_post_actions(self, what, status):
        post_actions = list()
        for conditional_action in self.conditional_actions:
            if conditional_action['Condition'].is_satisfied('post', what, status):
                post_actions.append(conditional_action['Action'])
        return sorted(post_actions, key=lambda action: action.priority)

class ActionParser:
    def __init__(self, ppa_files):
        self.ppa_files = ppa_files
        self.resources = self.__build_resource()
        self.action_map = ActionMap()
        self.__parse()

    def __build_resource(self):
        return [ResourceFileBuilder().build(ppa_file) for ppa_file in self.ppa_files]

    def import_actions(self):
        for ppa_file in self.ppa_files:
            BuiltIn().import_resource(os.path.dirname(__file__).replace('\\', '/') + '/' + ppa_file.replace('\\', '/'))

    def __parse(self):
        for resource in self.resources:
            self.action_map.mapping(resource)

    def get_action_map(self):
        return self.action_map

# action_parser = ActionParser(glob.glob('**/*_ppa.robot', recursive=True) + glob.glob('**/*_ppa.txt', recursive=True))
# am = action_parser.get_action_map()
# acts = am.get_post_actions('fbSeleniumLibrary.log', 'FAIL')
# for act in acts:
#     print(act.keyword)
# def a(a, b, *args, c=1, d=2, **kwargs):
#     print(args)
#     # print(kwargs)

# a(1,1,*[3,8,5,8])


if __name__ == '__main__':
    import doctest
    doctest.testmod()
