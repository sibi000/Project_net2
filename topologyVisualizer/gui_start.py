import os
import json
from webob.static import DirectoryApp
from ryu.app.wsgi import ControllerBase, WSGIApplication, route
from ryu.base import app_manager
#Ryu is a framework and works as an SDN controller

#Ryu Application Main Class Definition
PATH = os.path.dirname(__file__)


# Serving static files
class GUIServerApp(app_manager.RyuApp):
    _CONTEXTS = {
        'wsgi': WSGIApplication,
    }

    def __init__(self, *args, **kwargs):
        super(GUIServerApp, self).__init__(*args, **kwargs)

        wsgi = kwargs['wsgi']
        wsgi.register(GUIServerController)

#HTTP Controller Definition
class GUIServerController(ControllerBase):
    
    def __init__(self, req, link, data, **config):
        super(GUIServerController, self).__init__(req, link, data, **config)
        path = "%s/frontend/" % PATH
        self.static_app = DirectoryApp(path)

    #Management of requests
    @route('topology', '/{filename:[^/]*}')
    def static_handler(self, req, **kwargs):
        if kwargs['filename']:
            req.path_info = kwargs['filename']
        return self.static_app(req)

app_manager.require_app('ryu.app.rest_topology')
app_manager.require_app('ryu.app.ws_topology')
app_manager.require_app('ryu.app.ofctl_rest')