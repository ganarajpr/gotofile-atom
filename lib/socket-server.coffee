module.exports = SocketServer =
  start: () ->
    app = require('http').createServer(handler)
    @io = require('socket.io')(app)
    pathex = require('node-path-extras')
    path = require('path')
    handler = (req, res) ->
      res.send 'hello'
      return

    app.listen 5186
    atom.notifications.addSuccess 'Go to File Server started'
    @io.on 'connection', (socket) ->
      atom.notifications.addSuccess 'Chrome Connected'
      socket.on 'error', (err) ->
        console.error err.stack
      socket.on 'gotofile-data', (data) ->
        if !data.length or typeof data[0] != 'string' 
          atom.notifications.addError 'Chrome did not send source path: Perhaps you did not add babel-plugin-transform-jsx-include-source ?'
          return
        projectPath = atom.project.rootDirectories[0].path;
        if pathex.along data[0],projectPath
          rel = path.relative projectPath, data[0]
          atom.workspace.open data[0]
          atom.show()
        return
      return
  stop: () ->
    @io.close()
    atom.notifications.addSuccess 'Go to File Server stopped'
