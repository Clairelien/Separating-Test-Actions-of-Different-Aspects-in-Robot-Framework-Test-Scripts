import glob
from os import path
from robot.running.builder import ResourceFileBuilder
from robot.libraries.BuiltIn import BuiltIn

# ppa_files = glob.glob('**/*_ppa.robot', recursive=True) + (glob.glob('**/*_ppa.txt', recursive=True))
# print(ppa_files)
# for ppa_file in ppa_files:
#     res = ResourceFileBuilder().build(ppa_file)
#     print([kw.name for kw in res.keywords])
#     print(path.dirname(__file__).replace('\\', '/') + '/' + ppa_file.replace('\\', '/'))
#     print('---------------')
#     BuiltIn().import_resource(path.dirname(__file__).replace(
#         '\\', '/') + '/' + ppa_file.replace('\\', '/'))


class test:
    ROBOT_LISTENER_API_VERSION = 2

    def __init__(self):
        # actions = ActionBuilder().build()
        # ah = ActionHandler(actions)
        self.res = ResourceFileBuilder.build('test_res.robot')

    # def start_suite(self, name, attributes):
    #     ah.import_resources()

    def start_keyword(self, name, attributes):
        BuiltIn().run_keyword(self.res.keywords[0].name)
        # ah.do_corresponding_action('pre', name)

    # def end_keyword(self, name, attributes):
        # ah.do_corresponding_action('post', name)
