

try: debug
except: debug = 1

if debug == 0:
  import vim


from xml.etree.ElementTree import *
import os
import glob
import re

menu_name = "[RubyMotion]"

toplevel_elements = {}
toplevel_element_names = []

secondlevel_elements = {}
secondlevel_element_names = []


def init_rubymotion_read_bridgesupport(rubymotion_bridgesupport_path):

  wildcard_path = os.path.join(rubymotion_bridgesupport_path, "*.bridgesupport")

  files = glob.glob(wildcard_path)


  for path in files:

    tree = parse(path)

    for el in tree.getiterator():
      if el.tag in ["struct", "constant", "enum", "function", "function_alias", "class", "string_constant" ]:
        name = el.get("name")
        toplevel_elements[name] = el
        toplevel_element_names.append(name)

      if el.tag in ["function", "function_alias"]:
        name = el.get("name")
        secondlevel_elements[name] = el
        secondlevel_element_names.append(name)
      if el.tag in ["method"]:
        name = el.get("selector")
        secondlevel_elements[name] = el
        secondlevel_element_names.append(name)

  return 1


def get_current_completions(cur_keyword_pos, cur_keyword_str):

  print "[py] cur_keyword_pos = %s" % cur_keyword_pos
  print "[py] cur_keyword_str = %s" % cur_keyword_str

  cur_text = vim.eval("neocomplcache#get_cur_text()")
  print "[py] get_cur_text = %s" % cur_text


  # return str(result)
  return get_current_completions2(cur_keyword_pos, cur_keyword_str, cur_text)


def get_current_completions2(cur_keyword_pos, cur_keyword_str, cur_text):

  result = []

  matched = re.findall(r'[a-zA-Z_\-0-9]+', cur_text)
  last_text = ""
  show_methods = 0

  if len(matched) > 0:
    last_text = matched[-1]

  if len(matched) > 1 and matched[-2] == "def":
    show_methods = 1

  if show_methods == 0:
    for name in toplevel_element_names:
      if last_text != "" and name.find(last_text) == 0:
        result.append({"word": name, "menu": menu_name})
  else:
    for name in secondlevel_element_names:
      if last_text != "" and name.find(last_text) == 0:
        result.append({"word": name, "menu": menu_name})

  return str(result)

def stub():

  init_rubymotion_read_bridgesupport("/Library/RubyMotion/data/6.1/BridgeSupport")

  # res = get_current_completions2(24, None, "class AppDelegate < UI::")
  # res = get_current_completions2(24, None, "class UI")
  res = get_current_completions2(24, None, "  def web")
  # res = get_current_completions2(24, None, "")
  # print res

  print res[0:100]

if debug != 0:
  stub()
