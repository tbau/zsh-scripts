# start_selenium.py

import os
import json
import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import argparse

parser = argparse.ArgumentParser("selenium")
parser.add_argument("config", help="Config filename to load", type=str)
parser.add_argument('args', nargs='*', type=str, help='Arguments for config use')
cmd_args = parser.parse_args()

homedir = os.path.expanduser("~")
script_dir = os.path.dirname(os.path.realpath(__file__))
config_file = os.path.expanduser(cmd_args.config)

with open(config_file) as f:
    config = json.load(f)

args = {}

if config.get('defaults'):
    for k in config['defaults']:
        args[k]=config['defaults'][k]

args.update({f"arg{i+1}": arg for i, arg in enumerate(cmd_args.args)})
options = webdriver.ChromeOptions()
options.add_argument("--no-sandbox")
options.add_argument('--disable-gpu') 
# options.add_argument("--headless")

browser =  webdriver.Chrome(options=options)
wait = WebDriverWait(browser, timeout=20)

if config.get('actions'):
    for action in config['actions']:
        if action['type']=='navigate':       
            browser.get(action['url'])
        if action['type']=='type':       
            if args:
                input_element = wait.until(EC.element_to_be_clickable((By.XPATH, action['element'].format(**args))))        
                input_element.send_keys(action['text'].format(**args))
            else:
                input_element = wait.until(EC.element_to_be_clickable((By.XPATH, action['element'])))        
                input_element.send_keys(action['text'])            
        if action['type']=='enter':       
            input_element.send_keys(Keys.ENTER)
        if action['type']=='click':       
            if args:
                input_element =  wait.until(EC.element_to_be_clickable((By.XPATH, action['element'].format(**args)))) 
            else:
                input_element =  wait.until(EC.element_to_be_clickable((By.XPATH, action['element']))) 
            input_element.click()
        if action['type']=='get':       
            if args:
                input_element =  wait.until(EC.presence_of_element_located((By.XPATH, action['element'].format(**args)))).text 
            else:
                input_element =  wait.until(EC.presence_of_element_located((By.XPATH, action['element']))).text   
            if action.get('start_new_line')==True:
                print()
            if action.get('before_label'):
                print(action.get('before_label'), end='')
            if action.get('end_new_line')==True:
                print(input_element)
                if action.get('end_new_line_count'):
                    for i in range(1,  action.get('end_new_line_count')):
                        print()
            else:
                print(input_element, end='')
        if action.get('wait'):
            if args:
                time.sleep(int(str(action['delay']).format(**args)))
            else:
                time.sleep(int(action['delay']))  
browser.quit()