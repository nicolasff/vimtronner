socket = require('socket.io-client').connect('http://localhost:8000')
screen = require './screen'
Board = require './board'

board = new Board

socket.on 'connect', ->
  onSigInt = ->
    screen.clear()
    screen.showCursor()
    process.nextTick process.exit

  process.on 'SIGINT', onSigInt

  process.stdin.setRawMode true
  process.stdin.resume()
  process.stdin.on 'data', (chunk)->
    switch chunk[0]
      when 3
        process.kill process.pid, 'SIGINT'
      else
        socket.emit 'movement', chunk[0]

  socket.on 'game', (game) ->
    board.loadState(game)
    board.render()