#!/usr/bin/env python

# MODULE IMPORTS
import xml.dom.minidom
import re

# CLASS TO HOLD THE DATA FOR A TO DO GROUP
class toDo():
    def __init__(self):
        self.groupname = ""
        self.link = ""
        self.pubdate = ""
        self.tasklist = []

# GET THE FEED - UPDATE TO CMD LINE ARGUMENT
# BE SURE TO HAVE THE URL REDIRECT THE URL FROM THE COMMAND LINE WITH 
# THE FOLLOWING COMMAND
# curl --silent "url goes here in quotations or else it won't work" > /tmp/evernote_feed.xml
dom = xml.dom.minidom.parse("/tmp/evernote_feed.xml")

# LIST TO HOLD ALL THE TASKS (toDo CLASS)
tasks = []

# INLINE FUNCTIONS - DON'T FEEL LIKE CLASSING THIS UP
def getText(nodelist):
    rc = []
    for node in nodelist:
        if node.nodeType == node.TEXT_NODE:
            rc.append(node.data)
    return ''.join(rc)

def handleFeed(feed,tasks):
    items = feed.getElementsByTagName("item")
    handleSubjects(items,tasks)

def handleSubjects(items,tasks):
    for item in items:
        # CREATE TEMPORARY TODO
        tmpToDo = toDo()
        # GET THE DATA FROM THE CURRENT ITEM
        title = item.getElementsByTagName("title")[0]
        link = item.getElementsByTagName("link")[0]
        pubdate = item.getElementsByTagName("pubDate")[0]
        # DESCRIPTION IS DIFFERENT DUE TO THE CDATA IN THE XML
        desc = item.getElementsByTagName("description")[0].firstChild.data.strip()
        # GET THE TITLE FROM THE TITLE TAG
        titleText = getText(title.childNodes)
        # GET THE LINK FROM THE LINK TAG
        linkText = getText(link.childNodes)
        # GET THE PUB DATE FROM THE PUBDATE TAG
        pubDText = getText(pubdate.childNodes)
        # SET UP TITLE, LINK, AND PUBDATE IN THE TMP TODO VARIABLE
        tmpToDo.groupname = titleText
        tmpToDo.link = linkText
        tmpToDo.pubdate = pubDText
        # REGULAR EXPRESSIONS TO REMOVE THE <div class="ennote">, <div>, and </div> TAGS  
        # AND REPLACE WITH APPROPRIATE VALUES TO GET A COMMA DELIMITED LIST
        descCopy = desc
        tmp = re.sub('\n',",",descCopy)
        tmp = re.sub('<div class="ennote">',"",tmp)
        # REMOVE THE DOUBLE </div> TAGS, ACCOUNT FOR BOTH POSSIBILITIES EVEN THOUGH THE FIRST
        # RE WILL REMOVE THE RETURN LINES
        tmp = re.sub("</div>,</div>",",",tmp)
        tmp = re.sub("</div></div>","",tmp)
        # REMOVE THE LEADING <div> TAGS
        tmp = re.sub("<div>","",tmp)
        # REMOVE THE SINGLE </div> AND REPLACE WITH THE COMMAS
        tmp = re.sub("</div>,",",",tmp)
        # MAKE tmp A LIST
        tmp = tmp.split(',')
        # SET THE LIST TO THE LIST IN TEMP TODO
        tmpToDo.tasklist = tmp
        # APPEND TMP TODO TO TASKS
        tasks.append(tmpToDo)
        
# HANDLE THE XML
handleFeed(dom,tasks)

# PRINT OUT THE TASKS
# THIS IS CUSTOMIZABLE
for i in range(len(tasks)):
    # PRINT OUT TASK GROUP
    print tasks[i].groupname
    # PRINT OUT TASK PUB DATE
    #print "|- Updated: ", tasks[i].pubdate
    # PRINT OUT TASK LINK
    #print "|- Link: ", tasks[i].link
    # PRINT OUT ACTUAL TASKS
    for j in range(len(tasks[i].tasklist)):
        d2print = tasks[i].tasklist[j]
        if d2print != "":
            print "|-", d2print
