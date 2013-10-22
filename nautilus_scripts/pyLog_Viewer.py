#!/usr/bin/env python
   
import pygtk
pygtk.require('2.0')
import gtk

class LogViewer:
	def delete_event(self, widget, data):
		print "Exiting..."
		gtk.main_quit()
		return False
		
	def choose_file(self, widget, data):
		infile = open("%s" %data, "r")
		if infile:
			string = infile.read()
			infile.close()
			self.textbuffer.set_text(string)
			self.window.set_title("pyLog_Viewer - %s" %data)
		else:
			string = ("Some errors occur during retrive of file %s" %data)
			self.textbuffer.set_text(string)
			
	def reset_event(self, widget, data):
		string = ("pyLog_Viewer\n\nThis python script allow user to quiclky access some system logs.\n\nThis script is released under GPLv3\n\nAuthor: Mauro Lomartire\nEmail: maurelio@bromptoniano.me")
		self.textbuffer.set_text(string)
		self.window.set_title("pyLog_Viewer")
		
	def __init__(self):
		self.window = gtk.Window(gtk.WINDOW_TOPLEVEL)
		self.window.set_title("pyLog_Viewer")
		self.window.set_border_width(10)
		self.window.set_default_size(1024, 768)
		
		self.boxContainer = gtk.VBox(False, 10)
		self.box1 = gtk.HBox(False, 0)
		self.box2 = gtk.HBox(False, 0)
		self.box3 = gtk.HBox(False, 0)
		self.separator = gtk.HSeparator()
		self.sw = gtk.ScrolledWindow()
		self.textview = gtk.TextView()
		self.textbuffer = self.textview.get_buffer()
		string = ("pyLog_Viewer\n\nThis python script allow user to quiclky access some system logs.\n\nThis script is released under GPLv3\n\nAuthor: Mauro Lomartire\nEmail: maurelio@bromptoniano.me")
		self.textbuffer.set_text(string)
		self.buttonAuth = gtk.Button("Show Auth.log")
		self.buttonBoot = gtk.Button("Show Boot.log")
		self.buttonSyslog = gtk.Button("Show Syslog")
		self.buttonXorg = gtk.Button("Show Xorg.0.log")
		self.buttonReset = gtk.Button("Reset")
		self.buttonQuit = gtk.Button("Quit")
		
		self.window.connect("delete_event", self.delete_event)
		self.buttonQuit.connect("clicked", self.delete_event, None)
		self.buttonReset.connect("clicked", self.reset_event, None)
		self.buttonAuth.connect("clicked", self.choose_file, "/var/log/auth.log")
		self.buttonBoot.connect("clicked", self.choose_file, "/var/log/boot.log")
		self.buttonSyslog.connect("clicked", self.choose_file, "/var/log/syslog")
		self.buttonXorg.connect("clicked", self.choose_file, "/var/log/Xorg.0.log")
		
		self.window.add(self.boxContainer)
		self.boxContainer.pack_start(self.box1, False)
		self.boxContainer.pack_start(self.box2, True)
		self.boxContainer.pack_start(self.box3, False)
		self.box1.pack_start(self.buttonAuth)
		self.box1.pack_start(self.buttonBoot)
		self.box1.pack_start(self.buttonSyslog)
		self.box1.pack_start(self.buttonXorg)
		self.box2.pack_start(self.sw, True)
		self.sw.add(self.textview)
		self.box3.pack_start(self.buttonQuit, False)
		self.box3.pack_start(self.buttonReset, False)
		
		self.buttonAuth.show()
		self.buttonBoot.show()
		self.buttonSyslog.show()
		self.buttonXorg.show()
		self.buttonQuit.show()
		self.buttonReset.show()
		self.textview.show()
		self.sw.show()
		self.box1.show()
		self.box2.show()
		self.box3.show()
		self.boxContainer.show()
		self.window.show()
		
	def main(self):
		gtk.main()
		
if __name__ == "__main__":
	logviewer = LogViewer()
	logviewer.main()
