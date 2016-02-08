
{CompositeDisposable} = require 'atom'
socketServer             = require './socket-server'


module.exports = AtomicChrome =
  activate: (state) ->
    socketServer.start()

  deactivate: ->
    socketServer.stop()
