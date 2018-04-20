from SeleniumLibrary import SeleniumLibrary
from selenium import webdriver
from selenium.webdriver.remote.webelement import WebElement
from selenium.webdriver.common.by import By
from robot.api.deco import keyword

class fbSeleniumLibrary(SeleniumLibrary):
    def __init__(self, *args, **kwargs):
        super(fbSeleniumLibrary, self).__init__(*args, **kwargs)

    def __web_element__(self, locator):
        if isinstance(locator, WebElement):
            return locator
        return self._current_browser().find_element(By.XPATH, locator[len('xpath:'):])

    @keyword(name='Type Text')
    def type_text(self, locator, text):
        element = self.__web_element__(locator)
        # element.send_keys('<span data-text="true">%s</span>' % text)
        self.driver.execute_script('arguments[0].innerHTML = "<span data-text=\'true\'>%s</span>";' % text, element)
