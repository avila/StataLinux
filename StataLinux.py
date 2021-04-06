import sublime
import sublime_plugin
import subprocess
from os import remove, path, popen

settings = sublime.load_settings("StataLinux (Linux).sublime-settings")
counter = 0
stata_win_id = ""

class StataLinuxCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        # Load settings and counter
        global stata_win_id
        global counter
        counter += 1
        
        focus_stata = settings.get("focus_stata")

        filename = "/tmp/st_{c:03d}.do".format(c=counter)
        write_content_to_file(self, filename, settings)

        # get Stata's Window ID if none already assigned
        if not stata_win_id:
            stata_win_id = establish_stata_connection(verbose=True)

        # check if window id still matches to a open instace
        stata_win_name = popen("xdotool getwindowname {}".format(stata_win_id)).read()

        if stata_win_id and not stata_win_name:
            sublime.message_dialog('Window id {} no longer active. Try establishing a new connection.'.format(stata_win_id))
            stata_win_id = establish_stata_connection(verbose=False)
    
        if stata_win_id and stata_win_name:
            # focus stata window (optional)
            if focus_stata: popen('xdotool windowactivate {}'.format(stata_win_id))

            # Create and execute bash command:
            sublime_stata_sh_path = path.join(sublime.packages_path(), "StataLinux", "sublime-stata.sh")
            
            cmd = "sh {path} {fn} {id}".format(path=sublime_stata_sh_path, fn=filename, id=stata_win_id)
            ret = subprocess.call(cmd, shell = True)
            if ret != 0:
                if ret == 1:
                    sublime.error_message("Bash script returned error code %s.\nIt seems Stata is not running." % ret)
                else:
                    sublime.error_message("Bash script returned error code %s." % ret)

            

            # Print status message for debugging:
            # sublime.status_message("Content:%s" % content)
            sublime.status_message('StataLinuxCommand ran successfully')
        
        else:
            sublime.error_message("Unable to connect to Stata. Is it open? " + 
                "Try establishing `Connection to Stata` via command palette")


class StataLinuxAllCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        settings = sublime.load_settings(settingsfile)
        # Switch focus to Stata or not after sending a command depending on a setting
        if settings.get('save_before_run_all'):
            self.view.run_command("save")
        # Define current file as the one to be run, saving it first
        filename = self.view.file_name()
        # Create and execute bash command:
        sublime_stata_sh_path = path.join(sublime.packages_path(), "StataLinux", "sublime-stata.sh")
        cmd = "sh {path} {fn} {id}".format(path=sublime_stata_sh_path, fn=filename, id=stata_win_id)
        ret = subprocess.call(cmd, shell = True)
        if ret != 0:
            if ret == 1:
                sublime.error_message("Bash script returned error code %s. It seems Stata is not running." % ret)
                return
            else:
                sublime.error_message("Bash script returned error code %s." % ret)
                return
        
        sublime.status_message('StataLinuxAllCommand ran successfully')
        

class StataLinuxConnectCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        global stata_win_id
        
        # Switch focus to Stata or not after sending a command depending on a setting
        stata_win_id = establish_stata_connection(verbose=True)
        
        cmd_focus = 'xdotool windowactivate --sync {}'.format(stata_win_id)
        popen(cmd_focus)


class StataLinuxPrintIdCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        sublime.status_message('stata_win_id: {}'.format(stata_win_id))


def establish_stata_connection(verbose=True):
    """
    This function tries to find an running Stata window and returns its window ID. 
    """
    global stata_win_id

    # actual connection via xdotool
    cmd = 'xdotool search --name --limit 1 "(Stata/(IC|SE|MP)? 1[0-9]\.[0-9])"'
    stata_win_id = popen(cmd).read().strip("\n")
    
    if not stata_win_id:
        if verbose: sublime.error_message("Cannot establish connection. Is there a Stata instance running?")
        return False
    else: 
        # focus stata window (not optional, to make sure it is connecting to correct window)
        popen('xdotool windowactivate --sync {}'.format(stata_win_id))

        if verbose: sublime.status_message('stata_win_id: {}'.format(stata_win_id))
        return stata_win_id


def write_content_to_file(self, filename, settings):
    always_extract_full_line = settings.get('always_extract_full_line')
    remove_temp_file = settings.get('remove_temp_file')

    # Collect selected range or full current line if no selection in a list 
    contents = []
    for region in self.view.sel():
        # select full line if region starts and ends at the same point
        if always_extract_full_line or region.a == region.b:
            region = self.view.full_line(region)
        contents.append(self.view.substr(region))

    with open(filename, "w+") as file:
        for content in contents:
            file.write(content + "\n")
    # Remove temporary file:
    if remove_temp_file: remove(filename)


def send_to_stata(filename, stata_win_id, quietly=""):
    # not working properly, keys are getting "stuck"
    p = subprocess.call("""
        xdotool key    --window {id} --delay 50 --clearmodifiers ctrl+a
        xdotool type   --window {id} --delay 5 "{qui} do {fn}"
        xdotool key    --window {id} Return
        xdotool keyup  --window {id} --delay 5 ctrl a
        """.format(id=stata_win_id, fn=filename, qui=quietly), 
        shell = True, timeout = 5)
    #p.communicate()


available_completions = []
class StataLinuxSaveVariableList(sublime_plugin.TextCommand):
    def run(self, edit):
        import time 
        #global stata_win_id
        global available_completions

        do_file = path.join(sublime.packages_path(), "StataLinux", "misc",  "save_var_list.do")
        send_to_stata(filename = do_file, stata_win_id=stata_win_id, quietly="quietly")

        st = open("/tmp/st_vars.list", 'r').read().strip("\n")
        # "/tmp/st_vars.list"
        available_completions = []

        for var in st.split(' '): 
            available_completions.append(var)


class StataVariablesCompletionListener(sublime_plugin.EventListener):
    def on_query_completions(self, view, prefix, locations):
        global available_completions

        loc = locations[0]

        # limit you completions scope
        if not view.score_selector(loc, "source.stata"):
            return None

        prefix = prefix.lower()

        out = []
        for comp in available_completions:
            if comp.lower().startswith(prefix):
                out.append((comp + "\tvar", comp))

        return out