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
      socket.on 'gotofile-data', (paths) ->
        if !paths.length or typeof paths[0] != 'string'
          atom.notifications.addError 'Chrome did not send source path: Perhaps you did not add babel-plugin-transform-jsx-include-source ?'
          return
        atom.project.rootDirectories.forEach (rd) ->
          projectPath = rd.path
          if pathex.along paths[0],projectPath
            rel = path.relative projectPath, paths[0]
            atom.workspace.open paths[0]
            atom.show()
          return
      return
  stop: () ->
    @io.close()
    atom.notifications.addSuccess 'Go to File Server stopped'
