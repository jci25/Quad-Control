import tornado.httpserver
import tornado.websocket
import tornado.ioloop
import tornado.web
import json 

global rpi
global rpi2
rpi2=dict()
rpi=dict()
global arr
global arr2
arr2 = []
arr = []
global listeners
listeners = []
 
class WSHandler(tornado.websocket.WebSocketHandler):
	#data = dict()
	
	def open(self):
		print 'new connection'
		self.write_message("Hello World")

	def on_message(self, message):
		global arr
		global rpi
		global rpi2
		global arr2
		global listeners
		data = dict()
		data2 = dict()
		#print 'message received %s' % message
		if message == "Add":
			info = self.getKey(str(repr(self.request.headers)))
			data["IP"] = repr(self.request.remote_ip)
			data["Key"] = info
			data2["IP"] = repr(self.request.remote_ip)
			data2["Key"] = info
			data2["Id"] = self
			if data in arr:
				1==1
			else:
				listeners.append(self)
				arr.append(data)
				arr2.append(data2)
				rpi["data"]=arr
		elif message == "Get":
#			for value in listeners.itervalues():
#				self.write_message(value)
			jsonarray = json.dumps(rpi)
			self.write_message(jsonarray)
		elif message.find("Send") != -1:
			1==1
			#this would be a good time to hande a send command
			#output the java code for the IOIO OTG
			#doesnt do anything server side just should be used RPI side
		else:
			print "else"
			for w in arr2:
				if message.find(w["Key"]) != -1:
					device = w["Id"]
					#do the send command
					sendMess = message[message.find(" ")+1:]
					device.write_message(sendMess)
					
			#self.sendCommands(message)

	def on_close(self):
		global arr
		global arr2
		global listeners
		data = dict()
		data2 = dict()
		info = self.getKey(str(repr(self.request.headers)))
		data["IP"] = repr(self.request.remote_ip)
		data["Key"] = info
		data2["IP"] = repr(self.request.remote_ip)
		data2["Key"] = info
		data2["Id"] = self
		print 'connection closed'
		info = self.getKey(str(repr(self.request.headers)))
		print arr
		try:
			#print data
			arr.remove(data)
			arr2.remove(data2)
			listeners.remove(self)
		except ValueError:
			print "error"
		#print arr.index(self.data)
		print arr

	def sendCommands(self, mess):
		print arr.index(mess)

	def getKey(self, header):
		info = str(repr(self.request.headers))
		info = info[info.find('Sec-Websocket-Key'):]
		info = info[ info.find(':'):]
		info = info[info.find('\'')+1:]
		info = info[:info.find('\'')]
		return info
 
 
application = tornado.web.Application([
    (r'/ws', WSHandler),
])
 
 
if __name__ == "__main__":
	m = {'Origin': 'http://www.websocket.org', 'Upgrade': 'websocket', 'Sec-Websocket-Extensions': 'permessage-deflate; client_max_window_bits, x-webkit-deflate-frame', 'Sec-Websocket-Version': '13', 'Host': 'tux64-14.cs.drexel.edu:8888', 'Sec-Websocket-Key': 's6tEJR1KQDjMn+uuqDOKyw==', 'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.146 Safari/537.36', 'Connection': 'Upgrade', 'Cookie': '__utma=256054937.1157542120.1392751277.1392751277.1392751277.1; __utmz=256054937.1392751277.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __utma=191177727.1135622302.1390353658.1394090190.1394568214.14; __utmc=191177727; __utmz=191177727.1394090190.13.7.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided)', 'Pragma': 'no-cache', 'Cache-Control': 'no-cache'}  
	n = json.dumps(m)
	o = json.loads(n)
	print o['Host']
	http_server = tornado.httpserver.HTTPServer(application)
	http_server.listen(8888)
	tornado.ioloop.IOLoop.instance().start()
