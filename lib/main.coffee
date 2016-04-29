{CompositeDisposable} = require 'atom'

Bookmarks = null
ReactBookmarks = null
BookmarksView = null
editorsBookmarks = null
disposables = null

module.exports =
  activate: ->
    editorsBookmarks = []
    bookmarksView = null
    disposables = new CompositeDisposable

    atom.commands.add 'atom-workspace',
      'bookmarks:view-all', ->
        BookmarksView ?= require './bookmarks-view'
        bookmarksView ?= new BookmarksView(editorsBookmarks)
        bookmarksView.show()

    atom.workspace.observeTextEditors (textEditor) ->
      Bookmarks ?= require './bookmarks'
      bookmarks = new Bookmarks(textEditor)
      editorsBookmarks.push(bookmarks)
      disposables.add textEditor.onDidDestroy ->
        index = editorsBookmarks.indexOf(bookmarks)
        editorsBookmarks.splice(index, 1) if index isnt -1
        bookmarks.destroy()

  deactivate: ->
    bookmarks.destroy() for bookmarks in editorsBookmarks
    disposables.dispose()
