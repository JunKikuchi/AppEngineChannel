#!/usr/bin/env python
#
# Copyright 2012 Jun Kikuchi
#
import webapp2
from webapp2_extras import json
from webapp2_extras import jinja2
from google.appengine.ext import ndb
from google.appengine.api import channel

import logging

class Client(ndb.Model):
  def send_message(self, message):
    try:
      client_id = self.key.id()

      data = {'message': message}
      body = json.encode(data)
      channel.send_message(client_id, body)
    except channel.InvalidChannelClientIdError:
      self.key.delete()

class Jinja2Handler(webapp2.RequestHandler):
  @webapp2.cached_property
  def jinja2(self):
    return jinja2.get_jinja2(app=self.app)

  def render_response(self, _template, **context):
    rv = self.jinja2.render_template(_template, **context)
    self.response.write(rv)

class MainHandler(Jinja2Handler):
  def get(self):
    client_id = self.request.get('client_id')
    if client_id == '':
      self.render_response('checkin.html')
    else:
      self.render_response('main.html', client_id=client_id)

class ChannelHandler(webapp2.RequestHandler):
  def get(self):
    client_id = self.request.get('client_id')
    if client_id is None:
      self.response.set_status(404)
      return

    token = channel.create_channel(client_id)
    data  = {'token': token}
    body  = json.encode(data)

    client = Client(id=client_id)
    client.put()

    self.response.out.write(body)

class EchoHandler(webapp2.RequestHandler):
  def post(self):
    message = self.request.get('message')
    logging.info(message)
    if message is None:
      return

    query = Client.query()
    for client in query:
      try:
        client.send_message(message)
      except channel.InvalidMessageError:
        return

routes = [
  ('/',             MainHandler),
  ('/channel',      ChannelHandler),
  ('/channel/echo', EchoHandler),
]

app = webapp2.WSGIApplication(routes, debug=True)
